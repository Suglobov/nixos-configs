#!/usr/bin/env bash

apply_color() {
	if [[ "$1" == 0 ]]; then
		noctalia-shell ipc call colorScheme set "English"
	else
		noctalia-shell ipc call colorScheme set "Russian"
	fi
}
# Первоначальный запуск
LAUNCH_LAYOUT=$(niri msg keyboard-layouts | grep '^\s*\* ' | sed 's/[^0-9]*//g')
apply_color "$LAUNCH_LAYOUT"
# Читаем поток событий напрямую (без subshell)
while read -r line; do
	if [[ "$line" == *"Keyboard layout switched:"* ]]; then
		EVENT_LAYOUT="${line//[^0-9]/}"
		apply_color "$EVENT_LAYOUT"
	fi
done < <(niri msg event-stream)
