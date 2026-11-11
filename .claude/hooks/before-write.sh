#!/bin/bash
# Before Write Hook - Ensures Pine Script files are properly formatted and located
# Also enforces file protection when system is locked

FILE_PATH="$1"
FILE_CONTENT="$2"

# Get the absolute path of the project root
# Normalize to Windows (MSYS) form so it matches the Windows-form file paths
# the Claude Code harness passes in. Without this the prefix-strip
# ${FILE_PATH#$PROJECT_ROOT/} never matches under Git Bash.
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PROJECT_ROOT="$(cygpath -m "$PROJECT_ROOT")"

# Check lock state
LOCK_STATE="unlocked"  # Default to unlocked for development
if [ -f "$PROJECT_ROOT/.claude/.lock_state" ]; then
    LOCK_STATE=$(cat "$PROJECT_ROOT/.claude/.lock_state")
fi

# If system is locked, enforce protection
if [ "$LOCK_STATE" = "locked" ]; then
    # Check if file is in protected area
    RELATIVE_PATH="${FILE_PATH#$PROJECT_ROOT/}"
    
    # Always allow writes to projects directory
    if [[ "$RELATIVE_PATH" == projects/* ]]; then
        : # Allow - this is in projects directory
    # Allow state files
    elif [[ "$RELATIVE_PATH" == .claude/.lock_state ]] || \
         [[ "$RELATIVE_PATH" == .claude/.onboarding_complete ]] || \
         [[ "$RELATIVE_PATH" == .claude/.state.json ]] || \
         [[ "$RELATIVE_PATH" == .claude/.last_session ]]; then
        : # Allow - these are state files
    # Block everything else when locked
    else
        echo "🔒 SYSTEM LOCKED: Cannot modify files outside /projects/"
        echo "   Attempted to write: $RELATIVE_PATH"
        echo "   Use 'unlock' command to enable system modifications"
        echo ""
        echo "   Allowed areas when locked:"
        echo "   ✓ projects/ - User Pine Scripts"
        echo "   ✓ State files (.lock_state, .onboarding_complete)"
        exit 1  # Block the write
    fi
else
    # System is unlocked - show warning for system file modifications
    RELATIVE_PATH="${FILE_PATH#$PROJECT_ROOT/}"
    
    # Warn about critical system files
    if [[ "$RELATIVE_PATH" == .claude/agents/* ]] || \
       [[ "$RELATIVE_PATH" == .claude/hooks/* ]]; then
        echo "⚠️  Warning: Modifying system file: $RELATIVE_PATH"
        echo "   This could affect system behavior. Proceed with caution."
    fi
fi

# Pine Script specific checks
if [[ "$FILE_PATH" == *.pine ]]; then
    echo "📝 Pine Script File Write Detection"
    
    # Ensure it's in the projects directory (warning only, not blocking)
    if [[ "$FILE_PATH" != */projects/* ]]; then
        echo "💡 Tip: Pine Script files should be saved in /projects/ directory"
        echo "   Recommended path: $PROJECT_ROOT/projects/$(basename "$FILE_PATH")"
    fi
    
    # Check for version declaration
    if ! echo "$FILE_CONTENT" | head -1 | grep -q "^//@version="; then
        echo "⚠️  Warning: Pine Script should start with //@version=6"
    fi
    
    # Check if it's blank.pine being written directly (should be renamed first)
    if [[ "$(basename "$FILE_PATH")" == "blank.pine" ]] && [[ "$FILE_CONTENT" != *"Blank Template"* ]]; then
        echo "📌 Reminder: This file should be renamed to match your project (e.g., my-indicator.pine)"
        echo "   The pine-manager agent should rename this automatically when starting a new project"
    fi
    
    echo "✅ Pine Script file check complete"
fi

# Show lock status in output
if [ "$LOCK_STATE" = "locked" ]; then
    echo "🔒 System is LOCKED (only /projects/ writable)"
else
    echo "🔓 System is UNLOCKED (development mode)"
fi

exit 0