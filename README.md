# Windows Software Downloader Utility

![Utility Screenshot](https://via.placeholder.com/800x400?text=Windows+Software+Downloader+Screenshot)

A comprehensive tool for downloading essential Windows software from a curated collection. Choose from three convenient launch methods.

## ⚠️ IMPORTANT LEGAL DISCLAIMER

**THE DEVELOPERS OF THIS UTILITY TAKE NO RESPONSIBILITY FOR:**
- Any licensed software that may be present in the repository
- Any cracked/pirated software that users may add through contributions
- Legal consequences from software misuse
- System damage from downloaded software

**BY USING THIS TOOL, YOU ACKNOWLEDGE THAT:**
1. You are solely responsible for verifying software licenses
2. Some tools may require separate legal licenses
3. The maintainers merely provide download links, not software ownership

## 🚀 Launch Options

### Method 1: EXE Launcher (Recommended)

1. Download: [WIN-Toolkit.exe](https://github.com/GlitchLinux/WINDOWS-SOFTWARE/raw/refs/heads/main/WIN-Toolkit.exe)
2. Right-click → "Run as administrator"
3. Follow on-screen prompts

▶ **Best for**: Most users who want simple one-click operation

### Method 2: Batch File

1. Download: [WIN-Toolkit.bat](https://raw.githubusercontent.com/GlitchLinux/WINDOWS-SOFTWARE/refs/heads/main/WIN-Toolkit.bat)
2. Right-click → "Run as administrator"

▶ **Best for**: Users who prefer batch scripts or need to inspect the code

### Method 3: Direct PowerShell
```powershell
# Run in PowerShell (admin):
irm https://raw.githubusercontent.com/GlitchLinux/WINDOWS-SOFTWARE/main/WINDOWS-TOOLKIT.ps1 | iex
```
▶ **Best for**: Advanced users and automated deployments

## 📦 Software Categories

| Category | Description | Example Tools |
|----------|-------------|---------------|
| **Partition Tools** | Disk management utilities | 7-Zip, DiskGenius, HDD Regenerator |
| **System Recovery** | Repair and maintenance tools | Active Partition Recovery, CCleaner |
| **Executable Tools** | Ready-to-run applications | Rufus, CPU-Z, HWiNFO |
| **Boot Utilities** | Installation and setup tools | WinNTSetup, EasyUEFI |
| **Portable Apps** | No-install needed software | IrfanView, SumatraPDF |

## 🔧 Requirements

- Windows 7/10/11 (x64 recommended)
- PowerShell 5.1+
- Administrator rights (for full functionality)
- 50MB+ free disk space

## ⚠️ Safety First

1. Always verify downloaded files with antivirus software
2. The toolkit requires admin rights to:
   - Install system utilities
   - Modify protected directories
   - Access disk management tools

## 🔍 Troubleshooting

### Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Execution restricted" | Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Downloads fail | Check firewall/antivirus settings |
| Missing features | Run as administrator |
| 7-Zip functions unavailable | [Install 7-Zip](https://www.7-zip.org/) |

## 🤝 Contributing

To add software to the collection:

1. Fork the repository
2. Add entries to `WINDOWS-TOOLKIT.ps1` following the existing format:
   ```powershell
   @{Name="ToolName"; Url="https://direct-download-link"}
   ```
3. Submit a pull request

## 📜 License

MIT License - See [LICENSE](LICENSE) for full details.

---

> 💡 **Tip**: For fastest performance, use the EXE launcher and ensure your download directory is on an SSD.
```

Key improvements:
1. **Structured comparison** of all three launch methods
2. **Enhanced visual layout** with tables for categories and troubleshooting
3. **Clear requirements** section
4. **More detailed safety information**
5. **Specific contribution guidelines** with code example
6. **Performance tip** in the footer

Would you like me to:
1. Add a version history/changelog section?
2. Include more detailed system requirements?
3. Add a FAQ section for common questions?
4. Include screenshots of the interface?
