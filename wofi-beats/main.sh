#!/bin/bash

mDIR="$HOME/Music/"
iDIR="$HOME/.config/swaync/icons" # Use your own icon directory
wofi_base_cmd="wofi -d -W 600 -H 400 -i -M fuzzy -n"

# test url stations before adding with script below
# mpv --input-ipc-server=/tmp/mpvsock --shuffle --vid=no "test here"
declare -A online_music=(
	# ["FM - Easy Rock - Baguio 91.9 📻🎶"]="https://radio-stations-philippines.com/easy-rock-baguio"
	# ["FM - Easy Rock 96.3 📻🎶"]="https://radio-stations-philippines.com/easy-rock"
	# ["FM - Fresh Philippines 📻🎶"]="https://onlineradio.ph/553-fresh-fm.html"
	# ["FM - Love Radio 90.7 📻🎶"]="https://radio-stations-philippines.com/love"
	# ["FM - WRock - CEBU 96.3 📻🎶"]="https://onlineradio.ph/126-96-3-wrock.html"
	# ["YT - Korean Drama OST 📹🎶"]="https://youtube.com/playlist?list=PLUge_o9AIFp4HuA-A3e3ZqENh63LuRRlQ"
	# ["YT - Wish 107.5 YT Pinoy HipHop 📻🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJnmgMYwCKid4XIFqUKBVWEs&si=vahW_noh4UDJ5d37"
	["FM - 96.5 The Crab 📻🎶"]="http://centova.rockhost.com:8054/locals"
	["FM - WGMP 104.9 The Gump 📻🎶"]="https://ice9.securenetsystems.net/WGMP"
	["Radio - Chillhop 🎧🎶"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
	["Radio - Deep Space Chill 🎧🎶"]="http://stream.radioinfoweb.net:8000/chill"
	["Radio - Ibiza Global 🎧🎶"]="https://filtermusic.net/ibiza-global"
	["Radio - Lofi Girl 🎧🎶"]="https://play.streamafrica.net/lofiradio"
	["Radio - Metal Music 🎧🎶"]="https://tunein.com/radio/mETaLmuSicRaDio-s119867/"
	["Radio - Pure EDM Radio 🎧🎶"]="http://qa.torontocast.com:1170/"
	["Radio - RADIO BOB! 90er Rock 🎧🎶"]="http://streams.radiobob.de/bob-90srock/aac-64/mediaplayer"
	["Radio - Radio-Classic-Rock.com 🎧🎶"]="https://my.streamingmedia.it/listen/radioclassicrock/radio.mp3"
	["YT - Relaxing Piano Jazz Music 🎹🎶"]="https://youtu.be/85UEqRat6E4?si=jXQL1Yp2VP_G6NSn"
	["YT - Relaxing Piano Music 🎹🎶"]="https://youtu.be/6H7hXzjFoVU?si=nZTPREC9lnK1JJUG"
	["YT - Relaxing Water Music 🎹🎶"]="https://www.youtube.com/playlist?list=PLdQSlyIXgng2cirdWGHWsUQPwqI6x09n7"
	["YT - Remix Hard 📹🎶"]="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"
	["YT - Remix Medium 📹🎶"]="https://www.youtube.com/playlist?list=PLCdUAPSlbjWor2_y5-MesR-SlYSxPfABE"
	["YT - Remix Soft 📹🎶"]="https://www.youtube.com/playlist?list=PLLvHklUmDlPsjZTug1zUZwQFGsg6dg39s"
	["YT - Wish 107.5 YT Wishclusives 📹🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJn5B22H9HOWP3Kxxs-DkPSM&si=d_Ld2OKhGvpH48WO"
	["YT - Youtube Top 100 Songs Global 📹🎶"]="https://youtube.com/playlist?list=PL4fGSI1pDJn6puJdseH2Rt9sMvt9E2M4i&si=5jsyfqcoUXBCSLeu"
	["YT - lofi hip hop radio beats 📹🎶"]="https://www.youtube.com/live/jfKfPfyJRdk?si=PnJIA9ErQIAw6-qd"
)

# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
	local_music=()
	filenames=()
	while IFS= read -r file; do
		local_music+=("$file")
		filenames+=("$(basename "$file")")
	done < <(find -L "$mDIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.mp4" \))
}

notification() {
	notify-send -e -u normal -i "$iDIR/music.png" "Now Playing:" "$@"
}

play_local_music() {
	populate_local_music
	choice=$(printf "%s\n" "${filenames[@]}" | $wofi_base_cmd --prompt "🎵 Local Music")
	[ -z "$choice" ] && exit 1

	for ((i = 0; i < "${#filenames[@]}"; ++i)); do
		if [ "${filenames[$i]}" = "$choice" ]; then
			notification "$choice"
			mpv --input-ipc-server=/tmp/mpvsock --playlist-start="$i" --loop-playlist --vid=no "${local_music[@]}"
			break
		fi
	done
}

shuffle_local_music() {
	notification "Shuffle Play local music"
	mpv --input-ipc-server=/tmp/mpvsock --shuffle --loop-playlist --vid=no "$mDIR"
}

play_online_music() {
	choice=$(for label in "${!online_music[@]}"; do echo "$label"; done | sort | $wofi_base_cmd --prompt "🌐 Online Radio")
	[ -z "$choice" ] && exit 1

	notification "$choice"
	mpv --input-ipc-server=/tmp/mpvsock --shuffle --vid=no "${online_music[$choice]}" &

	# show current track after music starts
	sleep 3
	SOCK="/tmp/mpvsock"
	# Get current song title
	SONG_INFO=$(echo '{ "command": ["get_property", "media-title"] }' | socat - $SOCK)

	# Extract title from JSON
	TITLE=$(echo "$SONG_INFO" | grep -oP '"data":\s*"\K[^"]+')
	notify-send -e "▶️🎵 Next Song '$TITLE'"
}

# If MPV is running, stop it
# just play online music
pkill mpv && notify-send -e -u low -i "$iDIR/music.png" "Music stopped" || play_online_music {
# replace above with below if you wan to play local storage music
# pkill mpv && notify-send -e -u low -i "$iDIR/music.png" "Music stopped" || {
# 	main_choice=$(printf "Play from Online Stations\nPlay from Music directory\nShuffle Play from Music directory" | $wofi_base_cmd --prompt "🎶 Music Source")
#
# 	case "$main_choice" in
# 	"Play from Music directory") play_local_music ;;
# 	"Play from Online Stations") play_online_music ;;
# 	"Shuffle Play from Music directory") shuffle_local_music ;;
# 	*) echo "Invalid choice" ;;
# 	esac
# }
