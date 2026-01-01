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

shopt -s nullglob
for typfile in *.typ; do
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
