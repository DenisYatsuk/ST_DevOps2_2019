#1.	
    Get-PSDrive – список доступных дисков
	cd HKCU:\ - переход в HKey_Current_user
	dir – просмотр ветви HKCU
#2.	
    New-Item -ItemType Directory -Force –Path ‘D:\New Dir’ – создать 
	Rename-Item -path 'D:\New Dir' -NewName 'D:\Dir' – переименовать
	Remove-Item -path 'D:\Dir' – удалить
#3.	
    New-Item -ItemType Directory -Force –Path ‘C:\M2T2_YATSUK’ - создание папки
	new-psdrive -name M2T2 -psprovider FileSystem -root C:\M2T2_YATSUK - создание диска
#4.	
    Get-Service | Where-Object {$_.Status -eq "Running"} | Out-File M2T2:\RunningServices.txt – сохраняем txt c активными службами
	dir – просмотр содержимого диска M2T2
	Get-Content -path RunningServices.txt – просмотр файла в консоле
#5. Просуммировать все значения сеанса 
	$result = Get-Variable | ? -FilterScript {$_.Value.GetType() -like 'int*'}
	$result | % {$sum += $_.value}
	$sum 
#6. Список из 6 процессов занимающих дольше всего процессор
    Get-Process | Sort-Object CPU -Descending | select-object -First 6
#7. Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире, при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.
    Get-Process | ForEach-Object 
    {
        if ($($_.VM/1Mb) -gt 100) 
        {
            Write-Host ($_.name, ("{0:N2}" -f $($_.VM/1Mb))) -separator " - " -ForegroundColor red
        } 
        else 
        {
            Write-Host ($_.name, ("{0:N2}" -f $($_.VM/1Mb))) -separator " - " -ForegroundColor green
        }
    }
#8. Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp
"{0:N2} Gb" -f ((Get-ChildItem –force C:\Windows –Recurse -ErrorAction SilentlyContinue -Exclude *.tmp | Measure-Object Length -Sum).sum / 1Gb)
#9. Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
    Get-ChildItem HKLM:\SOFTWARE\Microsoft\ | Export-Csv C:\M2T2_YATSUK\hklm.csv
#10. Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.
    Get-History | Export-Clixml C:\M2T2_YATSUK\history.xml
#11. Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, в виде 5 любых свойств.
    Import-Clixml C:\M2T2_YATSUK\history.xml | Select-Object -Property Id, CommandLine, ExecutionStatus, StartExecutionTime, EndExecutionTime
#12. Удалить созданный диск и папку С:\M2T2_YATSUK
    Remove-PSDrive -Name M2T2 -PSProvider FileSystem -Force
    Remove-Item -Path C:\M2T2_YATSUK\ -Force

