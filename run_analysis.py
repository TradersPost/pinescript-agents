#!/usr/bin/env python3
import subprocess
import sys
import os

# Change to the project directory
project_dir = "/Users/hartman/Dropbox/TomHartman.ca/TradersPost/Projects/pinescript-agents"
os.chdir(project_dir)

# Run the video analyzer
url = "https://www.youtube.com/watch?v=rf_EQvubKlk&t=10s&pp=ygUbc2ltcGxlIHRyYWRpbmd2aWV3IHN0cmF0ZWd5"
result = subprocess.run([sys.executable, "tools/video-analyzer.py", url], 
                       capture_output=True, text=True, cwd=project_dir)

print("STDOUT:")
print(result.stdout)
print("\nSTDERR:")
print(result.stderr)
print("\nReturn code:", result.returncode)