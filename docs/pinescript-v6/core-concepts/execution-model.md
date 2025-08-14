# Pine Script v6 Execution Model

## How Pine Script Processes Data

Pine Script operates on a unique execution model that processes data bar by bar, from left to right on the chart. Understanding this model is crucial for writing effective Pine Script code.

## Bar-by-Bar Execution

### Sequential Processing
```pine
//@version=6
indicator("Execution Demo", overlay=true)

// This variable is calculated for EVERY bar
currentPrice = close

// This demonstrates the bar-by-bar execution
var int barCount = 0
barCount := barCount + 1  // Increments on each bar

// Plot shows how values change over time
plot(barCount, title="Bar Count")
```

### Historical vs Real-time Bars
Pine Script behaves differently for:
1. **Historical bars**: All bars from chart start to current real-time bar
2. **Real-time bar**: The currently forming bar that updates with each tick

```pine
//@version=6
indicator("Historical vs Real-time", overlay=false)

// This shows the difference
isRealtime = barstate.isrealtime
isHistorical = not barstate.isrealtime

plot(isRealtime ? 1 : 0, color=color.red, title="Real-time")
plot(isHistorical ? -1 : 0, color=color.blue, title="Historical")
```

## Bar States

### Understanding barstate.*
```pine
//@version=6
indicator("Bar States", overlay=false)

// Different bar states
isFirst = barstate.isfirst         // First bar of the dataset
isLast = barstate.islast           // Last bar (real-time bar)
isNew = barstate.isnew             // New bar has just started
isRealtime = barstate.isrealtime   // Currently processing real-time data
isConfirmed = barstate.isconfirmed // Bar is confirmed (not real-time)

// Visual representation
bgcolor(isFirst ? color.new(color.blue, 80) : na, title="First Bar")
bgcolor(isLast ? color.new(color.red, 80) : na, title="Last Bar")
bgcolor(isNew ? color.new(color.green, 80) : na, title="New Bar")

plot(isRealtime ? 1 : 0, color=color.red, title="Real-time")
plot(isConfirmed ? -1 : 0, color=color.blue, title="Confirmed")
```

## Variable Types and Scope

### Series Values
Series values recalculate on every bar:
```pine
//@version=6
indicator("Series Values", overlay=true)

// Recalculates on every bar
currentSMA = ta.sma(close, 20)
priceChange = close - close[1]

// These values change as script processes each bar
plot(currentSMA, title="SMA")
plot(priceChange, title="Price Change")
```

### Var Variables
Var variables maintain state across bars:
```pine
//@version=6
indicator("Var Variables", overlay=false)

// Initializes once, maintains value across bars
var float highestPrice = 0.0
var int barsSinceHigh = 0

// Only updates when condition is met
if high > highestPrice
    highestPrice := high
    barsSinceHigh := 0
else
    barsSinceHigh := barsSinceHigh + 1

plot(highestPrice, color=color.red, title="Highest Price")
plot(barsSinceHigh, color=color.blue, title="Bars Since High")
```

### Varip Variables
Varip variables update on every tick (real-time only):
```pine
//@version=6
indicator("Varip Variables", overlay=false)

// Updates on every tick in real-time
varip int tickCount = 0

// Only increments in real-time
if barstate.isrealtime
    tickCount := tickCount + 1

// Resets on new bar
if barstate.isnew
    tickCount := 0

plot(tickCount, title="Ticks in Current Bar")
```

## Execution Order

### Script Structure Execution
1. **Variable declarations**: Processed top to bottom
2. **Input statements**: Processed first
3. **Variable assignments**: Calculated in order
4. **Function calls**: Executed when called
5. **Plot statements**: Executed after calculations

```pine
//@version=6
indicator("Execution Order", overlay=true)

// 1. Inputs processed first
length = input.int(20, "MA Length")

// 2. Variables calculated in order
ma1 = ta.sma(close, length)
ma2 = ta.ema(close, length)
diff = ma1 - ma2

// 3. Conditions evaluated
crossUp = ta.crossover(ma1, ma2)

// 4. Plots executed last
plot(ma1, color=color.blue, title="SMA")
plot(ma2, color=color.red, title="EMA")
plotshape(crossUp, style=shape.triangleup, location=location.belowbar)
```

## Historical Reference Operator []

### Accessing Previous Values
```pine
//@version=6
indicator("Historical Reference", overlay=true)

// Current bar values
currentClose = close        // close[0] (implicit)
previousClose = close[1]    // Previous bar's close
close2BarsAgo = close[2]    // Close from 2 bars ago

// Calculate changes
change1Bar = close - close[1]
change5Bars = close - close[5]

plot(change1Bar, color=color.blue, title="1-Bar Change")
plot(change5Bars, color=color.red, title="5-Bar Change")
```

### Historical Reference Limitations
```pine
//@version=6
indicator("Historical Limits", overlay=false)

// Maximum lookback is 500 bars
validReference = close[499]     // OK
// invalidReference = close[500]   // Would cause error

// Use na() to check if reference is valid
safeReference = bar_index >= 100 ? close[100] : na

plot(na(safeReference) ? 0 : safeReference, title="Safe Reference")
```

## Function Execution Model

