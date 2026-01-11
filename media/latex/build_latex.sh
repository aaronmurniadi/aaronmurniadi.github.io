#!/bin/bash

# cd to the directory containing this script
cd "$(dirname "$0")"

# Check for tectonic command
if ! command -v tectonic &> /dev/null; then
    echo "Error: tectonic is not installed or not in PATH."
    exit 1
fi

# Check for magick command (ImageMagick v7+)
if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick 'magick' is not installed or not in PATH."
    exit 1
fi

# Create thumbnail directory if it doesn't exist
mkdir -p thumbnail

# Find all directories containing main.tex recursively
find . -name "main.tex" -type f | while read -r main_tex; do
    # Get the directory containing main.tex
    dir=$(dirname "$main_tex")
    # Get the folder name
    folder_name=$(basename "$dir")
    # Define output PDF path
    pdffile="${folder_name}.pdf"
    # Define thumbnail path
    jpgfile="thumbnail/${folder_name}.jpg"

    echo "Processing directory: $dir"
    echo "Compiling $main_tex to $pdffile"

    # Change to the directory containing main.tex and compile
    (cd "$dir" && tectonic main.tex)
    if [ $? -ne 0 ]; then
        echo "Error compiling $main_tex"
        continue
    fi

    # Move the generated PDF to the root directory with folder name
    if [ -f "$dir/main.pdf" ]; then
        mv "$dir/main.pdf" "$pdffile"
        echo "Moved PDF to $pdffile"
    else
        echo "Warning: main.pdf not found in $dir"
        continue
    fi

    # Convert first page of pdf to jpg in thumbnail folder
    echo "Converting first page of $pdffile to $jpgfile"
    magick -density 300 "${pdffile}[0]" -quality 90 "$jpgfile"
    if [ $? -ne 0 ]; then
        echo "Error converting $pdffile to jpg"
        continue
    fi

    echo "Completed processing $folder_name"
done

echo "Build process completed."
