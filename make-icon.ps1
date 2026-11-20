$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap(256, 256)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Arriere-plan : carre aux coins arrondis avec degrade sombre (bleu nuit -> violet)
$rect = New-Object System.Drawing.Rectangle(0, 0, 256, 256)
$lgb = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect,
    [System.Drawing.Color]::FromArgb(255, 12, 18, 48),  # bleu nuit
    [System.Drawing.Color]::FromArgb(255, 75, 20, 110), # violet sombre
    45.0
)

$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$radius = 48
$diameter = $radius * 2
$margin = 8
$w = 256 - ($margin * 2)
$h = 256 - ($margin * 2)

$path.AddArc($margin, $margin, $diameter, $diameter, 180, 90)
$path.AddArc($margin + $w - $diameter, $margin, $diameter, $diameter, 270, 90)
$path.AddArc($margin + $w - $diameter, $margin + $h - $diameter, $diameter, $diameter, 0, 90)
$path.AddArc($margin, $margin + $h - $diameter, $diameter, $diameter, 90, 90)
$path.CloseFigure()

$g.FillPath($lgb, $path)

# Contour fin brillant
$borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 255, 255, 255), 3)
$g.DrawPath($borderPen, $path)

# Dessin de l'eclair blanc au centre
$boltPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$pts = [System.Drawing.PointF[]]@(
    (New-Object System.Drawing.PointF(138.0, 36.0)),
    (New-Object System.Drawing.PointF(82.0, 132.0)),
    (New-Object System.Drawing.PointF(126.0, 132.0)),
    (New-Object System.Drawing.PointF(102.0, 220.0)),
    (New-Object System.Drawing.PointF(178.0, 116.0)),
    (New-Object System.Drawing.PointF(134.0, 116.0))
)
$boltPath.AddPolygon($pts)

# Halo neon bleu/violet derriere l'eclair
$glowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(80, 120, 200, 255), 14)
$glowPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawPath($glowPen, $boltPath)

$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillPath($whiteBrush, $boltPath)

$g.Dispose()

# Encodage PNG en memoire
$ms = New-Object System.IO.MemoryStream
$bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
$pngBytes = $ms.ToArray()
$bmp.Dispose()
$ms.Dispose()

# Construction de l'en-tete et l'entree d'icone ICO (PNG incorpore)
$icoStream = New-Object System.IO.MemoryStream

# ICONDIR : Reserved(2), Type(2=1), Count(2=1)
$icoStream.Write([byte[]]@(0, 0, 1, 0, 1, 0), 0, 6)

# ICONDIRENTRY (16 octets) :
# Width(1)=0 (256), Height(1)=0 (256), ColorCount(1)=0, Reserved(1)=0,
# Planes(2)=1, BitCount(2)=32, BytesInRes(4)=len, ImageOffset(4)=22
$bytesInRes = [System.BitConverter]::GetBytes([uint32]$pngBytes.Length)
$imageOffset = [System.BitConverter]::GetBytes([uint32]22)

$entry = [byte[]]@(
    0, 0, 0, 0,
    1, 0, 32, 0,
    $bytesInRes[0], $bytesInRes[1], $bytesInRes[2], $bytesInRes[3],
    $imageOffset[0], $imageOffset[1], $imageOffset[2], $imageOffset[3]
)
$icoStream.Write($entry, 0, 16)

# Octets PNG
$icoStream.Write($pngBytes, 0, $pngBytes.Length)

$outputPath = Join-Path $PSScriptRoot "icon.ico"
[System.IO.File]::WriteAllBytes($outputPath, $icoStream.ToArray())
$icoStream.Dispose()

Write-Host "Icone generee avec succes : $outputPath"