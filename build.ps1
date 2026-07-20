# build.ps1 — genera dist/ y akakuaa-hostinger.zip listo para subir a Hostinger
# Uso: pwsh -File build.ps1  (o: powershell -File build.ps1)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
Set-Location $root

$dist = Join-Path $root 'dist'
$zip  = Join-Path $root 'akakuaa-hostinger.zip'

Write-Host "Limpiando build anterior..." -ForegroundColor Cyan
if (Test-Path $dist) { Remove-Item $dist -Recurse -Force }
if (Test-Path $zip)  { Remove-Item $zip  -Force }
New-Item -ItemType Directory -Path $dist | Out-Null

$files = @(
  'Akakuaa.dc.html','catalogo.html','faq.html','historia.html',
  'index.html','privacidad.html','sucursales.html',
  'mobile.css','mobile.js','support.js','.htaccess'
)
foreach ($f in $files) {
  if (Test-Path $f) { Copy-Item $f -Destination $dist }
  else { Write-Warning "No existe $f" }
}

foreach ($d in @('uploads','public')) {
  if (Test-Path $d) { Copy-Item $d -Destination $dist -Recurse }
}

Write-Host "Empaquetando akakuaa-hostinger.zip..." -ForegroundColor Cyan
Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::CreateFromDirectory(
  $dist, $zip,
  [System.IO.Compression.CompressionLevel]::Optimal,
  $false
)

$size = [math]::Round((Get-Item $zip).Length / 1MB, 2)
Write-Host "Listo. dist/ + $($zip.Split([IO.Path]::DirectorySeparatorChar)[-1]) ($size MB)" -ForegroundColor Green
Write-Host ""
Write-Host "Subir a Hostinger:" -ForegroundColor Yellow
Write-Host "  1. Entra al File Manager de Hostinger, carpeta public_html/"
Write-Host "  2. Subi akakuaa-hostinger.zip y hace Extract"
Write-Host "  3. Verifica que .htaccess quedo en la raiz (activa 'Show hidden files')"
