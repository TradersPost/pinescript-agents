# Pine Script v6 - Plots and Data Visualization

## CRITICAL LIMITATION: Plot Cannot Be Used in Local Scopes

⚠️ **IMPORTANT: The `plot()` function can ONLY be called at the global scope of a script.**

### ❌ This Will Cause "Cannot use 'plot' in local scope" Error:
```pinescript
// WRONG - plot inside if statement
if showMACD
    plot(macdLine, "MACD", color=color.blue)  // ERROR!
    
// WRONG - plot inside function
myFunction() =>
    value = close * 2
    plot(value)  // ERROR!
    
// WRONG - plot inside for loop
for i = 0 to 10
    plot(close[i])  // ERROR!
```

### ✅ CORRECT Solutions:
```pinescript
// SOLUTION 1: Use conditional value with ternary operator
showMACD = input.bool(true, "Show MACD")
macdLine = ta.macd(close, 12, 26, 9)[0]
plot(showMACD ? macdLine : na, "MACD", color=color.blue)

// SOLUTION 2: Use conditional color/style
plot(macdLine, "MACD", color=showMACD ? color.blue : color.new(color.blue, 100))

// SOLUTION 3: Pre-calculate in function, plot at global scope
calcValue() =>
    close * 2
    
myValue = calcValue()
plot(myValue, "My Value")  // Plot OUTSIDE function

// SOLUTION 4: For dynamic plots, use line.new() or label.new() instead
if condition
    line.new(bar_index, high, bar_index + 1, low, color=color.red)  // OK in local scope
```

## Overview

Plots are the primary way to visualize data in Pine Script. The `plot()` function displays numerical values as various visual styles on the chart, allowing traders to see indicator values, price levels, and custom calculations.

## Basic Plot Function

```pinescript
//@version=6
indicator("Basic Plot Example", overlay=true)

// Simple line plot
sma20 = ta.sma(close, 20)
plot(sma20, title="SMA 20", color=color.blue)

// Plot with custom color and width
ema20 = ta.ema(close, 20)
plot(ema20, title="EMA 20", color=color.red, linewidth=2)
```

## Plot Styles

### Line Plots (Default)
```pinescript
//@version=6
indicator("Line Plot Styles")

rsi = ta.rsi(close, 14)

// Basic line
plot(rsi, title="RSI", color=color.purple)

// Thick line
plot(ta.sma(rsi, 10), title="RSI SMA", color=color.orange, linewidth=3)

// Dashed line (using linestyle)
plot(70, title="Overbought", color=color.red, linestyle=line.style_dashed)
plot(30, title="Oversold", color=color.green, linestyle=line.style_dashed)
```

### Histogram Plots
```pinescript
//@version=6
indicator("Histogram Examples")

macd_line = ta.ema(close, 12) - ta.ema(close, 26)
signal_line = ta.ema(macd_line, 9)
histogram = macd_line - signal_line

// Basic histogram
plot(histogram, title="MACD Histogram", style=plot.style_histogram, color=color.gray)

// Colored histogram based on value
hist_color = histogram > 0 ? color.lime : color.red
plot(histogram, title="MACD Histogram Colored", style=plot.style_histogram, color=hist_color)
```

### Area Plots
```pinescript
//@version=6
indicator("Area Plot Example", overlay=true)

upper_band = ta.sma(close, 20) + ta.stdev(close, 20) * 2
lower_band = ta.sma(close, 20) - ta.stdev(close, 20) * 2

// Area between bands
plot(upper_band, title="Upper Band", color=color.new(color.blue, 70))
plot(lower_band, title="Lower Band", color=color.new(color.blue, 70))

// Fill area between plots
fill(plot(upper_band), plot(lower_band), color=color.new(color.blue, 90), title="Band Fill")
```

### Step Line Plots
```pinescript
//@version=6
indicator("Step Line Example")

// Volume-based step line
vol_sma = ta.sma(volume, 20)
plot(vol_sma, title="Volume SMA", style=plot.style_stepline, color=color.blue, linewidth=2)

// Price level steps
daily_high = request.security(syminfo.tickerid, "1D", high[1])
plot(daily_high, title="Previous Day High", style=plot.style_stepline, color=color.red)
```

### Cross Plots
```pinescript
//@version=6
indicator("Cross Plot Example", overlay=true)

// Mark crossover points
fast_ma = ta.ema(close, 10)
slow_ma = ta.ema(close, 20)

// Plot crosses at crossover points
bullish_cross = ta.crossover(fast_ma, slow_ma)
bearish_cross = ta.crossunder(fast_ma, slow_ma)

plotshape(bullish_cross, title="Bullish Cross", style=shape.cross, 
          location=location.belowbar, color=color.green, size=size.normal)
plotshape(bearish_cross, title="Bearish Cross", style=shape.cross, 
          location=location.abovebar, color=color.red, size=size.normal)
```

