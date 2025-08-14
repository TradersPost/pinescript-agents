#!/bin/bash
# Pine Script Agent Router Hook
# This hook runs before processing user prompts to ensure appropriate agent selection

# Check if the prompt mentions specific keywords to route to agents
PROMPT="$1"
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Check for lock/unlock commands
if [[ "$PROMPT_LOWER" == "lock" ]]; then
    echo "locked" > .claude/.lock_state
    echo "🔒 SYSTEM LOCKED - File protection enabled"
    echo ""
    echo "Protected areas:"
    echo "  ❌ System files (docs/, templates/, tools/, examples/)"
    echo "  ❌ Configuration (.claude/agents/, .claude/hooks/)"
    echo "  ❌ Root files (README.md, CLAUDE.md, package.json)"
    echo ""
    echo "Writable areas:"
    echo "  ✓ /projects/ - Your Pine Scripts"
    echo "  ✓ State files (.lock_state, .onboarding_complete)"
    echo ""
    echo "Use 'unlock' command to disable protection"
    exit 0
fi

if [[ "$PROMPT_LOWER" == "unlock" ]]; then
    echo "unlocked" > .claude/.lock_state
    echo "🔓 SYSTEM UNLOCKED - All files can be modified"
    echo ""
    echo "⚠️  Warning: System files can now be changed"
    echo "This mode is intended for development only"
    echo ""
    echo "Use 'lock' command to enable protection"
    exit 0
fi

