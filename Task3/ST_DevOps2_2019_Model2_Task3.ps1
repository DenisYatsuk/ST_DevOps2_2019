#1.1 Сохранить в текстовый файл на диске список запущенных(!) служб. 
#    Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
function fun1_1
{
    Param 
    (
        [parameter(Mandatory=$true, HelpMessage="Enter name of output .txt file")]  
        [string] $SavedFile = $(Throw "Enter name, for Example, saved.txt"),
        [parameter(Mandatory=$true, HelpMessage="Enter Disc to look")]               
        [ValidateLength(3,3)][string] $OutputDisc = $(Throw "Enter one Disc , for Example, C:\"),
        [parameter(Mandatory=$true, HelpMessage="File name")]                       
        [string] $OutputFile = $(Throw "Enter name, for Example, saved.txt")
    )
    Write-Host ("Saving File...")
    Get-Service > $SavedFile
    Write-Host ("Content of Disc " + $OutputDisc + " :")
    Get-ChildItem $OutputDisc
    Write-Host ("")

    $TestPath = Test-Path -Path $OutputFile
    if ($TestPath = $True)
    {
        Get-Content -Path $OutputFile
    }
    else
    {
        Write-host "File $OutputFile doesn't exist"
    }
}

fun1_1

#1.2 Просуммировать все числовые значения переменных среды Windows.
function fun1_2
{
    $sum = 0
    Get-Variable | % 
        {
            if (($PSitem.Name -ne "null") -and ($PSItem.Value.GetType() -eq [int32]))
            {
                $sum+=$PSitem.Value
            } 
            else 
            {

            }
        }
    $sum
}

fun1_2

#1.3 Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл. Запись каждые 10 мин.
    Get-Process | Sort-Object CPU -Descending | select-object -first 10 | Out-File С:\CPU_10.txt   
    
    $Trigger = New-ScheduledTaskTrigger -Once -At "06/12/2019 11:10" -RepetitionInterval (New-TimeSpan -Minutes 10)
    $Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\Get_CPU_10.ps1"
    Register-ScheduledTask -TaskName "Get_CPU_10" -Trigger $Trigger -Action $Action -RunLevel Highest –Force

#1.4 Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
function fun1_4
{
    Param 
    (
        [string]$Folder = "C:\Windows"
    )
    "{0:N2} Gb" -f ((Get-ChildItem –force $Folder –Recurse -ErrorAction SilentlyContinue -Exclude *.tmp | Measure-Object Length -Sum).sum / 1Gb) 
}

#1.5 
#1.5.1	Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
        $csv = Get-HotFix | Export-Csv C:\HotFix.csv
#1.5.2	Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
        $xml = Get-ChildItem HKLM:\SOFTWARE\Microsoft\ | Export-Clixml C:\HKLM.xml
#1.5.3  Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами
        $result_csv = Import-Csv -Path C:\HotFix.csv | Format-List
        $result_xml = Import-Clixml C:\HKLM.xml | Select-Object -Property id, commandline, ExecutionStatus, StartExecutionTime, EndExecutionTime | Format-List

        function fun1_5
        {
            Write-Host $result_csv -ForegroundColor Yellow
            Write-Host $result_xml -ForegroundColor Pink
        }



