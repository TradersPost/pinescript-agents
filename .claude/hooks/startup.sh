#!/bin/bash
# Startup Hook - Runs when Claude Code initializes in this project

echo "🚀 PINE SCRIPT DEVELOPMENT ASSISTANT INITIALIZING..."
echo "=================================================="
echo ""

# Check if this is first run
ONBOARDING_FILE=".claude/.onboarding_complete"

if [ ! -f "$ONBOARDING_FILE" ]; then
    echo "👋 Welcome to Pine Script Development Assistant!"
    echo ""
    echo "This appears to be your first time using this system."
    echo "Let me help you get started..."
    echo ""
    echo "📋 QUICK SETUP CHECKLIST:"
    echo "✓ 7 specialized AI agents loaded"
    echo "✓ Pine Script v6 documentation ready"
    echo "✓ Video analysis tools available"
    echo "✓ Template library loaded"
    echo ""
    echo "🎯 HOW TO GET STARTED:"
    echo ""
    echo "1. SIMPLE REQUEST:"
    echo "   Just tell me what you want to build:"
    echo "   - 'Create an RSI indicator'"
    echo "   - 'Build a moving average crossover strategy'"
    echo "   - 'Make a volume profile indicator'"
    echo ""
    echo "2. FROM A VIDEO:"
    echo "   Share a YouTube video about a strategy:"
    echo "   - 'Analyze this video: [YouTube URL]'"
    echo "   - './analyze-video.sh [YouTube URL]'"
    echo ""
    echo "3. COMPLEX REQUEST:"
    echo "   Describe your unique requirements:"
    echo "   - 'I need a pairs trading strategy for crypto'"
    echo "   - 'Build a market profile with delta analysis'"
    echo ""
    echo "💡 HELPFUL COMMANDS:"
    echo "   /agents - See available AI agents"
    echo "   /help - Get help with Claude Code"
    echo "   ls projects/ - See your Pine Scripts"
    echo ""
    echo "📁 YOUR SCRIPTS WILL BE SAVED IN: /projects/"
    echo ""
    echo "Ready to create your first Pine Script? Just tell me what you need!"
    echo ""
    
    # Mark onboarding as complete
    touch "$ONBOARDING_FILE"
    
    # Create initial state file
    echo "{
  \"onboarded\": true,
  \"first_run\": \"$(date -u +\"%Y-%m-%dT%H:%M:%SZ\")\",
  \"version\": \"1.0.0\"
}" > .claude/.state.json
    
else
    # Returning user
    echo "✅ Pine Script Development Assistant Ready!"
    echo ""
    
    # Check for any existing projects
    PROJECT_COUNT=$(ls -1 projects/*.pine 2>/dev/null | grep -v blank.pine | wc -l)
    
    if [ $PROJECT_COUNT -gt 0 ]; then
        echo "📁 You have $PROJECT_COUNT Pine Script project(s):"
        ls -1 projects/*.pine | grep -v blank.pine | head -5 | sed 's/projects\//  - /'
        
        if [ $PROJECT_COUNT -gt 5 ]; then
            echo "  ... and $((PROJECT_COUNT - 5)) more"
        fi
        echo ""
    fi
    
    echo "💡 Quick Actions:"
    echo "  • Create new script: 'Create a [type] indicator/strategy'"
    echo "  • Analyze video: 'Analyze [YouTube URL]'"
    echo "  • Get help: '/help'"
    echo ""
    echo "What would you like to build today?"
    echo ""
fi

# Ensure blank.pine exists
if [ ! -f "projects/blank.pine" ]; then
    echo "🔧 Creating blank.pine template..."
    mkdir -p projects
    cat > projects/blank.pine << 'EOF'
//@version=6
// This is a blank Pine Script template
// It will be renamed and populated based on your requirements
// 
// Project: [To be defined]
// Type: [Indicator/Strategy]
// Created: [Date]
// 
// ============================================================================

indicator("Blank Template", overlay=true)

// Your Pine Script code will be generated here
EOF
    echo "✓ Template ready"
    echo ""
fi

# Check Python dependencies for video analyzer
python3 -c "import youtube_transcript_api" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "📦 Installing video analysis dependencies..."
    pip3 install youtube-transcript-api pytube --quiet
    echo "✓ Dependencies installed"
    echo ""
fi

echo "---"
echo "🤖 System ready. How can I help you with Pine Script today?"
echo ""