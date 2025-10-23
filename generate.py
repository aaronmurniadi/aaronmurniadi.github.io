#!/usr/bin/env python3
"""
Static Blog Generator - Simplified
Converts Markdown files to HTML with watching support
"""

import re
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional

import markdown
import yaml
from jinja2 import Environment, FileSystemLoader
from rcssmin import cssmin
from rjsmin import jsmin
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

try:
    from PIL import Image
    PILLOW_AVAILABLE = True
except ImportError:
    print("Warning: Pillow not installed. Thumbnail generation will be skipped.")
    print("Install with: pip install Pillow")
    PILLOW_AVAILABLE = False

# Configuration
SRC_DIR = Path("src")
DOCS_DIR = Path("docs")
TEMPLATES_DIR = Path("src/templates")
BASE_URL = "https://aaronmurniadi.github.io"


def format_date(dt: Optional[datetime]) -> str:
    """Format datetime as '4th September 2019'."""
    if not dt:
        return ""
    day = dt.day
    suffix = "th" if 11 <= day <= 13 else {1: "st", 2: "nd", 3: "rd"}.get(day % 10, "th")
    return f"{day}{suffix} {dt.strftime('%B %Y')}"


@dataclass
class Post:
    """Blog post representation."""
    path: Path
    title: str
    slug: str
    category: str
    metadata: Dict[str, Any]
    content_md: str
    date: Optional[datetime] = None
    
    @property
    def url_path(self) -> str:
        return f"{self.category}/{self.slug}.html" if self.category != "blog" else f"{self.slug}.html"


