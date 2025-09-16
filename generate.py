#!/usr/bin/env python3
"""
Static Blog Generator
Converts Markdown files from src/ to HTML files in docs/
Supports GitHub Flavored Markdown with real-time watching and dynamic navigation
"""

import re
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Union

import markdown
import yaml
from jinja2 import Environment, FileSystemLoader
from watchdog.events import FileSystemEvent, FileSystemEventHandler
from watchdog.observers import Observer

# Configuration
SRC_DIR = Path("src")
DOCS_DIR = Path("docs")
TEMPLATES_DIR = Path("templates")


@dataclass
class Post:
    """Represents a blog post."""

    path: Path
    title: str
    slug: str
    category: str
    url_path: str
    metadata: Dict[str, Any]
    content_md: str
    content_html: str = ""
    date: Optional[datetime] = None

    def __post_init__(self) -> None:
        self.date = self._parse_date()

    def _parse_date(self) -> Optional[datetime]:
        """Parse date from metadata or file stats."""
        date_val = self.metadata.get("date")
        if isinstance(date_val, datetime):
            return date_val
        if isinstance(date_val, str):
            try:
                return datetime.strptime(date_val, "%Y-%m-%d")
            except ValueError:
                pass
        stat = self.path.stat()
        return datetime.fromtimestamp(stat.st_mtime)


class ContentParser:
    """Parses markdown files with frontmatter."""

    md: markdown.Markdown

    def __init__(self) -> None:
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

    def parse_frontmatter(self, content: str) -> tuple[Dict[str, Any], str]:
        """Parse YAML frontmatter from markdown content."""
        if not content.startswith("---"):
            return {}, content
        try:
            _, frontmatter, markdown_content = content.split("---", 2)
            metadata = yaml.safe_load(frontmatter.strip())
            return metadata or {}, markdown_content.strip()
        except ValueError:
            return {}, content

    def parse_file(self, file_path: Path) -> tuple[Dict[str, Any], str]:
        """Reads a file and parses frontmatter."""
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
        return self.parse_frontmatter(content)

    def convert_to_html(self, markdown_content: str) -> str:
        """Converts markdown content to HTML."""
        self.md.reset()
        return self.md.convert(markdown_content)


class Site:
    """Represents the entire site's data."""

    src_dir: Path
    content_dir: Path
    page_dir: Path
    content_parser: ContentParser
    posts: List[Post]
    nav_links: List[Dict[str, str]]
    categories: Set[str]

    def __init__(self, src_dir: Path, content_parser: ContentParser):
        self.src_dir = src_dir
        self.content_dir = self.src_dir / "content"
        self.page_dir = self.src_dir / "page"
        self.content_parser = content_parser
        self.posts: List[Post] = []
        self.nav_links: List[Dict[str, str]] = []
        self.categories: set[str] = set()

    def load(self) -> None:
        """Load all posts and site data."""
        self.posts = self._discover_and_parse_posts()
        self.nav_links = self._generate_nav_links()
        self.categories = {post.category for post in self.posts if post.category}
        # Also include directories that have index.md files (even if no posts)
        if self.page_dir.exists():
            for subdir in self.page_dir.iterdir():
                if (
                    subdir.is_dir()
                    and not subdir.name.startswith(".")
                    and (subdir / "index.md").exists()
                ):
                    self.categories.add(subdir.name)

    def _discover_and_parse_posts(self) -> List[Post]:
        """Finds all markdown files and parses them into Post objects."""
        posts = []
        md_files = [p for p in self.content_dir.rglob("*.md") if p.name != "index.md"]

        for md_file in md_files:
            try:
                metadata, md_content = self.content_parser.parse_file(md_file)

                relative_path = md_file.relative_to(self.content_dir)
                category = (
                    relative_path.parent.name
                    if relative_path.parent.name != "."
                    else "blog"
                )
                slug = md_file.stem

                post = Post(
                    path=md_file,
                    title=metadata.get("title", slug.replace("-", " ").title()),
                    slug=slug,
                    category=category,
                    url_path=f"{category}/{slug}.html"
                    if category != "blog"
                    else f"{slug}.html",
                    metadata=metadata,
                    content_md=md_content,
                )
                posts.append(post)
            except Exception as e:
                print(f"Error processing {md_file}: {e}")

        posts.sort(key=lambda p: p.date or datetime.min, reverse=True)
        return posts

    def _generate_nav_links(self) -> List[Dict[str, str]]:
        """Generate navigation links based on src/page subdirectories with index.md."""
        nav_links = [{"name": "Home", "url": "index.html"}]
        if self.page_dir.exists():
            for subdir in sorted(self.page_dir.iterdir()):
                if subdir.is_dir() and (subdir / "index.md").exists():
                    nav_links.append(
                        {
                            "name": subdir.name.replace("_", " ").title(),
                            "url": f"{subdir.name}/index.html",
                        }
                    )
        return nav_links

    def get_post_context(self, post: Post) -> Dict[str, Optional[Post]]:
        """Get previous and next post for navigation."""
        try:
            current_index = self.posts.index(post)
            prev_post = (
                self.posts[current_index + 1]
                if current_index < len(self.posts) - 1
                else None
            )
            next_post = self.posts[current_index - 1] if current_index > 0 else None
            return {"prev_post": prev_post, "next_post": next_post}
        except ValueError:
            return {"prev_post": None, "next_post": None}


