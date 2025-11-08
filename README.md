# File Integrity Verifier

Easily check the integrity of your downloaded files.

Supports the following hash algorithms:

* MD5
* SHA1
* SHA256
* SHA512

![hash\_check\_success](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/hash_check_success.png)

---

## How It Works

1. Select your downloaded file using the Explorer UI.
2. Paste the file hash from the download page into the terminal.
3. The script automatically detects the hash type and checks if the file is still downloading (detecting `.part`, `.crdownload`, or `.tmp` files).
4. View a clear result indicating whether your download is valid or corrupted.

---

## How to Run

You have two options:

### 1. Download and Run Manually (Offline)

1. Download `File-Integrity-Verifier.ps1` from this repository.
2. Right-click the file and select **Run with PowerShell**, or run it manually from PowerShell.

### 2. One-Time Execution via PowerShell

Run the script directly from GitHub:

```powershell
irm https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/File-Integrity-Verifier.ps1 | iex
```

> Note: You may need to allow script execution:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## Troubleshooting

* Ensure PowerShell is run with sufficient permissions (try **Run as Administrator**).
* Retry the script if errors occur.

---

## Screenshots

File selection dialog:
![file\_selection\_dialog](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/file_selection_dialog.png)

Download in progress detection:
![download\_in\_progress](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/download_in_progress.png)

Hash check failure:
![hash\_check\_failure](https://raw.githubusercontent.com/cerxil/File-Integrity-Verifier/refs/heads/main/hash_check_failure.png)

---

If something doesn’t work as expected, feel free to [open an issue](https://github.com/cerxil/File-Integrity-Verifier/issues).
