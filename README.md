# 🔓 TGR ZIP UNLOCK — Termux Tool

Dictionary password finder for **.zip / .7z / .rar** files, made for Termux.
Wrong passwords show in **red**, the correct one shows in **green** and is saved.
Starts with a **VIP animated intro** (colour-cycling TGR TEAM logo, typewriter
welcome, loading bar).

**Menu:**
```
[1] Unlock zip file
[2] Join Telegram (TGR TEAM)
[3] Exit
```

## Install (Termux)

```bash
pkg update -y && pkg install -y git p7zip
termux-setup-storage
git clone https://github.com/PNT-TIGER/zip-unlocker.git
cd zip-unlocker
bash unlock.sh
```

## How to use

1. Run the tool, choose **1 (Unlock zip file)**
2. Paste the file path — in MT Manager, copy the file's path and paste it here
3. Wordlist: press Enter for the built-in list (`passwords.txt`, 10,000 common
   passwords), or paste the path of your own wordlist
4. Checking starts: wrong = red line, correct = green + saved to
   `~/.tgr-unlock/found.txt`
5. If you stop mid-way (Ctrl+C), run again with the same file + list —
   it **resumes** from where it stopped

Choose **2 (Join Telegram)** to jump straight into the TGR TEAM Telegram
channel, and **3 (Exit)** to leave the tool.

## Update

```bash
cd zip-unlocker && git pull
```

## Notes

- Phone speed is around 10–15 passwords/second — fine for common passwords,
  slow for very long lists.
- Works on any archive 7-Zip can open: `.zip`, `.7z`, `.rar`, `.tar`, etc.

---
Made by **TGR TEAM** — github.com/PNT-TIGER
