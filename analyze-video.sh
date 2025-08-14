#!/bin/bash
# Video Analysis Wrapper for Pine Script Development

echo "🎥 Pine Script Video Analyzer"
echo "============================"
echo ""

# Check if URL provided
if [ $# -eq 0 ]; then
    echo "Please provide a YouTube URL:"
    read -r url
else
    url=$1
fi

# Validate URL format
if [[ ! "$url" =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/ ]]; then
    echo "❌ Error: Invalid YouTube URL"
    echo "Expected format: https://youtube.com/watch?v=... or https://youtu.be/..."
    exit 1
fi

echo "📊 Analyzing video..."
echo "URL: $url"
echo ""

# Run the analyzer
python3 tools/video-analyzer.py "$url"

# Check if analysis was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Analysis complete!"
    echo ""
    echo "Next steps:"
    echo "1. Review the summary above"
    echo "2. Confirm if the understanding is correct"
    echo "3. The system will create your Pine Script"
    echo ""
    echo "To proceed, type 'yes' or describe what needs adjustment:"
    read -r response
    
    if [ "$response" = "yes" ]; then
        echo ""
        echo "🚀 Great! The Pine Script development will now begin."
        echo "The pine-manager agent will take over from here."
    else
        echo ""
        echo "📝 Noted. Please describe what needs to be adjusted:"
        echo "$response"
        echo ""
        echo "The visualizer will refine the analysis based on your feedback."
    fi
else
    echo "❌ Analysis failed. Please check the URL and try again."
    exit 1
fi