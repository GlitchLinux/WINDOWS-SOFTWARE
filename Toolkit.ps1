<#
.SYNOPSIS
    WIN-TOOLKIT - CLI Software Utility
.DESCRIPTION
    This script provides a comprehensive interface to browse, search, and download software
    from the GlitchLinux/WINDOWS-SOFTWARE GitHub repository with an improved UI.
.NOTES
    File Name      : Win-Toolkit.ps1
    Author         : Your Name
    Prerequisite   : PowerShell 5.1 or later
#>

# Configuration
$repoUrl = "https://github.com/GlitchLinux/WINDOWS-SOFTWARE"
$defaultDownloadPath = "$env:USERPROFILE\Desktop\WINDOWS-SOFTWARE"
$logFile = "$env:TEMP\WinToolkit.log"
$enableLogging = $true

# Initialize variables
$softwareList = @()
$selectedCategory = $null
$downloadPath = $defaultDownloadPath
$currentPage = 1
$itemsPerPage = [math]::Floor(([console]::WindowHeight - 15) # Dynamic based on window size

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
            @{Name="TreeSizeFreeSetup.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/TreeSizeFreeSetup.exe"},
            @{Name="TreeSizeFree-Portable.zip"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/TreeSizeFree-Portable.zip"},
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
            @{Name="Microsoft_Visual_C++2015-2022_x64.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Microsoft_Visual_C++2015-2022_x64.exe"},
            @{Name="Microsoft_Visual_C++2015-2022_x86.exe"; Url="https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/PT4/Microsoft_Visual_C++2015-2022_x86.exe"},
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
    "6" = @{ 
        Name = "PT6"; 
        Description = "Accessibility";
        Files = @(
            @{Name="BalabolkaPortable_2.15.0.897.paf.exe"; Url="https://portableapps.com/downloading/?a=BalabolkaPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pa&n=Balabolka Portable&f=BalabolkaPortable_2.15.0.897.paf.exe"},
            @{Name="DicomPortable_1.3.paf.exe"; Url="https://portableapps.com/downloading/?a=DicomPortable&s=s&p=&d=pa&n=Dicom Portable&f=DicomPortable_1.3.paf.exe"},
            @{Name="DSpeechPortable_1.74.49.paf.exe"; Url="https://portableapps.com/redir2/?a=DSpeechPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=DSpeechPortable_1.74.49.paf.exe"},
            @{Name="NVDAPortable_2024.4.2.paf.exe"; Url="https://portableapps.com/downloading/?a=NVDAPortable&s=s&p=&d=pa&n=NVDA Portable&f=NVDAPortable_2024.4.2.paf.exe"},
            @{Name="On-ScreenKeyboardPortable_2.1.paf.exe"; Url="https://portableapps.com/downloading/?a=On-ScreenKeyboardPortable&s=s&p=&d=pa&n=On-Screen Keyboard Portable&f=On-ScreenKeyboardPortable_2.1.paf.exe"},
            @{Name="VirtualMagnifyingGlassPortable_3.6.paf.exe"; Url="https://portableapps.com/downloading/?a=VirtualMagnifyingGlassPortable&s=s&p=&d=pa&n=Virtual Magnifying Glass Portable&f=VirtualMagnifyingGlassPortable_3.6.paf.exe"}
        )
    }
    "7" = @{ 
        Name = "PT7"; 
        Description = "Development";
        Files = @(
            @{Name="AkelPadPortable_4.9.9.paf.exe"; Url="https://portableapps.com/downloading/?a=AkelPadPortable&s=s&p=&d=pa&n=AkelPad Portable&f=AkelPadPortable_4.9.9.paf.exe"},
            @{Name="CppcheckPortable_2.17.1.paf.exe"; Url="https://portableapps.com/downloading/?a=CppcheckPortable&s=s&p=&d=pa&n=Cppcheck Portable&f=CppcheckPortable_2.17.1.paf.exe"},
            @{Name="CudaTextPortable_1.224.0.0.paf.exe"; Url="https://portableapps.com/downloading/?a=CudaTextPortable&s=s&p=&d=pa&n=CudaText Portable&f=CudaTextPortable_1.224.0.0.paf.exe"},
            @{Name="DatabaseBrowserPortable_5.3.3.5_English.paf.exe"; Url="https://portableapps.com/downloading/?a=DatabaseBrowserPortable&s=s&p=&d=pa&n=Database Browser Portable&f=DatabaseBrowserPortable_5.3.3.5_English.paf.exe"},
            @{Name="SQLiteDatabaseBrowserPortable_3.13.1.paf.exe"; Url="https://portableapps.com/downloading/?a=SQLiteDatabaseBrowserPortable&s=s&p=&d=pa&n=DB Browser for SQLite Portable&f=SQLiteDatabaseBrowserPortable_3.13.1.paf.exe"},
            @{Name="FrhedPortable_2017.11.paf.exe"; Url="https://portableapps.com/downloading/?a=FrhedPortable&s=s&p=&d=pa&n=Frhed Portable&f=FrhedPortable_2017.11.paf.exe"},
            @{Name="GeanyPortable_2.0.paf.exe"; Url="https://portableapps.com/downloading/?a=GeanyPortable&s=s&p=&d=pa&n=Geany Portable&f=GeanyPortable_2.0.paf.exe"},
            @{Name="gVimPortable_9.1.paf.exe"; Url="https://portableapps.com/downloading/?a=gVimPortable&s=s&p=&d=pa&n=gVim Portable&f=gVimPortable_9.1.paf.exe"},
            @{Name="HMNISEditPortable_2.0.3_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=HMNISEditPortable&s=s&p=&d=pa&n=HM NIS Edit Portable&f=HMNISEditPortable_2.0.3_Rev_2.paf.exe"},
            @{Name="IniTranslatorPortable_1.9.0.52_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=IniTranslatorPortable&s=s&p=&d=pa&n=IniTranslator Portable&f=IniTranslatorPortable_1.9.0.52_Rev_2.paf.exe"},
            @{Name="NotepadPlusPlusPortable_8.8.1.paf.exe"; Url="https://portableapps.com/downloading/?a=Notepad%2B%2BPortable&s=s&p=&d=pa&n=Notepad++ Portable&f=NotepadPlusPlusPortable_8.8.1.paf.exe"},
            @{Name="Notepad2Portable_4.2.25_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=Notepad2Portable&s=s&p=&d=pa&n=Notepad2 Portable&f=Notepad2Portable_4.2.25_Rev_2_English.paf.exe"},
            @{Name="Notepad2-modPortable_4.2.25.998_English.paf.exe"; Url="https://portableapps.com/downloading/?a=Notepad2-modPortable&s=s&p=&d=pa&n=Notepad2-mod Portable&f=Notepad2-modPortable_4.2.25.998_English.paf.exe"},
            @{Name="NSISPortable_3.11_English.paf.exe"; Url="https://portableapps.com/downloading/?a=NSISPortable&s=s&p=&d=pa&n=NSIS Portable&f=NSISPortable_3.11_English.paf.exe"},
            @{Name="KompoZerPortable_0.8_Beta_3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=KompoZerPortable&s=s&p=&d=pa&n=KompoZer Portable&f=KompoZerPortable_0.8_Beta_3_English.paf.exe"},
            @{Name="SqlitemanPortable_1.2.2.paf.exe"; Url="https://portableapps.com/downloading/?a=SqlitemanPortable&s=s&p=&d=pa&n=Sqliteman Portable&f=SqlitemanPortable_1.2.2.paf.exe"},
            @{Name="SWI-PrologPortable_9.2.9-1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SWI-PrologPortable&s=s&p=&d=pa&n=SWI-Prolog Portable&f=SWI-PrologPortable_9.2.9-1_English.paf.exe"},
            @{Name="XAMPP_1.7.paf.exe"; Url="https://portableapps.com/downloading/?a=XAMPP&s=s&p=&d=pa&n=XAMPP Launcher&f=XAMPP_1.7.paf.exe"},
            @{Name="KompoZerPortable_0.8_Beta_3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=KompoZerPortable&s=s&p=&d=pa&n=KompoZer Portable&f=KompoZerPortable_0.8_Beta_3_English.paf.exe"}
        )
    }
    "8" = @{ 
        Name = "PT8"; 
        Description = "Education";
        Files = @(
            @{Name="QEyePortable_6.5.0.9_English.paf.exe"; Url="https://portableapps.com/redir2/?a=QEyePortable&s=s&p=https://www.etl-tools.com/dmdocuments/&d=pb&f=QEyePortable_6.5.0.9_English.paf.exe"},
            @{Name="ArthaPortable_1.0.3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ArthaPortable&s=s&p=&d=pa&n=Artha Portable&f=ArthaPortable_1.0.3_English.paf.exe"},
            @{Name="BPBiblePortable_0.5.3.1.paf.exe"; Url="https://portableapps.com/redir2/?a=BPBiblePortable&s=s&p=https://github.com/bpbible/bpbible/releases/download/release-0.5.3.1/&d=pb&f=BPBiblePortable_0.5.3.1.paf.exe"},
            @{Name="BrainWorkshopPortable_4.8.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=BrainWorkshopPortable&s=s&p=&d=pa&n=Brain Workshop Portable&f=BrainWorkshopPortable_4.8.4_English.paf.exe"},
            @{Name="CelestiaPortable_1.6.4.paf.exe"; Url="https://portableapps.com/downloading/?a=CelestiaPortable&s=s&p=&d=pa&n=Celestia Portable&f=CelestiaPortable_1.6.4.paf.exe"},
            @{Name="FreeMatPortable_4.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FreeMatPortable&s=s&p=&d=pa&n=FreeMat Portable&f=FreeMatPortable_4.2_English.paf.exe"},
            @{Name="GoldenDictPortable_1.5_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=GoldenDictPortable&s=s&p=&d=pa&n=GoldenDict Portable&f=GoldenDictPortable_1.5_Rev_2.paf.exe"},
            @{Name="GrampsPortable_6.0.1.paf.exe"; Url="https://portableapps.com/downloading/?a=GrampsPortable&s=s&p=&d=pa&n=Gramps Portable&f=GrampsPortable_6.0.1.paf.exe"},
            @{Name="MarblePortable_2.2.0.paf.exe"; Url="https://portableapps.com/downloading/?a=MarblePortable&s=s&p=&d=pa&n=Marble Portable&f=MarblePortable_2.2.0.paf.exe"},
            @{Name="MnemosynePortable_2.11.paf.exe"; Url="https://portableapps.com/downloading/?a=MnemosynePortable&s=s&p=&d=pa&n=Mnemosyne Portable&f=MnemosynePortable_2.11.paf.exe"},
            @{Name="SolfegePortable_3.22.2_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=SolfegePortable&s=s&p=&d=pa&n=Solfege Portable&f=SolfegePortable_3.22.2_Rev_2.paf.exe"},
            @{Name="StellariumPortable_25.1.0_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=StellariumPortable&s=s&p=&d=pa&n=Stellarium Portable&f=StellariumPortable_25.1.0_Rev_2.paf.exe"},
            @{Name="Tipp10Portable_2.1.0_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=Tipp10Portable&s=s&p=&d=pa&n=Tipp10 Portable&f=Tipp10Portable_2.1.0_Rev_2.paf.exe"},
            @{Name="TypeFasterPortable_0.4.2_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=TypeFasterPortable&s=s&p=&d=pa&n=TypeFaster Typing Tutor Portable&f=TypeFasterPortable_0.4.2_Rev_2_English.paf.exe"}
        )
    }
    "9" = @{ 
        Name = "PT9"; 
        Description = "Games";
        Files = @(
            @{Name="2048Portable_2.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=2048Portable&s=s&p=&d=pa&n=2048 Portable&f=2048Portable_2.2_English.paf.exe"},
            @{Name="4stAttackPortable_2.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=4stAttackPortable&s=s&p=&d=pa&n=4st Attack Portable&f=4stAttackPortable_2.0_English.paf.exe"},
            @{Name="ADarkRoomPortable_2022.05.01.paf.exe"; Url="https://portableapps.com/downloading/?a=ADarkRoomPortable&s=s&p=&d=pa&n=ADR Portable launcher for A Dark Room &f=ADarkRoomPortable_2022.05.01.paf.exe"},
            @{Name="ArmagetronAdvancedPortable_0.2.9.2.3.paf.exe"; Url="https://portableapps.com/downloading/?a=ArmagetronAdvancedPortable&s=s&p=&d=pa&n=Armagetron Advanced Portable&f=ArmagetronAdvancedPortable_0.2.9.2.3.paf.exe"},
            @{Name="AssaultCubePortable_1.3.0.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=AssaultCubePortable&s=s&p=&d=pa&n=AssaultCube Portable&f=AssaultCubePortable_1.3.0.2_English.paf.exe"},
            @{Name="AtomicTanksPortable_6.6.paf.exe"; Url="https://portableapps.com/downloading/?a=AtomicTanksPortable&s=s&p=&d=pa&n=Atomic Tanks Portable&f=AtomicTanksPortable_6.6.paf.exe"},
            @{Name="WesnothPortable_1.18.4.paf.exe"; Url="https://portableapps.com/downloading/?a=WesnothPortable&s=s&p=&d=pa&n=Battle for Wesnoth Portable&f=WesnothPortable_1.18.4.paf.exe"},
            @{Name="BeretPortable_1.2.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=BeretPortable&s=s&p=&d=pa&n=Beret Portable&f=BeretPortable_1.2.1_English.paf.exe"},
            @{Name="BigSolitairesPortable_1.4_Rev_3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=BigSolitairesPortable&s=s&p=&d=pa&n=Big Solitaires 3D Portable&f=BigSolitairesPortable_1.4_Rev_3_English.paf.exe"},
            @{Name="BrutalChessPortable_0.5.2.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=BrutalChessPortable&s=s&p=&d=pa&n=Brutal Chess Portable&f=BrutalChessPortable_0.5.2.2_English.paf.exe"},
            @{Name="BYONDPortable_5.0_Build_516.1663_English.paf.exe"; Url="https://portableapps.com/downloading/?a=BYONDPortable&s=s&p=&d=pa&n=BYOND Portable&f=BYONDPortable_5.0_Build_516.1663_English.paf.exe"},
            @{Name="CanabaltPortable_1.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=CanabaltPortable&s=s&p=&d=pa&n=Canabalt Portable&f=CanabaltPortable_1.2_English.paf.exe"},
            @{Name="ChromiumBSUPortable_0.9.13.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ChromiumBSUPortable&s=s&p=&d=pa&n=Chromium B.S.U. Portable&f=ChromiumBSUPortable_0.9.13.2_English.paf.exe"},
            @{Name="CubePortable_2005.08.29_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=CubePortable&s=s&p=&d=pa&n=Cube Portable&f=CubePortable_2005.08.29_Rev_2_English.paf.exe"},
            @{Name="DaveGnukemPortable_1.0.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=DaveGnukemPortable&s=s&p=&d=pa&n=Dave Gnukem Portable&f=DaveGnukemPortable_1.0.1_English.paf.exe"},
            @{Name="DominoChainPortable_1.1.paf.exe"; Url="https://portableapps.com/downloading/?a=DominoChainPortable&s=s&p=&d=pa&n=Domino-Chain Portable&f=DominoChainPortable_1.1.paf.exe"},
            @{Name="DOSBoxPortable_0.74.3.paf.exe"; Url="https://portableapps.com/downloading/?a=DOSBoxPortable&s=s&p=&d=pa&n=DOSBox Portable&f=DOSBoxPortable_0.74.3.paf.exe"},
            @{Name="FreecivPortable_3.1.4.paf.exe"; Url="https://portableapps.com/downloading/?a=FreecivPortable&s=s&p=&d=pa&n=Freeciv Portable&f=FreecivPortable_3.1.4.paf.exe"},
            @{Name="GetSudokuPortable_1.0_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=GetSudokuPortable&s=s&p=&d=pa&n=Get Sudoku Portable&f=GetSudokuPortable_1.0_Rev_2.paf.exe"},
            @{Name="GollyPortable_4.3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=GollyPortable&s=s&p=&d=pa&n=Golly Portable&f=GollyPortable_4.3_English.paf.exe"},
            @{Name="HedgewarsPortable_1.0.0.paf.exe"; Url="https://portableapps.com/downloading/?a=HedgewarsPortable&s=s&p=&d=pa&n=Hedgewars Portable&f=HedgewarsPortable_1.0.0.paf.exe"},
            @{Name="Hex-A-HopPortable_1.1.0_Rev_3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=Hex-A-HopPortable&s=s&p=&d=pa&n=Hex-A-Hop Portable&f=Hex-A-HopPortable_1.1.0_Rev_3_English.paf.exe"},
            @{Name="IceBreakerPortable_2.2.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=IceBreakerPortable&s=s&p=&d=pa&n=IceBreaker Portable&f=IceBreakerPortable_2.2.1_English.paf.exe"},
            @{Name="IHaveNoTomatoesPortable_1.5_English.paf.exe"; Url="https://portableapps.com/downloading/?a=IHaveNoTomatoesPortable&s=s&p=&d=pa&n=I Have No Tomatoes Portable&f=IHaveNoTomatoesPortable_1.5_English.paf.exe"},
            @{Name="JooleemPortable_0.1.4.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=JooleemPortable&s=s&p=&d=pa&n=Jooleem Portable&f=JooleemPortable_0.1.4.2_English.paf.exe"},
            @{Name="KoboDeluxePortable_0.5.1_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=KoboDeluxePortable&s=s&p=&d=pa&n=Kobo Deluxe Portable&f=KoboDeluxePortable_0.5.1_Rev_2_English.paf.exe"},
            @{Name="LBreakout2Portable_2.6.5_English.paf.exe"; Url="https://portableapps.com/downloading/?a=LBreakout2Portable&s=s&p=&d=pa&n=LBreakout2 Portable&f=LBreakout2Portable_2.6.5_English.paf.exe"},
            @{Name="LMarblesPortable_1.0.8_English.paf.exe"; Url="https://portableapps.com/downloading/?a=LMarblesPortable&s=s&p=&d=pa&n=LMarbles Portable&f=LMarblesPortable_1.0.8_English.paf.exe"},
            @{Name="LucasChessPortable_R_2.20c.paf.exe"; Url="https://portableapps.com/downloading/?a=LucasChessPortable&s=s&p=&d=pa&n=Lucas Chess Portable&f=LucasChessPortable_R_2.20c.paf.exe"},
            @{Name="MahJonggSolitaire3DPortable_1.01.paf.exe"; Url="https://portableapps.com/downloading/?a=MahJonggSolitaire3DPortable&s=s&p=&d=pa&n=MahJongg Solitaire 3D Portable&f=MahJonggSolitaire3DPortable_1.01.paf.exe"},
            @{Name="TheManaWorldPortable_2.1.3.17.paf.exe"; Url="https://portableapps.com/downloading/?a=TheManaWorldPortable&s=s&p=&d=pa&n=Mana Plus Portable&f=TheManaWorldPortable_2.1.3.17.paf.exe"},
            @{Name="ManiaDrivePortable_1.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ManiaDrivePortable&s=s&p=&d=pa&n=ManiaDrive Portable&f=ManiaDrivePortable_1.2_English.paf.exe"},
            @{Name="Mines-PerfectPortable_1.4.0.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=Mines-PerfectPortable&s=s&p=&d=pa&n=Mines-Perfect Portable&f=Mines-PerfectPortable_1.4.0.4_English.paf.exe"},
            @{Name="Monster2Portable_2.11.1.paf.exe"; Url="https://portableapps.com/downloading/?a=Monster2Portable&s=s&p=&d=pa&n=Monster RPG 2 Portable&f=Monster2Portable_2.11.1.paf.exe"},
            @{Name="NetHackPortable_3.6.7_English.paf.exe"; Url="https://portableapps.com/downloading/?a=NetHackPortable&s=s&p=&d=pa&n=NetHack Portable&f=NetHackPortable_3.6.7_English.paf.exe"},
            @{Name="netPanzerPortable_0.8.7_English.paf.exe"; Url="https://portableapps.com/downloading/?a=netPanzerPortable&s=s&p=&d=pa&n=netPanzer Portable&f=netPanzerPortable_0.8.7_English.paf.exe"},
            @{Name="NeverballPortable_1.6.0.paf.exe"; Url="https://portableapps.com/downloading/?a=NeverballPortable&s=s&p=&d=pa&n=Neverball Portable&f=NeverballPortable_1.6.0.paf.exe"},
            @{Name="OpenTTDPortable_14.1.paf.exe"; Url="https://portableapps.com/downloading/?a=OpenTTDPortable&s=s&p=&d=pa&n=OpenTTD Portable&f=OpenTTDPortable_14.1.paf.exe"},
            @{Name="PathologicalPortable_1.1.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PathologicalPortable&s=s&p=&d=pa&n=Pathological Portable&f=PathologicalPortable_1.1.2_English.paf.exe"},
            @{Name="PingusPortable_0.7.6.paf.exe"; Url="https://portableapps.com/downloading/?a=PingusPortable&s=s&p=&d=pa&n=Pingus Portable&f=PingusPortable_0.7.6.paf.exe"},
            @{Name="PokerTHPortable_1.1.2.paf.exe"; Url="https://portableapps.com/downloading/?a=PokerTHPortable&s=s&p=&d=pa&n=PokerTH Portable&f=PokerTHPortable_1.1.2.paf.exe"},
            @{Name="ProjectInvinciblePortable_2.10_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ProjectInvinciblePortable&s=s&p=&d=pa&n=Project Invincible Portable&f=ProjectInvinciblePortable_2.10_English.paf.exe"},
            @{Name="PuzzleCollectionPortable_2025.05.23_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PuzzleCollectionPortable&s=s&p=&d=pa&n=Puzzle Collection Portable&f=PuzzleCollectionPortable_2025.05.23_English.paf.exe"},
            @{Name="QuickBlackjackPortable_3.0.13.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=QuickBlackjackPortable&s=s&p=&d=pa&n=Quick Blackjack Portable&f=QuickBlackjackPortable_3.0.13.1_English.paf.exe"},
            @{Name="QuickBridgePortable_3.3.15.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=QuickBridgePortable&s=s&p=&d=pa&n=Quick Bridge Portable&f=QuickBridgePortable_3.3.15.1_English.paf.exe"},
            @{Name="QuickCribbagePortable_3.5.15.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=QuickCribbagePortable&s=s&p=&d=pa&n=Quick Cribbage Portable&f=QuickCribbagePortable_3.5.15.1_English.paf.exe"},
            @{Name="QuickPokerPortable_3.3.13.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=QuickPokerPortable&s=s&p=&d=pa&n=Quick Poker Portable&f=QuickPokerPortable_3.3.13.1_English.paf.exe"},
            @{Name="QuickSolitairePortable_3.3.16.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=QuickSolitairePortable&s=s&p=&d=pa&n=Quick Solitaire Portable&f=QuickSolitairePortable_3.3.16.1_English.paf.exe"},
            @{Name="RocksnDiamondsPortable_4.4.0.5_English.paf.exe"; Url="https://portableapps.com/downloading/?a=RocksnDiamondsPortable&s=s&p=&d=pa&n=Rocks'n'Diamonds Portable&f=RocksnDiamondsPortable_4.4.0.5_English.paf.exe"},
            @{Name="SauerbratenPortable_2020.12.21_English.paf.exe"; Url="https://portableapps.com/redir2/?a=SauerbratenPortable&s=s&p=&d=sf&f=SauerbratenPortable_2020.12.21_English.paf.exe"},
            @{Name="Scorched3DPortable_44.paf.exe"; Url="https://portableapps.com/downloading/?a=Scorched3DPortable&s=s&p=&d=pa&n=Scorched 3D Portable&f=Scorched3DPortable_44.paf.exe"},
            @{Name="SimpleSudokuPortable_4.2n.paf.exe"; Url="https://portableapps.com/downloading/?a=SimpleSudokuPortable&s=s&p=&d=pa&n=Simple Sudoku Portable&f=SimpleSudokuPortable_4.2n.paf.exe"},
            @{Name="StellaPortable_7.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=StellaPortable&s=s&p=&d=pa&n=Stella Portable&f=StellaPortable_7.0_English.paf.exe"},
            @{Name="SudokuPortable_1.1.7.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SudokuPortable&s=s&p=&d=pa&n=Sudoku Portable&f=SudokuPortable_1.1.7.4_English.paf.exe"},
            @{Name="SuperTuxPortable_0.6.3.paf.exe"; Url="https://portableapps.com/downloading/?a=SuperTuxPortable&s=s&p=&d=pa&n=SuperTux Portable&f=SuperTuxPortable_0.6.3.paf.exe"},
            @{Name="SuperTuxKartPortable_1.4.paf.exe"; Url="https://portableapps.com/downloading/?a=SuperTuxKartPortable&s=s&p=&d=pa&n=SuperTuxKart Portable&f=SuperTuxKartPortable_1.4.paf.exe"},
            @{Name="T-3Portable_4.12.20_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=T-3Portable&s=s&p=&d=pa&n=T^3 Portable&f=T-3Portable_4.12.20_Rev_2_English.paf.exe"},
            @{Name="TheLegendOfEdgarPortable_1.37-1.paf.exe"; Url="https://portableapps.com/downloading/?a=TheLegendOfEdgarPortable&s=s&p=&d=pa&n=The Legend of Edgar Portable&f=TheLegendOfEdgarPortable_1.37-1.paf.exe"},
            @{Name="PowderToyPortable_99.3.384_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PowderToyPortable&s=s&p=&d=pa&n=The Powder Toy Portable&f=PowderToyPortable_99.3.384_English.paf.exe"},
            @{Name="Tick5Portable_1.0_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=Tick5Portable&s=s&p=&d=pa&n=Tick5 Portable&f=Tick5Portable_1.0_Rev_2_English.paf.exe"},
            @{Name="TileWorldPortable_1.3.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=TileWorldPortable&s=s&p=&d=pa&n=Tile World Portable&f=TileWorldPortable_1.3.2_English.paf.exe"},
            @{Name="TwinDistressPortable_1.1.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=TwinDistressPortable&s=s&p=&d=pa&n=Twin Distress Portable&f=TwinDistressPortable_1.1.0_English.paf.exe"},
            @{Name="USBSudokuPortable_2.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=USBSudokuPortable&s=s&p=&d=pa&n=USB Sudoku Portable&f=USBSudokuPortable_2.0_English.paf.exe"},
            @{Name="Warzone2100Portable_4.5.5.paf.exe"; Url="https://portableapps.com/downloading/?a=Warzone2100Portable&s=s&p=&d=pa&n=Warzone 2100 Portable&f=Warzone2100Portable_4.5.5.paf.exe"},
            @{Name="WarMUXPortable_11.04.1_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=WarMUXPortable&s=s&p=&d=pa&n=WarMUX Portable&f=WarMUXPortable_11.04.1_Rev_2.paf.exe"},
            @{Name="WAtomicPortable_1.2.3_Revision_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WAtomicPortable&s=s&p=&d=pa&n=WAtomic Portable&f=WAtomicPortable_1.2.3_Revision_2_English.paf.exe"},
            @{Name="WinBoardPortable_4.8.0.paf.exe"; Url="https://portableapps.com/downloading/?a=WinBoardPortable&s=s&p=&d=pa&n=WinBoard Portable&f=WinBoardPortable_4.8.0.paf.exe"},
            @{Name="WizznicPortable_1.1.0.400_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WizznicPortable&s=s&p=&d=pa&n=Wizznic Portable&f=WizznicPortable_1.1.0.400_English.paf.exe"},
            @{Name="X-MotoPortable_0.6.3.paf.exe"; Url="https://portableapps.com/downloading/?a=X-MotoPortable&s=s&p=&d=pa&n=X-Moto Portable&f=X-MotoPortable_0.6.3.paf.exe"},
            @{Name="XonoticPortable_0.8.6.paf.exe"; Url="https://portableapps.com/downloading/?a=XonoticPortable&s=s&p=&d=pa&n=Xonotic Portable&f=XonoticPortable_0.8.6.paf.exe"},
            @{Name="XyePortable_0.12.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=XyePortable&s=s&p=&d=pa&n=Xye Portable&f=XyePortable_0.12.1_English.paf.exe"},
            @{Name="ZazPortable_1.0.0.paf.exe"; Url="https://portableapps.com/downloading/?a=ZazPortable&s=s&p=&d=pa&n=Zaz Portable&f=ZazPortable_1.0.0.paf.exe"}
        )
    }
    "10" = @{ 
        Name = "PT10"; 
        Description = "Graphics";
        Files = @(
            @{Name="AndreaMosaicPortable_3.53.paf.exe"; Url="https://portableapps.com/downloading/?a=AndreaMosaicPortable&s=s&p=&d=pa&n=AndreaMosaic Portable&f=AndreaMosaicPortable_3.53.paf.exe"},
            @{Name="AniFXPortable_1.0_Rev_3.paf.exe"; Url="https://portableapps.com/downloading/?a=AniFXPortable&s=s&p=&d=pa&n=AniFX Portable&f=AniFXPortable_1.0_Rev_3.paf.exe"},
            @{Name="BlenderPortable_4.4.3.paf.exe"; Url="https://portableapps.com/downloading/?a=BlenderPortable&s=s&p=&d=pa&n=Blender Portable&f=BlenderPortable_4.4.3.paf.exe"},
            @{Name="BlenderCompatPortable_4.3.0.paf.exe"; Url="https://portableapps.com/downloading/?a=BlenderCompatPortable&s=s&p=&d=pa&n=BlenderCompat Portable&f=BlenderCompatPortable_4.3.0.paf.exe"},
            @{Name="CaesiumPortable_2.8.5.paf.exe"; Url="https://portableapps.com/downloading/?a=CaesiumPortable&s=s&p=&d=pa&n=Caesium Portable&f=CaesiumPortable_2.8.5.paf.exe"},
            @{Name="CornicePortable_0.6.1.5.paf.exe"; Url="https://portableapps.com/downloading/?a=CornicePortable&s=s&p=&d=pa&n=Cornice Portable&f=CornicePortable_0.6.1.5.paf.exe"},
            @{Name="darktablePortable_5.0.1.paf.exe"; Url="https://portableapps.com/downloading/?a=darktablePortable&s=s&p=&d=pa&n=darktable Portable&f=darktablePortable_5.0.1.paf.exe"},
            @{Name="DiaPortable_0.97.2_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=DiaPortable&s=s&p=&d=pa&n=Dia Portable&f=DiaPortable_0.97.2_Rev_2.paf.exe"},
            @{Name="DiffImgPortable_2.2.0.paf.exe"; Url="https://portableapps.com/downloading/?a=DiffImgPortable&s=s&p=&d=pa&n=DiffImg Portable&f=DiffImgPortable_2.2.0.paf.exe"},
            @{Name="DrawioPortable_26.2.2.paf.exe"; Url="https://portableapps.com/downloading/?a=DrawioPortable&s=s&p=&d=pa&n=Draw.io Portable (diagrams.net)&f=DrawioPortable_26.2.2.paf.exe"},
            @{Name="ExifToolGUIPortable_6.3.9.paf.exe"; Url="https://portableapps.com/downloading/?a=ExifToolGUIPortable&s=s&p=&d=pa&n=ExifToolGUI Portable&f=ExifToolGUIPortable_6.3.9.paf.exe"},
            @{Name="fscPortable_5.3_Rev_2_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=fscPortable&s=s&p=&d=pa&n=fscPortable&f=fscPortable_5.3_Rev_2_English_online.paf.exe"},
            @{Name="FSViewerPortable_8.0.paf.exe"; Url="https://portableapps.com/downloading/?a=FSViewerPortable&s=s&p=&d=pa&n=FastStone Image Viewer Portable&f=FSViewerPortable_8.0.paf.exe"},
            @{Name="FotografixPortable_1.5_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=FotografixPortable&s=s&p=&d=pa&n=Fotografix Portable&f=FotografixPortable_1.5_Rev_2.paf.exe"},
            @{Name="FotoSketcherPortable_3.95.paf.exe"; Url="https://portableapps.com/downloading/?a=FotoSketcherPortable&s=s&p=&d=pa&n=FotoSketcher Portable&f=FotoSketcherPortable_3.95.paf.exe"},
            @{Name="FreeCADPortable_1.0.1.paf.exe"; Url="https://portableapps.com/downloading/?a=FreeCADPortable&s=s&p=&d=pa&n=FreeCAD Portable&f=FreeCADPortable_1.0.1.paf.exe"},
            @{Name="FyrePortable_1.0.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FyrePortable&s=s&p=&d=pa&n=Fyre Portable&f=FyrePortable_1.0.0_English.paf.exe"},
            @{Name="GIMPPortable_3.0.4.paf.exe"; Url="https://portableapps.com/downloading/?a=GIMPPortable&s=s&p=&d=pa&n=GIMP Portable&f=GIMPPortable_3.0.4.paf.exe"},
            @{Name="GreenfishIconEditorProPortable_4.4.paf.exe"; Url="https://portableapps.com/downloading/?a=GreenfishIconEditorProPortable&s=s&p=&d=pa&n=Greenfish Icon Editor Pro Portable&f=GreenfishIconEditorProPortable_4.4.paf.exe"},
            @{Name="HotSpotStudioPortable_2.1_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=HotSpotStudioPortable&s=s&p=&d=pa&n=Hot Spot Studio Portable&f=HotSpotStudioPortable_2.1_Rev_2_English.paf.exe"},
            @{Name="IcoFXPortable_1.6.4_Rev_3.paf.exe"; Url="https://portableapps.com/downloading/?a=IcoFXPortable&s=s&p=&d=pa&n=IcoFX Portable&f=IcoFXPortable_1.6.4_Rev_3.paf.exe"},
            @{Name="IDPhotoStudioPortable_2.16.5.75.paf.exe"; Url="https://portableapps.com/downloading/?a=IDPhotoStudioPortable&s=s&p=&d=pa&n=IDPhotoStudio Portable&f=IDPhotoStudioPortable_2.16.5.75.paf.exe"},
            @{Name="InkscapePortable_1.4.2.paf.exe"; Url="https://portableapps.com/downloading/?a=InkscapePortable&s=s&p=&d=pa&n=Inkscape Portable&f=InkscapePortable_1.4.2.paf.exe"},
            @{Name="IrfanViewPortable_4.72.paf.exe"; Url="https://portableapps.com/downloading/?a=IrfanViewPortable&s=s&p=&d=pa&n=IrfanView Portable&f=IrfanViewPortable_4.72.paf.exe"},
            @{Name="JPEGViewPortable_1.3.46_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=JPEGViewPortable&s=s&p=&d=pa&n=JPEGView Portable&f=JPEGViewPortable_1.3.46_Rev_2.paf.exe"},
            @{Name="K-3DPortable_0.8.0.1_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=K-3DPortable&s=s&p=&d=pa&n=K-3D Portable&f=K-3DPortable_0.8.0.1_Rev_2_English.paf.exe"},
            @{Name="KiCadPortable_9.0.2.paf.exe"; Url="https://portableapps.com/downloading/?a=KiCadPortable&s=s&p=&d=pa&n=KiCad Portable&f=KiCadPortable_9.0.2.paf.exe"},
            @{Name="KritaPortable_5.2.9.paf.exe"; Url="https://portableapps.com/downloading/?a=KritaPortable&s=s&p=&d=pa&n=Krita Portable&f=KritaPortable_5.2.9.paf.exe"},
            @{Name="LazPaintPortable_7.3.paf.exe"; Url="https://portableapps.com/downloading/?a=LazPaintPortable&s=s&p=&d=pa&n=LazPaint Portable&f=LazPaintPortable_7.3.paf.exe"},
            @{Name="LibreCADPortable_2.2.1.1.paf.exe"; Url="https://portableapps.com/downloading/?a=LibreCADPortable&s=s&p=&d=pa&n=LibreCAD Portable&f=LibreCADPortable_2.2.1.1.paf.exe"},
            @{Name="MyPaintPortable_2.0.1.paf.exe"; Url="https://portableapps.com/downloading/?a=MyPaintPortable&s=s&p=&d=pa&n=MyPaint Portable&f=MyPaintPortable_2.0.1.paf.exe"},
            @{Name="NAPS2Portable_8.1.4.paf.exe"; Url="https://portableapps.com/downloading/?a=NAPS2Portable&s=s&p=&d=pa&n=NAPS2 (Not Another PDF Scanner) Portable&f=NAPS2Portable_8.1.4.paf.exe"},
            @{Name="PaintDotNetPortable_5.1.8.paf.exe"; Url="https://portableapps.com/downloading/?a=PaintDotNetPortable&s=s&p=&d=pa&n=paint.net Portable&f=PaintDotNetPortable_5.1.8.paf.exe"},
            @{Name="Pencil2DPortable_0.6.6.paf.exe"; Url="https://portableapps.com/downloading/?a=Pencil2DPortable&s=s&p=&d=pa&n=Pencil2D Portable&f=Pencil2DPortable_0.6.6.paf.exe"},
            @{Name="PencilProjectPortable_3.1.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PencilProjectPortable&s=s&p=&d=pa&n=Pencil Project Portable&f=PencilProjectPortable_3.1.1_English.paf.exe"},
            @{Name="PhotoDemonPortable_2025.4.paf.exe"; Url="https://portableapps.com/downloading/?a=PhotoDemonPortable&s=s&p=&d=pa&n=PhotoDemon Portable&f=PhotoDemonPortable_2025.4.paf.exe"},
            @{Name="PhotoFilmStripPortable_3.7.0.paf.exe"; Url="https://portableapps.com/downloading/?a=PhotoFilmStripPortable&s=s&p=&d=pa&n=PhotoFilmStrip Portable&f=PhotoFilmStripPortable_3.7.0.paf.exe"},
            @{Name="PhotoFiltrePortable_7.2.1_Rev_3.paf.exe"; Url="https://portableapps.com/downloading/?a=PhotoFiltrePortable&s=s&p=&d=pa&n=PhotoFiltre Portable&f=PhotoFiltrePortable_7.2.1_Rev_3.paf.exe"},
            @{Name="PicPickPortable_7.3.6.paf.exe"; Url="https://portableapps.com/downloading/?a=PicPickPortable&s=s&p=&d=pa&n=PicPick Portable&f=PicPickPortable_7.3.6.paf.exe"},
            @{Name="PixeloramaPortable_1.1.1.paf.exe"; Url="https://portableapps.com/downloading/?a=PixeloramaPortable&s=s&p=&d=pa&n=Pixelorama Portable&f=PixeloramaPortable_1.1.1.paf.exe"},
            @{Name="PngOptimizerPortable_2.7.paf.exe"; Url="https://portableapps.com/downloading/?a=PngOptimizerPortable&s=s&p=&d=pa&n=PngOptimizer Portable&f=PngOptimizerPortable_2.7.paf.exe"},
            @{Name="RawTherapeePortable_5.12.paf.exe"; Url="https://portableapps.com/downloading/?a=RawTherapeePortable&s=s&p=&d=pa&n=RawTherapee Portable&f=RawTherapeePortable_5.12.paf.exe"},
            @{Name="ScreenToGifPortable_2.41.2.paf.exe"; Url="https://portableapps.com/downloading/?a=ScreenToGifPortable&s=s&p=&d=pa&n=ScreenToGif Portable&f=ScreenToGifPortable_2.41.2.paf.exe"},
            @{Name="ShareXPortable_17.1.0.paf.exe"; Url="https://portableapps.com/downloading/?a=ShareXPortable&s=s&p=&d=pa&n=ShareX Portable&f=ShareXPortable_17.1.0.paf.exe"},
            @{Name="SmartDeblurPortable_1.27_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SmartDeblurPortable&s=s&p=&d=pa&n=Smart Deblur Portable&f=SmartDeblurPortable_1.27_English.paf.exe"},
            @{Name="XnConvertPortable_1.105.0.paf.exe"; Url="https://portableapps.com/downloading/?a=XnConvertPortable&s=s&p=&d=pa&n=XnConvert Portable&f=XnConvertPortable_1.105.0.paf.exe"},
            @{Name="XnViewPortable_2.52.1.paf.exe"; Url="https://portableapps.com/downloading/?a=XnViewPortable&s=s&p=&d=pa&n=XnView Portable&f=XnViewPortable_2.52.1.paf.exe"},
            @{Name="XnViewMPPortable_1.8.8.paf.exe"; Url="https://portableapps.com/downloading/?a=XnViewMPPortable&s=s&p=&d=pa&n=XnView MP Portable&f=XnViewMPPortable_1.8.8.paf.exe"},
            @{Name="DiaPortable_0.97.2_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=DiaPortable&s=s&p=&d=pa&n=Dia Portable&f=DiaPortable_0.97.2_Rev_2.paf.exe"}
        )
    }
    "11" = @{ 
        Name = "PT11"; 
        Description = "Internet";
        Files = @(
            @{Name="aMSNPortable_0.98.9.paf.exe"; Url="https://portableapps.com/downloading/?a=aMSNPortable&s=s&p=&d=pa&n=aMSN Portable (Discontinued)&f=aMSNPortable_0.98.9.paf.exe"},
            @{Name="DamnVidPortable_1.6.0.1.paf.exe"; Url="https://portableapps.com/downloading/?a=DamnVidPortable&s=s&p=&d=pa&n=DamnVid Portable&f=DamnVidPortable_1.6.0.1.paf.exe"},
            @{Name="EkigaPortable_4.0.1_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=EkigaPortable&s=s&p=&d=pa&n=Ekiga Portable&f=EkigaPortable_4.0.1_Rev_2.paf.exe"},
            @{Name="FalkonPortable_3.1.0_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=FalkonPortable&s=s&p=&d=pa&n=Falkon Portable (Discontinued)&f=FalkonPortable_3.1.0_Rev_2.paf.exe"},
            @{Name="fdmPortable_6.28.0_online.paf.exe"; Url="https://portableapps.com/downloading/?a=fdmPortable&s=s&p=&d=pa&n=fdmPortable&f=fdmPortable_6.28.0_online.paf.exe"},
            @{Name="FeedNotifierPortable_2.6_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FeedNotifierPortable&s=s&p=&d=pa&n=Feed Notifier Portable&f=FeedNotifierPortable_2.6_English.paf.exe"},
            @{Name="FeedRollerPortable_0.65_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FeedRollerPortable&s=s&p=&d=pa&n=FeedRoller Portable&f=FeedRollerPortable_0.65_English.paf.exe"},
            @{Name="FerdiumPortable_7.1.0.paf.exe"; Url="https://portableapps.com/downloading/?a=FerdiumPortable&s=s&p=&d=pa&n=Ferdium Portable&f=FerdiumPortable_7.1.0.paf.exe"},
            @{Name="FileZillaPortable_3.69.1.paf.exe"; Url="https://portableapps.com/downloading/?a=FileZillaPortable&s=s&p=&d=pa&n=FileZilla Client Portable&f=FileZillaPortable_3.69.1.paf.exe"},
            @{Name="FreeDownloadManagerPortable_3.9.7.1641_Final.paf.exe"; Url="https://portableapps.com/downloading/?a=FreeDownloadManagerPortable&s=s&p=&d=pa&n=Free Download Manager Classic Portable&f=FreeDownloadManagerPortable_3.9.7.1641_Final.paf.exe"},
            @{Name="GoogleChromePortable_137.0.7151.69_online.paf.exe"; Url="https://portableapps.com/downloading/?a=GoogleChromePortable&s=s&p=&d=pa&n=Google Chrome Portable&f=GoogleChromePortable_137.0.7151.69_online.paf.exe"},
            @{Name="GopherusPortable_1.2.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=GopherusPortable&s=s&p=&d=pa&n=Gopherus Portable&f=GopherusPortable_1.2.2_English.paf.exe"},
            @{Name="gPodderPortable_3.11.5.paf.exe"; Url="https://portableapps.com/downloading/?a=gPodderPortable&s=s&p=&d=pa&n=gPodder Portable&f=gPodderPortable_3.11.5.paf.exe"},
            @{Name="HexChatPortable_2.16.2.paf.exe"; Url="https://portableapps.com/downloading/?a=HexChatPortable&s=s&p=&d=pa&n=HexChat Portable&f=HexChatPortable_2.16.2.paf.exe"},
            @{Name="InstantbirdPortable_1.5_English.paf.exe"; Url="https://portableapps.com/downloading/?a=InstantbirdPortable&s=s&p=&d=pa&n=Instantbird Portable (Discontinued)&f=InstantbirdPortable_1.5_English.paf.exe"},
            @{Name="IronPortable_135.0.6850.0.paf.exe"; Url="https://portableapps.com/downloading/?a=IronPortable&s=s&p=&d=pa&n=Iron Portable&f=IronPortable_135.0.6850.0.paf.exe"},
            @{Name="IsotoxinPortable_0.4.528.paf.exe"; Url="https://portableapps.com/downloading/?a=IsotoxinPortable&s=s&p=&d=pa&n=Isotoxin Portable&f=IsotoxinPortable_0.4.528.paf.exe"},
            @{Name="JuicePortable_2.22.paf.exe"; Url="https://portableapps.com/downloading/?a=JuicePortable&s=s&p=&d=pa&n=Juice Portable&f=JuicePortable_2.22.paf.exe"},
            @{Name="K-MeleonPortable_76.5.5-2024-12-21.paf.exe"; Url="https://portableapps.com/downloading/?a=K-MeleonPortable&s=s&p=&d=pa&n=K-Meleon Portable&f=K-MeleonPortable_76.5.5-2024-12-21.paf.exe"},
            @{Name="KiTTYPortable_0.76.1.13_English.paf.exe"; Url="https://portableapps.com/downloading/?a=KiTTYPortable&s=s&p=&d=pa&n=KiTTY Portable&f=KiTTYPortable_0.76.1.13_English.paf.exe"},
            @{Name="KVIrcPortable_5.2.2.paf.exe"; Url="https://portableapps.com/downloading/?a=KVIrcPortable&s=s&p=&d=pa&n=KVIrc Portable&f=KVIrcPortable_5.2.2.paf.exe"},
            @{Name="LagrangePortable_1.18.5.paf.exe"; Url="https://portableapps.com/downloading/?a=LagrangePortable&s=s&p=&d=pa&n=Lagrange Portable&f=LagrangePortable_1.18.5.paf.exe"},
            @{Name="LibreWolfPortable_139.0.1-1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=LibreWolfPortable&s=s&p=&d=pa&n=LibreWolf Portable&f=LibreWolfPortable_139.0.1-1_English.paf.exe"},
            @{Name="LinksPortable_2.29.paf.exe"; Url="https://portableapps.com/downloading/?a=LinksPortable&s=s&p=&d=pa&n=Links Portable&f=LinksPortable_2.29.paf.exe"},
            @{Name="LANMessengerPortable_1.2.35.paf.exe"; Url="https://portableapps.com/downloading/?a=LANMessengerPortable&s=s&p=&d=pa&n=LAN Messenger Portable&f=LANMessengerPortable_1.2.35.paf.exe"},
            @{Name="LynxPortable_2.9.2.paf.exe"; Url="https://portableapps.com/downloading/?a=LynxPortable&s=s&p=&d=pa&n=Lynx Portable&f=LynxPortable_2.9.2.paf.exe"},
            @{Name="MaxthonPortable_7.3.1.4201.paf.exe"; Url="https://portableapps.com/downloading/?a=MaxthonPortable&s=s&p=&d=pa&n=Maxthon Portable&f=MaxthonPortable_7.3.1.4201.paf.exe"},
            @{Name="MicroSIPPortable_3.21.6.paf.exe"; Url="https://portableapps.com/downloading/?a=MicroSIPPortable&s=s&p=&d=pa&n=MicroSIP Portable&f=MicroSIPPortable_3.21.6.paf.exe"},
            @{Name="MirandaPortable_0.10.80.paf.exe"; Url="https://portableapps.com/downloading/?a=MirandaPortable&s=s&p=&d=pa&n=Miranda IM Portable [Deprecated]&f=MirandaPortable_0.10.80.paf.exe"},
            @{Name="MirandaNGPortable_0.96.6.paf.exe"; Url="https://portableapps.com/downloading/?a=MirandaNGPortable&s=s&p=&d=pa&n=Miranda NG Portable&f=MirandaNGPortable_0.96.6.paf.exe"},
            @{Name="FirefoxPortable_139.0.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FirefoxPortable&s=s&p=&d=pa&n=Mozilla Firefox, Portable Edition&f=FirefoxPortable_139.0.1_English.paf.exe"},
            @{Name="FirefoxPortableDeveloper_140.0_Beta_1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FirefoxPortableDeveloper&s=s&p=&d=pa&n=Mozilla Firefox Developer Edition, Portable&f=FirefoxPortableDeveloper_140.0_Beta_1_English.paf.exe"},
            @{Name="ThunderbirdPortable_139.0.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ThunderbirdPortable&s=s&p=&d=pa&n=Thunderbird, Portable Edition&f=ThunderbirdPortable_139.0.1_English.paf.exe"},
            @{Name="MumblePortable_1.5.735.paf.exe"; Url="https://portableapps.com/downloading/?a=MumblePortable&s=s&p=&d=pa&n=Mumble Portable&f=MumblePortable_1.5.735.paf.exe"},
            @{Name="OperaPortable_119.0.5497.56.paf.exe"; Url="https://portableapps.com/downloading/?a=OperaPortable&s=s&p=&d=pa&n=Opera Portable, Portable Edition&f=OperaPortable_119.0.5497.56.paf.exe"},
            @{Name="OperaGXPortable_119.0.5497.43.paf.exe"; Url="https://portableapps.com/downloading/?a=OperaGXPortable&s=s&p=&d=pa&n=Opera GX Portable, Portable Edition&f=OperaGXPortable_119.0.5497.43.paf.exe"},
            @{Name="OperaMailPortable_1.0.1044.paf.exe"; Url="https://portableapps.com/downloading/?a=OperaMailPortable&s=s&p=&d=pa&n=Opera Mail Portable (Discontinued)&f=OperaMailPortable_1.0.1044.paf.exe"},
            @{Name="PChatPortable_1.5.2.paf.exe"; Url="https://portableapps.com/downloading/?a=PChatPortable&s=s&p=&d=pa&n=PChat Portable&f=PChatPortable_1.5.2.paf.exe"},
            @{Name="PidginPortable_2.14.14.paf.exe"; Url="https://portableapps.com/downloading/?a=PidginPortable&s=s&p=&d=pa&n=Pidgin Portable&f=PidginPortable_2.14.14.paf.exe"},
            @{Name="PopManPortable_1.3.18.paf.exe"; Url="https://portableapps.com/downloading/?a=PopManPortable&s=s&p=&d=pa&n=PopMan Portable&f=PopManPortable_1.3.18.paf.exe"},
            @{Name="PrivateBrowsingByPortableApps_5.0.paf.exe"; Url="https://portableapps.com/downloading/?a=PrivateBrowsingByPortableApps&s=s&p=&d=pa&n=Private Browsing by PortableApps.com&f=PrivateBrowsingByPortableApps_5.0.paf.exe"},
            @{Name="PuTTYPortable_0.83_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PuTTYPortable&s=s&p=&d=pa&n=PuTTY Portable&f=PuTTYPortable_0.83_English.paf.exe"},
            @{Name="qBittorrentPortable_5.1.0.paf.exe"; Url="https://portableapps.com/downloading/?a=qBittorrentPortable&s=s&p=&d=pa&n=qBittorrent Portable&f=qBittorrentPortable_5.1.0.paf.exe"},
            @{Name="qBittorrentEnhancedPortable_5.1.0.11.paf.exe"; Url="https://portableapps.com/downloading/?a=qBittorrentEnhancedPortable&s=s&p=&d=pa&n=qBittorrent Enhanced Portable&f=qBittorrentEnhancedPortable_5.1.0.11.paf.exe"},
            @{Name="qToxPortable_1.17.6.paf.exe"; Url="https://portableapps.com/downloading/?a=qToxPortable&s=s&p=&d=pa&n=qTox Portable&f=qToxPortable_1.17.6.paf.exe"},
            @{Name="QuiteRSSPortable_0.19.4.paf.exe"; Url="https://portableapps.com/downloading/?a=QuiteRSSPortable&s=s&p=&d=pa&n=QuiteRSS Portable&f=QuiteRSSPortable_0.19.4.paf.exe"},
            @{Name="QupZillaPortable_2.2.6.paf.exe"; Url="https://portableapps.com/downloading/?a=QupZillaPortable&s=s&p=&d=pa&n=QupZilla Portable (Discontinued)&f=QupZillaPortable_2.2.6.paf.exe"},
            @{Name="QuteComPortable_2.2.1_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=QuteComPortable&s=s&p=&d=pa&n=QuteCom Portable&f=QuteComPortable_2.2.1_Rev_2.paf.exe"},
            @{Name="RetroSharePortable_0.6.7.paf.exe"; Url="https://portableapps.com/downloading/?a=RetroSharePortable&s=s&p=&d=pa&n=RetroShare Portable&f=RetroSharePortable_0.6.7.paf.exe"},
            @{Name="RSSGuardPortable_4.8.5.paf.exe"; Url="https://portableapps.com/downloading/?a=RSSGuardPortable&s=s&p=&d=pa&n=RSS Guard Portable&f=RSSGuardPortable_4.8.5.paf.exe"},
            @{Name="SeaMonkeyPortable_2.53.20_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SeaMonkeyPortable&s=s&p=&d=pa&n=SeaMonkey Portable&f=SeaMonkeyPortable_2.53.20_English.paf.exe"},
            @{Name="sPortable_8.150.0.125_online.paf.exe"; Url="https://portableapps.com/downloading/?a=sPortable&s=s&p=&d=pa&n=sPortable (Discontinued)&f=sPortable_8.150.0.125_online.paf.exe"},
            @{Name="SupermiumPortable_132.0.6834.222_R3.01.paf.exe"; Url="https://portableapps.com/downloading/?a=SupermiumPortable&s=s&p=&d=pa&n=Supermium Portable&f=SupermiumPortable_132.0.6834.222_R3.01.paf.exe"},
            @{Name="SylpheedPortable_3.7_Cert_Update.paf.exe"; Url="https://portableapps.com/downloading/?a=SylpheedPortable&s=s&p=&d=pa&n=Sylpheed Portable&f=SylpheedPortable_3.7_Cert_Update.paf.exe"},
            @{Name="TelegramDesktopPortable_5.14.3.paf.exe"; Url="https://portableapps.com/downloading/?a=TelegramDesktopPortable&s=s&p=&d=pa&n=Telegram Desktop Portable&f=TelegramDesktopPortable_5.14.3.paf.exe"},
            @{Name="TransmissionPortable_4.0.6.paf.exe"; Url="https://portableapps.com/downloading/?a=TransmissionPortable&s=s&p=&d=pa&n=Transmission Portable&f=TransmissionPortable_4.0.6.paf.exe"},
            @{Name="uGetPortable_2.2.3-2.2.paf.exe"; Url="https://portableapps.com/downloading/?a=uGetPortable&s=s&p=&d=pa&n=uGet Portable&f=uGetPortable_2.2.3-2.2.paf.exe"},
            @{Name="uTorrentPortable_3.6.0.46896_online.paf.exe"; Url="https://portableapps.com/downloading/?a=uTorrentPortable&s=s&p=&d=pa&n=ÂµTorrent Portable&f=uTorrentPortable_3.6.0.46896_online.paf.exe"},
            @{Name="WackGetPortable_1.2.4_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WackGetPortable&s=s&p=&d=pa&n=WackGet Portable&f=WackGetPortable_1.2.4_Rev_2_English.paf.exe"},
            @{Name="WhalebirdPortable_6.2.2.paf.exe"; Url="https://portableapps.com/downloading/?a=WhalebirdPortable&s=s&p=&d=pa&n=Whalebird Portable&f=WhalebirdPortable_6.2.2.paf.exe"},
            @{Name="WinSCPPortable_6.5.1.paf.exe"; Url="https://portableapps.com/downloading/?a=WinSCPPortable&s=s&p=&d=pa&n=WinSCP Portable&f=WinSCPPortable_6.5.1.paf.exe"},
            @{Name="WinWGetPortable_0.20.2020-1.21.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WinWGetPortable&s=s&p=&d=pa&n=WinWGet+ Portable&f=WinWGetPortable_0.20.2020-1.21.2_English.paf.exe"},
            @{Name="wxDownloadFastPortable_0.6_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=wxDownloadFastPortable&s=s&p=&d=pa&n=wxDownload Fast Portable&f=wxDownloadFastPortable_0.6_Rev_2.paf.exe"},
            @{Name="zmPortable_6.4.12_online.paf.exe"; Url="https://portableapps.com/downloading/?a=zmPortable&s=s&p=&d=pa&n=zmPortable&f=zmPortable_6.4.12_online.paf.exe"},
            @{Name="ThunderbirdPortable_139.0.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ThunderbirdPortable&s=s&p=&d=pa&n=Thunderbird, Portable Edition&f=ThunderbirdPortable_139.0.1_English.paf.exe"}
        )
    }
    "12" = @{ 
        Name = "PT12"; 
        Description = "MusicVideo";
        Files = @(
            @{Name="AIMPPortable_5.40.2675.paf.exe"; Url="https://portableapps.com/downloading/?a=AIMPPortable&s=s&p=&d=pa&n=AIMP Portable&f=AIMPPortable_5.40.2675.paf.exe"},
            @{Name="AudaciousPortable_4.4.2.paf.exe"; Url="https://portableapps.com/downloading/?a=AudaciousPortable&s=s&p=&d=pa&n=Audacious Portable&f=AudaciousPortable_4.4.2.paf.exe"},
            @{Name="AudacityPortable_3.7.3.paf.exe"; Url="https://portableapps.com/downloading/?a=AudacityPortable&s=s&p=&d=pa&n=Audacity Portable&f=AudacityPortable_3.7.3.paf.exe"},
            @{Name="AutoDrumPortable_8.1.paf.exe"; Url="https://portableapps.com/downloading/?a=AutoDrumPortable&s=s&p=&d=pa&n=AutoDrum Portable&f=AutoDrumPortable_8.1.paf.exe"},
            @{Name="AvidemuxPortable_2.8.1.paf.exe"; Url="https://portableapps.com/downloading/?a=AvidemuxPortable&s=s&p=&d=pa&n=Avidemux Portable&f=AvidemuxPortable_2.8.1.paf.exe"},
            @{Name="CDexPortable_2.24_Rev_2_online.paf.exe"; Url="https://portableapps.com/downloading/?a=CDexPortable&s=s&p=&d=pa&n=CDex Portable&f=CDexPortable_2.24_Rev_2_online.paf.exe"},
            @{Name="cdrtfePortable_1.5.9.1_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=cdrtfePortable&s=s&p=&d=pa&n=cdrtfe Portable&f=cdrtfePortable_1.5.9.1_Rev_2.paf.exe"},
            @{Name="DVDStylerPortable_3.2.1.paf.exe"; Url="https://portableapps.com/downloading/?a=DVDStylerPortable&s=s&p=&d=pa&n=DVDStyler Portable&f=DVDStylerPortable_3.2.1.paf.exe"},
            @{Name="fb2kPortable_2.24.5_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=fb2kPortable&s=s&p=&d=pa&n=fb2kPortable&f=fb2kPortable_2.24.5_English_online.paf.exe"},
            @{Name="freacPortable_1.1.7.paf.exe"; Url="https://portableapps.com/downloading/?a=freacPortable&s=s&p=&d=pa&n=fre:ac Portable&f=freacPortable_1.1.7.paf.exe"},
            @{Name="gMKVExtractGUIPortable_2.9.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=gMKVExtractGUIPortable&s=s&p=&d=pa&n=gMKVExtractGUI Portable&f=gMKVExtractGUIPortable_2.9.1_English.paf.exe"},
            @{Name="ImgBurnPortable_2.5.8.0_online.paf.exe"; Url="https://portableapps.com/downloading/?a=ImgBurnPortable&s=s&p=&d=pa&n=ImgBurn Portable&f=ImgBurnPortable_2.5.8.0_online.paf.exe"},
            @{Name="InfraRecorderPortable_0.53_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=InfraRecorderPortable&s=s&p=&d=pa&n=InfraRecorder Portable&f=InfraRecorderPortable_0.53_Rev_2.paf.exe"},
            @{Name="LameXPPortable_2023-12-29_Build_2382.paf.exe"; Url="https://portableapps.com/downloading/?a=LameXPPortable&s=s&p=&d=pa&n=LameXP Portable&f=LameXPPortable_2023-12-29_Build_2382.paf.exe"},
            @{Name="LMMSPortable_1.2.2.paf.exe"; Url="https://portableapps.com/downloading/?a=LMMSPortable&s=s&p=&d=pa&n=LMMS Portable&f=LMMSPortable_1.2.2.paf.exe"},
            @{Name="LosslessCutPortable_3.64.0.paf.exe"; Url="https://portableapps.com/downloading/?a=LosslessCutPortable&s=s&p=&d=pa&n=Lossless Cut Portable&f=LosslessCutPortable_3.64.0.paf.exe"},
            @{Name="MKVToolNixPortable_92.0.paf.exe"; Url="https://portableapps.com/downloading/?a=MKVToolNixPortable&s=s&p=&d=pa&n=MKVToolNix Portable&f=MKVToolNixPortable_92.0.paf.exe"},
            @{Name="MPC-BEPortable_1.8.4.paf.exe"; Url="https://portableapps.com/downloading/?a=MPC-BEPortable&s=s&p=&d=pa&n=Media Player Classic - Black Edition (MPC-BE) Portable&f=MPC-BEPortable_1.8.4.paf.exe"},
            @{Name="MPC-HCPortable_2.4.3.paf.exe"; Url="https://portableapps.com/downloading/?a=MPC-HCPortable&s=s&p=&d=pa&n=Media Player Classic - Home Cinema (MPC-HC) Portable&f=MPC-HCPortable_2.4.3.paf.exe"},
            @{Name="MediaInfoPortable_25.04.paf.exe"; Url="https://portableapps.com/downloading/?a=MediaInfoPortable&s=s&p=&d=pa&n=MediaInfo Portable&f=MediaInfoPortable_25.04.paf.exe"},
            @{Name="MilkyTrackerPortable_1.05.01_English.paf.exe"; Url="https://portableapps.com/downloading/?a=MilkyTrackerPortable&s=s&p=&d=pa&n=MilkyTracker Portable&f=MilkyTrackerPortable_1.05.01_English.paf.exe"},
            @{Name="MixxxPortable_2.5.1_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=MixxxPortable&s=s&p=&d=pa&n=Mixxx Portable&f=MixxxPortable_2.5.1_Rev_2.paf.exe"},
            @{Name="Mp3spltPortable_0.9.2.paf.exe"; Url="https://portableapps.com/downloading/?a=Mp3spltPortable&s=s&p=&d=pa&n=Mp3splt-gtk Portable&f=Mp3spltPortable_0.9.2.paf.exe"},
            @{Name="MuseScorePortable_4.5.2.paf.exe"; Url="https://portableapps.com/downloading/?a=MuseScorePortable&s=s&p=&d=pa&n=MuseScore Portable&f=MuseScorePortable_4.5.2.paf.exe"},
            @{Name="OBSPortable_31.0.3.paf.exe"; Url="https://portableapps.com/downloading/?a=OBSPortable&s=s&p=&d=pa&n=OBS Studio Portable&f=OBSPortable_31.0.3.paf.exe"},
            @{Name="OpalPortable_1.5.0.paf.exe"; Url="https://portableapps.com/downloading/?a=OpalPortable&s=s&p=&d=pa&n=Opal Portable&f=OpalPortable_1.5.0.paf.exe"},
            @{Name="OpenMPTPortable_1.31.15_English.paf.exe"; Url="https://portableapps.com/downloading/?a=OpenMPTPortable&s=s&p=&d=pa&n=OpenMPT Portable&f=OpenMPTPortable_1.31.15_English.paf.exe"},
            @{Name="OpenShotPortable_3.3.0.paf.exe"; Url="https://portableapps.com/downloading/?a=OpenShotPortable&s=s&p=&d=pa&n=OpenShot Portable&f=OpenShotPortable_3.3.0.paf.exe"},
            @{Name="PicardPortable_2.13.3.paf.exe"; Url="https://portableapps.com/downloading/?a=PicardPortable&s=s&p=&d=pa&n=MusicBrainz Picard Portable&f=PicardPortable_2.13.3.paf.exe"},
            @{Name="PaulStretchPortable_2.2-2_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PaulStretchPortable&s=s&p=&d=pa&n=Paul's Extreme Sound Stretch Portable&f=PaulStretchPortable_2.2-2_Rev_2_English.paf.exe"},
            @{Name="PotPlayerPortable_1.7.22506.paf.exe"; Url="https://portableapps.com/downloading/?a=PotPlayerPortable&s=s&p=&d=pa&n=PotPlayer Portable&f=PotPlayerPortable_1.7.22506.paf.exe"},
            @{Name="QmmpPortable_1.7.5.paf.exe"; Url="https://portableapps.com/downloading/?a=QmmpPortable&s=s&p=&d=pa&n=Qmmp Portable&f=QmmpPortable_1.7.5.paf.exe"},
            @{Name="ShotcutPortable_25.05.11.paf.exe"; Url="https://portableapps.com/downloading/?a=ShotcutPortable&s=s&p=&d=pa&n=Shotcut Portable&f=ShotcutPortable_25.05.11.paf.exe"},
            @{Name="SMPlayerPortable_24.5.0.paf.exe"; Url="https://portableapps.com/downloading/?a=SMPlayerPortable&s=s&p=&d=pa&n=SMPlayer Portable&f=SMPlayerPortable_24.5.0.paf.exe"},
            @{Name="StreamWriterPortable_6.0.1.paf.exe"; Url="https://portableapps.com/downloading/?a=StreamWriterPortable&s=s&p=&d=pa&n=streamWriter Portable&f=StreamWriterPortable_6.0.1.paf.exe"},
            @{Name="TAudioConverterPortable_0.9.9.paf.exe"; Url="https://portableapps.com/downloading/?a=TAudioConverterPortable&s=s&p=&d=pa&n=TAudioConverter Portable&f=TAudioConverterPortable_0.9.9.paf.exe"},
            @{Name="TEncoderPortable_4.5.10.paf.exe"; Url="https://portableapps.com/downloading/?a=TEncoderPortable&s=s&p=&d=pa&n=TEncoder Video Converter Portable&f=TEncoderPortable_4.5.10.paf.exe"},
            @{Name="VirtualDubPortable_1.10.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=VirtualDubPortable&s=s&p=&d=pa&n=VirtualDub Portable&f=VirtualDubPortable_1.10.4_English.paf.exe"},
            @{Name="VLCPortable_3.0.21.paf.exe"; Url="https://portableapps.com/downloading/?a=VLCPortable&s=s&p=&d=pa&n= VLC Media Player Portable &f=VLCPortable_3.0.21.paf.exe"},
            @{Name="WaveShopPortable_1.0.14_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WaveShopPortable&s=s&p=&d=pa&n=WaveShop Portable&f=WaveShopPortable_1.0.14_English.paf.exe"},
            @{Name="winLAMEPortable_2023_Release_1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=winLAMEPortable&s=s&p=&d=pa&n=winLAME Portable&f=winLAMEPortable_2023_Release_1_English.paf.exe"},
            @{Name="wxMP3gainPortable_4.2.paf.exe"; Url="https://portableapps.com/downloading/?a=wxMP3gainPortable&s=s&p=&d=pa&n=wxMP3gain Portable&f=wxMP3gainPortable_4.2.paf.exe"},
            @{Name="XMPlayPortable_4.0.paf.exe"; Url="https://portableapps.com/downloading/?a=XMPlayPortable&s=s&p=&d=pa&n=XMPlay Portable&f=XMPlayPortable_4.0.paf.exe"}
        )
    }
    "13" = @{ 
        Name = "PT13"; 
        Description = "Office";
        Files = @(
            @{Name="ANotePortable_4.2.4.paf.exe"; Url="https://portableapps.com/downloading/?a=ANotePortable&s=s&p=&d=pa&n=A Note Portable&f=ANotePortable_4.2.4.paf.exe"},
            @{Name="AbiWordPortable_2.9.4.paf.exe"; Url="https://portableapps.com/downloading/?a=AbiWordPortable&s=s&p=&d=pa&n=AbiWord Portable&f=AbiWordPortable_2.9.4.paf.exe"},
            @{Name="OpenOfficePortable_4.1.15_MultilingualStandard.paf.exe"; Url="https://portableapps.com/downloading/?a=OpenOfficePortable&n=Apache OpenOffice Portable&s=s&p=&d=pa&f=OpenOfficePortable_4.1.15_MultilingualStandard.paf.exe"},
            @{Name="BabelPadPortable_16.0.0.6_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=BabelPadPortable&s=s&p=&d=pa&n=BabelPad Portable&f=BabelPadPortable_16.0.0.6_English_online.paf.exe"},
            @{Name="BitcoinPortable_29.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=BitcoinPortable&s=s&p=&d=pa&n=Bitcoin Core Portable&f=BitcoinPortable_29.0_English.paf.exe"},
            @{Name="calibrePortable_8.4.0.paf.exe"; Url="https://portableapps.com/downloading/?a=calibrePortable&s=s&p=&d=pa&n=calibre Portable&f=calibrePortable_8.4.0.paf.exe"},
            @{Name="CherrytreePortable_1.4.0.paf.exe"; Url="https://portableapps.com/downloading/?a=CherrytreePortable&s=s&p=&d=pa&n=Cherrytree Portable&f=CherrytreePortable_1.4.0.paf.exe"},
            @{Name="CintaNotesPortable_3.14.paf.exe"; Url="https://portableapps.com/downloading/?a=CintaNotesPortable&s=s&p=&d=pa&n=CintaNotes Portable&f=CintaNotesPortable_3.14.paf.exe"},
            @{Name="CuteMarkEdPortable_0.11.3.paf.exe"; Url="https://portableapps.com/downloading/?a=CuteMarkEdPortable&s=s&p=&d=pa&n=CuteMarkEd Portable&f=CuteMarkEdPortable_0.11.3.paf.exe"},
            @{Name="DogecoinPortable_1.14.7_English.paf.exe"; Url="https://portableapps.com/downloading/?a=DogecoinPortable&s=s&p=&d=pa&n=Dogecoin Core Portable&f=DogecoinPortable_1.14.7_English.paf.exe"},
            @{Name="EvincePortable_2.32.0-145_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=EvincePortable&s=s&p=&d=pa&n=Evince Portable&f=EvincePortable_2.32.0-145_Rev_2.paf.exe"},
            @{Name="FinanceExplorerPortable_8.2.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FinanceExplorerPortable&s=s&p=&d=pa&n=Finance Explorer Portable&f=FinanceExplorerPortable_8.2.0_English.paf.exe"},
            @{Name="FocusWriterPortable_1.8.11.paf.exe"; Url="https://portableapps.com/downloading/?a=FocusWriterPortable&s=s&p=&d=pa&n=FocusWriter Portable&f=FocusWriterPortable_1.8.11.paf.exe"},
            @{Name="FoxitReaderPortable_2025.1.0.paf.exe"; Url="https://portableapps.com/downloading/?a=FoxitReaderPortable&s=s&p=&d=pa&n=Foxit Reader Portable&f=FoxitReaderPortable_2025.1.0.paf.exe"},
            @{Name="GnuCashPortable_5.11.paf.exe"; Url="https://portableapps.com/downloading/?a=GnuCashPortable&s=s&p=&d=pa&n=GnuCash Portable&f=GnuCashPortable_5.11.paf.exe"},
            @{Name="GnumericPortable_1.12.17.paf.exe"; Url="https://portableapps.com/downloading/?a=GnumericPortable&s=s&p=&d=pa&n=Gnumeric Portable&f=GnumericPortable_1.12.17.paf.exe"},
            @{Name="HomeBankPortable_5.9.1.paf.exe"; Url="https://portableapps.com/downloading/?a=HomeBankPortable&s=s&p=&d=pa&n=HomeBank Portable&f=HomeBankPortable_5.9.1.paf.exe"},
            @{Name="JartePortable_6.2_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=JartePortable&s=s&p=&d=pa&n=Jarte Plus Portable&f=JartePortable_6.2_Rev_2_English.paf.exe"},
            @{Name="JoplinPortable_3.3.12.paf.exe"; Url="https://portableapps.com/downloading/?a=JoplinPortable&s=s&p=&d=pa&n=Joplin Portable&f=JoplinPortable_3.3.12.paf.exe"},
            @{Name="KanriPortable_0.8.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=KanriPortable&s=s&p=&d=pa&n=Kanri Portable&f=KanriPortable_0.8.1_English.paf.exe"},
            @{Name="KchmViewerPortable_7.7_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=KchmViewerPortable&s=s&p=&d=pa&n=KchmViewer Portable&f=KchmViewerPortable_7.7_Rev_2.paf.exe"},
            @{Name="KeepNotePortable_0.7.8.paf.exe"; Url="https://portableapps.com/downloading/?a=KeepNotePortable&s=s&p=&d=pa&n=KeepNote Portable&f=KeepNotePortable_0.7.8.paf.exe"},
            @{Name="LibreOfficePortable_25.2.3_MultilingualStandard.paf.exe"; Url="https://portableapps.com/redir2/?a=LibreOfficePortable&s=s&p=https://download.documentfoundation.org/libreoffice/portable/25.2.3/&d=pb&f=LibreOfficePortable_25.2.3_MultilingualStandard.paf.exe"},
            @{Name="LitecoinPortable_0.21.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=LitecoinPortable&s=s&p=&d=pa&n=Litecoin Core Portable&f=LitecoinPortable_0.21.4_English.paf.exe"},
            @{Name="MoneroPortable_0.18.3.3.paf.exe"; Url="https://portableapps.com/redir2/?a=MoneroPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=MoneroPortable_0.18.3.3.paf.exe"},
            @{Name="MoneyManagerExPortable_1.9.0.paf.exe"; Url="https://portableapps.com/downloading/?a=MoneyManagerExPortable&s=s&p=&d=pa&n=Money Manager Ex Portable&f=MoneyManagerExPortable_1.9.0.paf.exe"},
            @{Name="SunbirdPortable_1.0b1_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SunbirdPortable&s=s&p=&d=pa&n=Mozilla Sunbird, Portable Edition (Discontinued)&f=SunbirdPortable_1.0b1_Rev_2_English.paf.exe"},
            @{Name="NotesPortable_2.3.1.paf.exe"; Url="https://portableapps.com/downloading/?a=NotesPortable&s=s&p=&d=pa&n=Notes Portable&f=NotesPortable_2.3.1.paf.exe"},
            @{Name="PDFArrangerPortable_1.12.0.paf.exe"; Url="https://portableapps.com/downloading/?a=PDFArrangerPortable&s=s&p=&d=pa&n=PDF Arranger Portable&f=PDFArrangerPortable_1.12.0.paf.exe"},
            @{Name="PDFTKBuilderPortable_4.1.8_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PDFTKBuilderPortable&s=s&p=&d=pa&n=PDFTK Builder Enhanced Portable&f=PDFTKBuilderPortable_4.1.8_English.paf.exe"},
            @{Name="PDF-XChangeEditorPortable_10.6.0.396.paf.exe"; Url="https://portableapps.com/downloading/?a=PDF-XChangeEditorPortable&s=s&p=&d=pa&n=PDF-XChange Editor Portable&f=PDF-XChangeEditorPortable_10.6.0.396.paf.exe"},
            @{Name="PDF-XChangeViewerPortable_2.5.322.10.paf.exe"; Url="https://portableapps.com/downloading/?a=PDF-XChangeViewerPortable&s=s&p=&d=pa&n=PDF-XChange Viewer Portable&f=PDF-XChangeViewerPortable_2.5.322.10.paf.exe"},
            @{Name="PNotesPortable_9.3.0_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=PNotesPortable&s=s&p=&d=pa&n=PNotes Portable&f=PNotesPortable_9.3.0_Rev_2.paf.exe"},
            @{Name="PNotesDotNetPortable_3.8.2.paf.exe"; Url="https://portableapps.com/downloading/?a=PNotesDotNetPortable&s=s&p=&d=pa&n=PNotes.NET Portable&f=PNotesDotNetPortable_3.8.2.paf.exe"},
            @{Name="QalculatePortable_5.5.2b.paf.exe"; Url="https://portableapps.com/downloading/?a=QalculatePortable&s=s&p=&d=pa&n=Qalculate! Portable&f=QalculatePortable_5.5.2b.paf.exe"},
            @{Name="QOwnNotesPortable_25.6.0.paf.exe"; Url="https://portableapps.com/downloading/?a=QOwnNotesPortable&s=s&p=&d=pa&n=QOwnNotes Portable&f=QOwnNotesPortable_25.6.0.paf.exe"},
            @{Name="RedNotebookPortable_2.39.paf.exe"; Url="https://portableapps.com/downloading/?a=RedNotebookPortable&s=s&p=&d=pa&n=RedNotebook Portable&f=RedNotebookPortable_2.39.paf.exe"},
            @{Name="ScribusPortable_1.6.4.paf.exe"; Url="https://portableapps.com/downloading/?a=ScribusPortable&s=s&p=&d=pa&n=Scribus Portable&f=ScribusPortable_1.6.4.paf.exe"},
            @{Name="SigilPortable_2.5.0.paf.exe"; Url="https://portableapps.com/downloading/?a=SigilPortable&s=s&p=&d=pa&n=Sigil Portable&f=SigilPortable_2.5.0.paf.exe"},
            @{Name="SpeedCrunchPortable_0.12.paf.exe"; Url="https://portableapps.com/downloading/?a=SpeedCrunchPortable&s=s&p=&d=pa&n=SpeedCrunch Portable&f=SpeedCrunchPortable_0.12.paf.exe"},
            @{Name="StackNotesPortable_1.0.4.6.1.paf.exe"; Url="https://portableapps.com/downloading/?a=StackNotesPortable&s=s&p=&d=pa&n=StackNotes Portable&f=StackNotesPortable_1.0.4.6.1.paf.exe"},
            @{Name="StickiesPortable_10.2a.paf.exe"; Url="https://portableapps.com/redir2/?a=StickiesPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=StickiesPortable_10.2a.paf.exe"},
            @{Name="SumatraPDFPortable_3.5.2.paf.exe"; Url="https://portableapps.com/downloading/?a=SumatraPDFPortable&s=s&p=&d=pa&n=Sumatra PDF Portable&f=SumatraPDFPortable_3.5.2.paf.exe"},
            @{Name="TaskCoachPortable_1.4.6.1.paf.exe"; Url="https://portableapps.com/downloading/?a=TaskCoachPortable&s=s&p=&d=pa&n=Task Coach Portable&f=TaskCoachPortable_1.4.6.1.paf.exe"},
            @{Name="TheGuidePortable_2.0_Rev_3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=TheGuidePortable&s=s&p=&d=pa&n=The Guide Portable&f=TheGuidePortable_2.0_Rev_3_English.paf.exe"},
            @{Name="WinDjViewPortable_2.1.paf.exe"; Url="https://portableapps.com/downloading/?a=WinDjViewPortable&s=s&p=&d=pa&n=WinDjView Portable&f=WinDjViewPortable_2.1.paf.exe"},
            @{Name="ZettlrPortable_3.5.0.paf.exe"; Url="https://portableapps.com/downloading/?a=ZettlrPortable&s=s&p=&d=pa&n=Zettlr Portable&f=ZettlrPortable_3.5.0.paf.exe"},
            @{Name="ZoomItPortable_9.0_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=ZoomItPortable&s=s&p=&d=pa&n=ZoomIt Portable&f=ZoomItPortable_9.0_English_online.paf.exe"},
            @{Name="ZoteroPortable_7.0.15.paf.exe"; Url="https://portableapps.com/downloading/?a=ZoteroPortable&s=s&p=&d=pa&n=Zotero Portable&f=ZoteroPortable_7.0.15.paf.exe"}
        )
    }
    "14" = @{ 
        Name = "PT14"; 
        Description = "Security";
        Files = @(
            @{Name="ClamWinPortable_0.103.2.1_Rev_0.103.12_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ClamWinPortable&s=s&p=&d=pa&n=ClamWin Portable&f=ClamWinPortable_0.103.2.1_Rev_0.103.12_English.paf.exe"},
            @{Name="EmsisoftEmergencyKitPortable_2024.4.0.12347_online.paf.exe"; Url="https://portableapps.com/downloading/?a=EmsisoftEmergencyKitPortable&s=s&p=&d=pa&n=Emsisoft Emergency Kit Portable&f=EmsisoftEmergencyKitPortable_2024.4.0.12347_online.paf.exe"},
            @{Name="EraserPortable_5.8.8.2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=EraserPortable&s=s&p=&d=pa&n=Eraser Classic Portable&f=EraserPortable_5.8.8.2_English.paf.exe"},
            @{Name="EraserDotNetPortable_6.2.0.2996.paf.exe"; Url="https://portableapps.com/downloading/?a=EraserDotNetPortable&s=s&p=&d=pa&n=Eraser .Net Portable&f=EraserDotNetPortable_6.2.0.2996.paf.exe"},
            @{Name="EraserDropPortable_2.1.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=EraserDropPortable&s=s&p=&d=pa&n=EraserDrop Portable&f=EraserDropPortable_2.1.1_English.paf.exe"},
            @{Name="GPG_Plugin_Portable_2.2.45.paf.exe"; Url="https://portableapps.com/downloading/?a=GPG&s=s&p=&d=pa&n=GPG Plugin Portable&f=GPG_Plugin_Portable_2.2.45.paf.exe"},
            @{Name="HijackThisPortable_2.10.0.10.paf.exe"; Url="https://portableapps.com/downloading/?a=HijackThisPortable&s=s&p=&d=pa&n=HiJackThis Fork Portable&f=HijackThisPortable_2.10.0.10.paf.exe"},
            @{Name="KeePassPortable_1.43.paf.exe"; Url="https://portableapps.com/downloading/?a=KeePassPortable&s=s&p=&d=pa&n=KeePass Classic Password Safe Portable&f=KeePassPortable_1.43.paf.exe"},
            @{Name="KeePassProPortable_2.58.paf.exe"; Url="https://portableapps.com/downloading/?a=KeePassProPortable&s=s&p=&d=pa&n=KeePass Pro Password Safe Portable&f=KeePassProPortable_2.58.paf.exe"},
            @{Name="KeePassXCPortable_2.7.10.paf.exe"; Url="https://portableapps.com/downloading/?a=KeePassXCPortable&s=s&p=&d=pa&n=KeePassXC Portable&f=KeePassXCPortable_2.7.10.paf.exe"},
            @{Name="mssPortable_1.429.310_online.paf.exe"; Url="https://portableapps.com/downloading/?a=mssPortable&s=s&p=&d=pa&n=mssPortable&f=mssPortable_1.429.310_online.paf.exe"},
            @{Name="PasswordGorillaPortable_1.5.3.7.paf.exe"; Url="https://portableapps.com/downloading/?a=PasswordGorillaPortable&s=s&p=&d=pa&n=Password Gorilla Portable&f=PasswordGorillaPortable_1.5.3.7.paf.exe"},
            @{Name="PasswordSafePortable_3.68.0.paf.exe"; Url="https://portableapps.com/downloading/?a=PasswordSafePortable&s=s&p=&d=pa&n=Password Safe Portable&f=PasswordSafePortable_3.68.0.paf.exe"},
            @{Name="PeerBlockPortable_1.2.0.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PeerBlockPortable&s=s&p=&d=pa&n=PeerBlock Plus Portable&f=PeerBlockPortable_1.2.0.1_English.paf.exe"},
            @{Name="PWGenPortable_3.5.7.paf.exe"; Url="https://portableapps.com/downloading/?a=PWGenPortable&s=s&p=&d=pa&n=Password Tech Portable (formerly PWGen)&f=PWGenPortable_3.5.7.paf.exe"},
            @{Name="BlankAndSecurePortable_8.11.paf.exe"; Url="https://portableapps.com/downloading/?a=BlankAndSecurePortable&s=s&p=&d=pa&n=Blank And Secure Portable&f=BlankAndSecurePortable_8.11.paf.exe"},
            @{Name="SpybotPortable_2.9.85.5.paf.exe"; Url="https://portableapps.com/downloading/?a=SpybotPortable&s=s&p=&d=pa&n=Spybot - Search & Destroy Portable&f=SpybotPortable_2.9.85.5.paf.exe"},
            @{Name="TrellixStingerPortable_13.0.0.371_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=TrellixStingerPortable&s=s&p=&d=pa&n=Trellix Stinger Portable&f=TrellixStingerPortable_13.0.0.371_English_online.paf.exe"},
            @{Name="VeraCryptPortable_1.26.24.paf.exe"; Url="https://portableapps.com/downloading/?a=VeraCryptPortable&s=s&p=&d=pa&n=VeraCrypt Portable&f=VeraCryptPortable_1.26.24.paf.exe"}
        )
    }
     "15" = @{ 
        Name = "PT15"; 
        Description = "Utilities";
        Files = @(
            @{Name="PortableApps.comInstaller_3.9.1.paf.exe"; Url="https://portableapps.com/downloading/?a=PortableApps.comInstaller&s=s&p=&d=pa&n=PortableApps.com Installer&f=PortableApps.comInstaller_3.9.1.paf.exe"},
            @{Name="PortableApps.comLauncher_2.2.9.paf.exe"; Url="https://portableapps.com/downloading/?a=PortableApps.comLauncher&s=s&p=&d=pa&n=PortableApps.com Launcher&f=PortableApps.comLauncher_2.2.9.paf.exe"},
            @{Name="2XClient_12.0_build_2193.paf.exe"; Url="https://portableapps.com/downloading/?a=2XClient&s=s&p=&d=pa&n=2X Client Portable&f=2XClient_12.0_build_2193.paf.exe"},
            @{Name="7-ZipPortable_24.09.paf.exe"; Url="https://portableapps.com/downloading/?a=7-ZipPortable&s=s&p=&d=pa&n=7-Zip Portable&f=7-ZipPortable_24.09.paf.exe"},
            @{Name="7PlusTaskbarTweakerPortable_5.15.3.paf.exe"; Url="https://portableapps.com/downloading/?a=7PlusTaskbarTweakerPortable&s=s&p=&d=pa&n=7+ Taskbar Tweaker Portable&f=7PlusTaskbarTweakerPortable_5.15.3.paf.exe"},
            @{Name="AngryIPScannerPortable_3.9.1.paf.exe"; Url="https://portableapps.com/downloading/?a=AngryIPScannerPortable&s=s&p=&d=pa&n=Angry IP Scanner Portable&f=AngryIPScannerPortable_3.9.1.paf.exe"},
            @{Name="AntRenamerPortable_2.13.0.paf.exe"; Url="https://portableapps.com/downloading/?a=AntRenamerPortable&s=s&p=&d=pa&n=Ant Renamer Portable&f=AntRenamerPortable_2.13.0.paf.exe"},
            @{Name="AquaSnapPortable_1.24.1.paf.exe"; Url="https://portableapps.com/downloading/?a=AquaSnapPortable&s=s&p=&d=pa&n=AquaSnap Portable&f=AquaSnapPortable_1.24.1.paf.exe"},
            @{Name="AttributeChangerPortable_11.40a.paf.exe"; Url="https://portableapps.com/downloading/?a=AttributeChangerPortable&s=s&p=&d=pa&n=Attribute Changer Portable&f=AttributeChangerPortable_11.40a.paf.exe"},
            @{Name="AutorunsPortable_14.11_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=AutorunsPortable&s=s&p=&d=pa&n=Autoruns Portable&f=AutorunsPortable_14.11_English_online.paf.exe"},
            @{Name="BabelMapPortable_16.0.0.6_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=BabelMapPortable&s=s&p=&d=pa&n=BabelMap Portable&f=BabelMapPortable_16.0.0.6_English_online.paf.exe"},
            @{Name="balenaEtcherPortable_2.1.2.paf.exe"; Url="https://portableapps.com/downloading/?a=balenaEtcherPortable&s=s&p=&d=pa&n=balenaEtcher Portable&f=balenaEtcherPortable_2.1.2.paf.exe"},
            @{Name="BleachBitPortable_5.0.0.paf.exe"; Url="https://portableapps.com/downloading/?a=BleachBitPortable&s=s&p=&d=pa&n=BleachBit Portable&f=BleachBitPortable_5.0.0.paf.exe"},
            @{Name="BOINCPortable_8.0.2.paf.exe"; Url="https://portableapps.com/downloading/?a=BOINCPortable&s=s&p=&d=pa&n=BOINC Portable&f=BOINCPortable_8.0.2.paf.exe"},
            @{Name="CamStudioPortable_2.7.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=CamStudioPortable&s=s&p=&d=pa&n=CamStudio Portable&f=CamStudioPortable_2.7.4_English.paf.exe"},
            @{Name="Capture2TextPortable_4.6.3.paf.exe"; Url="https://portableapps.com/downloading/?a=Capture2TextPortable&s=s&p=&d=pa&n=Capture2Text Portable&f=Capture2TextPortable_4.6.3.paf.exe"},
            @{Name="ccPortable_6.36.11508_online.paf.exe"; Url="https://portableapps.com/downloading/?a=ccPortable&s=s&p=&d=pa&n=ccPortable&f=ccPortable_6.36.11508_online.paf.exe"},
            @{Name="ChecksumControlPortable_2.4.4.paf.exe"; Url="https://portableapps.com/downloading/?a=ChecksumControlPortable&s=s&p=&d=pa&n=Checksum Control Portable&f=ChecksumControlPortable_2.4.4.paf.exe"},
            @{Name="ClickyGonePortable_1.4.4.1_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ClickyGonePortable&s=s&p=&d=pa&n=Clicky Gone Portable&f=ClickyGonePortable_1.4.4.1_Rev_2_English.paf.exe"},
            @{Name="ColourContrastAnalyserPortable_3.5.4.paf.exe"; Url="https://portableapps.com/downloading/?a=ColourContrastAnalyserPortable&s=s&p=&d=pa&n=Colour Contrast Analyser Portable&f=ColourContrastAnalyserPortable_3.5.4.paf.exe"},
            @{Name="CommandPromptPortable_2.6.paf.exe"; Url="https://portableapps.com/downloading/?a=CommandPromptPortable&s=s&p=&d=pa&n=Command Prompt Portable&f=CommandPromptPortable_2.6.paf.exe"},
            @{Name="ConsolePortable_2.00_b148_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ConsolePortable&s=s&p=&d=pa&n=Console Portable&f=ConsolePortable_2.00_b148_Rev_2_English.paf.exe"},
            @{Name="ControlPadPortable_0.72_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ControlPadPortable&s=s&p=&d=pa&n=ControlPad Portable&f=ControlPadPortable_0.72_English.paf.exe"},
            @{Name="ConverberPortable_2.3.1_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=ConverberPortable&s=s&p=&d=pa&n=Converber Portable&f=ConverberPortable_2.3.1_Rev_2.paf.exe"},
            @{Name="ConvertAllPortable_1.0.1.paf.exe"; Url="https://portableapps.com/downloading/?a=ConvertAllPortable&s=s&p=&d=pa&n=ConvertAll Portable&f=ConvertAllPortable_1.0.1.paf.exe"},
            @{Name="CookTimerPortable_0.9.5_English.paf.exe"; Url="https://portableapps.com/downloading/?a=CookTimerPortable&s=s&p=&d=pa&n=Cook Timer Portable&f=CookTimerPortable_0.9.5_English.paf.exe"},
            @{Name="CopyQPortable_10.0.0.paf.exe"; Url="https://portableapps.com/downloading/?a=CopyQPortable&s=s&p=&d=pa&n=CopyQ Portable&f=CopyQPortable_10.0.0.paf.exe"},
            @{Name="CPU-ZPortable_2.15_English.paf.exe"; Url="https://portableapps.com/downloading/?a=CPU-ZPortable&s=s&p=&d=pa&n=CPU-Z Portable&f=CPU-ZPortable_2.15_English.paf.exe"},
            @{Name="CpuFrequenzPortable_4.44.paf.exe"; Url="https://portableapps.com/downloading/?a=CpuFrequenzPortable&s=s&p=&d=pa&n=CpuFrequenz Portable&f=CpuFrequenzPortable_4.44.paf.exe"},
            @{Name="CrystalDiskInfoPortable_9.6.3.paf.exe"; Url="https://portableapps.com/downloading/?a=CrystalDiskInfoPortable&s=s&p=&d=pa&n=CrystalDiskInfo Portable&f=CrystalDiskInfoPortable_9.6.3.paf.exe"},
            @{Name="CrystalDiskMarkPortable_8.0.6.paf.exe"; Url="https://portableapps.com/downloading/?a=CrystalDiskMarkPortable&s=s&p=&d=pa&n=CrystalDiskMark Portable&f=CrystalDiskMarkPortable_8.0.6.paf.exe"},
            @{Name="CrystalMarkRetroPortable_2.0.3.paf.exe"; Url="https://portableapps.com/downloading/?a=CrystalMarkRetroPortable&s=s&p=&d=pa&n=CrystalMark Retro Portable&f=CrystalMarkRetroPortable_2.0.3.paf.exe"},
            @{Name="CubicExplorerPortable_0.95.1_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=CubicExplorerPortable&s=s&p=&d=pa&n=CubicExplorer Portable&f=CubicExplorerPortable_0.95.1_Rev_2.paf.exe"},
            @{Name="DaphnePortable_2.04.paf.exe"; Url="https://portableapps.com/downloading/?a=DaphnePortable&s=s&p=&d=pa&n=Daphne Portable&f=DaphnePortable_2.04.paf.exe"},
            @{Name="DebugViewPortable_4.90_Release_2_Rev_2_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=DebugViewPortable&s=s&p=&d=pa&n=DebugView Portable&f=DebugViewPortable_4.90_Release_2_Rev_2_English_online.paf.exe"},
            @{Name="DesktopSnowOKPortable_6.51.paf.exe"; Url="https://portableapps.com/downloading/?a=DesktopSnowOKPortable&s=s&p=&d=pa&n=DesktopSnowOK Portable&f=DesktopSnowOKPortable_6.51.paf.exe"},
            @{Name="DetectItEasyPortable_3.10.paf.exe"; Url="https://portableapps.com/downloading/?a=DetectItEasyPortable&s=s&p=&d=pa&n=Detect It Easy Portable&f=DetectItEasyPortable_3.10.paf.exe"},
            @{Name="dfgPortable_2.22.33_Upd1_Rev_2_online.paf.exe"; Url="https://portableapps.com/downloading/?a=dfgPortable&s=s&p=&d=pa&n=dfgPortable&f=dfgPortable_2.22.33_Upd1_Rev_2_online.paf.exe"},
            @{Name="DiffpdfPortable_2.1.3.paf.exe"; Url="https://portableapps.com/downloading/?a=DiffpdfPortable&s=s&p=&d=pa&n=Diffpdf Portable&f=DiffpdfPortable_2.1.3.paf.exe"},
            @{Name="DiskCleanerPortable_1.7.1645_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=DiskCleanerPortable&s=s&p=&d=pa&n=Disk Cleaner Portable&f=DiskCleanerPortable_1.7.1645_Rev_2_English.paf.exe"},
            @{Name="DiskMonPortable_2.02_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=DiskMonPortable&s=s&p=&d=pa&n=DiskMon Portable&f=DiskMonPortable_2.02_English_online.paf.exe"},
            @{Name="DittoPortable_3.24.246.paf.exe"; Url="https://portableapps.com/downloading/?a=DittoPortable&s=s&p=&d=pa&n=Ditto Portable&f=DittoPortable_3.24.246.paf.exe"},
            @{Name="DM2Portable_1.23.1.1.paf.exe"; Url="https://portableapps.com/downloading/?a=DM2Portable&s=s&p=&d=pa&n=DM2 Portable&f=DM2Portable_1.23.1.1.paf.exe"},
            @{Name="DontPanicPortable_3.1.0.paf.exe"; Url="https://portableapps.com/downloading/?a=DontPanicPortable&s=s&p=&d=pa&n=Don't Panic Portable&f=DontPanicPortable_3.1.0.paf.exe"},
            @{Name="DontSleepPortable_9.73.paf.exe"; Url="https://portableapps.com/downloading/?a=DontSleepPortable&s=s&p=&d=pa&n=Don't Sleep Portable&f=DontSleepPortable_9.73.paf.exe"},
            @{Name="dotNETInspectorPortable_1.5.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=dotNETInspectorPortable&s=s&p=&d=pa&n=dotNETInspector Portable (Discontinued)&f=dotNETInspectorPortable_1.5.0_English.paf.exe"},
            @{Name="DTaskManagerPortable_1.57.31.paf.exe"; Url="https://portableapps.com/downloading/?a=DTaskManagerPortable&s=s&p=&d=pa&n=DTaskManager Portable&f=DTaskManagerPortable_1.57.31.paf.exe"},
            @{Name="DUMoPortable_2.25.4.125_Discontinued.paf.exe"; Url="https://portableapps.com/downloading/?a=DUMoPortable&s=s&p=&d=pa&n=DUMo Portable (Discontinued)&f=DUMoPortable_2.25.4.125_Discontinued.paf.exe"},
            @{Name="DSynchronizePortable_2.48.172.paf.exe"; Url="https://portableapps.com/downloading/?a=DSynchronizePortable&s=s&p=&d=pa&n=DSynchronize Portable&f=DSynchronizePortable_2.48.172.paf.exe"},
            @{Name="DuplicateFilesFinderPortable_0.8.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=DuplicateFilesFinderPortable&s=s&p=&d=pa&n=Duplicate Files Finder Portable&f=DuplicateFilesFinderPortable_0.8.0_English.paf.exe"},
            @{Name="DynDNSSimplyClientPortable_2.0.0.2_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=DynDNSSimplyClientPortable&s=s&p=&d=pa&n=DynDNS Simply Client Portable&f=DynDNSSimplyClientPortable_2.0.0.2_Rev_2.paf.exe"},
            @{Name="EverythingPortable_1.4.1.1027.paf.exe"; Url="https://portableapps.com/downloading/?a=EverythingPortable&s=s&p=&d=pa&n=Everything Portable&f=EverythingPortable_1.4.1.1027.paf.exe"},
            @{Name="ExplorerPlusPlusPortable_1.4.0.paf.exe"; Url="https://portableapps.com/downloading/?a=Explorer%2B%2BPortable&s=s&p=&d=pa&n=Explorer++ Portable&f=ExplorerPlusPlusPortable_1.4.0.paf.exe"},
            @{Name="fcpyPortable_5.9.0_online.paf.exe"; Url="https://portableapps.com/downloading/?a=fcpyPortable&s=s&p=&d=pa&n=fcpyPortable&f=fcpyPortable_5.9.0_online.paf.exe"},
            @{Name="FileAlyzerPortable_2.0.5.57_English.paf.exe"; Url="https://portableapps.com/downloading/?a=FileAlyzerPortable&s=s&p=&d=pa&n=FileAlyzer Portable&f=FileAlyzerPortable_2.0.5.57_English.paf.exe"},
            @{Name="FileOptimizerPortable_16.90.2829.paf.exe"; Url="https://portableapps.com/downloading/?a=FileOptimizerPortable&s=s&p=&d=pa&n=FileOptimizer Portable&f=FileOptimizerPortable_16.90.2829.paf.exe"},
            @{Name="FileVoyagerPortable_25.2.4.0.paf.exe"; Url="https://portableapps.com/downloading/?a=FileVoyagerPortable&s=s&p=&d=pa&n=FileVoyager Portable&f=FileVoyagerPortable_25.2.4.0.paf.exe"},
            @{Name="FoldingAtHomePortable_8.4.9.paf.exe"; Url="https://portableapps.com/downloading/?a=FoldingAtHomePortable&s=s&p=&d=pa&n=Folding@home Portable&f=FoldingAtHomePortable_8.4.9.paf.exe"},
            @{Name="FontForgePortable_2023-01-01.paf.exe"; Url="https://portableapps.com/downloading/?a=FontForgePortable&s=s&p=&d=pa&n=FontForge Portable&f=FontForgePortable_2023-01-01.paf.exe"},
            @{Name="FontViewOKPortable_8.91.paf.exe"; Url="https://portableapps.com/downloading/?a=FontViewOKPortable&s=s&p=&d=pa&n=FontViewOK Portable&f=FontViewOKPortable_8.91.paf.exe"},
            @{Name="FreeCommanderPortable_2025_Build_921.paf.exe"; Url="https://portableapps.com/redir2/?a=FreeCommanderPortable&s=s&p=https://freecommander.com/downloads/&d=pb&f=FreeCommanderPortable_2025_Build_921.paf.exe"},
            @{Name="FreeFileSyncPortable_6.2.paf.exe"; Url="https://portableapps.com/downloading/?a=FreeFileSyncPortable&s=s&p=&d=pa&n=FreeFileSync Portable&f=FreeFileSyncPortable_6.2.paf.exe"},
            @{Name="FreeUPXPortable_3.2.paf.exe"; Url="https://portableapps.com/downloading/?a=FreeUPXPortable&s=s&p=&d=pa&n=FUPX Portable&f=FreeUPXPortable_3.2.paf.exe"},
            @{Name="GeekUninstallerPortable_1.5.2.165.paf.exe"; Url="https://portableapps.com/downloading/?a=GeekUninstallerPortable&s=s&p=&d=pa&n=GeekUninstaller Portable&f=GeekUninstallerPortable_1.5.2.165.paf.exe"},
            @{Name="GhostscriptPortable_10.05.1.paf.exe"; Url="https://portableapps.com/downloading/?a=Ghostscript&s=s&p=&d=pa&n=Ghostscript Portable&f=GhostscriptPortable_10.05.1.paf.exe"},
            @{Name="GPU-ZPortable_2.66.0.paf.exe"; Url="https://portableapps.com/downloading/?a=GPU-ZPortable&s=s&p=&d=pa&n=GPU-Z Portable&f=GPU-ZPortable_2.66.0.paf.exe"},
            @{Name="grepWinPortable_2.1.8.paf.exe"; Url="https://portableapps.com/downloading/?a=grepWinPortable&s=s&p=&d=pa&n=grepWin Portable&f=grepWinPortable_2.1.8.paf.exe"},
            @{Name="GridyPortable_0.70_English.paf.exe"; Url="https://portableapps.com/downloading/?a=GridyPortable&s=s&p=&d=pa&n=Gridy Portable&f=GridyPortable_0.70_English.paf.exe"},
            @{Name="HDHackerPortable_1.6.5.paf.exe"; Url="https://portableapps.com/downloading/?a=HDHackerPortable&s=s&p=&d=pa&n=HDHacker Portable&f=HDHackerPortable_1.6.5.paf.exe"},
            @{Name="HWiNFOPortable_8.26.5730_English.paf.exe"; Url="https://portableapps.com/downloading/?a=HWiNFOPortable&s=s&p=&d=pa&n=HWiNFO 32+64 Portable&f=HWiNFOPortable_8.26.5730_English.paf.exe"},
            @{Name="HWMonitorPortable_1.57_English.paf.exe"; Url="https://portableapps.com/downloading/?a=HWMonitorPortable&s=s&p=&d=pa&n=HWMonitor Portable&f=HWMonitorPortable_1.57_English.paf.exe"},
            @{Name="IObitUninstallerPortable_7.5.0.7.paf.exe"; Url="https://portableapps.com/downloading/?a=IObitUninstallerPortable&s=s&p=&d=pa&n=IObit Uninstaller Portable&f=IObitUninstallerPortable_7.5.0.7.paf.exe"},
            @{Name="IObitUnlockerPortable_1.3.paf.exe"; Url="https://portableapps.com/redir2/?a=IObitUnlockerPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=IObitUnlockerPortable_1.3.paf.exe"},
            @{Name="jdkPortable_8_Update_451_online.paf.exe"; Url="https://portableapps.com/downloading/?a=JDK&s=s&p=&d=pa&n=jdkPortable 32-bit&f=jdkPortable_8_Update_451_online.paf.exe"},
            @{Name="JkDefragPortable_3.36_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=JkDefragPortable&s=s&p=&d=pa&n=JkDefrag Portable&f=JkDefragPortable_3.36_Rev_2.paf.exe"},
            @{Name="jPortable_8_Update_451_online.paf.exe"; Url="https://portableapps.com/downloading/?a=Java&s=s&p=&d=pa&n=jPortable&f=jPortable_8_Update_451_online.paf.exe"},
            @{Name="JavaPortableLauncher_6.0.paf.exe"; Url="https://portableapps.com/downloading/?a=JavaPortableLauncher&s=s&p=&d=pa&n=jPortable Launcher&f=JavaPortableLauncher_6.0.paf.exe"},
            @{Name="KCleanerPortable_3.8.6.116.paf.exe"; Url="https://portableapps.com/downloading/?a=KCleanerPortable&s=s&p=&d=pa&n=KCleaner Portable&f=KCleanerPortable_3.8.6.116.paf.exe"},
            @{Name="LightscreenPortable_2.5_English.paf.exe"; Url="https://portableapps.com/downloading/?a=LightscreenPortable&s=s&p=&d=pa&n=Lightscreen Portable&f=LightscreenPortable_2.5_English.paf.exe"},
            @{Name="ListaryPortable_6.3.2.88.paf.exe"; Url="https://portableapps.com/downloading/?a=ListaryPortable&s=s&p=&d=pa&n=Listary Portable&f=ListaryPortable_6.3.2.88.paf.exe"},
            @{Name="OpenJDK_17.0.15-6.paf.exe"; Url="https://portableapps.com/downloading/?a=OpenJDK&s=s&p=&d=pa&n=OpenJDK Temurin Portable Legacy 17&f=OpenJDK_17.0.15-6.paf.exe"},
            @{Name="PCI-ZPortable_2.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PCI-ZPortable&s=s&p=&d=pa&n=PCI-Z Portable&f=PCI-ZPortable_2.0_English.paf.exe"},
            @{Name="PeaZipPortable_10.4.0.paf.exe"; Url="https://portableapps.com/downloading/?a=PeaZipPortable&s=s&p=&d=pa&n=PeaZip Portable&f=PeaZipPortable_10.4.0.paf.exe"},
            @{Name="PortableApps.comAppCompactor_3.9_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PortableApps.comAppCompactor&s=s&p=&d=pa&n=PortableApps.com AppCompactor&f=PortableApps.comAppCompactor_3.9_English.paf.exe"},
            @{Name="PortExpertPortable_1.8.4.23_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PortExpertPortable&s=s&p=&d=pa&n=PortExpert Portable&f=PortExpertPortable_1.8.4.23_English.paf.exe"},
            @{Name="PrivaZerPortable_4.0.105.paf.exe"; Url="https://portableapps.com/downloading/?a=PrivaZerPortable&s=s&p=&d=pa&n=PrivaZer Portable&f=PrivaZerPortable_4.0.105.paf.exe"},
            @{Name="ProcessExplorerPortable_17.06_online.paf.exe"; Url="https://portableapps.com/downloading/?a=ProcessExplorerPortable&s=s&p=&d=pa&n=Process Explorer Portable&f=ProcessExplorerPortable_17.06_online.paf.exe"},
            @{Name="ProcessHackerPortable_2.39_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ProcessHackerPortable&s=s&p=&d=pa&n=Process Hacker Portable&f=ProcessHackerPortable_2.39_English.paf.exe"},
            @{Name="ProcessKOPortable_6.46.paf.exe"; Url="https://portableapps.com/downloading/?a=ProcessKOPortable&s=s&p=&d=pa&n=ProcessKO Portable&f=ProcessKOPortable_6.46.paf.exe"},
            @{Name="ProcessMonitorPortable_4.01_online.paf.exe"; Url="https://portableapps.com/downloading/?a=ProcessMonitorPortable&s=s&p=&d=pa&n=Process Monitor Portable&f=ProcessMonitorPortable_4.01_online.paf.exe"},
            @{Name="Q-DirPortable_12.22.paf.exe"; Url="https://portableapps.com/downloading/?a=Q-DirPortable&s=s&p=&d=pa&n=Q-Dir Portable&f=Q-DirPortable_12.22.paf.exe"},
            @{Name="QuickMemoryTestOKPortable_5.11.paf.exe"; Url="https://portableapps.com/downloading/?a=QuickMemoryTestOKPortable&s=s&p=&d=pa&n=QuickMemoryTestOK Portable&f=QuickMemoryTestOKPortable_5.11.paf.exe"},
            @{Name="QwikMarkPortable_0.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=QwikMarkPortable&s=s&p=&d=pa&n=QwikMark Portable&f=QwikMarkPortable_0.4_English.paf.exe"},
            @{Name="RAMMapPortable_1.61_Rev_2_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=RAMMapPortable&s=s&p=&d=pa&n=RAMMap Portable&f=RAMMapPortable_1.61_Rev_2_English_online.paf.exe"},
            @{Name="RapidCRCUnicodePortable_0.3.40_English.paf.exe"; Url="https://portableapps.com/downloading/?a=RapidCRCUnicodePortable&s=s&p=&d=pa&n=Rapid CRC Unicode Portable&f=RapidCRCUnicodePortable_0.3.40_English.paf.exe"},
            @{Name="RBTrayPortable_4.14_English.paf.exe"; Url="https://portableapps.com/downloading/?a=RBTrayPortable&s=s&p=&d=pa&n=RBTray Portable&f=RBTrayPortable_4.14_English.paf.exe"},
            @{Name="rcvPortable_1.54.120_online.paf.exe"; Url="https://portableapps.com/downloading/?a=rcvPortable&s=s&p=&d=pa&n=rcvPortable&f=rcvPortable_1.54.120_online.paf.exe"},
            @{Name="RegAlyzerPortable_1.6.2.16.paf.exe"; Url="https://portableapps.com/downloading/?a=RegAlyzerPortable&s=s&p=&d=pa&n=RegAlyzer Portable&f=RegAlyzerPortable_1.6.2.16.paf.exe"},
            @{Name="RegshotPortable_1.9.0.paf.exe"; Url="https://portableapps.com/downloading/?a=RegshotPortable&s=s&p=&d=pa&n=Regshot Portable&f=RegshotPortable_1.9.0.paf.exe"},
            @{Name="ReNamerPortable_7.7.paf.exe"; Url="https://portableapps.com/downloading/?a=ReNamerPortable&s=s&p=&d=pa&n=ReNamer Portable&f=ReNamerPortable_7.7.paf.exe"},
            @{Name="ResourceHackerPortable_5.2.8_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ResourceHackerPortable&s=s&p=&d=pa&n=Resource Hacker Portable&f=ResourceHackerPortable_5.2.8_English.paf.exe"},
            @{Name="RevoUninstallerPortable_2.5.8.paf.exe"; Url="https://portableapps.com/downloading/?a=RevoUninstallerPortable&s=s&p=&d=pa&n=Revo Uninstaller Portable&f=RevoUninstallerPortable_2.5.8.paf.exe"},
            @{Name="RisohEditorPortable_5.8.8.paf.exe"; Url="https://portableapps.com/downloading/?a=RisohEditorPortable&s=s&p=&d=pa&n=RisohEditor Portable&f=RisohEditorPortable_5.8.8.paf.exe"},
            @{Name="RufusPortable_4.7.paf.exe"; Url="https://portableapps.com/downloading/?a=RufusPortable&s=s&p=&d=pa&n=Rufus Portable&f=RufusPortable_4.7.paf.exe"},
            @{Name="Run-CommandPortable_6.23.paf.exe"; Url="https://portableapps.com/downloading/?a=Run-CommandPortable&s=s&p=&d=pa&n=Run-Command Portable&f=Run-CommandPortable_6.23.paf.exe"},
            @{Name="ShortcutsSearchAndReplacePortable_2.6.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ShortcutsSearchAndReplacePortable&s=s&p=&d=pa&n=Shortcuts Search And Replace Portable&f=ShortcutsSearchAndReplacePortable_2.6.1_English.paf.exe"},
            @{Name="SIWPortable_2011.10.29.paf.exe"; Url="https://portableapps.com/downloading/?a=SIWPortable&s=s&p=&d=pa&n=SIW (System Information for Windows) Portable (Discontinued)&f=SIWPortable_2011.10.29.paf.exe"},
            @{Name="SmartDefragPortable_10.4.0.441.paf.exe"; Url="https://portableapps.com/redir2/?a=SmartDefragPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=SmartDefragPortable_10.4.0.441.paf.exe"},
            @{Name="SnapTimerPortable_0.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SnapTimerPortable&s=s&p=&d=pa&n=SnapTimer Portable&f=SnapTimerPortable_0.1_English.paf.exe"},
            @{Name="specPortable_1.33.0.75_Rev_3_online.paf.exe"; Url="https://portableapps.com/downloading/?a=specPortable&s=s&p=&d=pa&n=specPortable&f=specPortable_1.33.0.75_Rev_3_online.paf.exe"},
            @{Name="SpeedyFoxPortable_2.0.30_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SpeedyFoxPortable&s=s&p=&d=pa&n=SpeedyFox Portable&f=SpeedyFoxPortable_2.0.30_Rev_2_English.paf.exe"},
            @{Name="SSD-ZPortable_16.09.09b_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SSD-ZPortable&s=s&p=&d=pa&n=SSD-Z Portable&f=SSD-ZPortable_16.09.09b_English.paf.exe"},
            @{Name="StartupSentinelPortable_1.9.0.28_English.paf.exe"; Url="https://portableapps.com/downloading/?a=StartupSentinelPortable&s=s&p=&d=pa&n=Startup Sentinel Portable&f=StartupSentinelPortable_1.9.0.28_English.paf.exe"},
            @{Name="SUMoPortable_5.17.10.542_Discontinued_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SUMoPortable&s=s&p=&d=pa&n=SUMo Portable (Discontinued)&f=SUMoPortable_5.17.10.542_Discontinued_English.paf.exe"},
            @{Name="SynkronPortable_1.6.2_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=SynkronPortable&s=s&p=&d=pa&n=Synkron Portable&f=SynkronPortable_1.6.2_Rev_2.paf.exe"},
            @{Name="SystemExplorerPortable_7.1.0.paf.exe"; Url="https://portableapps.com/downloading/?a=SystemExplorerPortable&s=s&p=&d=pa&n=System Explorer Portable&f=SystemExplorerPortable_7.1.0.paf.exe"},
            @{Name="SystemInformerPortable_3.2.25011_English.paf.exe"; Url="https://portableapps.com/downloading/?a=SystemInformerPortable&s=s&p=&d=pa&n=System Informer Portable&f=SystemInformerPortable_3.2.25011_English.paf.exe"},
            @{Name="TCPViewPortable_4.19_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=TCPViewPortable&s=s&p=&d=pa&n=TCPView Portable&f=TCPViewPortable_4.19_English_online.paf.exe"},
            @{Name="TeamViewerPortable_15.66.4.paf.exe"; Url="https://portableapps.com/downloading/?a=TeamViewerPortable&s=s&p=&d=pa&n=TeamViewer Portable&f=TeamViewerPortable_15.66.4.paf.exe"},
            @{Name="TexterPortable_0.6_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=TexterPortable&s=s&p=&d=pa&n=Texter Portable&f=TexterPortable_0.6_Rev_2_English.paf.exe"},
            @{Name="TextifyPortable_1.10.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=TextifyPortable&s=s&p=&d=pa&n=Textify Portable&f=TextifyPortable_1.10.4_English.paf.exe"},
            @{Name="TinyTaskPortable_1.77_English.paf.exe"; Url="https://portableapps.com/redir2/?a=TinyTaskPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=TinyTaskPortable_1.77_English.paf.exe"},
            @{Name="Toucan_3.1.8.2.paf.exe"; Url="https://portableapps.com/downloading/?a=Toucan&s=s&p=&d=pa&n=Toucan&f=Toucan_3.1.8.2.paf.exe"},
            @{Name="TreeSizeFreePortable_4.7.3_Rev_2.paf.exe"; Url="https://portableapps.com/downloading/?a=TreeSizeFreePortable&s=s&p=&d=pa&n=TreeSize Free Portable&f=TreeSizeFreePortable_4.7.3_Rev_2.paf.exe"},
            @{Name="TyperTaskPortable_1.20_Rev_3_English.paf.exe"; Url="https://portableapps.com/downloading/?a=TyperTaskPortable&s=s&p=&d=pa&n=TyperTask Portable&f=TyperTaskPortable_1.20_Rev_3_English.paf.exe"},
            @{Name="UNetbootinPortable_702.paf.exe"; Url="https://portableapps.com/downloading/?a=UNetbootinPortable&s=s&p=&d=pa&n=UNetbootin Portable&f=UNetbootinPortable_702.paf.exe"},
            @{Name="UnicodiaPortable_2.11.5.paf.exe"; Url="https://portableapps.com/downloading/?a=UnicodiaPortable&s=s&p=&d=pa&n=Unicodia Portable&f=UnicodiaPortable_2.11.5.paf.exe"},
            @{Name="UltraDefragPortable_7.1.4.paf.exe"; Url="https://portableapps.com/downloading/?a=UltraDefragPortable&s=s&p=&d=pa&n=UltraDefrag Portable&f=UltraDefragPortable_7.1.4.paf.exe"},
            @{Name="UUID-GUIDGeneratorPortable_3.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=UUID-GUIDGeneratorPortable&s=s&p=&d=pa&n=UUID-GUID Generator Portable&f=UUID-GUIDGeneratorPortable_3.0_English.paf.exe"},
            @{Name="VentoyPortable_1.1.05.paf.exe"; Url="https://portableapps.com/downloading/?a=VentoyPortable&s=s&p=&d=pa&n=Ventoy Portable&f=VentoyPortable_1.1.05.paf.exe"},
            @{Name="VirtualVolumesViewPortable_1.5.paf.exe"; Url="https://portableapps.com/downloading/?a=VirtualVolumesViewPortable&s=s&p=&d=pa&n=Virtual Volumes View Portable&f=VirtualVolumesViewPortable_1.5.paf.exe"},
            @{Name="VirtuaWinPortable_4.5_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=VirtuaWinPortable&s=s&p=&d=pa&n=VirtuaWin Portable&f=VirtuaWinPortable_4.5_Rev_2_English.paf.exe"},
            @{Name="VMMapPortable_3.40_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=VMMapPortable&s=s&p=&d=pa&n=VMMap Portable&f=VMMapPortable_3.40_English_online.paf.exe"},
            @{Name="WhatChangedPortable_1.07_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WhatChangedPortable&s=s&p=&d=pa&n=WhatChanged Portable&f=WhatChangedPortable_1.07_Rev_2_English.paf.exe"},
            @{Name="WhoDatPortable_0.9.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WhoDatPortable&s=s&p=&d=pa&n=WhoDat Portable&f=WhoDatPortable_0.9.1_English.paf.exe"},
            @{Name="WhyNotWin11Portable_2.6.0.0.paf.exe"; Url="https://portableapps.com/redir2/?a=WhyNotWin11Portable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=WhyNotWin11Portable_2.6.0.0.paf.exe"},
            @{Name="WinCDEmuPortable_4.0.paf.exe"; Url="https://portableapps.com/downloading/?a=WinCDEmuPortable&s=s&p=&d=pa&n=WinCDEmu Portable&f=WinCDEmuPortable_4.0.paf.exe"},
            @{Name="WinContigPortable_5.0.2.1.paf.exe"; Url="https://portableapps.com/downloading/?a=WinContigPortable&s=s&p=&d=pa&n=WinContig Portable&f=WinContigPortable_5.0.2.1.paf.exe"},
            @{Name="WinDirStatPortable_2.2.2.paf.exe"; Url="https://portableapps.com/downloading/?a=WinDirStatPortable&s=s&p=&d=pa&n=WinDirStat Portable&f=WinDirStatPortable_2.2.2.paf.exe"},
            @{Name="WindowsErrorLookupToolPortable_3.0.7_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WindowsErrorLookupToolPortable&s=s&p=&d=pa&n=Windows Error Lookup Tool Portable&f=WindowsErrorLookupToolPortable_3.0.7_English.paf.exe"},
            @{Name="WinFilePortable_10.3.paf.exe"; Url="https://portableapps.com/downloading/?a=WinFilePortable&s=s&p=&d=pa&n=WinFile Portable&f=WinFilePortable_10.3.paf.exe"},
            @{Name="winMd5SumPortable_1.0.1.55_Rev_4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=winMd5SumPortable&s=s&p=&d=pa&n=winMd5Sum Portable&f=winMd5SumPortable_1.0.1.55_Rev_4_English.paf.exe"},
            @{Name="WinMTRPortable_0.92_Rev_2_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WinMTRPortable&s=s&p=&d=pa&n=WinMTR Portable&f=WinMTRPortable_0.92_Rev_2_English.paf.exe"},
            @{Name="WinMergePortable_2.16.48.2.paf.exe"; Url="https://portableapps.com/downloading/?a=WinMergePortable&s=s&p=&d=pa&n=WinMerge Portable&f=WinMergePortable_2.16.48.2.paf.exe"},
            @{Name="WinMerge2011Portable_2011.211.170.paf.exe"; Url="https://portableapps.com/downloading/?a=WinMerge2011Portable&s=s&p=&d=pa&n=WinMerge 2011 Portable&f=WinMerge2011Portable_2011.211.170.paf.exe"},
            @{Name="WinObjPortable_3.14_Rev_2_English_online.paf.exe"; Url="https://portableapps.com/downloading/?a=WinObjPortable&s=s&p=&d=pa&n=WinObj Portable&f=WinObjPortable_3.14_Rev_2_English_online.paf.exe"},
            @{Name="WinPenguinsPortable_0.76_English.paf.exe"; Url="https://portableapps.com/downloading/?a=WinPenguinsPortable&s=s&p=&d=pa&n=WinPenguins Portable&f=WinPenguinsPortable_0.76_English.paf.exe"},
            @{Name="WiseDataRecoveryPortable_6.2.0.paf.exe"; Url="https://portableapps.com/downloading/?a=WiseDataRecoveryPortable&s=s&p=&d=pa&n=Wise Data Recovery Portable&f=WiseDataRecoveryPortable_6.2.0.paf.exe"},
            @{Name="WiseDiskCleanerPortable_11.2.3.paf.exe"; Url="https://portableapps.com/downloading/?a=WiseDiskCleanerPortable&s=s&p=&d=pa&n=Wise Disk Cleaner Portable&f=WiseDiskCleanerPortable_11.2.3.paf.exe"},
            @{Name="WiseDuplicateFinderPortable_2.1.7.paf.exe"; Url="https://portableapps.com/downloading/?a=WiseDuplicateFinderPortable&s=s&p=&d=pa&n=Wise Duplicate Finder Portable&f=WiseDuplicateFinderPortable_2.1.7.paf.exe"},
            @{Name="WiseForceDeleterPortable_1.5.6.58.paf.exe"; Url="https://portableapps.com/redir2/?a=WiseForceDeleterPortable&s=s&p=https://github.com/PortableApps/Downloads/releases/tag/download?&d=pb&f=WiseForceDeleterPortable_1.5.6.58.paf.exe"},
            @{Name="WiseJetSearchPortable_4.1.4.219.paf.exe"; Url="https://portableapps.com/downloading/?a=WiseJetSearchPortable&s=s&p=&d=pa&n=Wise JetSearch Portable&f=WiseJetSearchPortable_4.1.4.219.paf.exe"},
            @{Name="WiseProgramUninstallerPortable_3.2.3.paf.exe"; Url="https://portableapps.com/downloading/?a=WiseProgramUninstallerPortable&s=s&p=&d=pa&n=Wise Program Uninstaller Portable&f=WiseProgramUninstallerPortable_3.2.3.paf.exe"},
            @{Name="WiseRegistryCleanerPortable_11.1.10.paf.exe"; Url="https://portableapps.com/downloading/?a=WiseRegistryCleanerPortable&s=s&p=&d=pa&n=Wise Registry Cleaner Portable&f=WiseRegistryCleanerPortable_11.1.10.paf.exe"},
            @{Name="WizFilePortable_3.13.paf.exe"; Url="https://portableapps.com/downloading/?a=WizFilePortable&s=s&p=&d=pa&n=WizFile Portable&f=WizFilePortable_3.13.paf.exe"},
            @{Name="WizTreePortable_4.25.paf.exe"; Url="https://portableapps.com/downloading/?a=WizTreePortable&s=s&p=&d=pa&n=WizTree Portable&f=WizTreePortable_4.25.paf.exe"},
            @{Name="WorkravePortable_1.10.53.paf.exe"; Url="https://portableapps.com/downloading/?a=WorkravePortable&s=s&p=&d=pa&n=Workrave Portable&f=WorkravePortable_1.10.53.paf.exe"},
            @{Name="XenonPortable_1.5.0.2.paf.exe"; Url="https://portableapps.com/downloading/?a=XenonPortable&s=s&p=&d=pa&n=Xenon File Manager Portable&f=XenonPortable_1.5.0.2.paf.exe"},
            @{Name="XNResourceEditorPortable_3.0.0.1_English.paf.exe"; Url="https://portableapps.com/downloading/?a=XNResourceEditorPortable&s=s&p=&d=pa&n=XN Resource Editor Portable&f=XNResourceEditorPortable_3.0.0.1_English.paf.exe"},
            @{Name="xpyPortable_1.3.8.paf.exe"; Url="https://portableapps.com/downloading/?a=xpyPortable&s=s&p=&d=pa&n=xpy Portable&f=xpyPortable_1.3.8.paf.exe"},
            @{Name="YUMIPortable_2.0.9.4_English.paf.exe"; Url="https://portableapps.com/downloading/?a=YUMIPortable&s=s&p=&d=pa&n=YUMI Legacy Portable&f=YUMIPortable_2.0.9.4_English.paf.exe"},
            @{Name="YUMI-exFATPortable_1.0.2.9_English.paf.exe"; Url="https://portableapps.com/downloading/?a=YUMI-exFATPortable&s=s&p=&d=pa&n=YUMI-exFAT Portable&f=YUMI-exFATPortable_1.0.2.9_English.paf.exe"},
            @{Name="YUMI-UEFIPortable_0.0.4.6_English.paf.exe"; Url="https://portableapps.com/downloading/?a=YUMI-UEFIPortable&s=s&p=&d=pa&n=YUMI-UEFI Portable&f=YUMI-UEFIPortable_0.0.4.6_English.paf.exe"},
            @{Name="ZintPortable_2.15.0_English.paf.exe"; Url="https://portableapps.com/downloading/?a=ZintPortable&s=s&p=&d=pa&n=Zint Barcode Studio Portable&f=ZintPortable_2.15.0_English.paf.exe"},
            @{Name="ZSoftUninstallerPortable_2.5_Rev_3.paf.exe"; Url="https://portableapps.com/downloading/?a=ZSoftUninstallerPortable&s=s&p=&d=pa&n=ZSoft Uninstaller Portable&f=ZSoftUninstallerPortable_2.5_Rev_3.paf.exe"},
            @{Name="PortableApps.comLauncher_2.2.9.paf.exe"; Url="https://portableapps.com/downloading/?a=PortableApps.comLauncher&s=s&p=&d=pa&n=PortableApps.com Launcher&f=PortableApps.comLauncher_2.2.9.paf.exe"},
            @{Name="PortableApps.comInstaller_3.9.1.paf.exe"; Url="https://portableapps.com/downloading/?a=PortableApps.comInstaller&s=s&p=&d=pa&n=PortableApps.com Installer&f=PortableApps.comInstaller_3.9.1.paf.exe"},
            @{Name="PortableApps.comAppCompactor_3.9_English.paf.exe"; Url="https://portableapps.com/downloading/?a=PortableApps.comAppCompactor&s=s&p=&d=pa&n=PortableApps.com AppCompactor&f=PortableApps.comAppCompactor_3.9_English.paf.exe"}
        )
    }

}

function Show-Header {
    param (
        [string]$title,
        [string]$subtitle = ""
    )
    
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "¦          WIN-TOOLKIT - CLI UTILITY        ¦" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    if ($subtitle) {
        Write-Host $subtitle
        Write-Host "---------------------------------------------" -ForegroundColor DarkGray
    }
}

function Show-MainMenu {
    Show-Header -title "MAIN MENU" -subtitle "Repository: $repoUrl | Download Path: $downloadPath"
    
    Write-Host "1. Get Software    [Browse Categories]"
    Write-Host "2. System Path     [Configure Download Location]"
    Write-Host "3. Search Toolkit  [Find Specific Software]"
    Write-Host "---------------------------------------------" -ForegroundColor DarkGray
    Write-Host "Q. Quit"
    Write-Host "=============================================" -ForegroundColor Cyan
    
    $choice = Read-Host "`nEnter your choice"
    return $choice
}

function Show-CategoryMenu {
    Show-Header -title "SOFTWARE CATEGORIES" -subtitle "Select a category to browse"
    
    $sortedCategories = $categories.Keys | Sort-Object
    $columnWidth = 30
    $cols = [math]::Floor([console]::WindowWidth / ($columnWidth + 4))
    $rows = [math]::Ceiling($sortedCategories.Count / $cols)
    
    for ($i = 0; $i -lt $rows; $i++) {
        for ($j = 0; $j -lt $cols; $j++) {
            $index = $i + ($j * $rows)
            if ($index -lt $sortedCategories.Count) {
                $key = $sortedCategories[$index]
                $num = $key.PadLeft(2)
                $name = $categories[$key].Name
                if ($name.Length -gt $columnWidth - 4) {
                    $name = $name.Substring(0, $columnWidth - 4) + "..."
                }
                Write-Host " $num. $($name.PadRight($columnWidth - 4))" -NoNewline
            }
        }
        Write-Host ""
    }
    
    Write-Host "---------------------------------------------" -ForegroundColor DarkGray
    Write-Host "B. Back to Main Menu"
    Write-Host "Q. Quit"
    Write-Host "=============================================" -ForegroundColor Cyan
    
    $choice = Read-Host "`nEnter category number"
    return $choice
}

function Show-SoftwareList {
    param (
        [string]$category,
        [int]$page = 1
    )
    
    $files = $categories[$category].Files
    $totalPages = [math]::Ceiling($files.Count / $itemsPerPage)
    $startIndex = ($page - 1) * $itemsPerPage
    $endIndex = [math]::Min($startIndex + $itemsPerPage - 1, $files.Count - 1)
    
    Show-Header -title "$($categories[$category].Name.ToUpper())" -subtitle "$($categories[$category].Description) | Page $page of $totalPages"
    
    # Display files in columns
    $columnWidth = 40
    $cols = [math]::Floor([console]::WindowWidth / ($columnWidth + 4))
    $rows = [math]::Ceiling(($endIndex - $startIndex + 1) / $cols)
    
    for ($i = $startIndex; $i -le $endIndex; $i += $cols) {
        for ($j = 0; $j -lt $cols; $j++) {
            $index = $i + $j
            if ($index -le $endIndex) {
                $num = ($index - $startIndex + 1).ToString().PadLeft(3)
                $name = $files[$index].Name
                if ($name.Length -gt $columnWidth - 6) {
                    $name = $name.Substring(0, $columnWidth - 6) + "..."
                }
                Write-Host " $num. $($name.PadRight($columnWidth - 6))" -NoNewline
            }
        }
        Write-Host ""
    }
    
    Write-Host "---------------------------------------------" -ForegroundColor DarkGray
    if ($totalPages -gt 1) {
        Write-Host "N. Next Page | P. Previous Page | "
    }
    Write-Host "Enter number to download | B. Back to Categories | Q. Quit"
    Write-Host "=============================================" -ForegroundColor Cyan
    
    $choice = Read-Host "`nEnter your choice"
    return $choice, $page
}

function Show-PathMenu {
    Show-Header -title "DOWNLOAD PATH CONFIGURATION"
    
    Write-Host "Current download path:"
    Write-Host "  $downloadPath" -ForegroundColor Yellow
    Write-Host "---------------------------------------------" -ForegroundColor DarkGray
    Write-Host "1. Change download path"
    Write-Host "2. Open download folder"
    Write-Host "3. Reset to default path"
    Write-Host "---------------------------------------------" -ForegroundColor DarkGray
    Write-Host "B. Back to Main Menu"
    Write-Host "Q. Quit"
    Write-Host "=============================================" -ForegroundColor Cyan
    
    $choice = Read-Host "`nEnter your choice"
    return $choice
}

function Show-SearchMenu {
    Show-Header -title "SEARCH TOOLKIT"
    
    $searchTerm = Read-Host "Enter search term (leave blank to cancel)"
    if ([string]::IsNullOrWhiteSpace($searchTerm)) {
        return "B"
    }
    
    $results = @()
    foreach ($category in $categories.Keys) {
        foreach ($file in $categories[$category].Files) {
            if ($file.Name -like "*$searchTerm*") {
                $results += [PSCustomObject]@{
                    Category = $categories[$category].Name
                    Name = $file.Name
                    Url = $file.Url
                }
            }
        }
    }
    
    if ($results.Count -eq 0) {
        Show-Header -title "SEARCH RESULTS"
        Write-Host "No results found for '$searchTerm'"
        Write-Host "---------------------------------------------" -ForegroundColor DarkGray
        Write-Host "B. Back to Search | Q. Quit"
        Write-Host "=============================================" -ForegroundColor Cyan
        
        $choice = Read-Host "`nEnter your choice"
        if ($choice -eq "B") {
            return Show-SearchMenu
        } else {
            return $choice
        }
    }
    
    $currentPage = 1
    $totalPages = [math]::Ceiling($results.Count / $itemsPerPage)
    
    do {
        Show-Header -title "SEARCH RESULTS FOR '$searchTerm'" -subtitle "Found $($results.Count) matches | Page $currentPage of $totalPages"
        
        $startIndex = ($currentPage - 1) * $itemsPerPage
        $endIndex = [math]::Min($startIndex + $itemsPerPage - 1, $results.Count - 1)
        
        for ($i = $startIndex; $i -le $endIndex; $i++) {
            $num = ($i - $startIndex + 1).ToString().PadLeft(3)
            $category = $results[$i].Category
            $name = $results[$i].Name
            Write-Host " $num. [$category] $name"
        }
        
        Write-Host "---------------------------------------------" -ForegroundColor DarkGray
        if ($totalPages -gt 1) {
            Write-Host "N. Next Page | P. Previous Page | "
        }
        Write-Host "Enter number to download | B. New Search | Q. Quit"
        Write-Host "=============================================" -ForegroundColor Cyan
        
        $choice = Read-Host "`nEnter your choice"
        
        if ($choice -eq "N" -and $currentPage -lt $totalPages) {
            $currentPage++
        } elseif ($choice -eq "P" -and $currentPage -gt 1) {
            $currentPage--
        } elseif ($choice -match "^\d+$") {
            $index = [int]$choice - 1 + ($currentPage - 1) * $itemsPerPage
            if ($index -ge 0 -and $index -lt $results.Count) {
                $selectedFile = $results[$index]
                $fileToDownload = [PSCustomObject]@{
                    Name = $selectedFile.Name
                    Url = $selectedFile.Url
                }
                Download-File -file $fileToDownload
            }
        }
    } while ($choice -in "N", "P")
    
    return $choice
}

function Download-File {
    param (
        [PSCustomObject]$file
    )
    
    Show-Header -title "DOWNLOADING: $($file.Name)"
    
    # Ensure download directory exists
    if (-not (Test-Path -Path $downloadPath)) {
        try {
            New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null
            Write-Host "Created directory: $downloadPath" -ForegroundColor Green
        } catch {
            Write-Host "Error creating directory: $_" -ForegroundColor Red
            $downloadPath = $defaultDownloadPath
            Write-Host "Using default path: $downloadPath" -ForegroundColor Yellow
        }
    }
    
    $destinationFile = Join-Path -Path $downloadPath -ChildPath $file.Name
    
    try {
        Write-Host "Downloading from: $($file.Url)"
        Write-Host "Saving to: $destinationFile"
        Write-Host "---------------------------------------------" -ForegroundColor DarkGray
        
        # Use BITS for better download experience
        Start-BitsTransfer -Source $file.Url -Destination $destinationFile -DisplayName $file.Name -Priority High
        
        Write-Host "Download completed successfully!" -ForegroundColor Green
        Process-DownloadedFile -filePath $destinationFile
    } catch {
        Write-Host "Download failed: $_" -ForegroundColor Red
    }
    
    Write-Host "---------------------------------------------" -ForegroundColor DarkGray
    Pause
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
        {$_ -in ".zip",".7z",".rar"} {
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
        if (-not (Test-Path -Path $extractPath)) {
            New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
        }
        
        $7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
        if (Test-Path -Path $7zipPath) {
            & $7zipPath x "-o$extractPath" -y $filePath | Out-Null
            Write-Host "Extraction completed using 7-Zip." -ForegroundColor Green
        } elseif ($fileExtension -eq ".zip") {
            Expand-Archive -Path $filePath -DestinationPath $extractPath -Force
            Write-Host "Extraction completed using PowerShell." -ForegroundColor Green
        } else {
            Write-Host "7-Zip not found. Please install 7-Zip to extract this archive." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error extracting archive: $_" -ForegroundColor Red
    }
}

function Set-DownloadPath {
    Show-Header -title "CHANGE DOWNLOAD PATH"
    
    Write-Host "Current download path: $downloadPath"
    $newPath = Read-Host "`nEnter new download path (leave blank to keep current)"
    
    if (-not [string]::IsNullOrWhiteSpace($newPath)) {
        try {
            if (-not (Test-Path -Path $newPath)) {
                New-Item -ItemType Directory -Path $newPath -Force | Out-Null
            }
            $downloadPath = $newPath
            Write-Host "Download path updated to: $downloadPath" -ForegroundColor Green
        } catch {
            Write-Host "Error setting path: $_" -ForegroundColor Red
        }
    }
    
    Pause
}

# Main program loop
$running = $true
while ($running) {
    $choice = Show-MainMenu
    
    switch ($choice) {
        "1" {
            # Get Software - Browse Categories
            $categoryChoice = $null
            do {
                $categoryChoice = Show-CategoryMenu
                
                if ($categoryChoice -in $categories.Keys) {
                    $page = 1
                    do {
                        $softwareChoice, $page = Show-SoftwareList -category $categoryChoice -page $page
                        
                        if ($softwareChoice -eq "N") {
                            $page++
                        } elseif ($softwareChoice -eq "P") {
                            $page--
                        } elseif ($softwareChoice -match "^\d+$") {
                            $index = [int]$softwareChoice - 1 + ($page - 1) * $itemsPerPage
                            if ($index -ge 0 -and $index -lt $categories[$categoryChoice].Files.Count) {
                                $selectedFile = $categories[$categoryChoice].Files[$index]
                                $fileToDownload = [PSCustomObject]@{
                                    Name = $selectedFile.Name
                                    Url = $selectedFile.Url
                                }
                                Download-File -file $fileToDownload
                            }
                        }
                    } while ($softwareChoice -in "N", "P")
                }
            } while ($categoryChoice -eq "B")
            
            if ($categoryChoice -eq "Q") {
                $running = $false
            }
        }
        "2" {
            # System Path Configuration
            $pathChoice = $null
            do {
                $pathChoice = Show-PathMenu
                
                switch ($pathChoice) {
                    "1" { Set-DownloadPath }
                    "2" { 
                        try {
                            Invoke-Item $downloadPath
                        } catch {
                            Write-Host "Error opening folder: $_" -ForegroundColor Red
                            Pause
                        }
                    }
                    "3" { 
                        $downloadPath = $defaultDownloadPath
                        Write-Host "Reset to default path: $downloadPath" -ForegroundColor Green
                        Pause
                    }
                }
            } while ($pathChoice -eq "B")
            
            if ($pathChoice -eq "Q") {
                $running = $false
            }
        }
        "3" {
            # Search Toolkit
            $searchChoice = Show-SearchMenu
            if ($searchChoice -eq "Q") {
                $running = $false
            }
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

Write-Host "Thank you for using WIN-TOOLKIT!" -ForegroundColor Yellow
