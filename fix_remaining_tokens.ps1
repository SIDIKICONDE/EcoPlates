    # Script amélioré pour corriger les références restantes aux design tokens

param(
    [string]$ProjectPath = "."
)

Write-Host "Correction des références restantes aux design tokens..." -ForegroundColor Green

function Replace-InFile {
    param(
        [string]$FilePath
    )

    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        $originalContent = $content

        # Remplacer TOUTES les occurrences de EcoPlatesDesignTokens par des valeurs fixes
        $content = $content -replace 'EcoPlatesDesignTokens\.[^(]*\([^)]*\)', '16.0'  # Toutes les méthodes avec paramètres
        $content = $content -replace 'EcoPlatesDesignTokens\.[^.]*\.[^.]*', '16.0'  # Toutes les propriétés imbriquées

        if ($content -ne $originalContent) {
            $content | Set-Content $FilePath -NoNewline -Encoding UTF8
            Write-Host "Modifié: $FilePath" -ForegroundColor Yellow
        }
    }
}

# Trouver tous les fichiers Dart contenant EcoPlatesDesignTokens
$filesWithTokens = Get-ChildItem -Path $ProjectPath -Filter "*.dart" -Recurse | Where-Object {
    $_.FullName -notlike "*\build\*" -and
    $_.FullName -notlike "*\.dart_tool\*" -and
    $_.FullName -notlike "*\.pub-cache\*"
} | Where-Object {
    (Get-Content $_.FullName -Raw) -match "EcoPlatesDesignTokens"
}

Write-Host "Traitement de $($filesWithTokens.Count) fichiers contenant EcoPlatesDesignTokens..." -ForegroundColor Cyan

foreach ($file in $filesWithTokens) {
    $filePath = $file.FullName
    Replace-InFile -FilePath $filePath
}

Write-Host "Correction terminée !" -ForegroundColor Green
