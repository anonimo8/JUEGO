# Caminos de Fe V21.1 - instalador personal mejorado
# Descarga de imágenes solo a la computadora del usuario; no se incluyen en el ZIP.
$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$items = Get-Content (Join-Path $root 'fuentes-jw-personales.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$artDir = Join-Path $root 'assets\jw-uso-personal'
New-Item -ItemType Directory -Path $artDir -Force | Out-Null
Write-Host 'CAMINOS DE FE V21.1 - BUSCADOR CORREGIDO DE ILUSTRACIONES' -ForegroundColor Cyan
Write-Host 'Uso personal; no publiques ni compartas assets\jw-uso-personal.' -ForegroundColor Yellow
$confirm = Read-Host 'Escribe PERSONAL para continuar'
if ($confirm -cne 'PERSONAL') { Write-Host 'Sin cambios.'; exit 0 }
Add-Type -AssemblyName System.Drawing
$installed=@{}; $notFound=@(); $report=@(); $allFails=0
# Solo dominios oficiales de imágenes de las publicaciones.
function ImagenUrlValida([string]$u) {
  return $u -match '^https://cms-imgp\.jw-cdn\.org/img/p/[a-z0-9]+/univ/art/[^?#]+\.(?:jpg|jpeg)$' -or $u -match '^https://assetsnffrgf-a\.akamaihd\.net/assets/m/[a-z0-9]+/univ/wpub/[^?#]+\.(?:jpg|jpeg)$'
}
function AgregarCandidato($lista,[string]$u) {
  if ([string]::IsNullOrWhiteSpace($u)) { return }
  $u = [System.Net.WebUtility]::HtmlDecode($u.Trim()).Replace('\/','/')
  $u = $u -replace '^//','https://'
  $u = $u -replace '\?.*$',''
  if ((ImagenUrlValida $u) -and (-not $lista.Contains($u))) { [void]$lista.Add($u) }
}
# Crear un lienzo horizontal si la fuente original es vertical; evita recortar caras.
function AjustarImagenAlEscenario([string]$origen,[string]$destino) {
  $src = [System.Drawing.Image]::FromFile($origen)
  try {
    $bmp = New-Object System.Drawing.Bitmap(1600,900)
    try {
      $g=[System.Drawing.Graphics]::FromImage($bmp)
      try {
        $g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.Clear([System.Drawing.Color]::FromArgb(24,38,51))
        # Fondo ampliado con velo oscuro; imagen completa centrada en primer plano.
        $zoom=[Math]::Max(1600.0/$src.Width,900.0/$src.Height)
        $w=$src.Width*$zoom; $h=$src.Height*$zoom
        $g.DrawImage($src,[System.Drawing.RectangleF]::new([float]((1600-$w)/2),[float]((900-$h)/2),[float]$w,[float]$h))
        $shade = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(155,12,22,35))
        try { $g.FillRectangle($shade,0,0,1600,900) } finally { $shade.Dispose() }
        $scale=[Math]::Min(1490.0/$src.Width,840.0/$src.Height)
        $fw=$src.Width*$scale; $fh=$src.Height*$scale
        $g.DrawImage($src,[System.Drawing.RectangleF]::new([float]((1600-$fw)/2),[float]((900-$fh)/2),[float]$fw,[float]$fh))
      } finally { $g.Dispose() }
      $bmp.Save($destino,[System.Drawing.Imaging.ImageFormat]::Jpeg)
    } finally { $bmp.Dispose() }
  } finally { $src.Dispose() }
}
foreach ($item in $items) {
  $id=[string]$item.id; $nombre=[string]$item.nombre
  Write-Host ('Buscando: '+$nombre) -ForegroundColor Cyan
  $target=Join-Path $artDir ($id+'.jpg')
  if(Test-Path $target) {
    $installed[$id]='assets/jw-uso-personal/'+$id+'.jpg'
    $report+=($nombre+': YA EXISTE (si quieres reemplazarla, borra '+$id+'.jpg)')
    Write-Host 'Imagen ya instalada' -ForegroundColor Green
    continue
  }
  $urls = New-Object 'System.Collections.Generic.List[string]'
  $codes = New-Object 'System.Collections.Generic.List[string]'
  foreach ($code in @([string]$item.codigo_publicacion,[string]$item.codigo_anterior)) {
    if($code -match '^[0-9]{8,12}$' -and -not $codes.Contains($code)) {[void]$codes.Add($code)}
  }
  $pages = @([string]$item.pagina,[string]$item.pagina_anterior) | Where-Object {$_ -match '^https://www\.jw\.org/'} | Select-Object -Unique
  # Si no hay código preconfigurado, recuperarlo de la miniatura vinculada a la propia publicación.
  foreach ($pageUrl in $pages) {
    try {
      $html=(Invoke-WebRequest -Uri $pageUrl -UseBasicParsing -TimeoutSec 20 -Headers @{'User-Agent'='Mozilla/5.0';'Accept-Language'='es-ES,es;q=0.9'}).Content
      $html=[System.Net.WebUtility]::HtmlDecode([string]$html).Replace('\/','/')
      $m=[regex]::Match($html,'https?://cms-imgp\.jw-cdn\.org/img/p/([0-9]{8,12})/univ/art/\1_univ_sqr_')
      if($m.Success) { $c=$m.Groups[1].Value; if(-not $codes.Contains($c)){[void]$codes.Add($c)} }
      # Extraer imágenes de la propia publicación: no elegir imágenes de publicidad ni de otras secciones.
      $imgMatches=[regex]::Matches($html,'(?:https?:)?//(?:cms-imgp\.jw-cdn\.org/img/p|assetsnffrgf-a\.akamaihd\.net/assets/m)/[^\s"''<>]+?\.(?:jpg|jpeg)')
      foreach ($im in $imgMatches) {
        $candidate=$im.Value -replace '_xs\.(jpg|jpeg)$','_xl.$1' -replace '_sm\.(jpg|jpeg)$','_lg.$1'
        if($candidate -match '_cnt_[0-9]+_' -or $candidate -match '_lsr_') { AgregarCandidato $urls $candidate }
      }
    } catch { $report+=($nombre+': no se pudo leer pagina '+$pageUrl+': '+$_.Exception.Message) }
  }
  # Priorizar imágenes narrativas panorámicas de los libros modernos (cnt_1),
  # antes de la imagen cuadrada de portada. Se incluyen variantes por compatibilidad.
  $generated=New-Object 'System.Collections.Generic.List[string]'
  foreach ($code in $codes) {
    $base='https://cms-imgp.jw-cdn.org/img/p/'+$code+'/univ/art/'+$code+'_univ_'
    foreach($kind in @('cnt_1','cnt_2','cnt_3','cnt_4','cnt_5','lsr')) {
      foreach($size in @('xl','lg')) { AgregarCandidato $generated ($base+$kind+'_'+$size+'.jpg') }
    }
  }
  foreach ($u in $urls) { AgregarCandidato $generated $u }
  $ok=$false; $errors=New-Object 'System.Collections.Generic.List[string]'
  foreach ($link in $generated) {
    $tmp=Join-Path $artDir ($id+'.tmp')
    try {
      Invoke-WebRequest -Uri $link -UseBasicParsing -OutFile $tmp -TimeoutSec 15 -Headers @{'User-Agent'='Mozilla/5.0';'Referer'='https://www.jw.org/'} | Out-Null
      if ((Get-Item $tmp).Length -lt 12000) { throw 'archivo demasiado pequeno' }
      $img=[System.Drawing.Image]::FromFile($tmp)
      $iw=$img.Width; $ih=$img.Height; $img.Dispose()
      if ($iw -lt 400 -or $ih -lt 250) { throw 'resolucion insuficiente' }
      if ($iw -lt $ih) { AjustarImagenAlEscenario $tmp $target; Remove-Item $tmp -Force }
      else { Move-Item $tmp $target -Force }
      $installed[$id]='assets/jw-uso-personal/'+$id+'.jpg'
      $ok=$true
      Write-Host ($nombre+': '+$iw+'x'+$ih+' - imagen instalada') -ForegroundColor Green
      $report+=($nombre+': OK '+$link+' ('+$iw+'x'+$ih+')')
      break
    } catch {
      if (Test-Path $tmp) { Remove-Item $tmp -ErrorAction SilentlyContinue }
      if ($errors.Count -lt 3) { [void]$errors.Add($_.Exception.Message) }
    }
  }
  if(-not $ok) {
    $notFound+=$nombre; $allFails++
    $details=($errors -join ' / ')
    $report+=($nombre+': NO INSTALADA; '+$generated.Count+' variantes probadas. '+$details+' | '+$item.pagina)
    Write-Warning ($nombre+': no se pudo descargar. Ver detalles en RESULTADOS_ILUSTRACIONES.txt')
  }
}
$script=Join-Path $root 'assets-personales.js'
$json=ConvertTo-Json -InputObject $installed -Compress -Depth 6
[IO.File]::WriteAllText($script,'window.JW_LOCAL_ART='+$json+';', [Text.UTF8Encoding]::new($false))
$reportPath=Join-Path $root 'RESULTADOS_ILUSTRACIONES.txt'
$header=@('INSTALADOR V21.1 - REPORTE DE DESCARGA',('Instaladas o ya existentes: '+$installed.Count+'/'+$items.Count),'El uso local no garantiza descarga; algunas imágenes pueden estar bloqueadas por servidor.','NO DISTRIBUYAS assets/jw-uso-personal.',' ')
[IO.File]::WriteAllLines($reportPath,$header+$report,[Text.UTF8Encoding]::new($false))
Write-Host ('RESULTADO: '+$installed.Count+' de '+$items.Count+' relatos con arte local. '+$allFails+' no descargados.') -ForegroundColor Cyan
Write-Host 'Consulta RESULTADOS_ILUSTRACIONES.txt. Se abrira el juego al cerrar esta ventana.' -ForegroundColor Cyan
Start-Sleep -Seconds 5
