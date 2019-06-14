#1
#1.1.	Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)
        Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=True | Select-Object -Property Description, Ipaddress, Ipsubnet
#1.2	Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.
        Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=True | Select-Object -Property Description, Macaddress
#1.3	На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP
        Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=True -ComputerName Win-1 | % -Process {$_.InvokeMethod("EnableDHCP", $null)}
#1.4	Расшарить папку на компьютере
        New-SmbShare -Name "New Folder" -Path "C:\New Folder" -ContinuouslyAvailable -FullAccess 'home\Administrator' -ReadAccess 'home\GuestUsers'
#1.5	Удалить шару из п.1.4
        Remove-SmbShare -Name SharedFolder -Force

#2 
#2.1 	Получить список коммандлетов работы с Hyper-V (Module Hyper-V)
        Get-Command -Module Hyper-V 
#2.2    Получить список виртуальных машин 
        Get-VM
        <#
        Name       State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
        ----       ----- ----------- ----------------- ------   ------             -------
        YATSUK_VM1 Off   0           0                 00:00:00 Работает нормально 8.3    
        YATSUK_VM2 Off   0           0                 00:00:00 Работает нормально 8.3    
        YATSUK_VM3 Off   0           0                 00:00:00 Работает нормально 8.3    
        #>

#2.3	Получить состояние имеющихся виртуальных машин
        Get-VM | Select-Object Name, State
        <#
        Name         State
        ----         -----
        YATSUK_VM1   Running
        YATSUK_VM2   Off
        YATSUK_VM3   Off
        #>

#2.4	Выключить виртуальную машину
        Get-VM -Name YATSUK_VM1 | Stop-VM
        <#
        Name       State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
        ----       ----- ----------- ----------------- ------   ------             -------
        YATSUK_VM1 Off   0           0                 00:00:00 Работает нормально 8.3    
        #>

#2.5	Создать новую виртуальную машину
        [string] $VMName = "Test_VM"
        $VM = @{
            Name = "$VMName"
            Path = "C:\$VMName"
            NewVHDPath = "C:\$VMName\$VMName.vhdx"
            MemoryStartupBytes = 1024Mb
            Generation = 2
            NewVHDSizeBytes = 60Gb
            BootDevice = "VHD"
            SwitchName = 'Internal Net'
        }
        New-VM @VM

#2.6	Создать динамический жесткий диск
        New-VHD -Path "C:\$VMName\vhdx1.vhdx" -SizeBytes 60GB -Dynamic
        <#
        ComputerName            : DENMUSIC-PC
        Path                    : C:\vhdx1.vhdx
        VhdFormat               : VHDX
        VhdType                 : Dynamic
        FileSize                : 4194304
        Size                    : 64424509440
        MinimumSize             : 
        LogicalSectorSize       : 512
        PhysicalSectorSize      : 4096
        BlockSize               : 33554432
        ParentPath              : 
        DiskIdentifier          : E6CD4CB7-D4B9-4327-828F-5BEFE7EB81D9
        FragmentationPercentage : 0
        Alignment               : 1
        Attached                : False
        DiskNumber              : 
        IsPMEMCompatible        : False
        AddressAbstractionType  : None
        Number                  : 
        #>

#2.7	Удалить созданную виртуальную машину
        Get-VM -Name Test_VM | Remove-VM       