class TypstManager:
    """Handles Typst file processing."""

    src_dir: Path
    typst_src_dir: Path
    typst_docs_dir: Path

    def __init__(self, src_dir: Path, docs_dir: Path):
        self.src_dir = src_dir
        self.typst_src_dir = self.src_dir / "page" / "typst-collection"
        self.typst_docs_dir = docs_dir / "typst-collection"

    def generate_assets(self) -> None:
        """Generate PNGs and PDFs from .typ files."""
        if not self.typst_src_dir.exists():
            return
        self.typst_docs_dir.mkdir(parents=True, exist_ok=True)

        for typ_file in self.typst_src_dir.rglob("*.typ"):
            self._compile_typst_file(typ_file)

    def _compile_typst_file(self, typ_file: Path) -> None:
        """Compile a single Typst file to PDF and PNG."""
        png_path = self.typst_docs_dir / typ_file.with_suffix(".png").name
        pdf_path = self.typst_docs_dir / typ_file.with_suffix(".pdf").name

        try:
            print(f"Generating assets for {typ_file.name}...")
            # Generate PNG
            self._run_typst_command(
                [
                    "typst",
                    "compile",
                    str(typ_file),
                    "--pages=1",
                    "--format",
                    "png",
                    str(png_path),
                ],
                f"PNG for {typ_file.name}",
            )
            # Generate PDF
            self._run_typst_command(
                ["typst", "compile", str(typ_file), str(pdf_path)],
                f"PDF for {typ_file.name}",
            )
        except FileNotFoundError:
            print("Error: 'typst' command not found. Please install Typst CLI.")
        except Exception as e:
            print(f"Failed to generate assets for {typ_file.name}: {e}")

    def _run_typst_command(self, command: List[str], asset_name: str) -> None:
        """Runs a typst command and handles output."""
        try:
            subprocess.run(
                command, capture_output=True, text=True, timeout=30, check=True
            )
            print(f"Successfully generated {asset_name}")
        except subprocess.CalledProcessError as e:
            print(f"Failed to generate {asset_name}: {e.stderr}")
        except subprocess.TimeoutExpired:
            print(f"Timeout generating {asset_name}")

    def get_gallery_data(self) -> List[Dict[str, Optional[str]]]:
        """Get data for the Typst gallery."""
        if not self.typst_src_dir.exists():
            return []

        gallery_items = []
        for typ_file in self.typst_src_dir.rglob("*.typ"):
            png_filename = typ_file.with_suffix(".png").name
            pdf_filename = typ_file.with_suffix(".pdf").name

            thumbnail_url = (
                f"{png_filename}"
                if (self.typst_docs_dir / png_filename).exists()
                else None
            )
            pdf_url: Optional[str] = (
                f"{pdf_filename}"
                if (self.typst_docs_dir / pdf_filename).exists()
                else f"https://github.com/aaronmurniadi/typst-collection/releases/download/latest/{pdf_filename}"
            )

            gallery_items.append(
                {
                    "title": typ_file.stem.replace("_", " ").title(),
                    "thumbnail_path": thumbnail_url,
                    "pdf_path": pdf_url,
                    "typ_path": f"https://github.com/aaronmurniadi/typst-collection/blob/main/{typ_file.relative_to(self.typst_src_dir)}",
                    "filename": pdf_filename,
                }
            )
        return gallery_items


