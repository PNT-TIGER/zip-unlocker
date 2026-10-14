# 🔓 TGR TEAM ZIP UNLOCK — Termux Tool

Dictionary + unlimited password finder for **.zip / .7z / .rar** files, made for Termux.
Wrong passwords show in **red**, the correct one shows in **green** and is saved.
Starts with a **VIP animated intro** (colour-cycling TGR TEAM logo, typewriter
welcome, loading bar). Made by **TGR TEAM**.

**Menu:**
```
[1] Unlock zip file
[2] Join Telegram (TGR TEAM)
[3] Exit
```

## Install (Termux)

Copy the commands **one by one** — paste each into Termux and press Enter.

**Step 1 — install the packages:**

```bash
pkg update -y && pkg install -y git p7zip
```

**Step 2 — allow storage access:**

```bash
termux-setup-storage
```

**Step 3 — download the tool:**

```bash
git clone https://github.com/PNT-TIGER/zip-unlocker.git
```

**Step 4 — enter the folder:**

```bash
cd zip-unlocker
```

**Step 5 — run the tool:**

```bash
bash unlock.sh
```

## How to use

1. Run the tool, choose **1 (Unlock zip file)**
2. It asks **"Your Folder send koro"** — paste a folder path, e.g.
   `/storage/emulated/0/Download` (a direct file path also works)
3. The tool lists everything in that folder **numbered** — folders, files,
   ZIP and 7Z counts at the top:
   ```
   1. 📁 folder-name/
   2. 📄 file.txt
   3. 🔓 archive.zip
   4. 🔓 archive.7z
   ```
   Pick a folder number to go inside it, `0` to go up, `M` for the main menu —
   or pick an archive's number and the attack starts on that file
4. Wordlist: press Enter for the built-in list (`passwords.txt`, 10,000 common
   passwords), or paste the path of your own wordlist
5. Checking starts: wrong = red line, correct = green + saved to
   `~/.tgr-team/found.txt`
6. **Unlimited mode:** if the wordlist finishes with no hit, the tool does
   **not** stop — it automatically keeps checking number patterns, dates,
   word combos and then brute-force, until the correct password is found
   or you stop it with Ctrl+C
7. If you stop mid-way (Ctrl+C), run again with the same file + list —
   it **resumes** from where it stopped, in unlimited mode too

Choose **2 (Join Telegram)** to jump straight into the TGR TEAM Telegram
channel, and **3 (Exit)** to leave the tool.

## Update

```bash
cd zip-unlocker
```

```bash
git pull
```

## Notes

- Phone speed is around 10–15 passwords/second — fine for common passwords,
  slow for very long lists.
- Works on any archive 7-Zip can open: `.zip`, `.7z`, `.rar`, `.tar`, etc.

---
Made by **TGR TEAM** — github.com/PNT-TIGER
