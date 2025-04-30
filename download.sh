#!/bin/bash

# === Configuration ===

# Default placeholder formats (W x H)
all_formats=(
  "640x480" "800x600" "1024x768" "1280x720" "1280x800"
  "1366x768" "1440x900" "1600x900" "1920x1080" "2560x1440" "3840x2160"
  "500x500" "800x800" "1080x1080"
  "720x1280" "1080x1350" "1080x1920"
  "1200x628" "1080x566"
)

avatar_sizes=(64 128 256 512 800)

# Number of images per type/format
num_images=10

# Base directories
placeholder_dir="placeholders"
avatar_dir="avatars"

# === Functions ===

download_placeholders() {
  echo "▶️ Downloading placeholder images..."

  for format in "${selected_formats[@]}"; do
    width=${format%x*}
    height=${format#*x}

    # Determine suffix
    if [[ $width -eq $height ]]; then
      suffix="_square"
    elif [[ $width -lt $height ]]; then
      suffix="_portrait"
    else
      suffix="_landscape"
    fi

    dir="${placeholder_dir}/${format}${suffix}"
    mkdir -p "$dir"

    for i in $(seq 1 $num_images); do
      curl -sL "https://picsum.photos/${width}/${height}?random=${RANDOM}" -o "${dir}/image_${i}.jpg"
    done

    echo "📁 $dir: $num_images images downloaded."
  done
}

download_avatars() {
  echo "▶️ Downloading avatar images from Pravatar..."

  for size in "${avatar_sizes[@]}"; do
    subdir="${avatar_dir}/${size}x${size}"
    mkdir -p "$subdir"
    for i in $(seq 1 $num_images); do
      curl -sL "https://i.pravatar.cc/${size}?u=$RANDOM" -o "${subdir}/avatar_${i}.jpg"
    done
    echo "📁 $subdir: $num_images avatars downloaded."
  done
}

choose_formats_menu() {
  echo "📐 Select a format profile:"
  echo "  1) Web (landscape)"
  echo "  2) Mobile (portrait)"
  echo "  3) Square"
  echo "  4) All"
  echo "  5) Manual selection"
  echo -n "Enter your choice [1-5]: "
  read -r profile_choice

  case $profile_choice in
    1)
      selected_formats=(
        "640x480" "800x600" "1024x768" "1280x720" "1280x800"
        "1366x768" "1440x900" "1600x900" "1920x1080"
      )
      ;;
    2)
      selected_formats=(
        "720x1280" "1080x1350" "1080x1920"
      )
      ;;
    3)
      selected_formats=(
        "500x500" "800x800" "1080x1080"
      )
      ;;
    4)
      selected_formats=("${all_formats[@]}")
      ;;
    5)
      echo "📋 Manual selection:"
      for i in "${!all_formats[@]}"; do
        printf "%2d. %s\n" $((i + 1)) "${all_formats[$i]}"
      done
      echo -n "Enter format numbers (e.g. 1 3 8): "
      read -r input
      for idx in $input; do
        if [[ $idx =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#all_formats[@]} )); then
          selected_formats+=("${all_formats[$((idx - 1))]}")
        else
          echo "❌ Invalid format number: $idx"
        fi
      done
      ;;
    *)
      echo "❌ Invalid choice."
      exit 1
      ;;
  esac

  if [[ ${#selected_formats[@]} -eq 0 ]]; then
    echo "⚠️ No formats selected. Exiting."
    exit 1
  fi
}

# === Parse options ===

only_avatars=false
only_placeholders=false
selected_formats=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --avatar-only)
      only_avatars=true
      ;;
    --placeholder-only)
      only_placeholders=true
      ;;
    *)
      echo "❌ Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# === Execute logic ===

# If we need to download placeholders (either only or both), ask for formats
if [[ $only_avatars == false ]]; then
  choose_formats_menu
fi

# Download as needed
if [[ $only_placeholders == true ]]; then
  download_placeholders
elif [[ $only_avatars == true ]]; then
  download_avatars
else
  download_placeholders
  download_avatars
fi

echo "✅ All downloads completed successfully."