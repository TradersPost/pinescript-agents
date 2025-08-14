#!/bin/bash
# After Edit Hook - Validates Pine Script modifications

FILE_PATH="$1"

# Only process Pine Script files
if [[ "$FILE_PATH" == *.pine ]]; then
    echo "🔍 Pine Script Validation Check"
    
    # Get file content
    if [ -f "$FILE_PATH" ]; then
        FILE_CONTENT=$(cat "$FILE_PATH")
        
        # Check for common Pine Script issues
        
        # Check for repainting risks
        if echo "$FILE_CONTENT" | grep -q "security.*lookahead"; then
            if ! echo "$FILE_CONTENT" | grep -q "lookahead.*=.*barmerge\.lookahead_off"; then
                echo "⚠️ Potential repainting issue detected: security() without lookahead_off"
            fi
        fi
        
        # Check for proper na handling
        if echo "$FILE_CONTENT" | grep -q "\[.*\]"; then
            if ! echo "$FILE_CONTENT" | grep -q "na("; then
                echo "💡 Tip: Consider checking for na values when using historical references []"
            fi
        fi
        
        # Check for strategy risk management
        if echo "$FILE_CONTENT" | grep -q "^strategy("; then
            if ! echo "$FILE_CONTENT" | grep -q "strategy\.risk"; then
                echo "💡 Tip: Consider adding risk management with strategy.risk functions"
            fi
        fi
        
        # Check for proper input groups
        if echo "$FILE_CONTENT" | grep -q "input\." && ! echo "$FILE_CONTENT" | grep -q "group="; then
            echo "💡 Tip: Consider organizing inputs with group= parameter for better UX"
        fi
        
        echo "✅ Pine Script validation complete"
    fi
fi

exit 0