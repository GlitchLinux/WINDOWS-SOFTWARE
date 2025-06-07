<#
.SYNOPSIS
    Windows Software Downloader Utility
.DESCRIPTION
    This script allows users to browse and download software from the GlitchLinux/WINDOWS-SOFTWARE GitHub repository
    using direct download links for individual files.
.NOTES
    File Name      : WindowsSoftwareDownloader.ps1
    Author         : Your Name
    Prerequisite   : PowerShell 5.1 or later
#>

# Configuration
$repoUrl = "https://github.com/GlitchLinux/WINDOWS-SOFTWARE"
$defaultDownloadPath = "$env:USERPROFILE\Desktop\WINDOWS-SOFTWARE"

# Initialize variables
$softwareList = @()
$selectedCategory = $null
$downloadPath = $defaultDownloadPath

# Create a hashtable to map the folder structure with direct download links
$categories = @{
    "1" = @{ 
        Name = "PT1"; 
        Description = "Partition Tools & Utilities";
        Files = @(
            @{Name="7z.dll"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/7z.dll"},
            @{Name="7z.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/7z.exe"},
            @{Name="7zG.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/7zG.exe"},
            @{Name="7Zip.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/7Zip.7z"},
            @{Name="ActiveFileRecoveryMiniXP.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/ActiveFileRecoveryMiniXP.7z"},
            @{Name="ActivePartitionRecoveryMiniXP.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/ActivePartitionRecoveryMiniXP.7z"},
            @{Name="ActiveSetDT.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/ActiveSetDT.7z"},
            @{Name="AdminPasswordResetter.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/AdminPasswordResetter.7z"},
            @{Name="AntiDeepFreeze1.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/AntiDeepFreeze1.7z"},
            @{Name="AutoMountDrives.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/AutoMountDrives.7z"},
            @{Name="AvastRegistryEditor.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/AvastRegistryEditor.7z"},
            @{Name="BatteryInfoView.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BatteryInfoView.7z"},
            @{Name="BatteryMon.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BatteryMon.7z"},
            @{Name="BKAntiMacroVirus.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BKAntiMacroVirus.7z"},
            @{Name="BkavRansomwareScan.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BkavRansomwareScan.7z"},
            @{Name="BlankAndSecure.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BlankAndSecure.7z"},
            @{Name="BootICEx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BootICEx64.7z"},
            @{Name="BootICEx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BootICEx86.7z"},
            @{Name="BootNext.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/BootNext.7z"},
            @{Name="CardRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/CardRecovery.7z"},
            @{Name="CheckFileHash.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/CheckFileHash.7z"},
            @{Name="CheckMON.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/CheckMON.7z"},
            @{Name="CMOSDeAnimator.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/CMOSDeAnimator.7z"},
            @{Name="CPUZ.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/CPUZ.7z"},
            @{Name="DaossoftWindowsPassword.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DaossoftWindowsPassword.7z"},
            @{Name="DeadPixelTester.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DeadPixelTester.7z"},
            @{Name="De-CMOS3.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/De-CMOS3.7z"},
            @{Name="DevlibGetDiskSerial.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DevlibGetDiskSerial.7z"},
            @{Name="DLLRegSVR.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DLLRegSVR.7z"},
            @{Name="DLLRegSVRx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DLLRegSVRx64.7z"},
            @{Name="DLLRegSVRx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DLLRegSVRx86.7z"},
            @{Name="DnsJumper.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DnsJumper.7z"},
            @{Name="DoubleDriver.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DoubleDriver.7z"},
            @{Name="DuplicateFileFinder.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/DuplicateFileFinder.7z"},
            @{Name="EVKey.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/EVKey.7z"},
            @{Name="FATtoNTFS.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/FATtoNTFS.7z"},
            @{Name="FixNTLDR.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/FixNTLDR.7z"},
            @{Name="FixPrinter.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/FixPrinter.7z"},
            @{Name="FlashMemoryToolkit.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/FlashMemoryToolkit.7z"},
            @{Name="Framework35Offline.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/Framework35Offline.7z"},
            @{Name="GetPassword.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/GetPassword.7z"},
            @{Name="GhostExplorer.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/GhostExplorer.7z"},
            @{Name="HardDiskSerialNumberChanger.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/HardDiskSerialNumberChanger.7z"},
            @{Name="HardwareMonitor.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/HardwareMonitor.7z"},
            @{Name="HDDLowLevelFormatTool.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/HDDLowLevelFormatTool.7z"},
            @{Name="HDTunePro.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/HDTunePro.7z"},
            @{Name="IrfanView.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/IrfanView.7z"},
            @{Name="IsMyHddOK.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/IsMyHddOK.7z"},
            @{Name="IsMyLcdOK.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/IsMyLcdOK.7z"},
            @{Name="KeyTweak.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/KeyTweak.7z"},
            @{Name="LinksVIPTool.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/LinksVIPTool.7z"},
            @{Name="MouseEmulator.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/MouseEmulator.7z"},
            @{Name="NortonGhost.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/NortonGhost.7z"},
            @{Name="Notepad.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/Notepad.7z"},
            @{Name="NTBOOTAutoFix.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/NTBOOTAutoFix.7z"},
            @{Name="NTFSDriveProtection.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/NTFSDriveProtection.7z"},
            @{Name="OnScreenKeyboard.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/OnScreenKeyboard.7z"},
            @{Name="PandoraRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/PandoraRecovery.7z"},
            @{Name="PartitionFindandMount.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/PartitionFindandMount.7z"},
            @{Name="PassMarkKeyboardTest.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/PassMarkKeyboardTest.7z"},
            @{Name="PowerToolx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/PowerToolx64.7z"},
            @{Name="PowerToolx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/PowerToolx86.7z"},
            @{Name="PrintQueueCleaner.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/PrintQueueCleaner.7z"},
            @{Name="RegistryWorkshopx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/RegistryWorkshopx64.7z"},
            @{Name="RegistryWorkshopx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/RegistryWorkshopx86.7z"},
            @{Name="RemoveWGA.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/RemoveWGA.7z"},
            @{Name="ResourceHacker.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/ResourceHacker.7z"},
            @{Name="Rufus.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/Rufus.7z"},
            @{Name="SDFormatter.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/SDFormatter.7z"},
            @{Name="SmartRipper.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/SmartRipper.7z"},
            @{Name="TenorshareWindowsPassword.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/TenorshareWindowsPassword.7z"},
            @{Name="TeraCopy.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/TeraCopy.7z"},
            @{Name="TeraDisableEnable.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/TeraDisableEnable.7z"},
            @{Name="TestUSB.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/TestUSB.7z"},
            @{Name="TFtpd32.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/TFtpd32.7z"},
            @{Name="TNAntiM4NamesExcel.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/TNAntiM4NamesExcel.7z"},
            @{Name="UltraISO.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/UltraISO.7z"},
            @{Name="Unlocker.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/Unlocker.7z"},
            @{Name="USBDiskStorageFormat.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/USBDiskStorageFormat.7z"},
            @{Name="USBUnhide.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/USBUnhide.7z"},
            @{Name="VideoMemoryStressTest.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/VideoMemoryStressTest.7z"},
            @{Name="WebBrowserPassView.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/WebBrowserPassView.7z"},
            @{Name="WinContig.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/WinContig.7z"},
            @{Name="Windows7Loader.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/Windows7Loader.7z"},
            @{Name="WindowsGate.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/WindowsGate.7z"},
            @{Name="XpFiles.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT1/XpFiles.7z"}
        )
    }
    "2" = @{ 
        Name = "PT2"; 
        Description = "System Tools & Recovery";
        Files = @(
            @{Name="3DPChip.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/3DPChip.7z"},
            @{Name="AcronisTrueImageHome2014.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AcronisTrueImageHome2014.7z"},
            @{Name="AcronisTrueImageHome2021.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AcronisTrueImageHome2021.7z"},
            @{Name="AcronisTrueImageShellx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AcronisTrueImageShellx64.7z"},
            @{Name="AcronisTrueImageShellx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AcronisTrueImageShellx86.7z"},
            @{Name="ActiveBCDEditor.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveBCDEditor.7z"},
            @{Name="ActiveDiskImagex64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveDiskImagex64.7z"},
            @{Name="ActiveDiskImagex86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveDiskImagex86.7z"},
            @{Name="ActiveFileRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveFileRecovery.7z"},
            @{Name="ActiveKillDiskx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveKillDiskx64.7z"},
            @{Name="ActiveKillDiskx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveKillDiskx86.7z"},
            @{Name="ActiveLoadHive.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveLoadHive.7z"},
            @{Name="ActivePartitionRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActivePartitionRecovery.7z"},
            @{Name="ActivePasswordChanger.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActivePasswordChanger.7z"},
            @{Name="ActiveRunMiniXP.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveRunMiniXP.7z"},
            @{Name="ActiveRunO.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ActiveRunO.7z"},
            @{Name="AdvancedIPScanner.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AdvancedIPScanner.7z"},
            @{Name="AnyDesk.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AnyDesk.7z"},
            @{Name="AomeiPartitionAssistant.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AomeiPartitionAssistant.7z"},
            @{Name="AomeiPXEBoot.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/AomeiPXEBoot.7z"},
            @{Name="CCleanerx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/CCleanerx64.7z"},
            @{Name="CCleanerx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/CCleanerx86.7z"},
            @{Name="ChangeMACAddress.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ChangeMACAddress.7z"},
            @{Name="CrystalDiskInfo.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/CrystalDiskInfo.7z"},
            @{Name="CrystalDiskMark.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/CrystalDiskMark.7z"},
            @{Name="Defraggler.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/Defraggler.7z"},
            @{Name="DiskDrill.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/DiskDrill.7z"},
            @{Name="DiskGenius.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/DiskGenius.7z"},
            @{Name="DiskgetorDataRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/DiskgetorDataRecovery.7z"},
            @{Name="Dism.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/Dism.7z"},
            @{Name="DLL.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/DLL.7z"},
            @{Name="DriverPackOnline.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/DriverPackOnline.7z"},
            @{Name="EASEUSDataRecoveryWizard.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/EASEUSDataRecoveryWizard.7z"},
            @{Name="FreeMP3CutterJoiner.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/FreeMP3CutterJoiner.7z"},
            @{Name="GetDataBackPro.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/GetDataBackPro.7z"},
            @{Name="GetDataBackSimple.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/GetDataBackSimple.7z"},
            @{Name="GhostCastServer.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/GhostCastServer.7z"},
            @{Name="GPUZ.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/GPUZ.7z"},
            @{Name="HDDRegenerator.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/HDDRegenerator.7z"},
            @{Name="HDSentinel.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/HDSentinel.7z"},
            @{Name="HetmanPartitionRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/HetmanPartitionRecovery.7z"},
            @{Name="HEUKMSActivator.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/HEUKMSActivator.7z"},
            @{Name="HWiNFO.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/HWiNFO.7z"},
            @{Name="iCareDataRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/iCareDataRecovery.7z"},
            @{Name="InternetDownloadManager.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/InternetDownloadManager.7z"},
            @{Name="LinuxReader.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/LinuxReader.7z"},
            @{Name="M3DataRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/M3DataRecovery.7z"},
            @{Name="MilfordSoftDataRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/MilfordSoftDataRecovery.7z"},
            @{Name="MiniToolPowerDataRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/MiniToolPowerDataRecovery.7z"},
            @{Name="MiniToolPowerDataRecoveryx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/MiniToolPowerDataRecoveryx86.7z"},
            @{Name="NuclearCoffeeRecoverKeys.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/NuclearCoffeeRecoverKeys.7z"},
            @{Name="NuclearCoffeeRecoverPasswords.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/NuclearCoffeeRecoverPasswords.7z"},
            @{Name="OODiskRecovery.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/OODiskRecovery.7z"},
            @{Name="PDFPasswordRemover.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/PDFPasswordRemover.7z"},
            @{Name="PartitionWizardx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/PartitionWizardx64.7z"},
            @{Name="PartitionWizardx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/PartitionWizardx86.7z"},
            @{Name="PartitionWizardXP.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/PartitionWizardXP.7z"},
            @{Name="QemuBootTester.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/QemuBootTester.7z"},
            @{Name="QemuSimpleBoot.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/QemuSimpleBoot.7z"},
            @{Name="RDriveImage.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/RDriveImage.7z"},
            @{Name="RealVNCViewer.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/RealVNCViewer.7z"},
            @{Name="Reflectx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/Reflectx64.7z"},
            @{Name="Reflectx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/Reflectx86.7z"},
            @{Name="ReloaderActivator.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/ReloaderActivator.7z"},
            @{Name="RemoveWAT.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/RemoveWAT.7z"},
            @{Name="RenameFile.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/RenameFile.7z"},
            @{Name="RevoUninstaller.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/RevoUninstaller.7z"},
            @{Name="SoftMakerOffice.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/SoftMakerOffice.7z"},
            @{Name="SoftPerfectNetworkScanner.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/SoftPerfectNetworkScanner.7z"},
            @{Name="SumatraPDF.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/SumatraPDF.7z"},
            @{Name="TeamViewer6.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TeamViewer6.7z"},
            @{Name="TeamViewer.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TeamViewer.7z"},
            @{Name="TeraByteDrive.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TeraByteDrive.7z"},
            @{Name="TeraByteDrive.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TeraByteDrive.rar"},
            @{Name="TheUltimatePIDChecker.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TheUltimatePIDChecker.7z"},
            @{Name="TotalCommander.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TotalCommander.7z"},
            @{Name="TotalUninstallx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TotalUninstallx64.7z"},
            @{Name="TotalUninstallx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/TotalUninstallx86.7z"},
            @{Name="UltraSurf.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/UltraSurf.7z"},
            @{Name="VCW78X86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/VCW78X86.7z"},
            @{Name="Victoria.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/Victoria.7z"},
            @{Name="VLCMediaPlayer.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/VLCMediaPlayer.7z"},
            @{Name="WinNTSetupx64.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/WinNTSetupx64.7z"},
            @{Name="WinNTSetupx86.7z"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT2/WinNTSetupx86.7z"}
        )
    }
    "3" = @{ 
        Name = "PT3"; 
        Description = "Executable Tools (32/64-bit)";
        Files = @(
            @{Name="7z2401-x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/7z2401-x64.exe"},
            @{Name="advancedipscanner.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/advancedipscanner.exe"},
            @{Name="AIDA64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/AIDA64.exe"},
            @{Name="AIO_Boot_Extractor.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/AIO_Boot_Extractor.exe"},
            @{Name="AnkhTech.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/AnkhTech.exe"},
            @{Name="Antivirus.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Antivirus.exe"},
            @{Name="AnyDesk.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/AnyDesk.exe"},
            @{Name="AutoDisplay.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/AutoDisplay.exe"},
            @{Name="blacknotepad.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/blacknotepad.exe"},
            @{Name="Brave-x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Brave-x64.exe"},
            @{Name="CentBrowser_x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/CentBrowser_x64.exe"},
            @{Name="CentBrowser_x86.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/CentBrowser_x86.exe"},
            @{Name="chkdsk64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/chkdsk64.exe"},
            @{Name="chkdsk86.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/chkdsk86.exe"},
            @{Name="ChkDskGui.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/ChkDskGui.exe"},
            @{Name="CoreTemp.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/CoreTemp.exe"},
            @{Name="Deadpixelbuddy.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Deadpixelbuddy.exe"},
            @{Name="Defraggler.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Defraggler.exe"},
            @{Name="Dism++.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Dism++.exe"},
            @{Name="DisplayX.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/DisplayX.exe"},
            @{Name="DoubleDriver.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/DoubleDriver.exe"},
            @{Name="DriveProtect.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/DriveProtect.exe"},
            @{Name="EaseUS Partition Master.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/EaseUS%20Partition%20Master.exe"},
            @{Name="EasyUEFI.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/EasyUEFI.exe"},
            @{Name="EasyUEFI64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/EasyUEFI64.exe"},
            @{Name="Everything.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Everything.exe"},
            @{Name="FlashMemoryToolkit.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/FlashMemoryToolkit.exe"},
            @{Name="GetDataBack.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/GetDataBack.exe"},
            @{Name="GetDataBackmc.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/GetDataBackmc.exe"},
            @{Name="HDDLL.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/HDDLL.exe"},
            @{Name="HDSentinel.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/HDSentinel.exe"},
            @{Name="HDTunePro.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/HDTunePro.exe"},
            @{Name="HPUSBDisk.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/HPUSBDisk.exe"},
            @{Name="HWiNFO32.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/HWiNFO32.exe"},
            @{Name="HWiNFO64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/HWiNFO64.exe"},
            @{Name="HWMonitor.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/HWMonitor.exe"},
            @{Name="iCareDataRecoverys.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/iCareDataRecoverys.exe"},
            @{Name="IObitUnlocker.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/IObitUnlocker.exe"},
            @{Name="IrfanView.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/IrfanView.exe"},
            @{Name="IsMyHdOK_x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/IsMyHdOK_x64.exe"},
            @{Name="IsMyLcdOK.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/IsMyLcdOK.exe"},
            @{Name="ISO2USB.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/ISO2USB.exe"},
            @{Name="LinuxLiveUSBCreator.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/LinuxLiveUSBCreator.exe"},
            @{Name="Macrium_all.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Macrium_all.exe"},
            @{Name="MacriumReflect.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/MacriumReflect.exe"},
            @{Name="MapDrive.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/MapDrive.exe"},
            @{Name="MD5.SHA-1.CheckSum.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/MD5.SHA-1.CheckSum.exe"},
            @{Name="memreduct.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/memreduct.exe"},
            @{Name="MemTest64_x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/MemTest64_x64.exe"},
            @{Name="memTest.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/memTest.exe"},
            @{Name="NirSoft.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/NirSoft.exe"},
            @{Name="ntpwedit.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/ntpwedit.exe"},
            @{Name="ntpwedit64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/ntpwedit64.exe"},
            @{Name="Passwor.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Passwor.exe"},
            @{Name="peazip-9.7.1.WIN64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/peazip-9.7.1.WIN64.exe"},
            @{Name="Perfect_Icon.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Perfect_Icon.exe"},
            @{Name="QemuBootTester.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/QemuBootTester.exe"},
            @{Name="QemuSimpleBoot.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/QemuSimpleBoot.exe"},
            @{Name="RAMMon.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/RAMMon.exe"},
            @{Name="Recuva.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Recuva.exe"},
            @{Name="RegeditPE.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/RegeditPE.exe"},
            @{Name="RegWorkshop.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/RegWorkshop.exe"},
            @{Name="RemoveFakeAntivirus.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/RemoveFakeAntivirus.exe"},
            @{Name="RescuePRO.SSD.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/RescuePRO.SSD.exe"},
            @{Name="ResetWindowsPassword.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/ResetWindowsPassword.exe"},
            @{Name="RMMA.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/RMMA.exe"},
            @{Name="rufus.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/rufus.exe"},
            @{Name="Rufus64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Rufus64.exe"},
            @{Name="Securable.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Securable.exe"},
            @{Name="SetPageFile.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/SetPageFile.exe"},
            @{Name="SkyIAR(86-64).exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/SkyIAR(86-64).exe"},
            @{Name="Speccy.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Speccy.exe"},
            @{Name="StellarDataRecovery8.0.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/StellarDataRecovery8.0.exe"},
            @{Name="TFTTEST.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/TFTTEST.exe"},
            @{Name="tor-browser-windows-x86_64-portable-13.0.10.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/tor-browser-windows-x86_64-portable-13.0.10.exe"},
            @{Name="TOTALCMD.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/TOTALCMD.exe"},
            @{Name="uefipart.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/uefipart.exe"},
            @{Name="WContig.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/WContig.exe"},
            @{Name="WinDiskFlash.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/WinDiskFlash.exe"},
            @{Name="Windows Terminal Installer.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/Windows%20Terminal%20Installer.exe"},
            @{Name="XTBox.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT3/XTBox.exe"}
        )
    }
    "4" = @{ 
        Name = "PT4"; 
        Description = "Installers & Boot Utilities";
        Files = @(
            @{Name="Brave-x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Brave-x64.exe"},
            @{Name="BroadcomCardReader64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/BroadcomCardReader64.exe"},
            @{Name="crypticdisk_setup.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/crypticdisk_setup.exe"},
            @{Name="dcrypt_setup_1.2_beta_3_signed.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/dcrypt_setup_1.2_beta_3_signed.exe"},
            @{Name="decrypt_STOPDjvu.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/decrypt_STOPDjvu.exe"},
            @{Name="Defraggler-Setup.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Defraggler-Setup.exe"},
            @{Name="Iso2Usb.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Iso2Usb.exe"},
            @{Name="KeyLock.Setup-3.0.30010.9.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/KeyLock.Setup-3.0.30010.9.exe"},
            @{Name="live-usb-install-2.5.12.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/live-usb-install-2.5.12.exe"},
            @{Name="MicrosoftEdgeSetup.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/MicrosoftEdgeSetup.exe"},
            @{Name="MobaLiveCD.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/MobaLiveCD.exe"},
            @{Name="multibootusb-9.2.0-setup.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/multibootusb-9.2.0-setup.exe"},
            @{Name="MultiBoot Utility En.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/MultiBoot%20Utility%20En.exe"},
            @{Name="NTLite_setup_x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/NTLite_setup_x64.exe"},
            @{Name="PicoTorrent-0.25.0-x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/PicoTorrent-0.25.0-x64.exe"},
            @{Name="PortableApps.com_Platform_Setup_22.0.1.paf.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/PortableApps.com_Platform_Setup_22.0.1.paf.exe"},
            @{Name="Portable-VirtualBox_v5.1.22-Starter_v6.4.10-Win_all.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Portable-VirtualBox_v5.1.22-Starter_v6.4.10-Win_all.exe"},
            @{Name="PowerISO.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/PowerISO.exe"},
            @{Name="QemuBootTester.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/QemuBootTester.exe"},
            @{Name="Qsib.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Qsib.exe"},
            @{Name="RevoUninstaller.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/RevoUninstaller.exe"},
            @{Name="rmprepusb-2-1-746.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/rmprepusb-2-1-746.exe"},
            @{Name="rufus-3.20.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/rufus-3.20.exe"},
            @{Name="rufus-4.1.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/rufus-4.1.exe"},
            @{Name="Universal-USB-Installer-2.0.1.9.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Universal-USB-Installer-2.0.1.9.exe"},
            @{Name="UpdateFixer_Portable.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/UpdateFixer_Portable.exe"},
            @{Name="USBBootDriveCreatorSetup.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/USBBootDriveCreatorSetup.exe"},
            @{Name="USBBootDriveCreatorSetup (1).exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/USBBootDriveCreatorSetup%20(1).exe"},
            @{Name="USBLockit.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/USBLockit.exe"},
            @{Name="usb-secure-pd.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/usb-secure-pd.exe"},
            @{Name="usb-stick-encryption.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/usb-stick-encryption.exe"},
            @{Name="VeraCrypt Setup 1.25.9.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/VeraCrypt%20Setup%201.25.9.exe"},
            @{Name="vlc-3.0.18-win64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/vlc-3.0.18-win64.exe"},
            @{Name="vso_downloader_win64_setup_6.0.0.113.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/vso_downloader_win64_setup_6.0.0.113.exe"},
            @{Name="WinDiskFlash.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/WinDiskFlash.exe"},
            @{Name="WindowsVHDCreator.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/WindowsVHDCreator.exe"},
            @{Name="WinFLASHTool-2.0.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/WinFLASHTool-2.0.exe"},
            @{Name="WinRAR-x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/WinRAR-x64.exe"},
            @{Name="XTBox.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/XTBox.exe"},
            @{Name="XTBox.2.9.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/XTBox.2.9.exe"},
            @{Name="XTBox (1).exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/XTBox%20(1).exe"},
            @{Name="YUMI-2.0.9.4.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/YUMI-2.0.9.4.exe"},
            @{Name="YUMI-exFAT-1.0.0.7.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/YUMI-exFAT-1.0.0.7.exe"},
            @{Name="YUMI-NTFS- 2.0.9.4.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/YUMI-NTFS-%202.0.9.4.exe"},
            @{Name="YUMI-UEFI-0.0.4.6.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/YUMI-UEFI-0.0.4.6.exe"}
        )
    }
    "5" = @{ 
        Name = "PT5"; 
        Description = "Portable Applications & Archives";
        Files = @(
            @{Name="All Video Downloader Portable.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/All%20Video%20Downloader%20Portable.rar"},
            @{Name="Atlas_W10-22H2.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/Atlas_W10-22H2.zip"},
            @{Name="AT.Toolbox.2.7.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/AT.Toolbox.2.7.zip"},
            @{Name="BleachBitPortable.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/BleachBitPortable.zip"},
            @{Name="bootit_collection_en_trial.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/bootit_collection_en_trial.zip"},
            @{Name="DiskGenius Portable.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/DiskGenius%20Portable.rar"},
            @{Name="Drive Snapshot Portable.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/Drive%20Snapshot%20Portable.rar"},
            @{Name="FlashBoot Portable.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/FlashBoot%20Portable.rar"},
            @{Name="GiliSoft.Full.Disk.Encryption.5.4.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/GiliSoft.Full.Disk.Encryption.5.4.rar"},
            @{Name="Glary Utilities Portable.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/Glary%20Utilities%20Portable.rar"},
            @{Name="GlassWire_Elite v2.3.449 + Fix {_sHash}.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/GlassWire_Elite%20v2.3.449%20%2B%20Fix%20%7B_sHash%7D.zip"},
            @{Name="IObit Driver Booster Portable.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/IObit%20Driver%20Booster%20Portable.rar"},
            @{Name="Iso2Usb_0.1.5.0.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/Iso2Usb_0.1.5.0.zip"},
            @{Name="Portable ChatGPT v1.1.0 Desktop.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/Portable%20ChatGPT%20v1.1.0%20Desktop.rar"},
            @{Name="Portable Optimizer 14.8.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/Portable%20Optimizer%2014.8.rar"},
            @{Name="Portable UUByte WintoUSB Pro 4.7.2 Multilingual.rar"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/Portable%20UUByte%20WintoUSB%20Pro%204.7.2%20Multilingual.rar"},
            @{Name="PowerISO.9.1.Portable.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/PowerISO.9.1.Portable.zip"},
            @{Name="PowerISO.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/PowerISO.exe"},
            @{Name="PS2EXE-master.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/PS2EXE-master.zip"},
            @{Name="SetupDecentr.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/SetupDecentr.zip"},
            @{Name="SpeccyPro.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/SpeccyPro.zip"},
            @{Name="UEFITool-v0.28.0.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/UEFITool-v0.28.0.zip"},
            @{Name="win10script-master.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/win10script-master.zip"},
            @{Name="WinPEDownloader.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/WinPEDownloader.zip"},
            @{Name="WinToHDD.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/WinToHDD.zip"},
            @{Name="WinToUSB.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/WinToUSB.zip"},
            @{Name="wsl2-distro-manager-v1.8.11.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/wsl2-distro-manager-v1.8.11.zip"},
            @{Name="xmrig-6.19.2-gcc-win64.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT5/xmrig-6.19.2-gcc-win64.zip"}
        )
    }
}

function Show-MainMenu {
    Clear-Host
    Write-Host "============================================="
    Write-Host "    WINDOWS SOFTWARE DOWNLOADER UTILITY      "
    Write-Host "============================================="
    Write-Host "Repository: $repoUrl"
    Write-Host "Download Path: $downloadPath"
    Write-Host "---------------------------------------------"
    Write-Host "Available Categories:"
    foreach ($key in $categories.Keys | Sort-Object) {
        Write-Host " $key. $($categories[$key].Name) - $($categories[$key].Description)"
    }
    Write-Host "---------------------------------------------"
    Write-Host " C. Change download path"
    Write-Host " Q. Quit"
    Write-Host "============================================="
}

function Show-SoftwareMenu {
    param (
        [string]$category
    )
    
    Clear-Host
    Write-Host "============================================="
    Write-Host "    $($categories[$category].Name) - $($categories[$category].Description) "
    Write-Host "============================================="
    Write-Host "Download Path: $downloadPath"
    Write-Host "---------------------------------------------"
    
    # Display software list with numbers
    $index = 1
    foreach ($file in $categories[$category].Files) {
        Write-Host " $index. $($file.Name)"
        $index++
    }
    
    Write-Host "---------------------------------------------"
    Write-Host " B. Back to main menu"
    Write-Host " Q. Quit"
    Write-Host "============================================="
}

function Set-DownloadPath {
    Clear-Host
    Write-Host "============================================="
    Write-Host "         CHANGE DOWNLOAD PATH                "
    Write-Host "============================================="
    Write-Host "Current download path: $downloadPath"
    Write-Host "---------------------------------------------"
    $newPath = Read-Host "Enter new download path (leave blank for default)"
    
    if ([string]::IsNullOrWhiteSpace($newPath)) {
        $downloadPath = $defaultDownloadPath
    } else {
        $downloadPath = $newPath
    }
    
    # Create directory if it doesn't exist
    if (-not (Test-Path -Path $downloadPath)) {
        try {
            New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null
            Write-Host "Created directory: $downloadPath"
        } catch {
            Write-Host "Error creating directory: $_" -ForegroundColor Red
            $downloadPath = $defaultDownloadPath
            Write-Host "Reverting to default path: $downloadPath"
        }
    }
    
    Write-Host "Download path set to: $downloadPath"
    Pause
}

function Download-Software {
    param (
        [string]$url,
        [string]$fileName,
        [string]$destination
    )
    
    $destinationFile = Join-Path -Path $destination -ChildPath $fileName
    
    try {
        Write-Host "Downloading $fileName..."
        
        # Use BITS (Background Intelligent Transfer Service) for more reliable downloads
        Start-BitsTransfer -Source $url -Destination $destinationFile -DisplayName "Downloading $fileName"
        
        if (Test-Path -Path $destinationFile)) {
            Write-Host "Download completed: $destinationFile" -ForegroundColor Green
            return $destinationFile
        } else {
            Write-Host "Download failed: $fileName" -ForegroundColor Red
            return $null
        }
    } catch {
        Write-Host "Error downloading $fileName : $_" -ForegroundColor Red
        return $null
    }
}

function Process-DownloadedFile {
    param (
        [string]$filePath
    )
    
    $fileExtension = [System.IO.Path]::GetExtension($filePath).ToLower()
    
    switch ($fileExtension) {
        ".exe" {
            Write-Host "This is an executable file."
            $run = Read-Host "Do you want to run it now? (y/n)"
            if ($run -eq "y") {
                try {
                    Start-Process -FilePath $filePath
                    Write-Host "Executable launched." -ForegroundColor Green
                } catch {
                    Write-Host "Error running executable: $_" -ForegroundColor Red
                }
            }
        }
        ".zip" -or ".7z" -or ".rar" {
            Write-Host "This is an archive file."
            $extract = Read-Host "Do you want to extract it now? (y/n)"
            if ($extract -eq "y") {
                Extract-Archive -filePath $filePath
            }
        }
        default {
            Write-Host "File downloaded: $filePath"
        }
    }
}

function Extract-Archive {
    param (
        [string]$filePath
    )
    
    $destination = [System.IO.Path]::GetDirectoryName($filePath)
    $fileNameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
    $extractPath = Join-Path -Path $destination -ChildPath $fileNameWithoutExt
    
    try {
        # Create extraction directory if it doesn't exist
        if (-not (Test-Path -Path $extractPath)) {
            New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
        }
        
        # Check if 7-Zip is available
        $7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
        if (Test-Path -Path $7zipPath)) {
            # Use 7-Zip for extraction
            Write-Host "Extracting using 7-Zip..."
            & $7zipPath x "-o$extractPath" -y $filePath | Out-Null
        } else {
            # Fall back to Expand-Archive for .zip files
            if ([System.IO.Path]::GetExtension($filePath) -eq ".zip") {
                Write-Host "Extracting using built-in PowerShell..."
                Expand-Archive -Path $filePath -DestinationPath $extractPath -Force
            } else {
                Write-Host "7-Zip not found. Please install 7-Zip to extract this archive." -ForegroundColor Yellow
                return
            }
        }
        
        Write-Host "Extraction completed: $extractPath" -ForegroundColor Green
    } catch {
        Write-Host "Error extracting archive: $_" -ForegroundColor Red
    }
}

# Main program loop
$running = $true
while ($running) {
    Show-MainMenu
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        { $_ -in "1","2","3","4","5" } {
            $selectedCategory = $choice
            Show-SoftwareMenu -category $choice
            
            $softwareChoice = Read-Host "Enter software number to download (or B to go back)"
            
            if ($softwareChoice -eq "B") {
                continue
            } elseif ($softwareChoice -eq "Q") {
                $running = $false
                break
            } elseif ($softwareChoice -match "^\d+$") {
                $index = [int]$softwareChoice - 1
                if ($index -ge 0 -and $index -lt $categories[$choice].Files.Count) {
                    $selectedFile = $categories[$choice].Files[$index]
                    
                    # Ensure download directory exists
                    if (-not (Test-Path -Path $downloadPath)) {
                        New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null
                    }
                    
                    $downloadedFile = Download-Software -url $selectedFile.Url -fileName $selectedFile.Name -destination $downloadPath
                    
                    if ($downloadedFile) {
                        Process-DownloadedFile -filePath $downloadedFile
                        Pause
                    }
                } else {
                    Write-Host "Invalid selection." -ForegroundColor Red
                    Pause
                }
            } else {
                Write-Host "Invalid selection." -ForegroundColor Red
                Pause
            }
        }
        "C" {
            Set-DownloadPath
        }
        "Q" {
            $running = $false
        }
        default {
            Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            Pause
        }
    }
}

Write-Host "Thank you for using Windows Software Downloader Utility!"