class Renderer:
    """Handles rendering HTML from templates."""

    jinja_env: Environment
    site_data: Site
    content_parser: ContentParser

    def __init__(self, templates_dir: Path, site_data: Site):
        self.jinja_env = Environment(loader=FileSystemLoader(templates_dir))
        self.site_data = site_data
        self.content_parser = ContentParser()  # For post-list processing

    def render_post_page(self, post: Post) -> str:
        """Render a single post page."""
        template = self.jinja_env.get_template("post.html")
        post.content_html = self.content_parser.convert_to_html(post.content_md)
        context = self.site_data.get_post_context(post)

        return template.render(
            post=post,
            nav_links=self.site_data.nav_links,
            current_category=post.category if post.category != "blog" else None,
            prev_post=context["prev_post"],
            next_post=context["next_post"],
        )

    def render_index_page(self, category: Optional[str] = None) -> str:
        """Render an index page for the site or a category."""
        template = self.jinja_env.get_template("index.html")
        index_content_post = self._get_index_content(category)

        gallery_items = None
        if category == "typst-collection":
            typst_manager = TypstManager(SRC_DIR, DOCS_DIR)
            gallery_items = typst_manager.get_gallery_data()

        return template.render(
            nav_links=self.site_data.nav_links,
            page_title=f"{category.title()} - Aaron PM" if category else "Aaron PM",
            current_category=category,
            index_content=index_content_post,
            gallery_items=gallery_items,
        )

    def _get_index_content(self, category: Optional[str] = None) -> Optional[Post]:
        """Get content from index.md file for a category or the homepage."""
        if category:
            index_file = self.site_data.page_dir / category / "index.md"
        else:
            index_file = self.site_data.src_dir / "index.md"

        if not index_file.exists():
            return None

        try:
            metadata, md_content = self.content_parser.parse_file(index_file)
            processed_md = self._process_post_list_syntax(md_content, category)
            html_content = self.content_parser.convert_to_html(processed_md)

            return Post(
                path=index_file,
                title=metadata.get("title", "Index"),
                slug="index",
                category=category or "home",
                url_path=f"{category}/index.html" if category else "index.html",
                metadata=metadata,
                content_md=processed_md,
                content_html=html_content,
            )
        except Exception as e:
            print(f"Error processing {index_file}: {e}")
            return None

    def _process_post_list_syntax(
        self, content: str, current_category: Optional[str]
    ) -> str:
        """Process {{ posts|tag:tagname }} syntax."""
        pattern = r"\{\{\s*posts\|tag:([^}]+)\s*\}\}"

        def replace_with_posts(match: re.Match[str]) -> str:
            tag_name = match.group(1).strip()

            filtered_posts = [
                p
                for p in self.site_data.posts
                if tag_name in (p.metadata.get("tags") or [])
            ]

            if not filtered_posts:
                return f"*No posts found with tag '{tag_name}'*"

            post_list_items = []
            for post in filtered_posts:
                url = self._get_relative_url(post, current_category)
                date_str = post.date.strftime("%Y-%m-%d") if post.date else ""
                post_list_items.append(
                    f"- <div class='post-date'>{date_str}</div> "
                    f"<div class='post-title'>[{post.title}]({url})</div>"
                )

            return "\n".join(post_list_items)

        return re.sub(pattern, replace_with_posts, content)

    def _get_relative_url(self, post: Post, current_category: Optional[str]) -> str:
        """Calculate relative URL for a post from an index page."""
        if not current_category:  # Homepage
            return post.url_path
        if post.category == current_category:  # Same category
            return f"{post.slug}.html"
        # Different category
        return f"../{post.url_path}"


