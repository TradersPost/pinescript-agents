# Pine Script v6 Repainting Prevention Guide

## What is Repainting?

Repainting occurs when a script's output changes for historical bars after the script has been running. This creates a misleading picture where historical signals appear more accurate than they actually were, making backtesting results unreliable.

## Types of Repainting

### 1. Real-time vs Historical Differences
The most common cause of repainting is when scripts behave differently on real-time bars versus historical bars.

```pine
//@version=6
indicator("Repainting Example - BAD", overlay=true)

// BAD: This will repaint because it uses real-time high/low
currentHigh = high  // Changes during real-time bar formation
resistance = ta.highest(currentHigh, 20)

// This level will shift as the real-time bar updates
plot(resistance, color=color.red, title="Resistance - REPAINTS")
```

### 2. Lookahead Bias
Using future data to calculate current signals causes severe repainting.

```pine
//@version=6
indicator("Lookahead Bias - BAD", overlay=true)

// BAD: Using future data
futureHigh = high[1]  // This would be using future data if calculated incorrectly
signal = close > futureHigh  // Signal based on future information

plotshape(signal, style=shape.triangleup, location=location.belowbar, color=color.green)
```

### 3. Higher Timeframe Repainting
Improper use of `request.security()` can cause repainting.

```pine
//@version=6
indicator("HTF Repainting - BAD", overlay=true)

// BAD: Default lookahead setting can cause repainting
htfClose = request.security(syminfo.tickerid, "1D", close)  // May repaint

// Current timeframe signal based on HTF data
signal = close > htfClose
plotshape(signal, style=shape.circle, location=location.abovebar, color=color.blue)
```

## How to Prevent Repainting

### 1. Use Confirmed Values Only

```pine
//@version=6
indicator("Non-Repainting Method 1", overlay=true)

// GOOD: Use only confirmed values
confirmedHigh = barstate.isconfirmed ? high : high[1]
confirmedLow = barstate.isconfirmed ? low : low[1]
confirmedClose = barstate.isconfirmed ? close : close[1]

// Calculate resistance/support on confirmed data
resistance = ta.highest(confirmedHigh, 20)
support = ta.lowest(confirmedLow, 20)

plot(resistance, color=color.red, title="Non-Repainting Resistance")
plot(support, color=color.green, title="Non-Repainting Support")
```

### 2. Wait for Bar Confirmation

```pine
//@version=6
indicator("Non-Repainting Method 2", overlay=true)

// GOOD: Calculate signals only on bar confirmation
var float entryPrice = na
var bool signalActive = false

// Signal logic using previous bar's data
bullishSignal = close[1] > ta.sma(close[1], 20) and close[2] <= ta.sma(close[2], 20)

// Confirm signal on new bar
if barstate.isnew and bullishSignal
    entryPrice := close[1]  // Use previous bar's close
    signalActive := true

// Exit logic
if signalActive and (close < entryPrice * 0.98 or close > entryPrice * 1.02)
    signalActive := false
    entryPrice := na

// Plot
plot(entryPrice, color=signalActive ? color.green : na, style=plot.style_line, linewidth=2)
plotshape(barstate.isnew and bullishSignal, style=shape.triangleup, location=location.belowbar, color=color.green)
```

### 3. Proper request.security() Usage

```pine
//@version=6
indicator("Non-Repainting HTF", overlay=true)

// GOOD: Disable lookahead to prevent repainting
htfClose = request.security(syminfo.tickerid, "1D", close, lookahead=barmerge.lookahead_off)
htfHigh = request.security(syminfo.tickerid, "1D", high, lookahead=barmerge.lookahead_off)
htfLow = request.security(syminfo.tickerid, "1D", low, lookahead=barmerge.lookahead_off)

// Alternative: Use gaps to ensure no lookahead
htfCloseGapped = request.security(syminfo.tickerid, "1D", close, gaps=barmerge.gaps_on, lookahead=barmerge.lookahead_off)

plot(htfClose, color=color.blue, linewidth=2, title="HTF Close (Non-Repainting)")
```

### 4. Using Historical Offset

```pine
//@version=6
indicator("Historical Offset Method", overlay=true)

// GOOD: Always use previous bar for signals
prevMA = ta.sma(close[1], 20)  // Previous bar's MA
prevPrice = close[1]           // Previous bar's close

// Signal based on confirmed data
bullishCrossover = prevPrice > prevMA and close[2] <= ta.sma(close[2], 20)

plotshape(bullishCrossover, style=shape.triangleup, location=location.belowbar, color=color.green)
plot(ta.sma(close[1], 20), color=color.blue, title="Previous Bar MA")
```

## Testing for Repainting

### Method 1: Real-time vs Historical Comparison
```pine
//@version=6
indicator("Repainting Test", overlay=true)

// Test variable
testValue = ta.highest(high, 10)

// Store values at different times
var float historicalValue = na
var float realtimeValue = na

// Capture values
if barstate.isconfirmed
    historicalValue := testValue

if barstate.isrealtime
    realtimeValue := testValue

// Compare values - if different, there's repainting
repaintDetected = not na(historicalValue) and not na(realtimeValue) and historicalValue != realtimeValue

bgcolor(repaintDetected ? color.new(color.red, 80) : na, title="Repainting Detected")
```

### Method 2: Bar State Analysis
```pine
//@version=6
indicator("Bar State Test", overlay=false)

// Track values across bar states
var float confirmationValue = na
var float realtimeMax = na
var float realtimeMin = na

// Reset on new bar
if barstate.isnew
    realtimeMax := high
    realtimeMin := low

// Update during real-time
if barstate.isrealtime
    realtimeMax := math.max(realtimeMax, high)
    realtimeMin := math.min(realtimeMin, low)

// Store confirmed value
if barstate.isconfirmed
    confirmationValue := high

// Check for changes after confirmation
repainting = not na(confirmationValue) and barstate.isrealtime and high != confirmationValue

plot(repainting ? 1 : 0, color=color.red, title="Repainting Indicator")
```

