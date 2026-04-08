echo -e "\e[1;32m🎵 ALOK PLAYER 🎵\e[0m"
echo -e "\e[1;36mMade by Alok 😎\e[0m"#!/data/data/com.termux/files/usr/bin/bash

mkdir -p /sdcard/Music/MyApp

while true
do
clear
echo "🎧 TERMINAL MUSIC PLAYER"
echo "------------------------"
echo "1. 🔍 Search Song"
echo "2. 📂 Downloaded Songs"
echo "3. ❌ Exit"
echo ""

read -p "👉 Choose option: " main

# ================= SEARCH =================
if [ "$main" = "1" ]; then

    echo ""
    read -p "🎵 Enter song name: " song

    echo ""
    echo "🔍 Searching..."

    yt-dlp "ytsearch5:$song" --print "%(title)s" > list.txt

    echo ""
    echo "🎶 Select song:"
    nl list.txt

    echo ""
    read -p "👉 Enter number: " choice

    selected=$(sed "${choice}q;d" list.txt)

    file="/sdcard/Music/MyApp/$selected.mp3"

    echo ""
    echo "🎧 Selected: $selected"
    echo "1. ▶ Play"
    echo "2. ⬇ Download"

    read action

    if [ "$action" = "1" ]; then
        yt-dlp -f bestaudio -o - "ytsearch:$selected" | mpv -

    elif [ "$action" = "2" ]; then
        if [ -f "$file" ]; then
            echo "✅ Already downloaded!"
            mpv "$file"
        else
            echo "⬇ Downloading..."
            yt-dlp -x --audio-format mp3 -o "/sdcard/Music/MyApp/%(title)s.%(ext)s" "ytsearch:$selected"
            mpv "$file"
        fi
    fi

    read -p "Press Enter to continue..."

# ================= DOWNLOADS =================
elif [ "$main" = "2" ]; then

    echo ""
    echo "📂 Downloaded Songs Mode"
    echo "1. ▶ Play All"
    echo "2. 🔀 Shuffle"
    echo "3. 🎵 Select Song"

    read opt

    if [ "$opt" = "1" ]; then
        mpv /sdcard/Music/MyApp/*.mp3

    elif [ "$opt" = "2" ]; then
        mpv --shuffle /sdcard/Music/MyApp/*.mp3

    elif [ "$opt" = "3" ]; then

        files=(/sdcard/Music/MyApp/*.mp3)

        if [ ! -e "${files[0]}" ]; then
            echo "❌ No songs downloaded"
        else
            i=1
            for f in "${files[@]}"; do
                echo "$i. $(basename "$f")"
                ((i++))
            done

            echo ""
            read -p "👉 Enter number: " num
            selected="${files[$((num-1))]}"

            mpv "$selected"
        fi
    fi

    read -p "Press Enter to continue..."

# ================= EXIT =================
elif [ "$main" = "3" ]; then
    echo "Bye 👋"
    break

else
    echo "❌ Invalid option"
    sleep 1
fi

done
