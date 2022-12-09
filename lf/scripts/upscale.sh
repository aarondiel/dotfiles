#!/bin/sh

set -Cef

IFS=$(printf '\n+')
IFS=${IFS%+}

files="$1"
scale="${2:-2}"
noise_level="${3:-0}"

for file in $files
do
	directory="${file%/*}"

	name="${file##*/}"
	name="${name%.*}"
	name="${name} - upscaled.webp"

	waifu2x-ncnn-vulkan \
		-f webp \
		-s "$scale" \
		-n "$noise" \
		-i "$file" \
		-o "${directory}/${name}"
done