if [[ "$PROMPT_LOWER" == "status" ]]; then
    if [ -f ".claude/.lock_state" ]; then
        STATE=$(cat .claude/.lock_state)
    else
        STATE="unlocked"
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔐 System Lock Status: $(echo $STATE | tr '[:lower:]' '[:upper:]')"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ "$STATE" = "locked" ]; then
        echo "🔒 Protection: ENABLED"
        echo "   • System files are protected"
        echo "   • Only /projects/ can be modified"
        echo "   • Use 'unlock' to disable"
    else
        echo "🔓 Protection: DISABLED"
        echo "   • All files can be modified"
        echo "   • Development mode active"
        echo "   • Use 'lock' to enable protection"
    fi
    
    # Count projects
    PROJECT_COUNT=$(ls -1 projects/*.pine 2>/dev/null | grep -v blank.pine | wc -l)
    echo ""
    echo "📁 Projects: $PROJECT_COUNT Pine Script(s) in /projects/"
    
    exit 0
fi

# Check for single-word commands first
if [[ "$PROMPT_LOWER" == "start" ]]; then
    echo "🚀 Running interactive start command..."
    ./start
    exit 0
fi

if [[ "$PROMPT_LOWER" == "help" ]]; then
    echo "📚 Pine Script Assistant Commands:"
    echo ""
    echo "Core Commands:"
    echo "  • start - Interactive setup guide"
    echo "  • help - This help message"
    echo "  • status - Show system status and lock state"
    echo ""
    echo "Protection Commands:"
    echo "  • lock - Enable file protection (only /projects/ writable)"
    echo "  • unlock - Disable protection (development mode)"
    echo ""
    echo "Creation Commands:"
    echo "  • analyze [URL] - Analyze YouTube video"
    echo "  • create [description] - Create Pine Script"
    echo "  • examples - Show available examples"
    echo "  • templates - Show quick templates"
    exit 0
fi

if [[ "$PROMPT_LOWER" == "examples" ]]; then
    echo "📁 Available example scripts:"
    ls -1 examples/*/*.pine 2>/dev/null | sed 's/examples\//  /'
    exit 0
fi

if [[ "$PROMPT_LOWER" == "templates" ]]; then
    echo "🎯 Quick templates available:"
    echo "  • RSI divergence indicator"
    echo "  • Moving average crossover strategy"
    echo "  • Bollinger Band squeeze"
    echo "  • Volume profile"
    echo "  • MACD with alerts"
    echo ""
    echo "Tell Claude which template you want!"
    exit 0
fi

# Function to suggest agent usage
suggest_agent() {
    echo "🤖 Pine Script Agent Router: Detected $1 request"
    echo "Recommended agent: $2"
    echo "---"
}

# Check for project initialization
if [[ "$PROMPT_LOWER" == *"create"* ]] || [[ "$PROMPT_LOWER" == *"build"* ]] || [[ "$PROMPT_LOWER" == *"make"* ]] || [[ "$PROMPT_LOWER" == *"new"* ]]; then
    if [[ "$PROMPT_LOWER" == *"indicator"* ]] || [[ "$PROMPT_LOWER" == *"strategy"* ]] || [[ "$PROMPT_LOWER" == *"script"* ]]; then
        suggest_agent "new Pine Script project" "pine-manager to orchestrate full workflow"
        
        # Check if blank.pine exists and automatically prepare for renaming
        if [ -f "$(dirname "$0")/../../projects/blank.pine" ]; then
            echo "📝 Ready to start new project - blank.pine will be automatically renamed"
            echo "🔄 A fresh blank.pine will be created for future projects"
        fi
    fi
fi

# Check for debugging requests
if [[ "$PROMPT_LOWER" == *"debug"* ]] || [[ "$PROMPT_LOWER" == *"error"* ]] || [[ "$PROMPT_LOWER" == *"fix"* ]] || [[ "$PROMPT_LOWER" == *"issue"* ]] || [[ "$PROMPT_LOWER" == *"problem"* ]]; then
    suggest_agent "debugging" "pine-debugger"
fi

# Check for optimization requests
if [[ "$PROMPT_LOWER" == *"optimize"* ]] || [[ "$PROMPT_LOWER" == *"faster"* ]] || [[ "$PROMPT_LOWER" == *"improve"* ]] || [[ "$PROMPT_LOWER" == *"performance"* ]]; then
    suggest_agent "optimization" "pine-optimizer"
fi

# Check for backtesting requests
if [[ "$PROMPT_LOWER" == *"backtest"* ]] || [[ "$PROMPT_LOWER" == *"test"* ]] || [[ "$PROMPT_LOWER" == *"metrics"* ]] || [[ "$PROMPT_LOWER" == *"performance"* ]]; then
    if [[ "$PROMPT_LOWER" == *"strategy"* ]] || [[ "$PROMPT_LOWER" == *"profit"* ]] || [[ "$PROMPT_LOWER" == *"win rate"* ]]; then
        suggest_agent "backtesting" "pine-backtester"
    fi
fi

# Check for publishing requests
if [[ "$PROMPT_LOWER" == *"publish"* ]] || [[ "$PROMPT_LOWER" == *"share"* ]] || [[ "$PROMPT_LOWER" == *"release"* ]] || [[ "$PROMPT_LOWER" == *"community"* ]]; then
    suggest_agent "publishing preparation" "pine-publisher"
fi

# Check for YouTube video URLs or analyze command
if [[ "$PROMPT_LOWER" == *"youtube.com"* ]] || [[ "$PROMPT_LOWER" == *"youtu.be"* ]] || [[ "$PROMPT_LOWER" == *"analyze"* ]]; then
    if [[ "$PROMPT_LOWER" == *"youtube.com/watch"* ]] || [[ "$PROMPT_LOWER" == *"youtu.be/"* ]]; then
        echo "🎥 YouTube Video Detected!"
        echo "The pine-visualizer agent will:"
        echo "  1. Extract and analyze the video transcript"
        echo "  2. Identify trading concepts and strategies"
        echo "  3. Create a Pine Script specification"
        echo "  4. Pass to pine-manager for implementation"
        echo "---"
        suggest_agent "YouTube video analysis" "pine-visualizer to extract strategy"
    elif [[ "$PROMPT_LOWER" == "analyze "* ]]; then
        echo "📊 Analysis request detected"
        suggest_agent "video/content analysis" "pine-visualizer for extraction"
    fi
fi

# Check for conceptual/planning requests
if [[ "$PROMPT_LOWER" == *"how"* ]] || [[ "$PROMPT_LOWER" == *"plan"* ]] || [[ "$PROMPT_LOWER" == *"design"* ]] || [[ "$PROMPT_LOWER" == *"concept"* ]]; then
    if [[ "$PROMPT_LOWER" == *"indicator"* ]] || [[ "$PROMPT_LOWER" == *"strategy"* ]]; then
        suggest_agent "conceptual planning" "pine-visualizer"
    fi
fi

# Complex project detection (multiple requirements)
COMPLEXITY_SCORE=0
[[ "$PROMPT_LOWER" == *"and"* ]] && ((COMPLEXITY_SCORE++))
[[ "$PROMPT_LOWER" == *"with"* ]] && ((COMPLEXITY_SCORE++))
[[ "$PROMPT_LOWER" == *"also"* ]] && ((COMPLEXITY_SCORE++))
[[ "$PROMPT_LOWER" == *"multi"* ]] && ((COMPLEXITY_SCORE++))
[[ "$PROMPT_LOWER" == *"complete"* ]] && ((COMPLEXITY_SCORE++))
[[ "$PROMPT_LOWER" == *"full"* ]] && ((COMPLEXITY_SCORE++))

if [ $COMPLEXITY_SCORE -ge 2 ]; then
    echo "📊 Complex project detected (complexity score: $COMPLEXITY_SCORE)"
    suggest_agent "complex multi-part project" "pine-manager for orchestration"
fi

exit 0