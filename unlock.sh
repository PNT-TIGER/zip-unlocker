#!/usr/bin/env bash
# ============================================
#  TGR TEAM - ZIP UNLOCK TOOL (VIP Edition)
#  Dictionary + unlimited password finder
#  for .zip / .7z / .rar — by TGR TEAM
# ============================================

R='\033[1;31m'   # red    -> wrong password
G='\033[1;32m'   # green  -> correct password / logo
Y='\033[1;33m'   # yellow -> info
C='\033[1;36m'   # cyan   -> prompts
M='\033[1;35m'   # magenta
W='\033[1;37m'
N='\033[0m'

TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_LIST="$TOOL_DIR/passwords.txt"
WORK_DIR="$HOME/.tgr-team"
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

# ---------- unlimited candidate generator ----------
gen_len() {
  local len=$1 prefix=$2 chars=$3 i c
  if [ "$len" -eq 0 ]; then printf '%s\n' "$prefix"; return; fi
  for ((i = 0; i < ${#chars}; i++)); do
    gen_len $((len - 1)) "$prefix${chars:i:1}" "$chars"
  done
}

gen_unlimited() {
  local n d m y w s L
  local -a CORE=(password hackel baba pnl vip panel hacker tiger bd team
    admin king boss rafi pro ff freefire garena dhaka bangla mod root
    hackelbaba vippnl tgrteam official gamer legend dark ghost killer)
  local -a SUF=("" 123 1234 12345 123456 1 12 420 786 007 2023 2024 2025
    2026 "@" "!" "@123" bd 24 71 99 00 777 111)
  # Bangladeshi words: places, names, common Bangla words, religious words
  local -a BDW=(bangladesh bangla bengali dhaka chattogram chittagong
    khulna rajshahi sylhet barishal barisal rangpur mymensingh comilla
    cumilla gazipur narayanganj coxsbazar bogura jessore jashore kushtia
    pabna tangail dinajpur faridpur noakhali feni chandpur kishoreganj
    manikganj narsingdi gopalganj madaripur satkhira bagerhat chuadanga
    jhenaidah magura narail meherpur barguna bhola patuakhali pirojpur
    bandarban rangamati khagrachari sunamganj habiganj moulvibazar
    netrokona jamalpur sherpur kurigram gaibandha lalmonirhat nilphamari
    panchagarh thakurgaon joypurhat naogaon natore sirajganj brahmanbaria
    lakshmipur shariatpur rajbari munshiganj rahim karim abdul mohammad
    ahmed hossain islam uddin khan ali akter begum khatun sultana parvin
    fatema ayesha sumon rubel shakil arif roni sohel masud kamal jamal
    anwar mahmud hasan rakib ratul rifat tanvir fahim naim shanto sabbir
    imran mehedi shakib tamim mushfiq mashrafe liton mustafiz taskin
    bhalobasha bhalo desh deshi gram grameen shundor sundor taka bari
    ghor bondhu prem bhalobashi ami tumi amar sonar sonarbangla bijoy
    shadhin shadhinota muktijuddho ekattor bhasha noboborsho pohela
    boishakh rickshaw nouka ilish hilsa panta bhaat biriyani kacchi
    tehari fuchka jhalmuri adda khela cricket football allah allahu
    akbar bismillah alhamdulillah mashallah inshallah subhanallah
    ramadan ramjan eid eidmubarak muslim namaz roza iftar seheri haji
    hajj makkah madina madinah quran kuran hadis hadith nabi rasul
    muhammad grameenphone banglalink robi teletalk airtel)
  local -a BDS=("" 1971 1952 71 52 123 1234 12345 123456 420 786 111
    777 999 007 2024 2025 2026 1 12 21 16 26 24 99 00 "@" "!" "@123"
    bd BD)
  # 1) numbers: plain + 6-digit padded, interleaved (0..99999)
  for n in $(seq 0 99999); do printf '%s\n' "$n"; printf '%06d\n' "$n"; done
  # 2) dates DDMMYYYY + YYYYMMDD
  for y in $(seq 1970 2030); do
    for m in $(seq -w 1 12); do
      for d in $(seq -w 1 31); do
        printf '%s%s%s\n' "$d" "$m" "$y"
        printf '%s%s%s\n' "$y" "$m" "$d"
      done
    done
  done
  # 3) Bangladeshi words + suffixes, plus word pairs
  for w in "${BDW[@]}"; do
    for s in "${BDS[@]}"; do printf '%s%s\n' "$w" "$s"; done
    for s in "${BDS[@]}"; do printf '%s%s\n' "${w^}" "$s"; done
  done
  for w in "${BDW[@]:0:40}"; do
    for w2 in "${BDW[@]:0:40}"; do printf '%s%s\n' "$w" "$w2"; done
  done
  # 4) word + suffix combos
  for w in "${CORE[@]}"; do
    for s in "${SUF[@]}"; do printf '%s%s\n' "$w" "$s"; done
    for s in "${SUF[@]}"; do printf '%s%s\n' "${w^}" "$s"; done
  done
  # 4) bigger plain numbers
  for n in $(seq 100000 999999); do printf '%s\n' "$n"; done
  # 5) 8-digit padded numbers
  for n in $(seq 0 999999); do printf '%08d\n' "$n"; done
  # 6) even bigger plain numbers
  for n in $(seq 1000000 99999999); do printf '%s\n' "$n"; done
  # 7) brute force: lowercase, then lowercase+digits
  for L in 1 2 3 4 5 6 7 8; do gen_len "$L" "" "abcdefghijklmnopqrstuvwxyz"; done
  for L in 1 2 3 4 5 6 7; do gen_len "$L" "" "0123456789abcdefghijklmnopqrstuvwxyz"; done
  # 8) ENDLESS: ever-longer candidates — this loop never finishes,
  #    so the password stream NEVER runs out
  L=8
  while true; do
    gen_len "$L" "" "0123456789abcdefghijklmnopqrstuvwxyz"
    gen_len "$L" "" "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    L=$((L + 1))
  done
}

# test one candidate (runs in parallel batches of 4); globals:
# TGR_CUR_FILE = archive being attacked, TGR_FF = found-password file
try_one() {
  local cand="$1"
  if 7z t -p"$cand" "$TGR_CUR_FILE" >/dev/null 2>&1; then
    printf '%s' "$cand" > "$TGR_FF"
  else
    printf "${R}WRONG : %s${N}\n" "$cand"
  fi
}

success_box() {
  local file="$1" pw="$2" out="$WORK_DIR/found.txt"
  printf '%s  ->  %s\n' "$file" "$pw" >> "$out"
  printf "${G}============================================${N}\n"
  printf "${G}  [✓] PASSWORD PEYE GECHI!${N}\n"
  printf "${G}  File     : %s${N}\n" "$file"
  printf "${G}  Password : %s${N}\n" "$pw"
  printf "${G}  Save hoyeche: %s${N}\n" "$out"
  printf "${G}============================================${N}\n"
}

# ---------- attack on one file ----------
attack_file() {
  local file="$1"
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

  local total key pf state="" start=0 skip=0 i=0 u=0 pw found=""
  total=$(grep -c '' "$list")
  key=$(printf '%s|%s' "$file" "$list" | md5sum | cut -d' ' -f1)
  pf="$WORK_DIR/prog_$key"
  [ -f "$pf" ] && state=$(cat "$pf" 2>/dev/null)

  TGR_CUR_FILE="$file"
  TGR_FF="$WORK_DIR/.ff_$key"
  rm -f "$TGR_FF"

  printf "\n${Y}[*] File    : %s${N}\n" "$file"
  printf "${Y}[*] Wordlist: %s (%s ta password)${N}\n" "$list" "$total"

  if [ "${state#U }" != "$state" ]; then
    skip=${state#U }
    start=$total
    printf "${Y}[*] Unlimited mode theke resume hocche (%s ta skip)${N}\n" "$skip"
  elif [ -n "$state" ]; then
    start=$state
    printf "${Y}[*] Age %s ta try hoyeche — sekhan theke resume hocche${N}\n" "$start"
  fi
  printf "${Y}[*] Password check shuru... (bondho korte Ctrl+C)${N}\n\n"

  # Phase 1: wordlist (4 parallel checks — super fast)
  if [ "$start" -lt "$total" ]; then
    while IFS= read -r pw || [ -n "$pw" ]; do
      pw="${pw%$'\r'}"
      [ -z "$pw" ] && continue
      i=$((i + 1))
      [ "$i" -le "$start" ] && continue
      [ -f "$TGR_FF" ] && break
      try_one "$pw" &
      if [ $((i % 4)) -eq 0 ]; then wait; fi
      if [ $((i % 200)) -eq 0 ]; then
        echo "$i" > "$pf"
        printf "${Y}[*] %s/%s try hoyeche...${N}\n" "$i" "$total"
      fi
    done < "$list"
    wait
    [ -f "$TGR_FF" ] && found="$(cat "$TGR_FF")"
  fi

  # Phase 2: unlimited — runs until the password is found or user stops
  if [ -z "$found" ]; then
    echo
    printf "${M}============================================${N}\n"
    printf "${M}  List sesh! UNLIMITED MODE shuru —${N}\n"
    printf "${M}  sothik password na mela porjonto check choltei thakbe${N}\n"
    printf "${M}============================================${N}\n\n"
    echo "U $skip" > "$pf"
    while IFS= read -r pw; do
      [ -z "$pw" ] && continue
      [ -f "$TGR_FF" ] && break
      u=$((u + 1))
      try_one "$pw" &
      if [ $((u % 4)) -eq 0 ]; then wait; fi
      if [ $((u % 200)) -eq 0 ]; then
        echo "U $((skip + u))" > "$pf"
        printf "${Y}[*] Unlimited: %s ta try hoyeche...${N}\n" "$u"
      fi
    done < <(gen_unlimited | tail -n +$((skip + 1)))
    wait
    [ -f "$TGR_FF" ] && found="$(cat "$TGR_FF")"
  fi

  echo
  if [ -n "$found" ]; then
    rm -f "$pf" "$TGR_FF"
    success_box "$file" "$found"
  else
    printf "${R}[X] Check theme gelo. Abar chalale resume hobe.${N}\n"
  fi
}

is_archive_name() {
  case "$(printf '%s' "$1" | tr 'A-Z' 'a-z')" in
    *.zip|*.7z|*.rar|*.tar|*.gz|*.bz2|*.xz|*.jar|*.apk) return 0 ;;
    *) return 1 ;;
  esac
}

# ---------- folder browser ----------
browse_and_attack() {
  printf "\n${C}[?] Your Folder send koro:${N}\n"
  printf "${W}> ${N}"
  read -r raw_dir
  local dir target sel n i e base
  dir="$(clean_path "$raw_dir")"
  if [ -f "$dir" ]; then
    attack_file "$dir"
    return
  fi
  if [ ! -d "$dir" ]; then
    printf "${R}[X] Folder pacchi na: %s${N}\n" "$dir"
    return
  fi

  while true; do
    local -a entries=()
    while IFS= read -r e; do entries+=("$e"); done < <(find "$dir" -maxdepth 1 -mindepth 1 | LC_ALL=C sort)
    local ndir=0 nfile=0 nzip=0 n7z=0
    for e in "${entries[@]}"; do
      if [ -d "$e" ]; then ndir=$((ndir + 1));
      else
        nfile=$((nfile + 1))
        case "$(printf '%s' "$e" | tr 'A-Z' 'a-z')" in
          *.zip) nzip=$((nzip + 1)) ;;
          *.7z)  n7z=$((n7z + 1)) ;;
        esac
      fi
    done

    printf "\n${C}📂 Folder: %s${N}\n" "$dir"
    printf "${Y}   Folder: %s ta · File: %s ta · ZIP: %s ta · 7Z: %s ta${N}\n" "$ndir" "$nfile" "$nzip" "$n7z"
    printf "${C}--------------------------------------------${N}\n"
    if [ "${#entries[@]}" -eq 0 ]; then
      printf "${Y}   (folder faka)${N}\n"
    fi
    i=0
    for e in "${entries[@]}"; do
      i=$((i + 1))
      base="$(basename "$e")"
      if [ -d "$e" ]; then
        printf "${W}  %s.${N} 📁 %s/\n" "$i" "$base"
      elif is_archive_name "$base"; then
        printf "${W}  %s.${N} 🔓 %s\n" "$i" "$base"
      else
        printf "${W}  %s.${N} 📄 %s\n" "$i" "$base"
      fi
    done
    printf "${C}--------------------------------------------${N}\n"
    printf "${Y}  0 = Uporer folder · M = Main menu${N}\n"
    printf "${C}[?] Number daw (file select korte): ${N}"
    read -r sel
    case "$sel" in
      m|M) return ;;
      0) dir="$(dirname "$dir")" ;;
      ''|*[!0-9]*) printf "${R}[X] Vul input.${N}\n"; sleep 1 ;;
      *)
        if [ "$sel" -ge 1 ] && [ "$sel" -le "${#entries[@]}" ]; then
          target="${entries[$((sel - 1))]}"
          if [ -d "$target" ]; then
            dir="$target"
          else
            if ! is_archive_name "$(basename "$target")"; then
              printf "${Y}[!] Eta archive file nao hote pare — tobuo attack chalacchi.${N}\n"
            fi
            attack_file "$target"
            return
          fi
        else
          printf "${R}[X] List-e ei number nai.${N}\n"
          sleep 1
        fi
        ;;
    esac
  done
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
        browse_and_attack
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