## Plot Styles Reference

### Available Styles
```pinescript
// Line styles
plot.style_line        // Default solid line
plot.style_stepline    // Step line
plot.style_histogram   // Vertical bars from zero
plot.style_cross       // Cross markers
plot.style_area        // Area fill from zero
plot.style_columns     // Vertical columns
plot.style_circles     // Circle markers
plot.style_linebr      // Line with breaks on na values
```

### Line Styles
```pinescript
// Available line styles for borders and lines
line.style_solid       // Solid line (default)
line.style_dashed      // Dashed line
line.style_dotted      // Dotted line
```

## Advanced Plotting Techniques

### Conditional Plotting
```pinescript
//@version=6
indicator("Conditional Plotting")

rsi = ta.rsi(close, 14)

// Plot only when RSI is in certain ranges
overbought_rsi = rsi > 70 ? rsi : na
oversold_rsi = rsi < 30 ? rsi : na

plot(overbought_rsi, title="Overbought RSI", color=color.red, linewidth=2)
plot(oversold_rsi, title="Oversold RSI", color=color.green, linewidth=2)

// Plot background fill for conditions
bgcolor(rsi > 70 ? color.new(color.red, 90) : na, title="Overbought BG")
bgcolor(rsi < 30 ? color.new(color.green, 90) : na, title="Oversold BG")
```

### Width and Transparency
```pinescript
//@version=6
indicator("Line Width and Transparency")

sma20 = ta.sma(close, 20)
sma50 = ta.sma(close, 50)
sma200 = ta.sma(close, 200)

// Different line widths
plot(sma20, title="SMA 20", color=color.blue, linewidth=1)
plot(sma50, title="SMA 50", color=color.orange, linewidth=2)
plot(sma200, title="SMA 200", color=color.red, linewidth=3)

// Transparency levels (0 = opaque, 100 = transparent)
plot(ta.ema(close, 10), title="EMA 10 - 25% transparent", 
     color=color.new(color.purple, 25), linewidth=2)
plot(ta.ema(close, 30), title="EMA 30 - 50% transparent", 
     color=color.new(color.yellow, 50), linewidth=2)
```

### Offset and Displacement
```pinescript
//@version=6
indicator("Plot Offset Example", overlay=true)

sma20 = ta.sma(close, 20)

// Current SMA
plot(sma20, title="Current SMA", color=color.blue)

// SMA shifted forward by 5 bars
plot(sma20, title="SMA +5 offset", color=color.red, offset=5)

// SMA shifted backward by 5 bars
plot(sma20, title="SMA -5 offset", color=color.green, offset=-5)

// Using historical values
plot(sma20[10], title="SMA 10 bars ago", color=color.orange, linewidth=2)
```

## Multiple Plots with Different Scales

### Separate Panes
```pinescript
//@version=6
indicator("Multiple Scale Example", overlay=false)

// Price-based indicator
rsi = ta.rsi(close, 14)
plot(rsi, title="RSI", color=color.purple)

// Volume-based indicator (different scale)
vol_rsi = ta.rsi(volume, 14)
plot(vol_rsi, title="Volume RSI", color=color.blue)

// Reference lines
hline(70, title="Overbought", color=color.red, linestyle=hline.style_dashed)
hline(30, title="Oversold", color=color.green, linestyle=hline.style_dashed)
hline(50, title="Midline", color=color.gray, linestyle=hline.style_dotted)
```

### Normalized Plots
```pinescript
//@version=6
indicator("Normalized Multi-Indicator")

// Normalize function
normalize(src, length) =>
    highest = ta.highest(src, length)
    lowest = ta.lowest(src, length)
    (src - lowest) / (highest - lowest) * 100

// Multiple normalized indicators
norm_rsi = normalize(ta.rsi(close, 14), 50)
norm_stoch = normalize(ta.stoch(close, high, low, 14), 50)
norm_macd = normalize(ta.macd(close, 12, 26, 9)[0], 50)

plot(norm_rsi, title="Normalized RSI", color=color.red)
plot(norm_stoch, title="Normalized Stochastic", color=color.blue)
plot(norm_macd, title="Normalized MACD", color=color.green)
```

## Plot Performance Optimization

