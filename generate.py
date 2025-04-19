#!/usr/bin/env python3
"""
Markdown to HTML converter
A simple script to convert Markdown files to static HTML pages
"""

import os
import re
import sys
import glob
import shutil
import argparse
from pathlib import Path
import markdown
from jinja2 import Template
from PIL import Image
import yaml

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Convert Markdown files to HTML')
    parser.add_argument('-i', '--input_dir', default='content',
                        help='Directory containing markdown files (default: content)')
    parser.add_argument('-o', '--output_dir', default='docs',
                        help='Directory to output HTML files (default: docs)')
    parser.add_argument('-t', '--template', default='templates/default.html',
                        help='HTML template file (default: templates/default.html)')
    parser.add_argument('-s', '--static_dir', default='static',
                        help='Directory containing static files (default: static)')
    return parser.parse_args()

def extract_title(markdown_content):
    """Extract title from markdown content, defaulting to filename if no title found."""
    # Try to find a level 1 heading
    title_match = re.search(r'^#\s+(.+)$', markdown_content, re.MULTILINE)
    if title_match:
        return title_match.group(1)
    return "Untitled Page"

def get_photo_metadata(photo_path):
    """Read metadata from an accompanying YAML file."""
    # Get the photo path without extension
    base_path = os.path.splitext(photo_path)[0]
    # Look for a YAML file with the same name
    yaml_path = f"{base_path}.yaml"
    
    metadata = {}
    
    if os.path.exists(yaml_path):
        try:
            with open(yaml_path, 'r') as yaml_file:
                metadata = yaml.safe_load(yaml_file)
        except Exception as e:
            print(f"Error reading YAML metadata for {photo_path}: {e}")
    
    return metadata

def process_photo_gallery(gallery_dir, output_dir):
    """Process a directory of photos and generate gallery data."""
    # Get supported image extensions
    image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp']
    
    # Create photos directory in output
    photos_output_dir = os.path.join(output_dir, 'photos')
    os.makedirs(photos_output_dir, exist_ok=True)
    
    # Find all image files
    photos = []
    for ext in image_extensions:
        photos.extend(glob.glob(os.path.join(gallery_dir, f'*{ext}'), recursive=False))
        photos.extend(glob.glob(os.path.join(gallery_dir, f'*{ext.upper()}'), recursive=False))
    
    gallery_data = []
    
    for photo_path in photos:
        # Get filename
        filename = os.path.basename(photo_path)
        
        # Copy the photo to output directory
        output_photo_path = os.path.join(photos_output_dir, filename)
        shutil.copy2(photo_path, output_photo_path)
        
        # Get metadata from YAML
        metadata = get_photo_metadata(photo_path)
        
        # Add photo info to gallery data
        photo_info = {
            'filename': filename,
            'path': f"photos/{filename}",
            'metadata': metadata
        }
        
        gallery_data.append(photo_info)
    
    return gallery_data

def get_content_sections(input_dir):
    """Get all subdirectories in the content directory as sections."""
    sections = []
    
    # Get all subdirectories
    for item in os.listdir(input_dir):
        item_path = os.path.join(input_dir, item)
        if os.path.isdir(item_path) and not item.startswith('.'):
            # Only include directories that don't start with a dot
            sections.append({
                'name': item,
                'path': item,
            })
    
    return sections

def convert_markdown_to_html(markdown_content, template_path, site_title, sections):
    """Convert markdown to HTML using the specified template."""
    # Convert markdown to HTML
    html_content = markdown.markdown(
        markdown_content,
        extensions=['fenced_code', 'codehilite', 'tables', 'toc']
    )
    
    # Extract title
    title = extract_title(markdown_content)
    
    # Read template
    with open(template_path, 'r') as f:
        template_content = f.read()
    
    # Render template
    template = Template(template_content)
    rendered_html = template.render(
        title=title, 
        content=html_content, 
        site_title=site_title,
        sections=sections
    )
    
    return rendered_html

