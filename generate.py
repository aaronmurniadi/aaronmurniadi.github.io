#!/usr/bin/env python3
"""
Static Blog Generator
Converts Markdown files from src/ to HTML files in docs/
Supports GitHub Flavored Markdown with real-time watching and dynamic navigation
"""

import os
import shutil
import yaml
import time
import sys
import subprocess
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Any
from jinja2 import Environment, FileSystemLoader
import markdown
from markdown.extensions import codehilite, fenced_code, tables, toc
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


class BlogGenerator:
    def __init__(self, src_dir="src", docs_dir="docs", templates_dir="templates"):
        self.src_dir = Path(src_dir)
        self.docs_dir = Path(docs_dir)
        self.templates_dir = Path(templates_dir)

        # Set up Jinja2 environment
        self.jinja_env = Environment(loader=FileSystemLoader(self.templates_dir))

        # Configure markdown with GitHub Flavored Markdown extensions
        self.md = markdown.Markdown(
            extensions=[
                "markdown.extensions.fenced_code",
                "markdown.extensions.tables",
                "markdown.extensions.toc",
                "markdown.extensions.codehilite",
                "markdown.extensions.nl2br",
                "markdown.extensions.sane_lists",
                "markdown.extensions.smarty",
                "markdown.extensions.footnotes",
            ],
            extension_configs={
                "codehilite": {"css_class": "highlight", "use_pygments": True}
            },
        )

    def parse_frontmatter(self, content):
        """Parse YAML frontmatter from markdown content"""
        if not content.startswith("---"):
            return {}, content

        try:
            _, frontmatter, markdown_content = content.split("---", 2)
            metadata = yaml.safe_load(frontmatter.strip())
            return metadata or {}, markdown_content.strip()
        except ValueError:
            return {}, content

    def process_markdown_file(self, file_path, all_posts=None, current_category=None):
        """Process a single markdown file and return metadata and HTML content"""
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        metadata, markdown_content = self.parse_frontmatter(content)

        # Process post list syntax before converting to HTML
        if all_posts:
            markdown_content = self.process_post_list_syntax(
                markdown_content, all_posts, current_category
            )

        # Reset the markdown processor to clear any state from previous files
        # This is crucial for footnotes to work correctly across multiple files
        self.md.reset()
        
        # Convert markdown to HTML
        html_content = self.md.convert(markdown_content)

        # Set default metadata
        if "title" not in metadata:
            metadata["title"] = file_path.stem.replace("-", " ").title()

        if "date" not in metadata:
            # Use file modification time as fallback
            stat = file_path.stat()
            metadata["date"] = datetime.fromtimestamp(stat.st_mtime).strftime(
                "%Y-%m-%d"
            )

        metadata["slug"] = file_path.stem
        metadata["content"] = html_content

        return metadata

    def process_post_list_syntax(self, content, all_posts, current_category=None):
        """Process {{ posts|tag:tagname }} syntax in markdown content"""
        import re

        # Pattern to match {{ posts|tag:tagname }}
        pattern = r"\{\{\s*posts\|tag:([^}]+)\s*\}\}"

        def replace_post_list(match):
            tag_name = match.group(1).strip()

            # Filter posts by tag
            filtered_posts = []
            for post in all_posts:
                post_tags = post.get("tags", [])
                if isinstance(post_tags, list) and tag_name in post_tags:
                    filtered_posts.append(post)
                elif isinstance(post_tags, str):
                    # Handle case where tags might be a string
                    if tag_name in post_tags:
                        filtered_posts.append(post)

            # Generate markdown list of posts
            if not filtered_posts:
                return f"*No posts found with tag '{tag_name}'*"

            post_list = []
            for post in filtered_posts:
                date_str = post.get("date", "")
                title = post.get("title", post.get("slug", "Untitled"))

                # Determine the correct URL path based on context and post category
                if post.get("category") == "blog":
                    url = f"{post['slug']}.html"
                elif current_category and current_category == post.get("category"):
                    # If we're on the same category page, use relative path
                    url = f"{post['slug']}.html"
                else:
                    # For cross-category links or homepage, include the category path
                    if current_category:
                        # We're on a category page linking to a different category
                        url = f"../{post.get('category', '')}/{post['slug']}.html"
                    else:
                        # We're on the homepage
                        url = post.get(
                            "url_path",
                            f"{post.get('category', '')}/{post['slug']}.html",
                        )

                post_list.append(f"- <div class='post-date'>{date_str}</div> <div class='post-title'>[{title}]({url})</div>")

            return "\n".join(post_list)

        return re.sub(pattern, replace_post_list, content)

    def get_all_posts(self):
        """Get all markdown posts from src directory and subdirectories, excluding index.md files"""
        posts = []

        # Get posts from root src directory (excluding index.md)
        for md_file in self.src_dir.glob("*.md"):
            if md_file.name == "index.md":
                continue  # Skip index.md files
            try:
                post_data = self.process_markdown_file(md_file)
                post_data["category"] = "blog"  # Default category
                post_data["url_path"] = f"{post_data['slug']}.html"
                posts.append(post_data)
            except Exception as e:
                print(f"Error processing {md_file}: {e}")

        # Get posts from subdirectories (excluding index.md)
        for subdir in self.src_dir.iterdir():
            if subdir.is_dir() and not subdir.name.startswith("."):
                category = subdir.name
                for md_file in subdir.glob("*.md"):
                    if md_file.name == "index.md":
                        continue  # Skip index.md files
                    try:
                        post_data = self.process_markdown_file(md_file)
                        post_data["category"] = category
                        post_data["url_path"] = f"{category}/{post_data['slug']}.html"
                        posts.append(post_data)
                    except Exception as e:
                        print(f"Error processing {md_file}: {e}")

        # Sort posts by date (newest first)
        def get_sort_key(post):
            date_value = post.get("date", "")
            if isinstance(date_value, str):
                # Convert string date to comparable format
                try:
                    return datetime.strptime(date_value, "%Y-%m-%d").date()
                except (ValueError, TypeError):
                    # If parsing fails, return a very old date
                    return datetime(1900, 1, 1).date()
            elif hasattr(date_value, "date"):
                # If it's a datetime object, get the date part
                return date_value.date()
            elif hasattr(date_value, "year"):
                # If it's already a date object
                return date_value
            else:
                # Fallback for any other type
                return datetime(1900, 1, 1).date()

        posts.sort(key=get_sort_key, reverse=True)
        return posts

    def get_index_content(self, category=None, all_posts=None):
        """Get content from index.md file for a category or the homepage"""
        if category:
            index_file = self.src_dir / category / "index.md"
        else:
            index_file = self.src_dir / "index.md"

        if index_file.exists():
            try:
                return self.process_markdown_file(
                    index_file, all_posts, current_category=category
                )
            except Exception as e:
                print(f"Error processing {index_file}: {e}")
                return None
        return None

    def generate_post_html(self, post_data, all_posts):
        """Generate HTML for a single post with previous/next navigation"""
        template = self.jinja_env.get_template("post.html")
        nav_links = self.get_navigation_links()
        current_category = (
            post_data.get("category") if post_data.get("category") != "blog" else None
        )

        # Find previous and next posts
        current_index = None
        for i, post in enumerate(all_posts):
            if post["slug"] == post_data["slug"] and post.get(
                "category"
            ) == post_data.get("category"):
                current_index = i
                break

        prev_post = None
        next_post = None

        if current_index is not None:
            if current_index > 0:
                next_post = all_posts[
                    current_index - 1
                ]  # Next is newer (earlier in list)
            if current_index < len(all_posts) - 1:
                prev_post = all_posts[
                    current_index + 1
                ]  # Previous is older (later in list)

        return template.render(
            post=post_data,
            nav_links=nav_links,
            current_category=current_category,
            prev_post=prev_post,
            next_post=next_post,
        )

    def get_navigation_links(self):
        """Generate navigation links based on src subdirectories that have index.md"""
        nav_links = [{"name": "Home", "url": "index.html"}]

        # Add links for each subdirectory in src that has an index.md file
        for subdir in self.src_dir.iterdir():
            if subdir.is_dir() and not subdir.name.startswith("."):
                # Only include directories that have an index.md file
                index_file = subdir / "index.md"
                if index_file.exists():
                    nav_links.append(
                        {
                            "name": subdir.name.title(),
                            "url": f"{subdir.name}/index.html",
                        }
                    )

        return nav_links

    def generate_index_html(self, posts, category=None):
        """Generate index.html with custom content from index.md files"""
        template = self.jinja_env.get_template("index.html")
        nav_links = self.get_navigation_links()

        # Get custom content from index.md if available, passing all posts for processing
        index_content = self.get_index_content(category, posts)

        if category:
            page_title = f"{category.title()} - Aaron PM"
        else:
            page_title = "Aaron PM"

        return template.render(
            nav_links=nav_links,
            page_title=page_title,
            current_category=category,
            index_content=index_content,
        )

    def compile_typst_files(self):
        """Compile all .typ files in src/typst-collection directory"""
        typst_dir = self.src_dir / "typst-collection"
        
        if not typst_dir.exists():
            print("No typst-collection directory found, skipping Typst compilation")
            return
            
        try:
            # Find and compile all .typ files
            result = subprocess.run(
                ["find", str(typst_dir), "-name", "*.typ"],
                capture_output=True,
                text=True,
                check=True
            )
            
            typ_files = result.stdout.strip().split('\n') if result.stdout.strip() else []
            
            if not typ_files:
                print("No .typ files found in typst-collection")
                return
                
            print(f"Found {len(typ_files)} .typ files to compile")
            
            # Compile each file
            for typ_file in typ_files:
                if typ_file:  # Skip empty strings
                    try:
                        subprocess.run(["typst", "compile", typ_file], check=True)
                        print(f"Compiled {typ_file}")
                    except subprocess.CalledProcessError as e:
                        print(f"Error compiling {typ_file}: {e}")
                        
        except subprocess.CalledProcessError as e:
            print(f"Error finding .typ files: {e}")
        except FileNotFoundError:
            print("typst command not found. Please install Typst to compile documents.")

    def get_typst_gallery_data(self):
        """Get data for typst gallery - find all PDFs and their corresponding .typ sources"""
        typst_dir = self.src_dir / "typst-collection" 
        gallery_items = []
        
        if not typst_dir.exists():
            return gallery_items
            
        # Find all PDF files in the typst-collection directory
        for pdf_file in typst_dir.rglob("*.pdf"):
            # Find corresponding .typ file
            typ_file = pdf_file.with_suffix(".typ")
            
            if typ_file.exists():
                # Calculate relative paths from docs directory
                rel_pdf_path = pdf_file.relative_to(self.src_dir)
                
                # Generate GitHub URL for the .typ source file
                # Remove 'src/' prefix and construct GitHub blob URL
                typ_relative_to_typst_collection = typ_file.relative_to(typst_dir)
                github_source_url = f"https://github.com/aaronmurniadi/typst-collection/blob/main/{typ_relative_to_typst_collection}"
                
                gallery_items.append({
                    "title": pdf_file.stem.replace("_", " ").replace("-", " ").title(),
                    "pdf_path": str(rel_pdf_path),
                    "typ_path": github_source_url,
                    "filename": pdf_file.name
                })
                
        return gallery_items

    def generate_typst_gallery_html(self, gallery_items):
        """Generate HTML for the typst gallery page"""
        template = self.jinja_env.get_template("typst_gallery.html")
        nav_links = self.get_navigation_links()
        
        # Get content from typst-collection/index.md
        index_content = self.get_index_content("typst-collection")
        
        return template.render(
            nav_links=nav_links,
            page_title="Typst Collection - Aaron PM",
            gallery_items=gallery_items,
            index_content=index_content
        )

    def copy_static_files(self):
        """Copy CSS, JS, image files, and PDFs from src directory to docs directory"""
        # Define file extensions to copy
        static_extensions = {'.css', '.js', '.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.ico', '.bmp', '.pdf'}
        
        # Scan src directory for static files
        for file_path in self.src_dir.iterdir():
            if file_path.is_file() and file_path.suffix.lower() in static_extensions:
                # Copy to docs directory with just the filename
                dest_path = self.docs_dir / file_path.name
                shutil.copy2(file_path, dest_path)
                print(f"Copied {file_path} to docs/{file_path.name}")
                
        # Copy PDF files from typst-collection directory
        typst_dir = self.src_dir / "typst-collection"
        if typst_dir.exists():
            for pdf_file in typst_dir.rglob("*.pdf"):
                # Preserve directory structure in docs
                rel_path = pdf_file.relative_to(self.src_dir)
                dest_path = self.docs_dir / rel_path
                
                # Create directory if it doesn't exist
                dest_path.parent.mkdir(parents=True, exist_ok=True)
                
                shutil.copy2(pdf_file, dest_path)
                print(f"Copied {pdf_file} to {dest_path}")

    def build(self):
        """Build the entire blog"""
        print("Starting blog generation...")

        # Create docs directory if it doesn't exist
        self.docs_dir.mkdir(exist_ok=True)
        
        # Compile Typst files first
        self.compile_typst_files()

        # Get all posts
        posts = self.get_all_posts()
        print(f"Found {len(posts)} posts")

        # Create category directories
        categories = set(post.get("category", "blog") for post in posts)

        # Also include directories that have index.md files (even if no posts)
        for subdir in self.src_dir.iterdir():
            if subdir.is_dir() and not subdir.name.startswith("."):
                index_file = subdir / "index.md"
                if index_file.exists():
                    categories.add(subdir.name)

        for category in categories:
            if category != "blog":  # blog posts go in root
                category_dir = self.docs_dir / category
                category_dir.mkdir(exist_ok=True)

        # Generate individual post pages
        for post in posts:
            post_html = self.generate_post_html(post, posts)

            if post.get("category") == "blog":
                post_file = self.docs_dir / f"{post['slug']}.html"
            else:
                post_file = self.docs_dir / post["url_path"]

            # Ensure directory exists
            post_file.parent.mkdir(parents=True, exist_ok=True)

            with open(post_file, "w", encoding="utf-8") as f:
                f.write(post_html)
            print(f"Generated {post_file}")

        # Generate main index page
        index_html = self.generate_index_html(posts)
        index_file = self.docs_dir / "index.html"

        with open(index_file, "w", encoding="utf-8") as f:
            f.write(index_html)
        print(f"Generated {index_file}")

        # Generate category index pages (only for categories with index.md files)
        for category in categories:
            if category != "blog":
                # Only generate index page if the category has an index.md file
                category_index_md = self.src_dir / category / "index.md"
                if category_index_md.exists():
                    category_index_html = self.generate_index_html(posts, category)
                    category_index_file = self.docs_dir / category / "index.html"

                    with open(category_index_file, "w", encoding="utf-8") as f:
                        f.write(category_index_html)
                    print(f"Generated {category_index_file}")

        # Generate Typst gallery page
        gallery_items = self.get_typst_gallery_data()
        if gallery_items:
            gallery_html = self.generate_typst_gallery_html(gallery_items)
            gallery_file = self.docs_dir / "typst-collection.html"
            
            with open(gallery_file, "w", encoding="utf-8") as f:
                f.write(gallery_html)
            print(f"Generated {gallery_file}")

        # Copy static files
        self.copy_static_files()

        print("Blog generation complete!")