### Built-in Function Behavior
```pine
//@version=6
indicator("Function Execution", overlay=false)

// Functions calculate for current bar context
rsi14 = ta.rsi(close, 14)           // RSI for current bar
sma20 = ta.sma(close, 20)           // SMA for current bar
highestHigh = ta.highest(high, 10)   // Highest in last 10 bars

// Functions use available historical data
plot(rsi14, title="RSI")
plot(sma20, title="SMA")
```

### User-Defined Functions
```pine
//@version=6
indicator("Custom Functions", overlay=false)

// Function executes when called for each bar
customMA(src, length) =>
    sum = 0.0
    for i = 0 to length - 1
        sum := sum + src[i]
    sum / length

// Function called for every bar
myMA = customMA(close, 20)
plot(myMA, title="Custom MA")
```

## Real-time vs Historical Differences

### Real-time Behavior
```pine
//@version=6
indicator("Real-time Behavior", overlay=false)

// Real-time bars update continuously
var float barOpen = na
var float barHigh = na
var float barLow = na

// Capture values at bar start
if barstate.isnew
    barOpen := open
    barHigh := high
    barLow := low
else if barstate.isrealtime
    // Update high/low during real-time
    barHigh := math.max(barHigh, high)
    barLow := math.min(barLow, low)

plot(barHigh - barLow, title="Intrabar Range")
```

### Avoiding Real-time Issues
```pine
//@version=6
indicator("Confirmed Values", overlay=true)

// Use confirmed values to avoid real-time repainting
confirmedClose = barstate.isconfirmed ? close : close[1]
confirmedHigh = barstate.isconfirmed ? high : high[1]

// Calculate on confirmed data only
confirmedMA = ta.sma(confirmedClose, 20)

plot(confirmedMA, title="Confirmed MA")
```

## Context Switching with request.security()

### Multi-timeframe Execution
```pine
//@version=6
indicator("MTF Execution", overlay=true)

// Context switches to daily timeframe
dailyClose = request.security(syminfo.tickerid, "1D", close, lookahead=barmerge.lookahead_off)
dailyMA = request.security(syminfo.tickerid, "1D", ta.sma(close, 20), lookahead=barmerge.lookahead_off)

// Back to current timeframe context
currentMA = ta.sma(close, 20)

plot(dailyMA, color=color.red, linewidth=3, title="Daily MA")
plot(currentMA, color=color.blue, title="Current TF MA")
```

## Performance Considerations

### Efficient Execution
```pine
//@version=6
indicator("Efficient Execution", overlay=false)

// Avoid unnecessary calculations
length = input.int(20, "Length")

// Good: Calculate once per bar
ma = ta.sma(close, length)
rsi = ta.rsi(close, 14)

// Good: Use conditional execution
expensiveCalc = bar_index % 10 == 0 ? ta.stdev(close, 100) : ta.stdev(close, 100)[1]

// Avoid: Recalculating same value multiple times
// Don't do this: plot(ta.sma(close, length) + ta.sma(close, length))
// Do this instead:
plot(ma * 2, title="Double MA")
```

### Memory Management
```pine
//@version=6
indicator("Memory Management", overlay=false)

// Use var for arrays that grow
var array<float> prices = array.new<float>()

// Limit array size to prevent memory issues
if array.size(prices) > 1000
    array.shift(prices)

array.push(prices, close)

// Calculate from array efficiently
avgPrice = array.size(prices) > 0 ? array.avg(prices) : close

plot(avgPrice, title="Average Price")
```

## Debugging Execution Flow

### Understanding Execution Path
```pine
//@version=6
indicator("Debug Execution", overlay=false)

// Track execution
var int executionCount = 0
executionCount := executionCount + 1

// Show different execution phases
phase = barstate.isfirst ? "First" : 
         barstate.islast ? "Last" : 
         barstate.isrealtime ? "Real-time" : "Historical"

// Use plotchar for debugging
plotchar(executionCount, char=str.tostring(executionCount % 10), location=location.top)

// Table for detailed info (if needed)
if barstate.islast
    var table debugTable = table.new(position.top_right, 2, 3, bgcolor=color.white, border_width=1)
    table.cell(debugTable, 0, 0, "Phase", text_color=color.black)
    table.cell(debugTable, 1, 0, phase, text_color=color.black)
    table.cell(debugTable, 0, 1, "Bar Index", text_color=color.black)
    table.cell(debugTable, 1, 1, str.tostring(bar_index), text_color=color.black)
    table.cell(debugTable, 0, 2, "Execution Count", text_color=color.black)
    table.cell(debugTable, 1, 2, str.tostring(executionCount), text_color=color.black)
```

## Best Practices for Execution Model

1. **Understand bar states**: Use barstate.* variables appropriately
2. **Use var wisely**: For values that should persist across bars
3. **Avoid real-time dependencies**: Design for confirmed data when possible
4. **Optimize calculations**: Don't recalculate unnecessarily
5. **Test thoroughly**: Verify behavior on both historical and real-time data
6. **Handle edge cases**: First bar, last bar, insufficient data
7. **Use appropriate variable types**: Series, simple, input as needed

Understanding Pine Script's execution model is fundamental to creating reliable and efficient indicators and strategies that behave consistently across different market conditions and timeframes.