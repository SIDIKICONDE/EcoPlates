# Script PowerShell pour remplacer withOpacity() par withValues()
# dans tous les fichiers Dart du projet EcoPlates

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Script de migration withOpacity -> withValues" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Fonction pour convertir withOpacity en withValues
function Convert-WithOpacity {
    param (
        [string]$content
    )
    
    # Pattern pour matcher .withOpacity(valeur)
    $pattern = '\.withOpacity\(([^)]+)\)'
    
    # Remplacer par .withValues(opacity: valeur)
    $replacement = '.withValues(opacity: $1)'
    
    $newContent = [regex]::Replace($content, $pattern, $replacement)
    
    return $newContent
}

# Obtenir tous les fichiers Dart du projet
$dartFiles = Get-ChildItem -Path "lib", "test" -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue

if ($dartFiles.Count -eq 0) {
    Write-Host "Aucun fichier Dart trouvé dans lib/ et test/" -ForegroundColor Yellow
    exit
}

Write-Host "Fichiers Dart trouvés: $($dartFiles.Count)" -ForegroundColor Green

$totalReplacements = 0
$filesModified = 0
$backupDir = "backup_withOpacity_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Créer un dossier de backup
New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
Write-Host "`nDossier de backup créé: $backupDir" -ForegroundColor Yellow

foreach ($file in $dartFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Compter les occurrences avant remplacement
        $matches = [regex]::Matches($content, '\.withOpacity\([^)]+\)')
        $occurrences = $matches.Count
        
        if ($occurrences -gt 0) {
            # Créer une copie de sauvegarde
            $relativePath = $file.FullName.Replace($PWD.Path, "").TrimStart("\")
            $backupPath = Join-Path $backupDir $relativePath
            $backupFolder = Split-Path $backupPath -Parent
            
            if (!(Test-Path $backupFolder)) {
                New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null
            }
            
            $originalContent | Set-Content -Path $backupPath -Encoding UTF8 -NoNewline
            
            # Effectuer le remplacement
            $newContent = Convert-WithOpacity -content $content
            
            # Sauvegarder le fichier modifié
            $newContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
            
            $filesModified++
            $totalReplacements += $occurrences
            
            Write-Host "✓ " -ForegroundColor Green -NoNewline
            Write-Host "$($file.Name)" -NoNewline
            Write-Host " - $occurrences remplacement(s)" -ForegroundColor Cyan
        }
    }
    catch {
        Write-Host "✗ Erreur lors du traitement de $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Résumé de la migration:" -ForegroundColor Green
Write-Host "- Fichiers modifiés: $filesModified" -ForegroundColor White
Write-Host "- Total de remplacements: $totalReplacements" -ForegroundColor White
Write-Host "- Backup créé dans: $backupDir" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Vérifier si tout s'est bien passé
if ($filesModified -gt 0) {
    Write-Host "`n✅ Migration terminée avec succès!" -ForegroundColor Green
    Write-Host "Recommandation: Exécutez 'flutter analyze' pour vérifier le code" -ForegroundColor Yellow
} else {
    Write-Host "`n⚠️ Aucun fichier n'a été modifié" -ForegroundColor Yellow
}
