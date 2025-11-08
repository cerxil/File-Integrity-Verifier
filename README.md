# File-Integrity-Verifier
Checks the integrity of your downloaded files with ease

Supports
* MD5
* SHA1
* SHA256
* SHA512

![hash_check_success](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/hash_check_success.png)

## How It Works

* Select your download from explorer UI

* Paste file hash from the download page to the terminal

* Automatically checks what hash to use and if file is still downloading `.part`, `.crdownload`, `.tmp`

* Shows you if good or bad download 

## How to Run

You have two options:

### 1. Download and Run Manually (Offline)

* Download `File-Integrity-Verifier.ps1` from this repository.
* Right-click the file and select **Run with PowerShell** (or run it in PowerShell manually).

### 2. One-Time Execution via PowerShell

You can run the script directly from GitHub using this command in PowerShell:

```powershell
irm https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/File-Integrity-Verifier.ps1 | iex
```

Note: You may need to allow script execution by running:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Troubleshooting

If you encounter errors:

* Ensure PowerShell is run with sufficient permissions (try **Run as Administrator**).
* Try running the script again

## More screenshots

![file_selection_dialog](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/file_selection_dialog.png)
![download_in_progress](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/download_in_progress.png)
![hash_check_failure](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/hash_check_failure.png)

---

Feel free to open an issue if something doesn't work as expected.