class BlogGenerator:
    """Main blog generator class."""
    
    def __init__(self):
        self.md = markdown.Markdown(
            extensions=[
                "markdown.extensions.fenced_code",
                "markdown.extensions.tables",
                "markdown.extensions.toc",
                "markdown.extensions.footnotes",
                "markdown.extensions.codehilite",
                "markdown.extensions.nl2br",
            ],
            extension_configs={"codehilite": {"css_class": "highlight"}}
        )
        self.jinja_env = Environment(loader=FileSystemLoader(TEMPLATES_DIR))
        self.jinja_env.globals["format_date"] = format_date
        self.posts: List[Post] = []
        self.nav_links: List[Dict[str, str]] = []
    
    def parse_frontmatter(self, content: str) -> tuple[Dict[str, Any], str]:
        """Parse YAML frontmatter from markdown."""
        content = content.strip()
        if not content.startswith("---"):
            return {}, content
        try:
            parts = content.split("---", 2)
            if len(parts) < 3:
                return {}, content
            metadata = yaml.safe_load(parts[1]) or {}
            return metadata, parts[2].strip()
        except Exception:
            return {}, content
    
    def parse_date(self, metadata: Dict[str, Any], file_path: Path) -> Optional[datetime]:
        """Parse date from metadata or file modification time."""
        date_val = metadata.get("date")
        
        # Handle datetime object
        if isinstance(date_val, datetime):
            return date_val
            
        # Handle date object (convert to datetime)
        if hasattr(date_val, 'year') and hasattr(date_val, 'month') and hasattr(date_val, 'day'):
            return datetime(date_val.year, date_val.month, date_val.day)
            
        # Handle string date
        if isinstance(date_val, str):
            try:
                return datetime.strptime(date_val, "%Y-%m-%d")
            except ValueError:
                # Try other common date formats
                for fmt in ["%Y-%m-%d", "%d-%m-%Y", "%m-%d-%Y", "%Y/%m/%d"]:
                    try:
                        return datetime.strptime(date_val, fmt)
                    except ValueError:
                        continue
        
        # Extract date from filename if it follows the YYYY-MM-DD-* pattern
        filename = file_path.stem
        date_match = re.match(r"(\d{4}-\d{2}-\d{2})-", filename)
        if date_match:
            try:
                return datetime.strptime(date_match.group(1), "%Y-%m-%d")
            except ValueError:
                pass
        
        # Use file modification time as last fallback
        return datetime.fromtimestamp(file_path.stat().st_mtime)
    
    def load_posts(self) -> None:
        """Load all markdown posts."""
        content_dir = SRC_DIR / "content"
        if not content_dir.exists():
            return
        
        posts = []
        for md_file in content_dir.rglob("*.md"):
            if md_file.name == "index.md":
                continue
            
            with open(md_file, "r", encoding="utf-8") as f:
                metadata, md_content = self.parse_frontmatter(f.read())
            
            relative_path = md_file.relative_to(content_dir)
            category = relative_path.parent.name if relative_path.parent != Path(".") else "blog"
            slug = md_file.stem
            
            post = Post(
                path=md_file,
                title=metadata.get("title", slug.replace("-", " ").title()),
                slug=slug,
                category=category,
                metadata=metadata,
                content_md=md_content,
                date=self.parse_date(metadata, md_file)
            )
            posts.append(post)
        
        self.posts = sorted(posts, key=lambda p: p.date or datetime.min, reverse=True)
    
    def generate_nav_links(self) -> None:
        """Generate navigation from page directories."""
        self.nav_links = [{"name": "Home", "url": "index.html"}]
        page_dir = SRC_DIR / "page"
        if page_dir.exists():
            for subdir in sorted(page_dir.iterdir()):
                if subdir.is_dir() and (subdir / "index.md").exists():
                    self.nav_links.append({
                        "name": subdir.name.replace("_", " ").title(),
                        "url": f"{subdir.name}/index.html"
                    })
    
    def process_post_list(self, content: str, category: Optional[str]) -> str:
        """Replace {{ posts|tag:tagname }} with post list."""
        pattern = r"\{\{\s*posts\|tag:([^}]+)\s*\}\}"
        
        def replace(match):
            tag = match.group(1).strip()
            filtered = [p for p in self.posts if tag in (p.metadata.get("tags") or [])]
            
            if not filtered:
                return f"*No posts with tag '{tag}'*"
            
            items = []
            for post in filtered:
                url = self.get_relative_url(post, category)
                date_str = format_date(post.date)
                items.append(f"<tr><td class='post-date'>{date_str}</td>"
                           f"<td class='post-title'><a href='{url}'>{post.title}</a></td></tr>")
            
            return f"<table class='post-list-table'>{''.join(items)}</table>"
        
        return re.sub(pattern, replace, content)
    
    def get_relative_url(self, post: Post, current_category: Optional[str]) -> str:
        """Calculate relative URL for a post."""
        if not current_category:
            return post.url_path
        if post.category == current_category:
            return f"{post.slug}.html"
        return f"../{post.url_path}"
    
    def render_post(self, post: Post) -> str:
        """Render a single post page."""
        template = self.jinja_env.get_template("post.html")
        self.md.reset()
        post_html = self.md.convert(post.content_md)
        
        # Get prev/next posts
        try:
            idx = self.posts.index(post)
            prev_post = self.posts[idx + 1] if idx < len(self.posts) - 1 else None
            next_post = self.posts[idx - 1] if idx > 0 else None
        except ValueError:
            prev_post = next_post = None
        
        return template.render(
            post=post,
            content_html=post_html,
            nav_links=self.nav_links,
            current_category=post.category if post.category != "blog" else None,
            prev_post=prev_post,
            next_post=next_post
        )
    
    def render_index(self, category: Optional[str] = None) -> str:
        """Render index page."""
        template = self.jinja_env.get_template("index.html")
        
        # Load index.md content
        index_file = (SRC_DIR / "page" / category / "index.md" if category 
                     else SRC_DIR / "index.md")
        
        index_html = ""
        if index_file.exists():
            with open(index_file, "r", encoding="utf-8") as f:
                metadata, md_content = self.parse_frontmatter(f.read())
            md_content = self.process_post_list(md_content, category)
            self.md.reset()
            index_html = self.md.convert(md_content)
        
        # Get gallery items for typst-collection
        gallery_items = None
        if category == "typst-collection":
            gallery_items = self.get_typst_gallery()
        
        return template.render(
            nav_links=self.nav_links,
            page_title=f"{category.title()} - Aaron PM" if category else "Aaron PM",
            current_category=category,
            index_content_html=index_html,
            gallery_items=gallery_items
        )
    
    def get_typst_gallery(self) -> List[Dict[str, Optional[str]]]:
        """Get Typst gallery data."""
        typst_src = SRC_DIR / "page" / "typst-collection"
        if not typst_src.exists():
            return []
        
        items = []
        for typ_file in typst_src.rglob("*.typ"):
            if "maid_of_orleans" in typ_file.parts and typ_file.name != "main.typ":
                continue
            
            png_name = typ_file.with_suffix(".png").name
            pdf_name = typ_file.with_suffix(".pdf").name
            
            title = (typ_file.parent.name.replace("_", " ").title() 
                    if "maid_of_orleans" in typ_file.parts 
                    else typ_file.stem.replace("_", " ").title())
            
            items.append({
                "title": title,
                "thumbnail_path": png_name,
                "pdf_path": pdf_name,
                "typ_path": f"https://github.com/aaronmurniadi/typst-collection/blob/main/{typ_file.relative_to(typst_src)}",
                "filename": pdf_name
            })
        
        return items
    
    def compile_typst(self) -> None:
        """Compile Typst files to PNG and PDF."""
        typst_src = SRC_DIR / "page" / "typst-collection"
        if not typst_src.exists():
            return
        
        typst_docs = DOCS_DIR / "typst-collection"
        typst_docs.mkdir(parents=True, exist_ok=True)
        
        for typ_file in typst_src.rglob("*.typ"):
            if "maid_of_orleans" in typ_file.parts and typ_file.name != "main.typ":
                continue
            
            png_path = typst_docs / typ_file.with_suffix(".png").name
            pdf_path = typst_docs / typ_file.with_suffix(".pdf").name
            typ_mtime = typ_file.stat().st_mtime
            
            # Compile PNG if needed
            if not png_path.exists() or typ_mtime > png_path.stat().st_mtime:
                print(f"Generating PNG: {typ_file.name}")
                try:
                    subprocess.run(
                        ["typst", "compile", str(typ_file), "--format=png", 
                         "--pages=1", str(png_path)],
                        capture_output=True, check=True, timeout=30
                    )
                except Exception as e:
                    print(f"Failed to generate PNG: {e}")
            
            # Compile PDF if needed
            if not pdf_path.exists() or typ_mtime > pdf_path.stat().st_mtime:
                print(f"Generating PDF: {typ_file.name}")
                try:
                    subprocess.run(
                        ["typst", "compile", str(typ_file), str(pdf_path)],
                        capture_output=True, check=True, timeout=30
                    )
                except Exception as e:
                    print(f"Failed to generate PDF: {e}")
    
    def generate_thumbnail(self, image_path: Path, output_path: Path, max_size: int = 800) -> None:
        """Generate a thumbnail for an image."""
        if not PILLOW_AVAILABLE:
            return
            
        try:
            # Always generate the thumbnail, overwriting any existing one
            print(f"Generating thumbnail for {image_path.name}...")
                
            # Open the image
            with Image.open(image_path) as img:
                # Calculate new dimensions while maintaining aspect ratio
                width, height = img.size
                if width > height:
                    new_width = max_size
                    new_height = int(height * (max_size / width))
                else:
                    new_height = max_size
                    new_width = int(width * (max_size / height))
                
                # Resize the image
                resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                
                # Save the thumbnail
                resized_img.save(output_path, quality=85, optimize=True)
                print(f"Generated thumbnail: {output_path}")
        except Exception as e:
            print(f"Error generating thumbnail for {image_path}: {e}")

    def generate_sitemap(self) -> None:
        """Generate sitemap.xml for search engines."""
        print("Generating sitemap.xml...")
        
        # Start XML content
        xml_content = [
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
        ]
        
        # Add homepage
        xml_content.append(f'  <url>\n    <loc>{BASE_URL}/</loc>\n    <priority>1.0</priority>\n  </url>')
        
        # Add all posts
        for post in self.posts:
            url = f"{BASE_URL}/{post.url_path}"
            lastmod = post.date.strftime("%Y-%m-%d") if post.date else datetime.now().strftime("%Y-%m-%d")
            
            xml_content.append(f'  <url>')
            xml_content.append(f'    <loc>{url}</loc>')
            xml_content.append(f'    <lastmod>{lastmod}</lastmod>')
            xml_content.append(f'    <priority>0.8</priority>')
            xml_content.append(f'  </url>')
        
        # Add category pages
        page_dir = SRC_DIR / "page"
        if page_dir.exists():
            for subdir in page_dir.iterdir():
                if subdir.is_dir() and (subdir / "index.md").exists():
                    category = subdir.name
                    url = f"{BASE_URL}/{category}/"
                    
                    xml_content.append(f'  <url>')
                    xml_content.append(f'    <loc>{url}</loc>')
                    xml_content.append(f'    <priority>0.9</priority>')
                    xml_content.append(f'  </url>')
        
        # Close XML
        xml_content.append('</urlset>')
        
        # Write to file
        sitemap_path = DOCS_DIR / "sitemap.xml"
        sitemap_path.write_text('\n'.join(xml_content), encoding="utf-8")
        print(f"Generated: {sitemap_path}")

    def build(self) -> None:
        """Build the entire site."""
        print("Building blog...")
        DOCS_DIR.mkdir(exist_ok=True)
        
        # Compile Typst files
        self.compile_typst()
        
        # Load content
        self.load_posts()
        self.generate_nav_links()
        print(f"Found {len(self.posts)} posts")
        
        # Create category directories
        page_dir = SRC_DIR / "page"
        if page_dir.exists():
            for subdir in page_dir.iterdir():
                if subdir.is_dir() and subdir.name != "typst-collection":
                    (DOCS_DIR / subdir.name).mkdir(exist_ok=True)
        
        # Render posts
        for post in self.posts:
            html = self.render_post(post)
            output_path = DOCS_DIR / post.url_path
            output_path.parent.mkdir(parents=True, exist_ok=True)
            output_path.write_text(html, encoding="utf-8")
            print(f"Generated: {output_path}")
        
        # Render main index
        (DOCS_DIR / "index.html").write_text(self.render_index(), encoding="utf-8")
        print("Generated: index.html")
        
        # Render category indexes
        if page_dir.exists():
            for subdir in page_dir.iterdir():
                if subdir.is_dir() and (subdir / "index.md").exists():
                    category = subdir.name
                    html = self.render_index(category)
                    index_path = DOCS_DIR / category / "index.html"
                    index_path.write_text(html, encoding="utf-8")
                    print(f"Generated: {index_path}")
        
        # Copy static files and minify CSS/JS
        src_static = SRC_DIR / "static"
        if src_static.exists():
            docs_static = DOCS_DIR / "static"
            docs_static.mkdir(exist_ok=True)
            
            # First, recursively copy all directories
            for item in src_static.rglob('*'):
                if item.is_dir():
                    relative_path = item.relative_to(src_static)
                    target_dir = docs_static / relative_path
                    target_dir.mkdir(exist_ok=True)
                    print(f"Created directory: {target_dir}")
            
            # Then copy all files
            for file in src_static.rglob('*'):
                if file.is_file():
                    relative_path = file.relative_to(src_static)
                    dest_file = docs_static / relative_path
                    dest_file.parent.mkdir(exist_ok=True)
                    
                    # Copy the file
                    shutil.copy2(file, dest_file)
                    print(f"Copied: {file} -> {dest_file}")
                    
                    # Generate thumbnails for images in the photos directory
                    if PILLOW_AVAILABLE and "photos" in file.parts and file.suffix.lower() in ['.jpg', '.jpeg', '.png', '.gif']:
                        # Skip if the filename already contains "_thumbnail"
                        if "_thumbnail" in file.stem:
                            continue
                            
                        # Create thumbnail filename
                        thumbnail_name = file.stem + "_thumbnail" + file.suffix
                        thumbnail_path = file.parent / thumbnail_name
                        dest_thumbnail_path = dest_file.parent / thumbnail_name
                        
                        # Only generate thumbnails for files in the src directory
                        if str(file).startswith(str(SRC_DIR)):
                            # Generate the thumbnail
                            self.generate_thumbnail(file, thumbnail_path, max_size=800)
                            
                            # Copy the thumbnail to docs directory
                            if thumbnail_path.exists():
                                shutil.copy2(thumbnail_path, dest_thumbnail_path)
                                print(f"Copied thumbnail: {thumbnail_path} -> {dest_thumbnail_path}")
                    
                    # Minify CSS and JS files (only at the top level)
                    if file.parent == src_static:
                        if file.name == "style.css" or file.name.endswith(".css"):
                            print(f"Minifying CSS: {file.name}")
                            with open(dest_file, "r", encoding="utf-8") as f:
                                content = f.read()
                            minified = cssmin(content)
                            with open(dest_file, "w", encoding="utf-8") as f:
                                f.write(minified)
                        elif file.name == "script.js" or (file.name.endswith(".js") and file.name != "service-worker.js"):
                            print(f"Minifying JS: {file.name}")
                            with open(dest_file, "r", encoding="utf-8") as f:
                                content = f.read()
                            minified = jsmin(content)
                            with open(dest_file, "w", encoding="utf-8") as f:
                                f.write(minified)
                        elif file.name == "service-worker.js":
                            print(f"Copying service worker: {file.name}")
                            # Service worker is copied as-is to maintain readability and functionality
        
        # Generate sitemap.xml
        self.generate_sitemap()
        
        print("Build complete!")
    

if __name__ == "__main__":
    """Build once."""
    generator = BlogGenerator()
    generator.build()
