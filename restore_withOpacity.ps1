# Script PowerShell pour restaurer les fichiers depuis le backup
# Utilise le dernier dossier de backup créé

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Script de restauration depuis backup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Trouver le dernier dossier de backup
$backupDirs = Get-ChildItem -Path . -Filter "backup_withOpacity_*" -Directory | Sort-Object Name -Descending

if ($backupDirs.Count -eq 0) {
    Write-Host "❌ Aucun dossier de backup trouvé" -ForegroundColor Red
    exit
}

$latestBackup = $backupDirs[0]
Write-Host "Dossier de backup trouvé: $($latestBackup.Name)" -ForegroundColor Yellow

$response = Read-Host "`nVoulez-vous restaurer depuis ce backup? (O/N)"

if ($response -ne "O" -and $response -ne "o") {
    Write-Host "Restauration annulée" -ForegroundColor Yellow
    exit
}

Write-Host "`nRestauration en cours..." -ForegroundColor Cyan

$restoredFiles = 0
$errors = 0

# Parcourir tous les fichiers dans le backup
$backupFiles = Get-ChildItem -Path $latestBackup.FullName -Filter "*.dart" -Recurse

foreach ($backupFile in $backupFiles) {
    try {
        # Reconstruire le chemin original
        $relativePath = $backupFile.FullName.Replace($latestBackup.FullName, "").TrimStart("\")
        $originalPath = Join-Path $PWD.Path $relativePath
        
        # Copier le fichier de backup vers l'emplacement original
        Copy-Item -Path $backupFile.FullName -Destination $originalPath -Force
        
        $restoredFiles++
        Write-Host "✓ Restauré: $relativePath" -ForegroundColor Green
    }
    catch {
        $errors++
        Write-Host "✗ Erreur lors de la restauration de $relativePath : $_" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Résumé de la restauration:" -ForegroundColor Green
Write-Host "- Fichiers restaurés: $restoredFiles" -ForegroundColor White
Write-Host "- Erreurs: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "White" })
Write-Host "========================================" -ForegroundColor Cyan

if ($errors -eq 0) {
    Write-Host "`n✅ Restauration terminée avec succès!" -ForegroundColor Green
    
    $deleteBackup = Read-Host "`nVoulez-vous supprimer le dossier de backup? (O/N)"
    if ($deleteBackup -eq "O" -or $deleteBackup -eq "o") {
        Remove-Item -Path $latestBackup.FullName -Recurse -Force
        Write-Host "Dossier de backup supprimé" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n⚠️ Restauration terminée avec des erreurs" -ForegroundColor Yellow
}

Write-Host "`nRecommandation: Exécutez 'flutter analyze' pour vérifier le code" -ForegroundColor Yellow
