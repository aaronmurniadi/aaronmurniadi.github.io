# Static Blog Generator

A modern Python-based static blog generator with real-time watching, dynamic navigation, and GitHub Flavored Markdown support.

## ✨ Features

- ✅ **GitHub Flavored Markdown** support with syntax highlighting
- ✅ **Real-time file watching** - auto-rebuilds on save
- ✅ **Dynamic navigation** - automatically creates nav links from src subdirectories
- ✅ **Category organization** - organize posts in subdirectories (projects/, tutorials/, etc.)
- ✅ **YAML frontmatter** for post metadata
- ✅ **UV package management** with Python version control
- ✅ **Responsive design** using beautiful typography
- ✅ **Simple templating** with Jinja2
- ✅ **Clean URLs** and automatic index pages

## 📁 Project Structure

```
blog-htmx/
├── .venv/                  # UV-managed virtual environment
├── src/                    # Markdown source files
│   ├── hello-world.md      # Root-level blog posts
│   ├── github-graveyard.md
│   ├── projects/           # Project showcase
│   │   └── my-awesome-project.md
│   └── tutorials/          # Tutorial content
│       └── getting-started.md
├── docs/                   # Generated HTML files
│   ├── index.html          # Main blog index
│   ├── hello-world.html    # Individual posts
│   ├── github-graveyard.html
│   ├── projects/           # Category pages
│   │   ├── index.html      # Projects index
│   │   └── my-awesome-project.html
│   ├── tutorials/
│   │   ├── index.html      # Tutorials index
│   │   └── getting-started.html
│   └── style.css           # Beautiful typography CSS
├── templates/              # Jinja2 HTML templates
│   ├── base.html           # Base layout with dynamic nav
│   ├── index.html          # Homepage and category pages
│   └── post.html           # Individual post layout
├── blog_generator.py       # Main generator script
├── pyproject.toml          # UV project configuration
├── .python-version         # Python version specification
└── README.md
```

## 🚀 Installation

### Prerequisites
Install [UV](https://docs.astral.sh/uv/) for modern Python package management:

```bash
# Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Setup
1. Clone and setup the project:
```bash
git clone <your-repo>
cd blog-htmx

# UV automatically installs Python 3.11 and dependencies
uv sync
```

## 📖 Usage

### 1. Create Your Content

Create markdown files in `src/` or organize them in subdirectories:

```bash
# Root-level blog posts (appear in main navigation)
src/my-first-post.md

# Organized in categories (creates nav links automatically!)
src/projects/awesome-project.md
src/tutorials/getting-started.md
src/reviews/book-review.md
```

Example post with frontmatter:

```markdown
---
title: "My First Post"
date: "2024-01-01"
tags: ["first", "hello"]
category: "blog"  # Optional, auto-detected from directory
---

# Hello World!

This is my first blog post using the static generator.

## Features Demo

- **Bold text** and *italic text*
- `inline code` and code blocks
- Tables, lists, and more!

\```python
def hello_world():
    print("Hello from my blog!")
\```
```

### 2. Generate Your Blog

```bash
# One-time generation
uv run blog-generate

# Real-time watching (recommended for development) 🔥
uv run blog-watch
```

The watch mode will:
- ✅ Monitor `src/` and `templates/` directories
- ✅ Auto-rebuild when files change
- ✅ Show build status with emojis
- ✅ Debounce rapid changes

### 3. Preview Your Blog

```bash
cd docs
python -m http.server 8000
```

Visit `http://localhost:8000` to see your blog with dynamic navigation!

## GitHub Pages Deployment

Since the generated files are in the `docs/` directory, you can easily deploy to GitHub Pages:

1. Push your repository to GitHub
2. Go to Settings → Pages
3. Select "Deploy from a branch"
4. Choose `main` branch and `/docs` folder
5. Your blog will be available at `https://username.github.io/repository-name/`

## Customization

### Templates

Modify the templates in `templates/`:
- `base.html` - Base template with header/footer
- `index.html` - Homepage template
- `post.html` - Individual post template

### Styling

The generator uses the existing `style.css` file, which includes:
- Dark/light mode support
- Typography optimized for reading
- Syntax highlighting for code
- Responsive design

### Post Metadata

Supported frontmatter fields:
- `title` - Post title (required)
- `date` - Publication date (YYYY-MM-DD format)
- `tags` - List of tags
- Custom fields can be added and accessed in templates

## Examples

See the example posts in `src/`:
- `hello-world.md` - Demonstrates various Markdown features
- `github-graveyard.md` - Real-world blog post example

## 🎯 Advanced Features

### Dynamic Navigation
The blog automatically creates navigation links based on your `src/` subdirectories:

```
src/
├── projects/        → Creates "Projects" nav link
├── tutorials/       → Creates "Tutorials" nav link  
├── reviews/         → Creates "Reviews" nav link
└── my-post.md      → Goes in main "Blog" section
```

### Real-time File Watching
```bash
uv run blog-watch
```

Features:
- 👀 **Monitors** `src/` and `templates/` directories
- ⚡ **Auto-rebuilds** on file save (with 1-second debounce)
- 📝 **Shows** which files changed
- ✅ **Displays** build status with emojis
- 🔄 **Handles** file creation, modification, and deletion

### UV Integration
- 🐍 **Automatic Python management** - installs Python 3.11
- 📦 **Dependency isolation** - uses `.venv` virtual environment
- ⚡ **Fast installs** - UV is much faster than pip
- 🔒 **Lockfile support** - reproducible builds
- 🎯 **Script shortcuts** - `uv run blog-generate` and `uv run blog-watch`

## 🔧 Requirements

- **UV package manager** (handles Python and dependencies automatically)
- **Git** (for version control)
- **A text editor** (VS Code, Vim, etc.)

## 🏗️ Development Workflow

1. **Write content** in markdown files in `src/`
2. **Run watcher** with `uv run blog-watch` 
3. **Edit and save** - blog rebuilds automatically
4. **Preview** at `http://localhost:8000`
5. **Commit and deploy** when ready

## 🚀 Deployment Options

### GitHub Pages (Recommended)
1. Push to GitHub repository
2. Settings → Pages → Deploy from branch → `main` → `/docs`
3. Your blog will be live at `https://username.github.io/repo-name/`

### Netlify
1. Connect your GitHub repository
2. Build command: `uv run blog-generate`
3. Publish directory: `docs`

### Custom Server
Just upload the `docs/` folder contents to any web server!

---

**Happy blogging!** 🚀✨

*Built with Python, UV, and lots of ❤️* 