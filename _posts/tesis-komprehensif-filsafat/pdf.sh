find ./ -iname "*.md" -type f -exec sh -c 'pandoc --template template.tex --listings "${0}" -o "${0%.md}.pdf"' {} \;
