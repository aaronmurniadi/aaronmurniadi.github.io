# Markdown to HTML Converter

A simple Python script that converts Markdown files to static HTML pages.

## Features

- Converts Markdown files to HTML
- Uses Jinja2 templates for customizable styling
- Preserves directory structure
- Supports code syntax highlighting, tables, and more
- Supports external CSS files

## Setup

1. Create a virtual environment (optional but recommended):
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

1. Place your Markdown files in the `content` directory
2. Customize CSS in the `static/css` directory
3. Run the script:
   ```bash
   python md_to_html.py
   ```

4. Find your generated HTML files in the `output` directory

### Command Line Options

- `-i`, `--input_dir`: Specify input directory (default: `content`)
- `-o`, `--output_dir`: Specify output directory (default: `output`)
- `-t`, `--template`: Specify HTML template file (default: `templates/default.html`)
- `-s`, `--static_dir`: Specify static files directory (default: `static`)

Example:
```bash
python md_to_html.py --input_dir my_markdown --output_dir my_website
```

## Customization

### Templates

You can customize the HTML output by modifying the template in `templates/default.html`.
The template uses Jinja2 syntax with variables:

- `{{ title }}`: The page title (extracted from the first # heading)
- `{{ content }}`: The converted HTML content

### CSS

CSS styles are stored in `static/css/style.css` and are automatically copied to the output directory.
You can modify this file to customize the appearance of your generated HTML.

## License

MIT 