class BlogHandler(FileSystemEventHandler):
    """File system event handler for watching markdown files"""

    def __init__(self, generator: BlogGenerator):
        self.generator = generator
        self.last_build = 0
        self.debounce_delay = 1  # seconds

    def on_modified(self, event):
        if event.is_directory:
            return

        # Rebuild for markdown files, CSS files, JS files, template files, and typst files
        if (event.src_path.endswith(".md") or 
            event.src_path.endswith(".css") or 
            event.src_path.endswith(".js") or
            event.src_path.endswith(".html") or
            event.src_path.endswith(".typ")):
            current_time = time.time()
            if current_time - self.last_build > self.debounce_delay:
                print(f"\n📝 File changed: {event.src_path}")
                print("🔄 Rebuilding blog...")
                try:
                    self.generator.build()
                    print("✅ Blog rebuilt successfully!")
                except Exception as e:
                    print(f"❌ Error rebuilding blog: {e}")
                self.last_build = current_time

    def on_created(self, event):
        if not event.is_directory and (event.src_path.endswith(".md") or 
                                     event.src_path.endswith(".css") or 
                                     event.src_path.endswith(".js") or
                                     event.src_path.endswith(".html") or
                                     event.src_path.endswith(".typ")):
            self.on_modified(event)

    def on_deleted(self, event):
        if not event.is_directory and (event.src_path.endswith(".md") or 
                                     event.src_path.endswith(".css") or 
                                     event.src_path.endswith(".js") or
                                     event.src_path.endswith(".html") or
                                     event.src_path.endswith(".typ")):
            print(f"\n🗑️  File deleted: {event.src_path}")
            print("🔄 Rebuilding blog...")
            try:
                self.generator.build()
                print("✅ Blog rebuilt successfully!")
            except Exception as e:
                print(f"❌ Error rebuilding blog: {e}")


def main():
    """Main function for one-time blog generation"""
    generator = BlogGenerator()
    generator.build()


def watch_main():
    """Main function for watching and auto-rebuilding"""
    generator = BlogGenerator()

    # Initial build
    print("🚀 Starting blog generator with file watching...")
    generator.build()

    # Set up file watcher
    event_handler = BlogHandler(generator)
    observer = Observer()

    # Watch the src directory and templates directory
    observer.schedule(event_handler, str(generator.src_dir), recursive=True)
    observer.schedule(event_handler, str(generator.templates_dir), recursive=True)

    observer.start()

    print(f"\n👀 Watching for changes in:")
    print(f"   📁 {generator.src_dir} (markdown, CSS, and JS files)")
    print(f"   📁 {generator.templates_dir} (template files)")
    print("\n📡 Server running... Press Ctrl+C to stop")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n\n🛑 Stopping file watcher...")
        observer.stop()

    observer.join()
    print("👋 Blog generator stopped!")


if __name__ == "__main__":
    print(sys.argv[0])
    if len(sys.argv) > 1 and sys.argv[1] == "watch":
        watch_main()
    else:
        main()
