function profile
{
    'Profile'
}

(Get-Host).UI.RawUI.ForegroundColor = 'green'
(Get-Host).UI.RawUI.BackgroundColor = 'black'

Set-Alias sort Sort-Object
Set-Alias ga Get-Alias

New-Variable consta -value 7788
New-Variable PI -value 3.14

Set-location C:\

Write-Host ("---------Приветствую--------")

Get-Module -ListAvailable