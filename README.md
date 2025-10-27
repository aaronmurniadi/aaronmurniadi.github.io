# My Static Blog Generator

A vibe-coded Python-based static blog generator with real-time watch.

## Development

The `generate.py` script now supports PEP 723 inline metadata for dependencies, allowing it to be run directly with `uv`:

```bash
$ ./generate.py
```

Or explicitly:

```bash
$ uv run generate.py
```

This will automatically create an isolated environment with all required dependencies.

**Happy blogging!** 🚀✨

*Built with Python, UV, and lots of LLM Tokens* 