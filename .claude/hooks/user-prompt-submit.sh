#!/bin/bash
# Pine Script Agent Router Hook
# This hook runs before processing user prompts to ensure appropriate agent selection

# Check if the prompt mentions specific keywords to route to agents
PROMPT="$1"
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

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