def copy_static_files(static_dir, output_dir):
    """Copy static files (CSS, JS, images) to output directory."""
    if not os.path.exists(static_dir):
        print(f"Warning: Static directory '{static_dir}' not found")
        return
    
    # Create css directory in output if it doesn't exist
    css_output_dir = os.path.join(output_dir, 'css')
    os.makedirs(css_output_dir, exist_ok=True)
    
    # Copy CSS files
    css_dir = os.path.join(static_dir, 'css')
    if os.path.exists(css_dir):
        for css_file in glob.glob(os.path.join(css_dir, '*.css')):
            dest_file = os.path.join(css_output_dir, os.path.basename(css_file))
            shutil.copy2(css_file, dest_file)
            print(f"Copied: {css_file} -> {dest_file}")
    
    # Create js directory in output if it doesn't exist
    js_output_dir = os.path.join(output_dir, 'js')
    os.makedirs(js_output_dir, exist_ok=True)
    
    # Copy JavaScript files
    js_dir = os.path.join(static_dir, 'js')
    if os.path.exists(js_dir):
        for js_file in glob.glob(os.path.join(js_dir, '*.js')):
            dest_file = os.path.join(js_output_dir, os.path.basename(js_file))
            shutil.copy2(js_file, dest_file)
            print(f"Copied: {js_file} -> {dest_file}")

def process_markdown_files(input_dir, output_dir, template_path):
    """Process all markdown files in the input directory."""
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)
    
    # Site title configuration
    site_title = "AARON MURNIADI"
    
    # Get content sections for navigation
    sections = get_content_sections(input_dir)
    
    # Special handling for photo gallery
    photos_dir = os.path.join(input_dir, 'photos')
    if os.path.exists(photos_dir):
        gallery_data = process_photo_gallery(photos_dir, output_dir)
        
        # Generate gallery HTML
        gallery_template_path = 'templates/gallery.html'
        if os.path.exists(gallery_template_path):
            with open(gallery_template_path, 'r') as f:
                template_content = f.read()
            
            # Create a gallery index file in content directory if it doesn't exist
            gallery_index_path = os.path.join(photos_dir, 'index.md')
            if not os.path.exists(gallery_index_path):
                with open(gallery_index_path, 'w') as f:
                    f.write("# Photo Gallery\n\nMy photography collection with detailed metadata.\n")
            
            # Read gallery index content
            with open(gallery_index_path, 'r') as f:
                markdown_content = f.read()
            
            # Convert markdown to HTML
            html_content = markdown.markdown(
                markdown_content,
                extensions=['fenced_code', 'codehilite', 'tables', 'toc']
            )
            
            # Extract title
            title = extract_title(markdown_content)
            
            # Render template
            template = Template(template_content)
            rendered_html = template.render(
                title=title,
                content=html_content,
                photos=gallery_data,
                site_title=site_title,
                sections=sections
            )
            
            # Write HTML file
            gallery_output_path = os.path.join(output_dir, 'photos', 'index.html')
            os.makedirs(os.path.dirname(gallery_output_path), exist_ok=True)
            
            with open(gallery_output_path, 'w') as f:
                f.write(rendered_html)
            
            print(f"Generated photo gallery: {gallery_output_path}")
    
    # Find all markdown files
    markdown_files = glob.glob(os.path.join(input_dir, '**', '*.md'), recursive=True)
    
    print(f"Found {len(markdown_files)} markdown files")
    
    for md_file in markdown_files:
        # Skip gallery index if it exists - we've already processed it
        if md_file.endswith(os.path.join('photos', 'index.md')):
            continue
        
        # Determine the output path
        rel_path = os.path.relpath(md_file, input_dir)
        output_path = os.path.join(output_dir, rel_path.replace('.md', '.html'))
        
        # Ensure output subdirectory exists
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # Read markdown content
        with open(md_file, 'r') as f:
            markdown_content = f.read()
        
        # Convert to HTML
        html_content = convert_markdown_to_html(markdown_content, template_path, site_title, sections)
        
        # Write HTML file
        with open(output_path, 'w') as f:
            f.write(html_content)
        
        print(f"Converted: {md_file} -> {output_path}")

def main():
    """Main function."""
    args = parse_arguments()
    
    if not os.path.exists(args.template):
        print(f"Error: Template file '{args.template}' not found")
        sys.exit(1)
    
    if not os.path.exists(args.input_dir):
        print(f"Error: Input directory '{args.input_dir}' not found")
        sys.exit(1)
    
    print(f"Converting markdown files from '{args.input_dir}' to HTML in '{args.output_dir}'")
    
    # Copy static files first
    copy_static_files(args.static_dir, args.output_dir)
    
    # Then process markdown files
    process_markdown_files(args.input_dir, args.output_dir, args.template)
    
    print("Conversion complete!")

if __name__ == "__main__":
    main() 