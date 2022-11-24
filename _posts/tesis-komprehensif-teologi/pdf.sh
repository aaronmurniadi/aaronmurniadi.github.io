find ./ -iname "*.docx" -type f -exec sh -c 'pandoc --listings "${0}" -o "${0%.md}.md"' {} \;