## Common Repainting Scenarios and Solutions

### Scenario 1: Pivot Points
```pine
//@version=6
indicator("Non-Repainting Pivots", overlay=true)

// BAD: Real-time pivot detection
// pivotHigh = ta.pivothigh(high, 5, 5)  // May repaint

// GOOD: Confirmed pivot detection
confirmedPivotHigh = ta.pivothigh(high[1], 5, 5)  // Use historical data

plotshape(not na(confirmedPivotHigh), style=shape.triangledown, location=location.abovebar, color=color.red, size=size.small)
```

### Scenario 2: Breakout Detection
```pine
//@version=6
indicator("Non-Repainting Breakout", overlay=true)

// Calculate resistance level from confirmed data
lookback = 20
resistance = ta.highest(high[1], lookback)  // Use previous bars only

// Breakout condition using confirmed data
breakout = close[1] > resistance[1] and close[2] <= resistance[2]

// Signal appears only after bar confirmation
plotshape(breakout and barstate.isnew, style=shape.triangleup, location=location.belowbar, color=color.green)
plot(resistance, color=color.red, style=plot.style_line, title="Resistance")
```

### Scenario 3: Multi-Condition Signals
```pine
//@version=6
indicator("Non-Repainting Multi-Condition", overlay=true)

// All conditions use confirmed data
ma20 = ta.sma(close[1], 20)
ma50 = ta.sma(close[1], 50)
rsi = ta.rsi(close[1], 14)
volume_avg = ta.sma(volume[1], 20)

// Multi-condition signal
bullishConditions = close[1] > ma20 and ma20 > ma50 and rsi < 70 and volume[1] > volume_avg

// Confirm signal on new bar only
confirmedSignal = bullishConditions and barstate.isnew

plotshape(confirmedSignal, style=shape.labelup, location=location.belowbar, color=color.green, text="BUY")
```

## Advanced Anti-Repainting Techniques

### Using Arrays for Historical Data
```pine
//@version=6
indicator("Array-Based Non-Repainting", overlay=true)

// Store confirmed values in arrays
var array<float> confirmedCloses = array.new<float>()
var array<float> confirmedHighs = array.new<float>()

// Add confirmed data only
if barstate.isconfirmed
    array.push(confirmedCloses, close)
    array.push(confirmedHighs, high)
    
    // Limit array size
    if array.size(confirmedCloses) > 100
        array.shift(confirmedCloses)
        array.shift(confirmedHighs)

// Calculate signals from confirmed data only
if array.size(confirmedCloses) >= 20
    confirmedMA = array.avg(confirmedCloses)
    confirmedResistance = array.max(confirmedHighs)
    
    plot(confirmedMA, color=color.blue, title="Confirmed MA")
    plot(confirmedResistance, color=color.red, title="Confirmed Resistance")
```

### State Machine Approach
```pine
//@version=6
indicator("State Machine Anti-Repainting", overlay=true)

// Define states
var string state = "WAITING"
var float entryLevel = na
var int barsInState = 0

// State transitions only on confirmed bars
if barstate.isconfirmed
    barsInState := barsInState + 1
    
    if state == "WAITING"
        // Look for entry condition
        if close > ta.sma(close, 20) * 1.02
            state := "ENTERED"
            entryLevel := close
            barsInState := 0
    
    else if state == "ENTERED"
        // Look for exit condition or timeout
        if close < entryLevel * 0.95 or barsInState >= 10
            state := "WAITING"
            entryLevel := na
            barsInState := 0

// Visual feedback
bgcolor(state == "ENTERED" ? color.new(color.green, 90) : na)
plot(entryLevel, color=state == "ENTERED" ? color.green : na, style=plot.style_line, linewidth=2)
```

## Debugging Repainting Issues

### Real-time Monitor
```pine
//@version=6
indicator("Repainting Monitor", overlay=false)

// Monitor a specific calculation
monitoredValue = ta.highest(high, 10)

// Track changes
var float lastConfirmedValue = na
var bool valueChanged = false

if barstate.isconfirmed
    if not na(lastConfirmedValue) and lastConfirmedValue != monitoredValue
        valueChanged := true
    lastConfirmedValue := monitoredValue
else
    valueChanged := false

// Alert when repainting detected
if valueChanged
    alert("Repainting detected in monitored value!", alert.freq_once_per_bar)

plot(valueChanged ? 1 : 0, color=color.red, title="Repaint Alert")
plot(monitoredValue, color=color.blue, title="Monitored Value")
```

## Best Practices Summary

1. **Always use confirmed data**: Avoid calculations on real-time bars
2. **Test thoroughly**: Compare historical vs real-time behavior
3. **Use proper request.security() settings**: Always set `lookahead=barmerge.lookahead_off`
4. **Implement bar confirmation**: Wait for `barstate.isnew` before signaling
5. **Use historical offsets**: Reference previous bars for signal generation
6. **Document behavior**: Clearly state if any repainting exists and why
7. **Validate with arrays**: Store confirmed values for complex calculations
8. **Monitor in real-time**: Implement repainting detection in your scripts

## Warning Signs of Repainting

- Signals that appear and disappear in real-time
- Backtest results that seem too good to be true
- Different outputs when refreshing the chart
- Signals that change when viewed on different timeframes
- Perfect entries and exits in historical testing

By following these guidelines and techniques, you can create Pine Script indicators and strategies that provide reliable, non-repainting signals suitable for real-world trading.