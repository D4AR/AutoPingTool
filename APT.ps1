$file = "IP's.txt"
$folder = "Results"

function Set-ConsoleColor ($bc, $fc) {
    $Host.UI.RawUI.BackgroundColor = $bc
    $Host.UI.RawUI.ForegroundColor = $fc
    Clear-Host
}
Set-ConsoleColor 'black' 'green'
#https://stackoverflow.com/questions/18685772/how-to-set-powershell-background-color-programmatically-to-rgb-value


Function CheckIP{
  $names=Get-Content "$file"
  foreach ($name in $names){
    if(Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue){
      Write-Host "$name is UP" -ForegroundColor Cyan
      $Output1+="$name"+"`n"
      $Output1 | Out-file "Results\IP_UP.txt"
    }
    else{
      Write-Host "$name is DOWN" -ForegroundColor Magenta
      $Output+="$name"+"`n"
      $Output | Out-File "Results\IP_DOWN.txt"
      }
    }
    Start-Sleep -s 1
}

Function DoesFolderExist {
  param([string]$inputfile)
  if (Test-Path -Path $inputfile -PathType Container){ return $true;} else { return $false; }
}

Function DoesFileExist {
  param([string]$inputfile)
  if (Test-Path -Path $inputfile -PathType Leaf){ return $true;} else { return $false; }
}

Function CheckALL {
  if(DoesFolderExist($folder)){
    if(DoesFileExist($file)){
    CheckIP
      }
      else{
        New-Item "$file" -ItemType "file" -Force | Out-Null
        Write-Host "`nThe file 'ip's' does not exist!`n" -ForegroundColor DarkRed
        Write-Host "But now it does!`n" -ForegroundColor Green
        Write-Host "`n`nYOU NEED TO PUT IP'S IN THE FILE, OTHERWISE IT NO WORKY >:( `nCome back when you have put in ip's`n" -ForegroundColor Darkred
        Exit
      }
  }
  else {
    Write-Host "`nThe folder 'results' does not exist!`n" -ForegroundColor DarkRed
    Write-Host "But now it does!`n" -ForegroundColor Green
    New-Item 'Results' -ItemType "Directory" -Force | Out-Null
    if(DoesFileExist($file)){
    CheckIP
      }
      else{
        New-Item "$file" -ItemType "file" -Force | Out-Null
        Write-Host "`nThe file 'ip's' does not exist!`n" -ForegroundColor DarkRed
        Write-Host "But now it does!`n" -ForegroundColor Green
        Write-Host "`n`nYOU NEED TO PUT IP'S IN THE FILE, OTHERWISE IT NO WORKY >:( `nCome back when you have put in ip's`n" -ForegroundColor Darkred
        Exit
      }
  }
}
CheckALL

$text = @"
 /#######                  /## /##                       /##                     /##         /##                     /#######  /##   /##  /######       /## /###### /########
| ##__  ##                | ##|__/                      | ##                    | ##        | ##                    | ##__  ##| ##  | ## /##__  ##     /##/|_  ##_/|__  ##__/
| ##  \ ##  /######   /####### /##  /#######  /######  /######    /######   /#######       /######    /######       | ##  \ ##| ##  | ##| ##  \__/    /##/   | ##     | ##
| ##  | ## /##__  ## /##__  ##| ## /##_____/ |____  ##|_  ##_/   /##__  ## /##__  ##      |_  ##_/   /##__  ##      | ####### | ##  | ##|  ######    /##/    | ##     | ##
| ##  | ##| ########| ##  | ##| ##| ##        /#######  | ##    | ########| ##  | ##        | ##    | ##  \ ##      | ##__  ##| ##  | ## \____  ##  /##/     | ##     | ##
| ##  | ##| ##_____/| ##  | ##| ##| ##       /##__  ##  | ## /##| ##_____/| ##  | ##        | ## /##| ##  | ##      | ##  \ ##| ##  | ## /##  \ ## /##/      | ##     | ##
| #######/|  #######|  #######| ##|  #######|  #######  |  ####/|  #######|  #######        |  ####/|  ######/      | #######/|  ######/|  ######//##/      /######   | ##
|_______/  \_______/ \_______/|__/ \_______/ \_______/   \___/   \_______/ \_______/         \___/   \______/       |_______/  \______/  \______/|__/      |______/   |__/
"@
function Blink-Message {
 param([String]$Message,[int]$Delay,[int]$Count,[ConsoleColor[]]$Colors)
    $startColor = [Console]::ForegroundColor
    $startLeft  = [Console]::CursorLeft
    $startTop   = [Console]::CursorTop
    $colorCount = $Colors.Length
    for($i = 0; $i -lt $Count; $i++) {
        [Console]::CursorLeft = $startLeft
        [Console]::CursorTop  = $startTop
        [Console]::ForegroundColor = $Colors[$($i % $colorCount)]
        [Console]::WriteLine($Message)
        Start-Sleep -Milliseconds $Delay
    }
    [Console]::ForegroundColor = $startColor
}
cls
Write-Host "`n All IPs have been recorded to Results/IP*.txt`n"
Blink-Message $text 250 20000 DarkRed, DarkYellow, DarkGreen, DarkCyan, DarkBlue, DarkMagenta
