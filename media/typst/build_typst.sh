#!/bin/bash

# cd to the directory containing this script
cd "$(dirname "$0")"

# Check for typst command
if ! command -v typst &> /dev/null; then
    echo "Error: typst is not installed or not in PATH."
    exit 1
fi

# Check for magick command (ImageMagick v7+)
if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick 'magick' is not installed or not in PATH."
    exit 1
fi

# Get list of changed .typ files from git (relative to repo root)
# Look for files in media/typst/ directory
changed_typ_files=$(git status --porcelain | grep '^...media/typst/.*\.typ$' | sed 's/^...//' | sed 's|media/typst/||')

# If no changed .typ files, exit early
if [ -z "$changed_typ_files" ]; then
    echo "No .typ files have been changed."
    exit 0
fi

echo "Found changed .typ files: $changed_typ_files"

shopt -s nullglob
for typfile in $changed_typ_files; do
    base="${typfile%.typ}"
    pdffile="${base}.pdf"
    jpgfile="${base}.jpg"

    # Compile .typ to .pdf
    echo "Compiling $typfile to $pdffile"
    typst compile "$typfile" "$pdffile"
    if [ $? -ne 0 ]; then
        echo "Error compiling $typfile"
        continue
    fi

    # Convert first page of pdf to jpg
    echo "Converting first page of $pdffile to $jpgfile"
    magick -density 300 "${pdffile}[0]" -quality 90 "$jpgfile"
    if [ $? -ne 0 ]; then
        echo "Error converting $pdffile to jpg"
        continue
    fi
done
