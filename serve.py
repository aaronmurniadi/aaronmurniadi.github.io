#!/usr/bin/env python3
"""
Simple HTTP server for serving the generated static site
"""

import os
import sys
import argparse
from http.server import HTTPServer, SimpleHTTPRequestHandler

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Serve the generated static site')
    parser.add_argument('-d', '--directory', default='docs',
                        help='Directory to serve (default: docs)')
    parser.add_argument('-p', '--port', type=int, default=8000,
                        help='Port to serve on (default: 8000)')
    return parser.parse_args()

def serve_directory(directory, port):
    """Serve the specified directory on the specified port."""
    if not os.path.exists(directory):
        print(f"Error: Directory '{directory}' not found")
        sys.exit(1)

    # Change to the directory to serve
    os.chdir(directory)
    
    # Set up the server
    handler = SimpleHTTPRequestHandler
    server = HTTPServer(('', port), handler)
    
    # Print server info
    print(f"Serving {os.path.abspath(directory)} at http://localhost:{port}")
    print("Press Ctrl+C to stop the server")
    
    try:
        # Start the server
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped")

def main():
    """Main function."""
    args = parse_arguments()
    serve_directory(args.directory, args.port)

if __name__ == "__main__":
    main() 