#!/usr/bin/env bash
# ============================================
#  TGR TEAM - ZIP UNLOCK TOOL (VIP Edition)
#  Dictionary password finder for .zip / .7z / .rar
#  by TGR TEAM (PNT-TIGER)
# ============================================

R='\033[1;31m'   # red    -> wrong password
G='\033[1;32m'   # green  -> correct password / logo
Y='\033[1;33m'   # yellow -> info
C='\033[1;36m'   # cyan   -> prompts
M='\033[1;35m'   # magenta
B='\033[1;34m'   # blue
W='\033[1;37m'
N='\033[0m'

TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_LIST="$TOOL_DIR/passwords.txt"
WORK_DIR="$HOME/.tgr-unlock"
CHANNEL_URL="https://t.me/+jnSdSlPbNxU0NGM1"
mkdir -p "$WORK_DIR"

print_logo() {
  local col="$1"
  printf "${col}   ████████╗ ██████╗ ██████╗ ${N}\n"
  printf "${col}   ╚══██╔══╝██╔════╝ ██╔══██╗${N}\n"
  printf "${col}      ██║   ██║  ███╗██████╔╝${N}\n"
  printf "${col}      ██║   ██║   ██║██╔══██╗${N}\n"
  printf "${col}      ██║   ╚██████╔╝██║  ██║${N}\n"
  printf "${col}      ╚═╝    ╚═════╝ ╚═╝  ╚═╝${N}\n"
}

