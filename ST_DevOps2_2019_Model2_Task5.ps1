#1  При помощи WMI перезагрузить все виртуальные машины(с учетом памяти - одну вм).
    Get-WmiObject Win32_OperatingSystem –ComputerName win-1 -Credential DenMusic-PC | Invoke-WmiMethod -Name Reboot
#2  При помощи WMI просмотреть список запущенных служб на удаленном компьютере.
    Get-WmiObject Win32_Service -ComputerName win-1 -Credential DenMusic-PC | ? {$_.State -eq 'Running'} | Format-Table -Property Name, State
#3  Настроить PowerShell Remoting
    Enable-PSRemoting
#4	Для одной из виртуальных машин установить для прослушивания порт 42658. Проверить работоспособность PS Remoting
    Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener $true
    Set-Item WSMan:\localhost\Listener\Listener_1084132640\Port -Value 42658
    Enter-PSSession 192.168.15.1 -Port 42658
#5  Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.
    New-PSSessionConfigurationFile -Path C:\SessionConfig.pssc -VisibleCmdlets Get-ChildItem,Exit-PSSession
