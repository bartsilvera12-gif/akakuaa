# Resizes big PNGs to reasonable display dimensions using System.Drawing.
# Preserves transparency. Overwrites the originals.
# Usage: powershell -File scripts\resize-images.ps1

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function Resize-Png {
  param([string]$Path, [int]$MaxSide)
  $abs = (Resolve-Path $Path).Path
  $orig = [System.Drawing.Image]::FromFile($abs)
  try {
    $w = $orig.Width; $h = $orig.Height
    if ([Math]::Max($w, $h) -le $MaxSide) {
      Write-Host ("skip {0} (ya es {1}x{2})" -f $Path, $w, $h)
      return
    }
    $scale = [double]$MaxSide / [Math]::Max($w, $h)
    $nw = [int][Math]::Round($w * $scale)
    $nh = [int][Math]::Round($h * $scale)
    $bmp = New-Object System.Drawing.Bitmap $nw, $nh, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.DrawImage($orig, 0, 0, $nw, $nh)
    $g.Dispose()
    $orig.Dispose()
    $tmp = "$abs.tmp.png"
    $bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Move-Item -Force $tmp $abs
    $newSize = [math]::Round((Get-Item $abs).Length / 1KB)
    Write-Host ("resized {0}: {1}x{2} -> {3}x{4} ({5} KB)" -f $Path, $w, $h, $nw, $nh, $newSize)
  } finally {
    if ($orig) { try { $orig.Dispose() } catch {} }
  }
}

# Logo: se muestra a 60x60. 200x200 alcanza para retina (2x-3x).
Resize-Png -Path 'uploads/akakuaa.png' -MaxSide 200

# Cinta metrica (esencia): se muestra hasta ~520px de ancho en desktop
Resize-Png -Path 'uploads/cinta-metrica-jirafa-buho.png' -MaxSide 560

# Monito interactivo (esencia): 19% del cinta ~= 100px en desktop
Resize-Png -Path 'uploads/monito-interactivo-akakuaa.png' -MaxSide 240

Write-Host "`nListo. Recorda que los .webp no se procesan con System.Drawing."