type_text() {
  local s="$1" i
  for ((i = 0; i < ${#s}; i++)); do
    printf '%s' "${s:i:1}"
    sleep 0.015
  done
  printf '\n'
}

intro_anim() {
  # VIP animated intro: logo flashes in 4 colours, typewriter line, loading bar
  local cols=("$C" "$M" "$Y" "$G") col p filled empty bar
  for col in "${cols[@]}"; do
    clear
    printf "${C}============================================${N}\n"
    print_logo "$col"
    printf "${M}        ★ TGR TEAM ★ VIP EDITION ★${N}\n"
    printf "${C}============================================${N}\n"
    sleep 0.28
  done
  printf "\n${G}"
  type_text "   WELCOME TO TGR TEAM"
  printf "${C}"
  type_text "   ZIP UNLOCK TOOL — LOADING..."
  printf "${N}\n"
  for p in 0 10 20 30 40 50 60 70 80 90 100; do
    filled=$((p / 5))
    empty=$((20 - filled))
    bar="$(printf '█%.0s' $(seq 1 $filled 2>/dev/null))$(printf '░%.0s' $(seq 1 $empty 2>/dev/null))"
    printf "\r${Y}   [%s] %s%%${N}" "$bar" "$p"
    sleep 0.09
  done
  printf "\n\n"
  sleep 0.3
}

banner() {
  clear
  printf "${C}============================================${N}\n"
  print_logo "$G"
  printf "${M}        ★ TGR TEAM ★ ZIP UNLOCK TOOL${N}\n"
  printf "${C}============================================${N}\n"
}

check_deps() {
  if ! command -v 7z >/dev/null 2>&1; then
    printf "${Y}[!] 7z pacchi na — p7zip install hocche, ektu wait koro...${N}\n"
    pkg install -y p7zip >/dev/null 2>&1
    if ! command -v 7z >/dev/null 2>&1; then
      printf "${R}[X] p7zip install holo na. Nije chalao: pkg install p7zip${N}\n"
      exit 1
    fi
  fi
}

clean_path() {
  local p="$1"
  p="$(printf '%s' "$p" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  p="${p%\"}"; p="${p#\"}"; p="${p%\'}"; p="${p#\'}"
  case "$p" in
    "~/"*) p="$HOME/${p#~/}" ;;
    "~")   p="$HOME" ;;
  esac
  printf '%s' "$p"
}

unlock_file() {
  printf "\n${C}[?] File-er path daw (MT Manager theke copy kore paste koro):${N}\n"
  printf "${W}> ${N}"
  read -r raw_path
  local file
  file="$(clean_path "$raw_path")"
  if [ ! -f "$file" ]; then
    printf "${R}[X] File pacchi na: %s${N}\n" "$file"
    return
  fi

  printf "${C}[?] Wordlist-er path daw (faka rakhle default list cholbe):${N}\n"
  printf "${W}> ${N}"
  read -r raw_list
  local list
  list="$(clean_path "$raw_list")"
  [ -z "$list" ] && list="$DEFAULT_LIST"
  if [ ! -f "$list" ]; then
    printf "${R}[X] Wordlist pacchi na: %s${N}\n" "$list"
    return
  fi

  local total key pf start=0 i=0 pw found=""
  total=$(grep -c '' "$list")
  key=$(printf '%s|%s' "$file" "$list" | md5sum | cut -d' ' -f1)
  pf="$WORK_DIR/prog_$key"
  [ -f "$pf" ] && start=$(cat "$pf" 2>/dev/null || echo 0)

  printf "\n${Y}[*] File    : %s${N}\n" "$file"
  printf "${Y}[*] Wordlist: %s (%s ta password)${N}\n" "$list" "$total"
  if [ "$start" -gt 0 ] 2>/dev/null; then
    printf "${Y}[*] Age %s ta try hoyeche — sekhan thekei resume hocche.${N}\n" "$start"
    printf "${Y}    (Notun kore shuru korte chaile delete koro: %s)${N}\n" "$pf"
  fi
  printf "${Y}[*] Password check shuru... (bondho korte Ctrl+C)${N}\n\n"

  while IFS= read -r pw || [ -n "$pw" ]; do
    pw="${pw%$'\r'}"
    [ -z "$pw" ] && continue
    i=$((i + 1))
    [ "$i" -le "$start" ] && continue
    if 7z t -p"$pw" "$file" >/dev/null 2>&1; then
      found="$pw"
      break
    fi
    printf "${R}[%s/%s] WRONG : %s${N}\n" "$i" "$total" "$pw"
    if [ $((i % 50)) -eq 0 ]; then echo "$i" > "$pf"; fi
  done < "$list"

  echo
  if [ -n "$found" ]; then
    local out="$WORK_DIR/found.txt"
    printf '%s  ->  %s\n' "$file" "$found" >> "$out"
    rm -f "$pf"
    printf "${G}============================================${N}\n"
    printf "${G}  [✓] PASSWORD PEYE GECHI!${N}\n"
    printf "${G}  Password : %s${N}\n" "$found"
    printf "${G}  Save hoyeche: %s${N}\n" "$out"
    printf "${G}============================================${N}\n"
  else
    rm -f "$pf"
    printf "${R}[X] Ei list-e password ta nai. Onno boro wordlist diye try koro.${N}\n"
  fi
}

join_telegram() {
  printf "\n${C}[*] TGR TEAM Telegram channel khulchi...${N}\n"
  if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url "$CHANNEL_URL"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$CHANNEL_URL" >/dev/null 2>&1
  elif command -v am >/dev/null 2>&1; then
    am start -a android.intent.action.VIEW -d "$CHANNEL_URL" >/dev/null 2>&1
  else
    printf "${Y}Link ta copy kore Telegram-e khulo: %s${N}\n" "$CHANNEL_URL"
    return
  fi
  printf "${G}[✓] Channel khule deya hoyeche!${N}\n"
}

menu() {
  check_deps
  intro_anim
  while true; do
    banner
    printf "\n${W}  [1]${G} Unlock zip file${N}\n"
    printf "${W}  [2]${C} Join Telegram (TGR TEAM)${N}\n"
    printf "${W}  [3]${R} Exit${N}\n"
    printf "\n${C}[?] Choice daw (1/2/3): ${N}"
    read -r choice
    case "$choice" in
      1)
        unlock_file
        printf "\n${C}Menu-te firte Enter chapo...${N}"
        read -r _
        ;;
      2)
        join_telegram
        printf "\n${C}Menu-te firte Enter chapo...${N}"
        read -r _
        ;;
      3)
        printf "\n${G}Allah Hafez! — TGR TEAM${N}\n"
        exit 0
        ;;
      *)
        printf "\n${R}[X] Vul choice. 1, 2 ba 3 daw.${N}\n"
        sleep 1
        ;;
    esac
  done
}

menu
