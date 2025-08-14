#!/bin/bash
# After Rename Hook - Recreates blank.pine when it's renamed for a project

OLD_PATH="$1"
NEW_PATH="$2"

# Check if blank.pine was renamed
if [[ "$(basename "$OLD_PATH")" == "blank.pine" ]] && [[ "$OLD_PATH" == */projects/* ]]; then
    echo "🔄 Project initialized: $(basename "$NEW_PATH")"
    
    # Create a new blank.pine for the next project
    BLANK_TEMPLATE="//@version=6
// This is a blank Pine Script template
// It will be renamed and populated based on your requirements
// 
// Project: [To be defined]
// Type: [Indicator/Strategy]
// Created: [Date]
// 
// ============================================================================

indicator(\"Blank Template\", overlay=true)

// Your Pine Script code will be generated here"
    
    PROJECTS_DIR="$(dirname "$OLD_PATH")"
    echo "$BLANK_TEMPLATE" > "$PROJECTS_DIR/blank.pine"
    
    echo "✅ New blank.pine created for future projects"
    echo "📝 Current project: $(basename "$NEW_PATH")"
fi

exit 0