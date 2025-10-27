#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "markdown>=3.4.0",
#     "pymdown-extensions>=10.0.0",
#     "PyYAML>=6.0",
#     "jinja2>=3.1.0",
#     "watchdog>=3.0.0",
#     "rcssmin>=1.2.2",
#     "rjsmin>=1.2.5",
#     "pillow",
# ]
# ///

import re
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Set

import markdown
import yaml
from jinja2 import Environment, FileSystemLoader
from PIL import Image
from rcssmin import cssmin
from rjsmin import jsmin
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

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
        self.changed_files: Set[str] = set()
        self.load_changed_files()
    
    def load_changed_files(self) -> None:
        """Load list of changed files using Git."""
        try:
            # Check if we're in a Git repository
            subprocess.run(
                ["git", "rev-parse", "--is-inside-work-tree"],
                capture_output=True, 
                check=True
            )
            
            # Get list of modified files (including untracked files)
            result = subprocess.run(
                ["git", "ls-files", "--modified", "--others", "--exclude-standard"],
                capture_output=True, 
                text=True, 
                check=False  # Don't raise exception if command fails
            )
            modified_files = result.stdout.strip().split("\n") if result.returncode == 0 else []
            
            # Get list of files with uncommitted changes
            result = subprocess.run(
                ["git", "diff", "--name-only"],
                capture_output=True, 
                text=True, 
                check=False
            )
            diff_files = result.stdout.strip().split("\n") if result.returncode == 0 else []
            
            # Get list of staged files
            result = subprocess.run(
                ["git", "diff", "--cached", "--name-only"],
                capture_output=True, 
                text=True, 
                check=False
            )
            staged_files = result.stdout.strip().split("\n") if result.returncode == 0 else []
            
            # Combine all lists and filter out empty strings
            all_changed = modified_files + diff_files + staged_files
            self.changed_files = set(f for f in all_changed if f)
            
            if self.changed_files:
                print(f"Detected {len(self.changed_files)} changed files")
            else:
                print("No changed files detected, will process all files")
                
        except Exception as e:
            print(f"Error detecting changed files: {e}")
            print("Will process all files")
            # If Git commands fail, assume all files are changed
            self.changed_files = set()
    
    def is_file_modified(self, file_path: Path) -> bool:
        """Check if a file has been modified using Git."""
        # Convert to string path, handling both absolute and relative paths
        if file_path.is_absolute():
            try:
                # Try to make it relative to the current directory
                rel_path = file_path.relative_to(Path.cwd())
                str_path = str(rel_path)
            except ValueError:
                # If that fails, just use the string representation
                str_path = str(file_path)
        else:
            # Already a relative path
            str_path = str(file_path)
        
        # If we couldn't get changed files from Git, assume all files are changed
        if not self.changed_files:
            return True
            
        # Check if the file is in the list of changed files
        return str_path in self.changed_files
    
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
            
            # Check if the file has been modified since last build
            file_modified = self.is_file_modified(md_file)
            
            # Check if the output file exists
            relative_path = md_file.relative_to(content_dir)
            category = relative_path.parent.name if relative_path.parent != Path(".") else "blog"
            slug = md_file.stem
            output_path = DOCS_DIR / (f"{category}/{slug}.html" if category != "blog" else f"{slug}.html")
            
            # If the file hasn't been modified and the output exists, skip processing
            if not file_modified and output_path.exists():
                # Load minimal info for navigation without parsing content
                post = Post(
                    path=md_file,
                    title=slug.replace("-", " ").title(),  # Use a default title
                    slug=slug,
                    category=category,
                    metadata={},
                    content_md="",
                    date=datetime.fromtimestamp(md_file.stat().st_mtime)
                )
                posts.append(post)
                print(f"Skipping unchanged file: {md_file}")
                continue
            
            # Process modified or new files
            with open(md_file, "r", encoding="utf-8") as f:
                metadata, md_content = self.parse_frontmatter(f.read())
            
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
        try:
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
                
                # Save the thumbnail as progressive JPEG
                resized_img.save(output_path, format='JPEG', quality=90, optimize=True, progressive=True)
                print(f"Generated thumbnail: {output_path}")
        except Exception as e:
            print(f"Error generating thumbnail for {image_path}: {e}")

    def generate_sitemap(self) -> None:
        """Generate sitemap.xml for search engines."""
        print("Generating sitemap.xml...")
        
        # Read existing sitemap if it exists
        existing_lastmod = {}
        sitemap_path = DOCS_DIR / "sitemap.xml"
        if sitemap_path.exists():
            try:
                content = sitemap_path.read_text(encoding="utf-8")
                # Extract URLs and their lastmod dates using regex
                import re
                url_pattern = re.compile(r'<loc>(.*?)</loc>.*?<lastmod>(.*?)</lastmod>', re.DOTALL)
                for match in url_pattern.finditer(content):
                    url = match.group(1)
                    lastmod = match.group(2)
                    existing_lastmod[url] = lastmod
                print(f"Loaded {len(existing_lastmod)} existing lastmod dates from sitemap")
            except Exception as e:
                print(f"Error reading existing sitemap: {e}")
        
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
            
            # Check if the post has been modified
            src_path = post.path
            is_modified = self.is_file_modified(src_path)
            
            # Use existing lastmod if available and file hasn't changed
            if url in existing_lastmod and not is_modified:
                lastmod = existing_lastmod[url]
            else:
                # Use post date or current date for modified files
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
                index_file = subdir / "index.md"
                if subdir.is_dir() and index_file.exists():
                    category = subdir.name
                    url = f"{BASE_URL}/{category}/"
                    
                    xml_content.append(f'  <url>')
                    xml_content.append(f'    <loc>{url}</loc>')
                    
                    # Check if index file has been modified
                    is_modified = self.is_file_modified(index_file)
                    if url in existing_lastmod and not is_modified:
                        xml_content.append(f'    <lastmod>{existing_lastmod[url]}</lastmod>')
                    
                    xml_content.append(f'    <priority>0.9</priority>')
                    xml_content.append(f'  </url>')
        
        # Close XML
        xml_content.append('</urlset>')
        
        # Write to file
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
            # Skip posts that were already identified as unchanged
            if not post.content_md:
                continue
                
            html = self.render_post(post)
            output_path = DOCS_DIR / post.url_path
            output_path.parent.mkdir(parents=True, exist_ok=True)
            output_path.write_text(html, encoding="utf-8")
            print(f"Generated: {output_path}")
        
        # Check if main index needs updating
        main_index_file = SRC_DIR / "index.md"
        main_index_output = DOCS_DIR / "index.html"
        if self.is_file_modified(main_index_file) or not main_index_output.exists():
            main_index_output.write_text(self.render_index(), encoding="utf-8")
            print(f"Generated: {main_index_output}")
        else:
            print(f"Skipping unchanged index: {main_index_output}")
        
        # Render category indexes
        if page_dir.exists():
            for subdir in page_dir.iterdir():
                index_md = subdir / "index.md"
                if subdir.is_dir() and index_md.exists():
                    category = subdir.name
                    index_path = DOCS_DIR / category / "index.html"
                    
                    # Check if category index needs updating
                    if self.is_file_modified(index_md) or not index_path.exists():
                        html = self.render_index(category)
                        index_path.write_text(html, encoding="utf-8")
                        print(f"Generated: {index_path}")
                    else:
                        print(f"Skipping unchanged index: {index_path}")
        
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
                    
                    # Check if file has been modified
                    file_modified = self.is_file_modified(file)
                    
                    # Skip if file hasn't been modified and destination exists
                    if not file_modified and dest_file.exists():
                        print(f"Skipping unchanged file: {file}")
                        continue
                    
                    # Handle images in the photos directory
                    if "photos" in file.parts and file.suffix.lower() in ['.jpg', '.jpeg', '.png', '.gif']:
                        # Convert to progressive JPEG with quality 90
                        try:
                            print(f"Converting to progressive JPEG: {file}")
                            with Image.open(file) as img:
                                # Ensure the destination has .jpg extension
                                dest_file = dest_file.with_suffix('.jpg')
                                # Save as progressive JPEG with quality 90
                                img.save(dest_file, format='JPEG', quality=90, optimize=True, progressive=True)
                                print(f"Converted: {file} -> {dest_file}")
                                
                                # Skip if the filename already contains "_thumbnail"
                                if "_thumbnail" not in file.stem:
                                    # Create thumbnail filename
                                    thumbnail_name = file.stem + "_thumbnail.jpg"
                                    dest_thumbnail_path = dest_file.parent / thumbnail_name
                                    
                                    # Only generate thumbnails in docs directory for photos from src directory
                                    if str(file).startswith(str(SRC_DIR)):
                                        # Check if thumbnail needs regeneration - simpler now with Git
                                        thumbnail_needs_update = (
                                            not dest_thumbnail_path.exists() or 
                                            file_modified
                                        )
                                        
                                        if thumbnail_needs_update:
                                            # Generate the thumbnail directly in the docs directory
                                            self.generate_thumbnail(file, dest_thumbnail_path, max_size=800)
                                            print(f"Generated thumbnail in docs: {dest_thumbnail_path}")
                                        else:
                                            print(f"Skipping unchanged thumbnail: {dest_thumbnail_path}")
                        except Exception as e:
                            print(f"Error converting image {file}: {e}")
                            # Fall back to regular copy if conversion fails
                            shutil.copy2(file, dest_file)
                            print(f"Copied (fallback): {file} -> {dest_file}")
                    else:
                        # Copy non-image files normally
                        shutil.copy2(file, dest_file)
                        print(f"Copied: {file} -> {dest_file}")
                    
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
