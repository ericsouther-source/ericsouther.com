#!/usr/bin/env bash
# Build web-ready looping GIF previews from source video.
#
#   1. put source files in previews/source/ named <slug>.<ext>  e.g. shambala.mov
#   2. optional: previews/source/shots.txt lines of  slug|start|duration
#      to pick the moment, e.g.  shambala|00:01:12|4
#      no entry = 4 seconds starting 10% into the file
#   3. bash previews/make-gifs.sh
#
# Two-pass palette method: generate a palette from the clip, then apply it.
# A single-pass GIF is limited to a generic 256-colour web palette and will
# band badly on video synthesis work. This keeps the colour.

set -euo pipefail
cd "$(dirname "$0")"
mkdir -p gifs
FPS=${FPS:-12}
WIDTH=${WIDTH:-640}
COLORS=${COLORS:-160}

shopt -s nullglob
for f in source/*.{mov,MOV,mp4,MP4,m4v,avi,mkv,webm}; do
  slug=$(basename "$f"); slug="${slug%.*}"
  start=""; dur=4
  if [[ -f source/shots.txt ]]; then
    line=$(grep -i "^${slug}|" source/shots.txt || true)
    if [[ -n "$line" ]]; then
      start=$(echo "$line" | cut -d'|' -f2)
      dur=$(echo "$line" | cut -d'|' -f3)
    fi
  fi
  if [[ -z "$start" ]]; then
    total=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f" | cut -d. -f1)
    start=$(( total / 10 ))
  fi

  echo "==> $slug  (from ${start}, ${dur}s)"
  filt="fps=${FPS},scale=${WIDTH}:-1:flags=lanczos"
  ffmpeg -v error -y -ss "$start" -t "$dur" -i "$f" \
    -vf "${filt},palettegen=max_colors=${COLORS}:stats_mode=diff" /tmp/pal_$slug.png
  ffmpeg -v error -y -ss "$start" -t "$dur" -i "$f" -i /tmp/pal_$slug.png \
    -lavfi "${filt}[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3:diff_mode=rectangle" \
    -loop 0 "gifs/${slug}.gif"
  echo "    $(du -h "gifs/${slug}.gif" | cut -f1)  gifs/${slug}.gif"
done
echo
echo "Done. Anything over ~3MB: lower FPS or WIDTH, e.g.  FPS=10 WIDTH=520 bash previews/make-gifs.sh"
