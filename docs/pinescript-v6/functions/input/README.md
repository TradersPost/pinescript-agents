# Pine Script v6 Input Functions Documentation

## Overview

Input functions in Pine Script v6 provide a powerful interface for creating user-configurable parameters in indicators and strategies. They allow users to customize behavior without modifying code, creating professional and flexible trading tools.

## Table of Contents

1. [Core Input Functions](#core-input-functions)
2. [Common Parameters](#common-parameters)
3. [Input Organization](#input-organization)
4. [Advanced Patterns](#advanced-patterns)
5. [Best Practices](#best-practices)
6. [Complete Examples](#complete-examples)

## Core Input Functions

### input.int()

Creates integer input fields with validation and constraints.

**Syntax:**
```pinescript
input.int(defval, title, minval, maxval, step, tooltip, group, display, confirm) → series int
```

**Parameters:**
- `defval` (int): Default value
- `title` (string): Display label
- `minval` (int): Minimum allowed value
- `maxval` (int): Maximum allowed value  
- `step` (int): Increment step size
- `tooltip` (string): Help text on hover
- `group` (string): Grouping category
- `display` (display.*): When to show (display.none to hide)
- `confirm` (bool): Require confirmation for changes

**Examples:**
```pinescript
// Basic integer input
length = input.int(14, "RSI Length", minval=1, maxval=200)

// Integer with step and tooltip
fastMA = input.int(12, "Fast MA", minval=1, maxval=100, step=1, 
                   tooltip="Period for fast moving average")

// Grouped integer with validation
rsiLength = input.int(14, "RSI Period", minval=2, maxval=100, 
                      group="RSI Settings", 
                      tooltip="Number of bars for RSI calculation")

// Conditional input (hidden by default)
debugBars = input.int(50, "Debug Bars", minval=10, maxval=500, 
                      display=display.none)
```

### input.float()

Creates floating-point number inputs with precision control.

**Syntax:**
```pinescript
input.float(defval, title, minval, maxval, step, tooltip, group, display, confirm) → series float
```

**Parameters:**
- Same as input.int() but with float values
- `step` controls decimal precision

**Examples:**
```pinescript
// Basic float input
multiplier = input.float(2.0, "BB Multiplier", minval=0.1, maxval=5.0, step=0.1)

// Percentage input
stopLoss = input.float(2.5, "Stop Loss %", minval=0.1, maxval=10.0, step=0.1,
                       tooltip="Stop loss percentage")

// Price-related float
atrMultiplier = input.float(1.5, "ATR Multiplier", minval=0.1, maxval=10.0, step=0.1,
                            group="Volatility Settings",
                            tooltip="Multiplier for ATR-based calculations")

// High precision float
correlation = input.float(0.75, "Correlation Threshold", minval=-1.0, maxval=1.0, step=0.01,
                          tooltip="Correlation coefficient threshold")
```

### input.bool()

Creates checkbox inputs for boolean values.

**Syntax:**
```pinescript
input.bool(defval, title, tooltip, group, display, confirm) → series bool
```

**Examples:**
```pinescript
// Basic boolean
showMA = input.bool(true, "Show Moving Average")

// Grouped boolean with tooltip
enableAlerts = input.bool(false, "Enable Alerts", 
                          group="Alert Settings",
                          tooltip="Send alerts on signal generation")

// Feature toggles
showHighLow = input.bool(true, "Show High/Low", group="Display Options")
showVolume = input.bool(false, "Show Volume", group="Display Options")
showDivergence = input.bool(true, "Show Divergence", group="Display Options")

// Confirmation required
riskConfirm = input.bool(false, "Enable High Risk Mode", 
                         confirm=true,
                         tooltip="WARNING: This enables aggressive trading signals")
```

### input.string()

Creates dropdown selections or text inputs.

**Syntax:**
```pinescript
input.string(defval, title, options, tooltip, group, display, confirm) → series string
```

**Parameters:**
- `options` (array<string>): Dropdown options (optional)
- If no options provided, creates text input field

**Examples:**
```pinescript
// Dropdown selection
maType = input.string("SMA", "MA Type", 
                      options=["SMA", "EMA", "WMA", "RMA", "VWMA"],
                      group="Moving Average Settings")

// Signal mode selection
signalMode = input.string("Both", "Signal Mode",
                          options=["Long Only", "Short Only", "Both"],
                          tooltip="Type of signals to generate")

// Text input (no options)
alertMessage = input.string("Signal Generated", "Alert Message",
                            tooltip="Custom message for alerts")

// Market session selection
sessionType = input.string("Regular", "Session Type",
                           options=["Regular", "Extended", "Both"],
                           group="Session Settings")
```

### input.source()

Creates source selection dropdown for price data.

**Syntax:**
```pinescript
input.source(defval, title, tooltip, group, display) → series float
```

**Examples:**
```pinescript
// Basic source input
src = input.source(close, "Source", tooltip="Price source for calculations")

// Multiple sources for different calculations
maSource = input.source(close, "MA Source", group="Moving Average")
rsiSource = input.source(close, "RSI Source", group="RSI Settings")
volumeSource = input.source(volume, "Volume Source", group="Volume Analysis")

// Typical price as default
typicalSrc = input.source((high + low + close) / 3, "Typical Price Source",
                          tooltip="Source for typical price calculations")
```

### input.color()

Creates color picker inputs for visual customization.

**Syntax:**
```pinescript
input.color(defval, title, tooltip, group, display) → series color
```

**Examples:**
```pinescript
// Basic color input
bullColor = input.color(color.green, "Bull Color")
bearColor = input.color(color.red, "Bear Color")

// Grouped colors with transparency
upColor = input.color(color.new(color.green, 0), "Up Color", 
                      group="Color Settings")
downColor = input.color(color.new(color.red, 0), "Down Color", 
                        group="Color Settings")

// Background colors with transparency
bgUpColor = input.color(color.new(color.green, 90), "Background Up", 
                        group="Background Colors",
                        tooltip="Background color for bullish conditions")
bgDownColor = input.color(color.new(color.red, 90), "Background Down", 
                          group="Background Colors",
                          tooltip="Background color for bearish conditions")
```

### input.time()

Creates date/time picker inputs for time-based analysis.

**Syntax:**
```pinescript
input.time(defval, title, tooltip, group, display, confirm) → series int
```

**Examples:**
```pinescript
// Basic time input
startTime = input.time(timestamp("2023-01-01 00:00"), "Start Date")

// Time range inputs
sessionStart = input.time(timestamp("2023-01-01 09:30"), "Session Start",
                          group="Session Settings")
sessionEnd = input.time(timestamp("2023-01-01 16:00"), "Session End",
                        group="Session Settings")

// Earnings date
earningsDate = input.time(timestamp("2023-01-01 00:00"), "Earnings Date",
                          tooltip="Date of earnings announcement",
                          confirm=true)
```

### input.price()

Creates price level inputs with chart interaction.

**Syntax:**
```pinescript
input.price(defval, title, tooltip, group, display, confirm) → series float
```

**Examples:**
```pinescript
// Support/Resistance levels
supportLevel = input.price(100.0, "Support Level", 
                           tooltip="Click on chart to set support level")
resistanceLevel = input.price(110.0, "Resistance Level",
                              tooltip="Click on chart to set resistance level")

// Stop loss and take profit
stopLossPrice = input.price(95.0, "Stop Loss Price", group="Risk Management")
takeProfitPrice = input.price(115.0, "Take Profit Price", group="Risk Management")

// Pivot levels
pivotHigh = input.price(0.0, "Pivot High", group="Pivot Levels")
pivotLow = input.price(0.0, "Pivot Low", group="Pivot Levels")
```

### input.session()

Creates session string inputs for time-based analysis.

**Syntax:**
```pinescript
input.session(defval, title, tooltip, group, display) → series string
```

**Examples:**
```pinescript
// Market sessions
regularSession = input.session("0930-1600", "Regular Session Hours")
extendedSession = input.session("0400-2000", "Extended Session Hours")

// Custom trading sessions
londonSession = input.session("0200-1100", "London Session", 
                              group="Global Sessions")
newYorkSession = input.session("0800-1700", "New York Session", 
                               group="Global Sessions")
asiaSession = input.session("2100-0600", "Asia Session", 
                            group="Global Sessions")

// Lunch break session
lunchBreak = input.session("1200-1300", "Lunch Break",
                           tooltip="Time to avoid trading")
```

### input.symbol()

Creates symbol selection inputs for multi-symbol analysis.

**Syntax:**
```pinescript
input.symbol(defval, title, tooltip, group, display) → series string
```

**Examples:**
```pinescript
// Related symbols
correlatedSymbol = input.symbol("SPY", "Correlated Symbol",
                                tooltip="Symbol for correlation analysis")

// Sector comparison
sectorETF = input.symbol("XLF", "Sector ETF", group="Sector Analysis")

// Benchmark comparison
benchmark = input.symbol("SPY", "Benchmark", 
                         tooltip="Benchmark for relative performance")

// Currency pair
baseCurrency = input.symbol("EURUSD", "Base Currency Pair", 
                            group="Forex Analysis")
```

### input.timeframe()

Creates timeframe selection inputs for multi-timeframe analysis.

**Syntax:**
```pinescript
input.timeframe(defval, title, tooltip, group, display) → series string
```

**Examples:**
```pinescript
// Higher timeframe analysis
htf = input.timeframe("1D", "Higher Timeframe", 
                      tooltip="Timeframe for trend analysis")

// Multiple timeframes
trendTF = input.timeframe("4H", "Trend Timeframe", group="Timeframes")
signalTF = input.timeframe("1H", "Signal Timeframe", group="Timeframes")
entryTF = input.timeframe("15m", "Entry Timeframe", group="Timeframes")

// Weekly analysis
weeklyTF = input.timeframe("1W", "Weekly Timeframe",
                           tooltip="Weekly timeframe for long-term analysis")
```

## Common Parameters

### Universal Parameters

All input functions share these common parameters:

- **title**: Display name shown in the inputs panel
- **tooltip**: Help text displayed on hover
- **group**: Category for organizing related inputs
- **display**: Controls when input is visible (display.all, display.none)
- **confirm**: Requires user confirmation for sensitive changes

### Validation Parameters

Numeric inputs (int, float, price) support:

- **minval**: Minimum allowed value
- **maxval**: Maximum allowed value  
- **step**: Increment/decrement step size

### Organization Parameters

- **group**: Groups related inputs together
- **display**: Controls input visibility
- **confirm**: Adds confirmation dialog for critical inputs

## Input Organization

### Grouping Strategy

Organize inputs into logical groups for better user experience:

```pinescript
//@version=6
indicator("Professional Input Organization", overlay=true)

// === TREND ANALYSIS ===
trendLength = input.int(50, "Trend Length", minval=10, maxval=200, group="Trend Analysis")
trendSource = input.source(close, "Trend Source", group="Trend Analysis")
showTrend = input.bool(true, "Show Trend", group="Trend Analysis")

// === MOMENTUM SETTINGS ===
rsiLength = input.int(14, "RSI Length", minval=2, maxval=50, group="Momentum Settings")
rsiOverbought = input.int(70, "RSI Overbought", minval=50, maxval=90, group="Momentum Settings")
rsiOversold = input.int(30, "RSI Oversold", minval=10, maxval=50, group="Momentum Settings")

// === VOLATILITY ANALYSIS ===
bbLength = input.int(20, "BB Length", minval=5, maxval=50, group="Volatility Analysis")
bbMultiplier = input.float(2.0, "BB Multiplier", minval=0.5, maxval=5.0, step=0.1, group="Volatility Analysis")
showBB = input.bool(true, "Show Bollinger Bands", group="Volatility Analysis")

// === VISUAL SETTINGS ===
bullColor = input.color(color.green, "Bull Color", group="Visual Settings")
bearColor = input.color(color.red, "Bear Color", group="Visual Settings")
showBackground = input.bool(false, "Show Background", group="Visual Settings")

// === ALERT SETTINGS ===
enableAlerts = input.bool(false, "Enable Alerts", group="Alert Settings")
alertMessage = input.string("Signal Generated", "Alert Message", group="Alert Settings")

// === ADVANCED SETTINGS ===
debugMode = input.bool(false, "Debug Mode", group="Advanced Settings", display=display.none)
maxBarsBack = input.int(500, "Max Bars Back", minval=100, maxval=5000, group="Advanced Settings", display=display.none)
```

### Professional Input Layout

```pinescript
//@version=6
strategy("Professional Strategy Inputs", overlay=true)

// === STRATEGY SETTINGS ===
strategyMode = input.string("Long & Short", "Strategy Mode", 
                           options=["Long Only", "Short Only", "Long & Short"], 
                           group="Strategy Settings")
maxPositions = input.int(1, "Max Positions", minval=1, maxval=10, group="Strategy Settings")
pyramiding = input.int(0, "Pyramiding", minval=0, maxval=5, group="Strategy Settings")

// === ENTRY CONDITIONS ===
entrySignal = input.string("MA Cross", "Entry Signal", 
                          options=["MA Cross", "RSI Divergence", "Bollinger Touch"], 
                          group="Entry Conditions")
fastMA = input.int(12, "Fast MA", minval=1, maxval=50, group="Entry Conditions")
slowMA = input.int(26, "Slow MA", minval=1, maxval=200, group="Entry Conditions")
confirmationTF = input.timeframe("1H", "Confirmation Timeframe", group="Entry Conditions")

// === RISK MANAGEMENT ===
riskPerTrade = input.float(1.0, "Risk Per Trade (%)", minval=0.1, maxval=10.0, step=0.1, 
                          group="Risk Management", tooltip="Percentage of capital to risk per trade")
stopLossType = input.string("ATR", "Stop Loss Type", 
                           options=["Fixed %", "ATR", "Support/Resistance"], 
                           group="Risk Management")
stopLossATR = input.float(2.0, "Stop Loss ATR", minval=0.5, maxval=10.0, step=0.1, group="Risk Management")
takeProfitRatio = input.float(2.0, "Take Profit Ratio", minval=0.5, maxval=10.0, step=0.1, 
                             group="Risk Management", tooltip="Risk:Reward ratio")

// === TIMEFRAME ANALYSIS ===
htfTrend = input.timeframe("1D", "Higher Timeframe Trend", group="Timeframe Analysis")
mtfSignal = input.timeframe("4H", "Medium Timeframe Signal", group="Timeframe Analysis")
ltfEntry = input.timeframe("1H", "Lower Timeframe Entry", group="Timeframe Analysis")

// === FILTERS ===
useVolumeFilter = input.bool(true, "Use Volume Filter", group="Filters")
volumeMA = input.int(20, "Volume MA", minval=5, maxval=100, group="Filters")
useTimeFilter = input.bool(false, "Use Time Filter", group="Filters")
sessionFilter = input.session("0930-1600", "Session Filter", group="Filters")

// === ALERTS ===
alertOnEntry = input.bool(true, "Alert on Entry", group="Alerts")
alertOnExit = input.bool(true, "Alert on Exit", group="Alerts")
webhookURL = input.string("", "Webhook URL", group="Alerts", tooltip="Optional webhook for automated trading")

// === VISUAL DISPLAY ===
showSignals = input.bool(true, "Show Entry/Exit Signals", group="Visual Display")
showStopLoss = input.bool(true, "Show Stop Loss Levels", group="Visual Display")
showTakeProfit = input.bool(true, "Show Take Profit Levels", group="Visual Display")
signalSize = input.string("Normal", "Signal Size", options=["Small", "Normal", "Large"], group="Visual Display")

// === COLOR SCHEME ===
colorScheme = input.string("Default", "Color Scheme", 
                          options=["Default", "Dark", "High Contrast", "Colorblind Friendly"], 
                          group="Color Scheme")
longColor = input.color(color.green, "Long Color", group="Color Scheme")
shortColor = input.color(color.red, "Short Color", group="Color Scheme")
neutralColor = input.color(color.gray, "Neutral Color", group="Color Scheme")

// === DEBUGGING ===
showDebugInfo = input.bool(false, "Show Debug Info", group="Debugging", display=display.none)
maxDebugBars = input.int(100, "Max Debug Bars", minval=10, maxval=500, group="Debugging", display=display.none)
debugLevel = input.string("Info", "Debug Level", options=["Error", "Warning", "Info", "Debug"], 
                         group="Debugging", display=display.none)
```

## Advanced Patterns

### Dynamic Input Validation

```pinescript
//@version=6
indicator("Dynamic Input Validation", overlay=true)

// Primary inputs
length1 = input.int(10, "Length 1", minval=1, maxval=100)
length2 = input.int(20, "Length 2", minval=1, maxval=100)

// Validation: Ensure length2 > length1
validatedLength2 = length2 > length1 ? length2 : length1 + 1

// Display warning if validation failed
if length2 <= length1
    label.new(bar_index, high, "Warning: Length 2 must be greater than Length 1", 
              color=color.orange, style=label.style_label_down, size=size.small)

// Use validated values
sma1 = ta.sma(close, length1)
sma2 = ta.sma(close, validatedLength2)

plot(sma1, "SMA 1", color=color.blue)
plot(sma2, "SMA 2", color=color.red)
```

### Conditional Input Display

```pinescript
//@version=6
indicator("Conditional Inputs", overlay=true)

// Main feature toggle
enableAdvanced = input.bool(false, "Enable Advanced Features")

// Basic inputs (always shown)
length = input.int(14, "Length", minval=1, maxval=100)
source = input.source(close, "Source")

// Advanced inputs (conditionally hidden)
advancedMultiplier = input.float(1.5, "Advanced Multiplier", minval=0.1, maxval=5.0, 
                                display=enableAdvanced ? display.all : display.none)
advancedSmoothing = input.int(3, "Advanced Smoothing", minval=1, maxval=10,
                             display=enableAdvanced ? display.all : display.none)

// Use conditional logic
multiplier = enableAdvanced ? advancedMultiplier : 2.0
smoothing = enableAdvanced ? advancedSmoothing : 1

// Calculate indicator
value = ta.sma(source, length) * multiplier
smoothedValue = enableAdvanced ? ta.sma(value, smoothing) : value

plot(smoothedValue, "Value", color=color.blue)
```

### Input Groups with Dependencies

```pinescript
//@version=6
indicator("Input Dependencies", overlay=true)

// === MA SETTINGS ===
useMA = input.bool(true, "Use Moving Average", group="MA Settings")
maType = input.string("SMA", "MA Type", options=["SMA", "EMA", "WMA"], 
                     group="MA Settings", display=useMA ? display.all : display.none)
maLength = input.int(20, "MA Length", minval=1, maxval=200, 
                    group="MA Settings", display=useMA ? display.all : display.none)
maSource = input.source(close, "MA Source", 
                       group="MA Settings", display=useMA ? display.all : display.none)

// === BOLLINGER BANDS ===
useBB = input.bool(false, "Use Bollinger Bands", group="Bollinger Bands")
bbLength = input.int(20, "BB Length", minval=1, maxval=100, 
                    group="Bollinger Bands", display=useBB ? display.all : display.none)
bbMultiplier = input.float(2.0, "BB Multiplier", minval=0.1, maxval=5.0, 
                          group="Bollinger Bands", display=useBB ? display.all : display.none)

// === RSI SETTINGS ===
useRSI = input.bool(false, "Use RSI", group="RSI Settings")
rsiLength = input.int(14, "RSI Length", minval=2, maxval=50, 
                     group="RSI Settings", display=useRSI ? display.all : display.none)
rsiOverbought = input.int(70, "RSI Overbought", minval=50, maxval=95, 
                         group="RSI Settings", display=useRSI ? display.all : display.none)
rsiOversold = input.int(30, "RSI Oversold", minval=5, maxval=50, 
                       group="RSI Settings", display=useRSI ? display.all : display.none)

// Calculate only enabled indicators
ma = useMA ? (maType == "SMA" ? ta.sma(maSource, maLength) : 
              maType == "EMA" ? ta.ema(maSource, maLength) : 
              ta.wma(maSource, maLength)) : na

[bbMiddle, bbUpper, bbLower] = useBB ? ta.bb(close, bbLength, bbMultiplier) : [na, na, na]

rsi = useRSI ? ta.rsi(close, rsiLength) : na

// Plot enabled indicators
plot(ma, "MA", color=useMA ? color.blue : na)
plot(bbMiddle, "BB Middle", color=useBB ? color.orange : na)
plot(bbUpper, "BB Upper", color=useBB ? color.gray : na)
plot(bbLower, "BB Lower", color=useBB ? color.gray : na)

// RSI in separate pane
rsiPlot = plot(rsi, "RSI", color=useRSI ? color.purple : na, display=display.pane)
hline(rsiOverbought, "RSI Overbought", color=useRSI ? color.red : na, linestyle=hline.style_dashed, display=display.pane)
hline(rsiOversold, "RSI Oversold", color=useRSI ? color.green : na, linestyle=hline.style_dashed, display=display.pane)
```

## Best Practices

### 1. Input Validation and Error Prevention

```pinescript
// Prevent invalid configurations
fastLength = input.int(12, "Fast Length", minval=1, maxval=100)
slowLength = input.int(26, "Slow Length", minval=1, maxval=200)

// Ensure slow > fast
validatedSlowLength = math.max(slowLength, fastLength + 1)

// Provide feedback
if slowLength <= fastLength
    runtime.error("Slow length must be greater than fast length")
```

### 2. Descriptive Tooltips

```pinescript
// Good tooltip examples
rsiLength = input.int(14, "RSI Period", minval=2, maxval=50,
                     tooltip="Number of bars for RSI calculation. Lower values = more sensitive.")

stopLoss = input.float(2.0, "Stop Loss %", minval=0.1, maxval=10.0, step=0.1,
                      tooltip="Stop loss as percentage of entry price. Higher values = wider stops.")

maType = input.string("EMA", "Moving Average Type", 
                     options=["SMA", "EMA", "WMA", "RMA"],
                     tooltip="SMA=Simple, EMA=Exponential (faster), WMA=Weighted, RMA=Rolling")
```

### 3. Professional Input Organization

```pinescript
// Group related inputs logically
// === TREND ANALYSIS ===
// === ENTRY CONDITIONS ===  
// === RISK MANAGEMENT ===
// === VISUAL SETTINGS ===
// === ADVANCED OPTIONS ===

// Use consistent naming conventions
trendLength = input.int(50, "Trend Length", group="Trend Analysis")
trendSource = input.source(close, "Trend Source", group="Trend Analysis")
trendColor = input.color(color.blue, "Trend Color", group="Visual Settings")
```

### 4. Smart Defaults

```pinescript
// Use commonly accepted default values
rsiLength = input.int(14, "RSI Length")  // Standard RSI period
bbLength = input.int(20, "BB Length")    // Standard BB period
bbStdDev = input.float(2.0, "BB StdDev") // Standard BB deviation

// For colors, use intuitive defaults
bullColor = input.color(color.green, "Bull Color")
bearColor = input.color(color.red, "Bear Color")
neutralColor = input.color(color.gray, "Neutral Color")
```

### 5. Confirmation for Dangerous Settings

```pinescript
// Require confirmation for risky settings
highRiskMode = input.bool(false, "High Risk Mode", 
                         confirm=true,
                         tooltip="WARNING: Enables aggressive signals with higher risk")

resetData = input.bool(false, "Reset All Data", 
                      confirm=true,
                      tooltip="CAUTION: This will clear all historical data")
```

## Complete Examples

### Professional Indicator Input Section

```pinescript
//@version=6
indicator("Professional RSI with Complete Inputs", overlay=false, timeframe="", timeframe_gaps=true)

// ============================================================================
// INPUT SECTION
// ============================================================================

// === CORE SETTINGS ===
rsiLength = input.int(14, "RSI Length", minval=2, maxval=200, step=1, 
                     tooltip="Period for RSI calculation. Standard value is 14.", 
                     group="Core Settings")
rsiSource = input.source(close, "RSI Source", 
                        tooltip="Price source for RSI calculation", 
                        group="Core Settings")
smoothing = input.int(1, "RSI Smoothing", minval=1, maxval=10, 
                     tooltip="Additional smoothing applied to RSI", 
                     group="Core Settings")

// === LEVELS ===
overboughtLevel = input.int(70, "Overbought Level", minval=50, maxval=95, step=1,
                           tooltip="RSI level considered overbought", 
                           group="Levels")
oversoldLevel = input.int(30, "Oversold Level", minval=5, maxval=50, step=1,
                         tooltip="RSI level considered oversold", 
                         group="Levels")
middleLine = input.int(50, "Middle Line", minval=40, maxval=60, step=1,
                      tooltip="RSI middle reference line", 
                      group="Levels")
showLevels = input.bool(true, "Show Level Lines", 
                       tooltip="Display overbought/oversold lines", 
                       group="Levels")

// === DIVERGENCE DETECTION ===
enableDivergence = input.bool(true, "Enable Divergence Detection", 
                             group="Divergence Detection")
divergenceLookback = input.int(5, "Divergence Lookback", minval=3, maxval=20,
                              tooltip="Bars to look back for divergence patterns",
                              group="Divergence Detection",
                              display=enableDivergence ? display.all : display.none)
minDivergenceStrength = input.float(2.0, "Min Divergence Strength", minval=1.0, maxval=10.0, step=0.5,
                                   tooltip="Minimum strength for valid divergence",
                                   group="Divergence Detection",
                                   display=enableDivergence ? display.all : display.none)

// === ALERTS ===
enableAlerts = input.bool(false, "Enable Alerts", group="Alerts")
alertOnOverbought = input.bool(true, "Alert on Overbought", 
                              group="Alerts", 
                              display=enableAlerts ? display.all : display.none)
alertOnOversold = input.bool(true, "Alert on Oversold", 
                            group="Alerts", 
                            display=enableAlerts ? display.all : display.none)
alertOnDivergence = input.bool(true, "Alert on Divergence", 
                              group="Alerts", 
                              display=(enableAlerts and enableDivergence) ? display.all : display.none)
customAlertMessage = input.string("RSI Signal", "Custom Alert Message", 
                                 group="Alerts", 
                                 display=enableAlerts ? display.all : display.none)

// === VISUAL SETTINGS ===
rsiColor = input.color(color.purple, "RSI Line Color", group="Visual Settings")
rsiLineWidth = input.int(2, "RSI Line Width", minval=1, maxval=5, group="Visual Settings")
overboughtColor = input.color(color.red, "Overbought Color", group="Visual Settings")
oversoldColor = input.color(color.green, "Oversold Color", group="Visual Settings")
middleColor = input.color(color.gray, "Middle Line Color", group="Visual Settings")
showBackground = input.bool(true, "Show Background Fill", group="Visual Settings")
backgroundTransparency = input.int(85, "Background Transparency", minval=0, maxval=100, 
                                  group="Visual Settings",
                                  display=showBackground ? display.all : display.none)

// === DIVERGENCE VISUAL ===
divergenceBullColor = input.color(color.green, "Bull Divergence Color", 
                                 group="Divergence Visual",
                                 display=enableDivergence ? display.all : display.none)
divergenceBearColor = input.color(color.red, "Bear Divergence Color", 
                                 group="Divergence Visual",
                                 display=enableDivergence ? display.all : display.none)
divergenceLineStyle = input.string("Solid", "Divergence Line Style", 
                                  options=["Solid", "Dashed", "Dotted"],
                                  group="Divergence Visual",
                                  display=enableDivergence ? display.all : display.none)

// === MULTI-TIMEFRAME ===
enableMTF = input.bool(false, "Enable Multi-Timeframe", group="Multi-Timeframe")
mtfTimeframe = input.timeframe("1H", "MTF Timeframe", 
                              tooltip="Higher timeframe for MTF analysis",
                              group="Multi-Timeframe",
                              display=enableMTF ? display.all : display.none)
showMTFRSI = input.bool(true, "Show MTF RSI", 
                       group="Multi-Timeframe",
                       display=enableMTF ? display.all : display.none)
mtfRSIColor = input.color(color.orange, "MTF RSI Color", 
                         group="Multi-Timeframe",
                         display=(enableMTF and showMTFRSI) ? display.all : display.none)

// === ADVANCED OPTIONS ===
showDebugInfo = input.bool(false, "Show Debug Info", 
                          group="Advanced Options", 
                          display=display.none)
maxBarsBack = input.int(500, "Max Bars Back", minval=100, maxval=5000,
                       tooltip="Maximum historical bars for calculations",
                       group="Advanced Options", 
                       display=display.none)
precisionDecimals = input.int(2, "Display Precision", minval=0, maxval=4,
                             tooltip="Decimal places for RSI display",
                             group="Advanced Options")

// ============================================================================
// CALCULATIONS
// ============================================================================

// Calculate RSI with smoothing
rsiRaw = ta.rsi(rsiSource, rsiLength)
rsi = smoothing > 1 ? ta.sma(rsiRaw, smoothing) : rsiRaw

// Multi-timeframe RSI
mtfRSI = enableMTF ? request.security(syminfo.tickerid, mtfTimeframe, rsi) : na

// ============================================================================
// PLOTTING
// ============================================================================

// Main RSI line
plot(rsi, "RSI", color=rsiColor, linewidth=rsiLineWidth)

// MTF RSI
plot(mtfRSI, "MTF RSI", color=showMTFRSI ? mtfRSIColor : na, linewidth=1)

// Level lines
obLine = hline(overboughtLevel, "Overbought", color=showLevels ? overboughtColor : na, linestyle=hline.style_dashed)
osLine = hline(oversoldLevel, "Oversold", color=showLevels ? oversoldColor : na, linestyle=hline.style_dashed)
midLine = hline(middleLine, "Middle", color=showLevels ? middleColor : na, linestyle=hline.style_dotted)

// Background fill
bgcolor(showBackground and rsi > overboughtLevel ? color.new(overboughtColor, backgroundTransparency) : 
        showBackground and rsi < oversoldLevel ? color.new(oversoldColor, backgroundTransparency) : na)

// ============================================================================
// ALERTS
// ============================================================================

// Alert conditions
if enableAlerts
    if alertOnOverbought and ta.crossover(rsi, overboughtLevel)
        alert("RSI Overbought: " + customAlertMessage, alert.freq_once_per_bar)
    
    if alertOnOversold and ta.crossunder(rsi, oversoldLevel)
        alert("RSI Oversold: " + customAlertMessage, alert.freq_once_per_bar)

// Debug information
if showDebugInfo
    var debugTable = table.new(position.top_right, 2, 5, bgcolor=color.white, border_width=1)
    table.cell(debugTable, 0, 0, "RSI", text_color=color.black)
    table.cell(debugTable, 1, 0, str.tostring(rsi, "#.##"), text_color=color.black)
    table.cell(debugTable, 0, 1, "Smoothing", text_color=color.black)
    table.cell(debugTable, 1, 1, str.tostring(smoothing), text_color=color.black)
    table.cell(debugTable, 0, 2, "Length", text_color=color.black)
    table.cell(debugTable, 1, 2, str.tostring(rsiLength), text_color=color.black)
```

### Professional Strategy Input Section

```pinescript
//@version=6
strategy("Professional Strategy Template", overlay=true, 
         default_qty_type=strategy.percent_of_equity, default_qty_value=10,
         commission_type=strategy.commission.percent, commission_value=0.1)

// ============================================================================
// STRATEGY INPUT SECTION
// ============================================================================

// === STRATEGY MODE ===
strategyDirection = input.string("Long & Short", "Strategy Direction", 
                                options=["Long Only", "Short Only", "Long & Short"],
                                tooltip="Direction of trades to take",
                                group="Strategy Mode")
maxPositions = input.int(1, "Maximum Positions", minval=1, maxval=10,
                        tooltip="Maximum number of concurrent positions",
                        group="Strategy Mode")
pyramidingEnabled = input.bool(false, "Enable Pyramiding", group="Strategy Mode")
maxPyramid = input.int(2, "Max Pyramid Entries", minval=1, maxval=5,
                      group="Strategy Mode",
                      display=pyramidingEnabled ? display.all : display.none)

// === ENTRY CONDITIONS ===
entryMethod = input.string("MA Crossover", "Entry Method",
                          options=["MA Crossover", "RSI Reversal", "Bollinger Touch", "Custom"],
                          group="Entry Conditions")

// MA Crossover Settings
fastMALength = input.int(12, "Fast MA Length", minval=1, maxval=100,
                        group="Entry Conditions",
                        display=entryMethod == "MA Crossover" ? display.all : display.none)
slowMALength = input.int(26, "Slow MA Length", minval=1, maxval=200,
                        group="Entry Conditions", 
                        display=entryMethod == "MA Crossover" ? display.all : display.none)
maType = input.string("EMA", "MA Type", options=["SMA", "EMA", "WMA"],
                     group="Entry Conditions",
                     display=entryMethod == "MA Crossover" ? display.all : display.none)

// RSI Reversal Settings  
rsiLength = input.int(14, "RSI Length", minval=2, maxval=50,
                     group="Entry Conditions",
                     display=entryMethod == "RSI Reversal" ? display.all : display.none)
rsiOverbought = input.int(70, "RSI Overbought", minval=50, maxval=95,
                         group="Entry Conditions",
                         display=entryMethod == "RSI Reversal" ? display.all : display.none)
rsiOversold = input.int(30, "RSI Oversold", minval=5, maxval=50,
                       group="Entry Conditions",
                       display=entryMethod == "RSI Reversal" ? display.all : display.none)

// === CONFIRMATION FILTERS ===
useVolumeConfirmation = input.bool(true, "Use Volume Confirmation", group="Confirmation Filters")
volumeMALength = input.int(20, "Volume MA Length", minval=5, maxval=100,
                          group="Confirmation Filters",
                          display=useVolumeConfirmation ? display.all : display.none)
volumeMultiplier = input.float(1.5, "Volume Multiplier", minval=1.0, maxval=5.0, step=0.1,
                              group="Confirmation Filters",
                              display=useVolumeConfirmation ? display.all : display.none)

useTrendConfirmation = input.bool(true, "Use Trend Confirmation", group="Confirmation Filters")
trendTimeframe = input.timeframe("1H", "Trend Timeframe", 
                                group="Confirmation Filters",
                                display=useTrendConfirmation ? display.all : display.none)
trendMALength = input.int(50, "Trend MA Length", minval=10, maxval=200,
                         group="Confirmation Filters",
                         display=useTrendConfirmation ? display.all : display.none)

// === RISK MANAGEMENT ===
riskManagementType = input.string("Fixed %", "Risk Management Type",
                                 options=["Fixed %", "ATR Based", "Volatility Adjusted"],
                                 group="Risk Management")

// Fixed Percentage Risk
riskPerTrade = input.float(1.0, "Risk Per Trade (%)", minval=0.1, maxval=10.0, step=0.1,
                          tooltip="Percentage of account to risk per trade",
                          group="Risk Management")

// Stop Loss Settings
stopLossType = input.string("ATR", "Stop Loss Type",
                           options=["Fixed %", "ATR", "Previous Low/High", "Custom"],
                           group="Risk Management")
stopLossPercent = input.float(2.0, "Stop Loss %", minval=0.1, maxval=20.0, step=0.1,
                             group="Risk Management",
                             display=stopLossType == "Fixed %" ? display.all : display.none)
stopLossATRLength = input.int(14, "ATR Length", minval=1, maxval=50,
                             group="Risk Management",
                             display=stopLossType == "ATR" ? display.all : display.none)
stopLossATRMultiplier = input.float(2.0, "ATR Multiplier", minval=0.5, maxval=10.0, step=0.1,
                                   group="Risk Management",
                                   display=stopLossType == "ATR" ? display.all : display.none)

// Take Profit Settings
useTakeProfit = input.bool(true, "Use Take Profit", group="Risk Management")
takeProfitType = input.string("Risk Ratio", "Take Profit Type",
                             options=["Fixed %", "Risk Ratio", "ATR", "Resistance/Support"],
                             group="Risk Management",
                             display=useTakeProfit ? display.all : display.none)
takeProfitRatio = input.float(2.0, "Risk:Reward Ratio", minval=0.5, maxval=10.0, step=0.1,
                             tooltip="Take profit as multiple of stop loss",
                             group="Risk Management",
                             display=(useTakeProfit and takeProfitType == "Risk Ratio") ? display.all : display.none)

// Trailing Stop
useTrailingStop = input.bool(false, "Use Trailing Stop", group="Risk Management")
trailingStopType = input.string("ATR", "Trailing Stop Type", 
                               options=["Fixed %", "ATR"],
                               group="Risk Management",
                               display=useTrailingStop ? display.all : display.none)
trailingStopDistance = input.float(3.0, "Trailing Stop Distance", minval=0.1, maxval=10.0, step=0.1,
                                  group="Risk Management",
                                  display=useTrailingStop ? display.all : display.none)

// === TIME FILTERS ===
useTimeFilter = input.bool(false, "Enable Time Filter", group="Time Filters")
sessionFilter = input.session("0930-1600", "Trading Session",
                              tooltip="Trading hours (exchange timezone)",
                              group="Time Filters",
                              display=useTimeFilter ? display.all : display.none)
mondayTrading = input.bool(true, "Monday", group="Time Filters", 
                          display=useTimeFilter ? display.all : display.none)
tuesdayTrading = input.bool(true, "Tuesday", group="Time Filters",
                           display=useTimeFilter ? display.all : display.none)
wednesdayTrading = input.bool(true, "Wednesday", group="Time Filters",
                             display=useTimeFilter ? display.all : display.none)
thursdayTrading = input.bool(true, "Thursday", group="Time Filters",
                            display=useTimeFilter ? display.all : display.none)
fridayTrading = input.bool(true, "Friday", group="Time Filters",
                          display=useTimeFilter ? display.all : display.none)

// === POSITION SIZING ===
positionSizingMethod = input.string("Fixed %", "Position Sizing Method",
                                   options=["Fixed %", "Kelly Criterion", "Volatility Adjusted", "Risk Parity"],
                                   group="Position Sizing")
fixedPositionSize = input.float(10.0, "Fixed Position Size (%)", minval=1.0, maxval=100.0, step=1.0,
                               tooltip="Fixed percentage of equity per trade",
                               group="Position Sizing",
                               display=positionSizingMethod == "Fixed %" ? display.all : display.none)

// Kelly Criterion Settings
kellyLookback = input.int(50, "Kelly Lookback Period", minval=10, maxval=500,
                         tooltip="Number of trades to analyze for Kelly calculation",
                         group="Position Sizing",
                         display=positionSizingMethod == "Kelly Criterion" ? display.all : display.none)
kellyMaxSize = input.float(25.0, "Kelly Maximum Size (%)", minval=5.0, maxval=50.0, step=1.0,
                          tooltip="Maximum position size when using Kelly criterion",
                          group="Position Sizing",
                          display=positionSizingMethod == "Kelly Criterion" ? display.all : display.none)

// === ALERTS ===
enableAlerts = input.bool(true, "Enable Alerts", group="Alerts")
alertOnEntry = input.bool(true, "Alert on Entry", group="Alerts",
                         display=enableAlerts ? display.all : display.none)
alertOnExit = input.bool(true, "Alert on Exit", group="Alerts",
                        display=enableAlerts ? display.all : display.none)
alertOnStopLoss = input.bool(true, "Alert on Stop Loss", group="Alerts",
                            display=enableAlerts ? display.all : display.none)
alertOnTakeProfit = input.bool(true, "Alert on Take Profit", group="Alerts",
                              display=enableAlerts ? display.all : display.none)

// Webhook Settings
useWebhook = input.bool(false, "Use Webhook", group="Alerts",
                       display=enableAlerts ? display.all : display.none)
webhookURL = input.string("", "Webhook URL", group="Alerts",
                          tooltip="URL for automated trading webhook",
                          display=(enableAlerts and useWebhook) ? display.all : display.none)

// === VISUAL SETTINGS ===
showEntrySignals = input.bool(true, "Show Entry Signals", group="Visual Settings")
showExitSignals = input.bool(true, "Show Exit Signals", group="Visual Settings")
showStopLossLines = input.bool(true, "Show Stop Loss Lines", group="Visual Settings")
showTakeProfitLines = input.bool(true, "Show Take Profit Lines", group="Visual Settings")
showPositionInfo = input.bool(true, "Show Position Info", group="Visual Settings")

// Signal Styling
entrySignalSize = input.string("Normal", "Entry Signal Size",
                              options=["Small", "Normal", "Large"],
                              group="Visual Settings")
longEntryColor = input.color(color.green, "Long Entry Color", group="Visual Settings")
shortEntryColor = input.color(color.red, "Short Entry Color", group="Visual Settings")
exitColor = input.color(color.orange, "Exit Color", group="Visual Settings")

// === BACKTESTING ===
backtestStartDate = input.time(timestamp("2020-01-01 00:00"), "Backtest Start Date", 
                              group="Backtesting")
backtestEndDate = input.time(timestamp("2025-12-31 23:59"), "Backtest End Date", 
                            group="Backtesting")
useBacktestPeriod = input.bool(true, "Use Backtest Period", group="Backtesting")

// Performance Metrics
showPerformanceTable = input.bool(true, "Show Performance Table", group="Backtesting")
tablePosition = input.string("Top Right", "Table Position",
                            options=["Top Left", "Top Right", "Bottom Left", "Bottom Right"],
                            group="Backtesting",
                            display=showPerformanceTable ? display.all : display.none)

// === ADVANCED SETTINGS ===
allowRepainting = input.bool(false, "Allow Repainting", 
                           group="Advanced Settings",
                           tooltip="WARNING: May cause look-ahead bias",
                           confirm=true)
maxBarsBack = input.int(5000, "Max Bars Back", minval=100, maxval=10000,
                       group="Advanced Settings")
enableDebugMode = input.bool(false, "Enable Debug Mode", 
                           group="Advanced Settings",
                           display=display.none)
debugLogLevel = input.string("Info", "Debug Log Level",
                            options=["Error", "Warning", "Info", "Debug"],
                            group="Advanced Settings",
                            display=enableDebugMode ? display.all : display.none)

// Commission and Slippage
includeCommission = input.bool(true, "Include Commission", group="Advanced Settings")
commissionPercent = input.float(0.1, "Commission %", minval=0.0, maxval=1.0, step=0.01,
                               group="Advanced Settings",
                               display=includeCommission ? display.all : display.none)
includeSlippage = input.bool(true, "Include Slippage", group="Advanced Settings")
slippageTicks = input.int(1, "Slippage (ticks)", minval=0, maxval=10,
                         group="Advanced Settings",
                         display=includeSlippage ? display.all : display.none)

// ============================================================================
// STRATEGY LOGIC IMPLEMENTATION
// ============================================================================

// [Strategy implementation would follow here using the input values]
// This is just the comprehensive input section demonstrating best practices

// Validation
if slowMALength <= fastMALength
    runtime.error("Slow MA length must be greater than Fast MA length")

if rsiOversold >= rsiOverbought
    runtime.error("RSI oversold level must be less than overbought level")

if takeProfitRatio <= 0
    runtime.error("Take profit ratio must be positive")

// Display current settings in debug mode
if enableDebugMode
    var settingsTable = table.new(position.bottom_left, 2, 10, bgcolor=color.white, border_width=1)
    table.cell(settingsTable, 0, 0, "Entry Method", text_color=color.black)
    table.cell(settingsTable, 1, 0, entryMethod, text_color=color.black)
    table.cell(settingsTable, 0, 1, "Risk Per Trade", text_color=color.black)
    table.cell(settingsTable, 1, 1, str.tostring(riskPerTrade) + "%", text_color=color.black)
    table.cell(settingsTable, 0, 2, "Stop Loss Type", text_color=color.black)
    table.cell(settingsTable, 1, 2, stopLossType, text_color=color.black)
    table.cell(settingsTable, 0, 3, "Position Size Method", text_color=color.black)
    table.cell(settingsTable, 1, 3, positionSizingMethod, text_color=color.black)
```

This comprehensive documentation provides everything needed to master Pine Script v6 input functions, from basic usage to advanced professional implementations. The examples demonstrate real-world patterns that create intuitive, powerful user interfaces for trading indicators and strategies.