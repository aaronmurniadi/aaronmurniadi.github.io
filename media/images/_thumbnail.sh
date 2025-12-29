#!/bin/bash

# Directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Output directory
THUMBNAIL_DIR="$DIR/thumbnail"

# Create the thumbnail directory if it doesn't exist
mkdir -p "$THUMBNAIL_DIR"

# Supported image extensions (add or remove as needed)
EXTENSIONS=("jpg" "jpeg" "png" "gif" "tiff" "JPG" "JPEG" "PNG" "GIF" "TIFF")

# Set up a flag for interruption
INTERRUPTED=0

# Handler for SIGINT (Ctrl+C)
trap 'echo "Interrupted! Exiting..."; INTERRUPTED=1' SIGINT

# Loop through each supported image type in the current directory
for ext in "${EXTENSIONS[@]}"; do
  for img in "$DIR"/*.$ext; do
    # Skip if no files matching the pattern exist
    [ -e "$img" ] || continue

    # Break out of loops if interrupted
    if [ "$INTERRUPTED" -eq 1 ]; then
      break 2
    fi

    # Get filename without directory
    filename=$(basename "$img")
    # Output path
    outpath="$THUMBNAIL_DIR/$filename"

    # Create thumbnail (max 500px, keeping aspect ratio)
    # Uses ImageMagick 'convert'
    magick "$img" -resize '800x800>' "$outpath"
    echo "Created thumbnail: $outpath"
  done
done

