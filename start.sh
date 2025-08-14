#!/bin/bash
# Manual start script for Pine Script Development Assistant

echo "🚀 PINE SCRIPT DEVELOPMENT ASSISTANT"
echo "===================================="
echo ""

# Check if first time
if [ ! -f ".claude/.onboarding_complete" ]; then
    echo "👋 Welcome! This appears to be your first time."
    echo ""
    echo "This system helps you create TradingView Pine Scripts using AI."
    echo ""
    echo "You can:"
    echo "  1. Describe any indicator or strategy you want"
    echo "  2. Provide a YouTube video to analyze"
    echo "  3. Request complex features (we'll find workarounds)"
    echo ""
    echo "Example commands:"
    echo '  "Create an RSI divergence indicator"'
    echo '  "Build a moving average crossover strategy"'
    echo '  "Analyze this video: [YouTube URL]"'
    echo ""
    
    mkdir -p .claude
    touch .claude/.onboarding_complete
else
    echo "✅ System ready!"
    echo ""
    # Count projects
    if [ -d "projects" ]; then
        count=$(ls -1 projects/*.pine 2>/dev/null | grep -v blank.pine | wc -l)
        if [ $count -gt 0 ]; then
            echo "📁 You have $count existing Pine Script(s):"
            ls -1 projects/*.pine | grep -v blank.pine | head -3 | sed 's/projects\//  - /'
            echo ""
        fi
    fi
fi

echo "💡 Quick start: Just tell Claude what you want to build!"
echo ""
echo "Ready? Type your request or 'help' for more options."
echo "