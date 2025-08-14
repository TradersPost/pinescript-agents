#!/bin/bash
# Before Write Hook - Ensures Pine Script files are properly formatted and located

FILE_PATH="$1"
FILE_CONTENT="$2"

# Check if this is a Pine Script file
if [[ "$FILE_PATH" == *.pine ]]; then
    echo "📝 Pine Script File Write Detection"
    
    # Ensure it's in the projects directory
    if [[ "$FILE_PATH" != */projects/* ]]; then
        echo "⚠️ Warning: Pine Script files should be saved in /projects/ directory"
        echo "Recommended path: /projects/$(basename "$FILE_PATH")"
    fi
    
    # Check for version declaration
    if ! echo "$FILE_CONTENT" | head -1 | grep -q "^//@version="; then
        echo "⚠️ Warning: Pine Script should start with //@version=6"
    fi
    
    # Check if it's blank.pine being written directly (should be renamed first)
    if [[ "$(basename "$FILE_PATH")" == "blank.pine" ]] && [[ "$FILE_CONTENT" != *"Blank Template"* ]]; then
        echo "📌 Reminder: This file should be renamed to match your project (e.g., my-indicator.pine)"
        echo "The pine-manager agent should rename this automatically when starting a new project"
    fi
    
    echo "✅ Pine Script file check complete"
fi

exit 0