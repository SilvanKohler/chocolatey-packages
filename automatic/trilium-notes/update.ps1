import-module au

$domain   = 'https://github.com'
$releases = "$domain/zadam/trilium/releases"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"   	= "`$1'$($Latest.Checksum)'"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing #1
  $regex   = 'trilium-windows-x64-\d+.\d+.\d+.zip$'
  $sublink = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -Skip 0 -expand href #2
  $url = ($domain, $sublink) -join ''
  $token = $url -split 'trilium-windows-x64-' | Select-Object -First 1 -Skip 1
  $version = $token -split '.zip' | Select-Object -Last 1 -Skip 1
  return @{ Version = $version; URL = $url }
}

update -ChecksumFor 64 #-NoCheckChocoVersion