### Efficient Plotting
```pinescript
//@version=6
indicator("Optimized Plotting")

// Pre-calculate once, use multiple times
rsi_value = ta.rsi(close, 14)
is_overbought = rsi_value > 70
is_oversold = rsi_value < 30

// Use conditions to minimize plotting calls
plot(rsi_value, title="RSI", 
     color=is_overbought ? color.red : is_oversold ? color.green : color.gray)

// Avoid unnecessary calculations in plot calls
// Good: calculate once, plot once
sma_value = ta.sma(close, 20)
plot(sma_value, title="SMA", color=color.blue)

// Bad: calculating in every plot call
// plot(ta.sma(close, 20), title="SMA", color=color.blue)  // Inefficient if used multiple times
```

### Managing Plot Limits
```pinescript
//@version=6
indicator("Plot Limit Management")

// Pine Script has a limit of 64 plots
// Use arrays or other methods for dynamic plotting

// Example: Plot only significant levels
pivot_high = ta.pivothigh(high, 5, 5)
pivot_low = ta.pivotlow(low, 5, 5)

// Plot only when pivots are found
plot(pivot_high, title="Pivot High", style=plot.style_circles, 
     color=color.red, linewidth=3, offset=-5)
plot(pivot_low, title="Pivot Low", style=plot.style_circles, 
     color=color.green, linewidth=3, offset=-5)
```

## Common Plot Patterns

### Ribbon Effect
```pinescript
//@version=6
indicator("MA Ribbon", overlay=true)

// Create moving average ribbon
ma_length = 20
ma_increment = 5

ma1 = ta.ema(close, ma_length)
ma2 = ta.ema(close, ma_length + ma_increment)
ma3 = ta.ema(close, ma_length + ma_increment * 2)
ma4 = ta.ema(close, ma_length + ma_increment * 3)

// Plot with gradient transparency
plot(ma1, title="EMA 20", color=color.new(color.blue, 0))
plot(ma2, title="EMA 25", color=color.new(color.blue, 25))
plot(ma3, title="EMA 30", color=color.new(color.blue, 50))
plot(ma4, title="EMA 35", color=color.new(color.blue, 75))
```

### Support/Resistance Levels
```pinescript
//@version=6
indicator("Support Resistance", overlay=true)

// Calculate support/resistance levels
resistance_level = ta.highest(high, 50)
support_level = ta.lowest(low, 50)

// Plot as horizontal lines
plot(resistance_level, title="Resistance", color=color.red, 
     linewidth=2, style=plot.style_stepline)
plot(support_level, title="Support", color=color.green, 
     linewidth=2, style=plot.style_stepline)

// Add zone between levels
fill(plot(resistance_level), plot(support_level), 
     color=color.new(color.gray, 95), title="Range Zone")
```

## Best Practices

### 1. Color Management
```pinescript
// Define colors at the top for consistency
BULLISH_COLOR = color.new(color.green, 20)
BEARISH_COLOR = color.new(color.red, 20)
NEUTRAL_COLOR = color.new(color.gray, 40)

// Use meaningful names
trend_color = close > ta.sma(close, 20) ? BULLISH_COLOR : BEARISH_COLOR
plot(ta.sma(close, 20), color=trend_color)
```

### 2. Plot Organization
```pinescript
// Group related plots together
// Main trend indicators
sma_fast = ta.sma(close, 10)
sma_slow = ta.sma(close, 20)
plot(sma_fast, title="Fast SMA", color=color.blue)
plot(sma_slow, title="Slow SMA", color=color.red)

// Support levels
plot(ta.support_level, title="Support", color=color.green, linestyle=line.style_dashed)
plot(ta.resistance_level, title="Resistance", color=color.red, linestyle=line.style_dashed)
```

### 3. Performance Considerations
- Limit the number of plots (max 64)
- Pre-calculate values used multiple times
- Use conditional plotting to reduce visual clutter
- Avoid complex calculations within plot() calls

### 4. User Experience
- Use meaningful titles and colors
- Provide appropriate transparency for background elements
- Consider color-blind accessibility
- Group related plots logically
- Use consistent styling throughout your indicator

## Troubleshooting Common Issues

### Plot Not Showing
```pinescript
// Check for na values
value = ta.sma(close, 20)
plot(na(value) ? 0 : value)  // Replace na with 0 or other default

// Check plot limits and scaling
// Ensure values are in reasonable range for visibility
```

### Overlapping Plots
```pinescript
// Use offset to separate similar plots
plot(ta.sma(close, 20), offset=1, color=color.blue)
plot(ta.ema(close, 20), offset=-1, color=color.red)

// Use different transparency levels
plot(ma1, color=color.new(color.blue, 0))
plot(ma2, color=color.new(color.blue, 30))
```

This comprehensive guide covers all aspects of plotting in Pine Script v6, from basic line plots to advanced visualization techniques. Use these patterns and examples to create clear, informative, and visually appealing indicators.