class SiteBuilder:
    """Orchestrates the blog generation process."""

    src_dir: Path
    docs_dir: Path
    content_parser: ContentParser
    site: Site
    renderer: Renderer
    typst_manager: TypstManager
    templates_dir: Path

    def __init__(self, src_dir: Path, docs_dir: Path, templates_dir: Path):
        self.src_dir = src_dir
        self.docs_dir = docs_dir
        self.content_parser = ContentParser()
        self.site = Site(src_dir, self.content_parser)
        self.renderer = Renderer(templates_dir, self.site)
        self.typst_manager = TypstManager(src_dir, docs_dir)
        self.templates_dir = templates_dir

    def build(self) -> None:
        """Build the entire blog."""
        print("Starting blog generation...")

        self.docs_dir.mkdir(exist_ok=True)

        self.typst_manager.generate_assets()

        self.site.load()
        print(f"Found {len(self.site.posts)} posts.")

        for category in self.site.categories:
            if category != "blog":
                (self.docs_dir / category).mkdir(exist_ok=True)

        for post in self.site.posts:
            html_content = self.renderer.render_post_page(post)
            output_path = self.docs_dir / post.url_path
            output_path.parent.mkdir(parents=True, exist_ok=True)
            with open(output_path, "w", encoding="utf-8") as f:
                f.write(html_content)
            print(f"Generated {output_path}")

        main_index_html = self.renderer.render_index_page()
        with open(self.docs_dir / "index.html", "w", encoding="utf-8") as f:
            f.write(main_index_html)
        print(f"Generated {self.docs_dir / 'index.html'}")

        # Category indexes
        if self.site.page_dir.exists():
            for page_dir in self.site.page_dir.iterdir():
                if page_dir.is_dir() and (page_dir / "index.md").exists():
                    category = page_dir.name
                    category_index_html = self.renderer.render_index_page(category)
                    index_path = self.docs_dir / category / "index.html"
                    with open(index_path, "w", encoding="utf-8") as f:
                        f.write(category_index_html)
                    print(f"Generated {index_path}")

        self.copy_static_files()

        print("Blog generation complete!")

    def copy_static_files(self) -> None:
        """Copy static files from src/static to docs/static."""
        src_static_dir = self.src_dir / "static"
        docs_static_dir = self.docs_dir / "static"
        if not src_static_dir.exists():
            return

        docs_static_dir.mkdir(exist_ok=True)

        for file_path in src_static_dir.iterdir():
            if file_path.is_file():
                shutil.copy2(file_path, docs_static_dir / file_path.name)
                print(f"Copied {file_path.name} to {docs_static_dir.name}/")


class BlogHandler(FileSystemEventHandler):
    """File system event handler for watching files."""

    builder: SiteBuilder
    last_build: float
    debounce_delay: Union[int, float]

    def __init__(self, builder: SiteBuilder):
        self.builder = builder
        self.last_build = 0
        self.debounce_delay = 1  # seconds

    def on_any_event(self, event: FileSystemEvent) -> None:
        if event.is_directory:
            return

        src_path_str = (
            event.src_path.decode("utf-8")
            if isinstance(event.src_path, bytes)
            else event.src_path
        )
        src_path = Path(src_path_str)
        if any(
            src_path.match(f"*{ext}")
            for ext in [".md", ".css", ".js", ".html", ".typ"]
        ):
            current_time = time.time()
            if current_time - self.last_build > self.debounce_delay:
                print(f"\n📝 File changed: {src_path}")
                print("🔄 Rebuilding blog...")
                try:
                    self.builder.build()
                    print("✅ Blog rebuilt successfully!")
                except Exception as e:
                    print(f"❌ Error rebuilding blog: {e}")
                self.last_build = current_time


def main() -> None:
    """Main function for one-time blog generation."""
    builder = SiteBuilder(SRC_DIR, DOCS_DIR, TEMPLATES_DIR)
    builder.build()


def watch_main() -> None:
    """Main function for watching and auto-rebuilding."""
    builder = SiteBuilder(SRC_DIR, DOCS_DIR, TEMPLATES_DIR)

    print("🚀 Starting blog generator with file watching...")
    builder.build()

    event_handler = BlogHandler(builder)
    observer = Observer()
    observer.schedule(event_handler, str(builder.src_dir), recursive=True)
    observer.schedule(event_handler, str(builder.templates_dir), recursive=True)
    observer.start()

    print("\n👀 Watching for changes in:")
    print(f"   📁 {builder.src_dir}")
    print(f"   📁 {builder.templates_dir}")
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
    if len(sys.argv) > 1 and sys.argv[1] == "watch":
        watch_main()
    else:
        main()
