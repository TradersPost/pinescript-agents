# Pine Script v6 Common Trading Patterns

## Moving Average Crossovers

### Simple Moving Average Crossover
```pine
//@version=6
indicator("SMA Crossover", overlay=true)

length1 = input.int(9, "Fast MA Length")
length2 = input.int(21, "Slow MA Length")

fastMA = ta.sma(close, length1)
slowMA = ta.sma(close, length2)

// Crossover signals
bullishCross = ta.crossover(fastMA, slowMA)
bearishCross = ta.crossunder(fastMA, slowMA)

// Plot MAs
plot(fastMA, color=color.blue, title="Fast MA")
plot(slowMA, color=color.red, title="Slow MA")

// Plot signals
plotshape(bullishCross, style=shape.triangleup, location=location.belowbar, color=color.green, size=size.small)
plotshape(bearishCross, style=shape.triangledown, location=location.abovebar, color=color.red, size=size.small)
```

### Exponential Moving Average with Trend Detection
```pine
//@version=6
indicator("EMA Trend", overlay=true)

length = input.int(20, "EMA Length")
ema = ta.ema(close, length)

// Trend detection
uptrend = close > ema and ema > ema[1]
downtrend = close < ema and ema < ema[1]

// Color-coded EMA
emaColor = uptrend ? color.green : downtrend ? color.red : color.gray
plot(ema, color=emaColor, linewidth=2, title="EMA")
```

## RSI Patterns

### RSI Divergence Detection
```pine
//@version=6
indicator("RSI Divergence", overlay=false)

length = input.int(14, "RSI Length")
rsi = ta.rsi(close, length)

// Find pivots
leftBars = 5
rightBars = 5
pivotHigh = ta.pivothigh(rsi, leftBars, rightBars)
pivotLow = ta.pivotlow(rsi, leftBars, rightBars)

// Store pivot values and bars
var array<float> rsiHighs = array.new<float>()
var array<int> rsiHighBars = array.new<int>()
var array<float> rsiLows = array.new<float>()
var array<int> rsiLowBars = array.new<int>()

// Update arrays when new pivot found
if not na(pivotHigh)
    array.push(rsiHighs, pivotHigh)
    array.push(rsiHighBars, bar_index[rightBars])
    if array.size(rsiHighs) > 10
        array.shift(rsiHighs)
        array.shift(rsiHighBars)

if not na(pivotLow)
    array.push(rsiLows, pivotLow)
    array.push(rsiLowBars, bar_index[rightBars])
    if array.size(rsiLows) > 10
        array.shift(rsiLows)
        array.shift(rsiLowBars)

// Check for bearish divergence
bearishDiv = false
if array.size(rsiHighs) >= 2
    lastHigh = array.get(rsiHighs, array.size(rsiHighs) - 1)
    prevHigh = array.get(rsiHighs, array.size(rsiHighs) - 2)
    lastHighBar = array.get(rsiHighBars, array.size(rsiHighBars) - 1)
    prevHighBar = array.get(rsiHighBars, array.size(rsiHighBars) - 2)
    
    priceHigher = high[bar_index - lastHighBar] > high[bar_index - prevHighBar]
    rsiLower = lastHigh < prevHigh
    bearishDiv := priceHigher and rsiLower

// Check for bullish divergence
bullishDiv = false
if array.size(rsiLows) >= 2
    lastLow = array.get(rsiLows, array.size(rsiLows) - 1)
    prevLow = array.get(rsiLows, array.size(rsiLows) - 2)
    lastLowBar = array.get(rsiLowBars, array.size(rsiLowBars) - 1)
    prevLowBar = array.get(rsiLowBars, array.size(rsiLowBars) - 2)
    
    priceLower = low[bar_index - lastLowBar] < low[bar_index - prevLowBar]
    rsiHigher = lastLow > prevLow
    bullishDiv := priceLower and rsiHigher

// Plot RSI
plot(rsi, color=color.purple, title="RSI")
hline(70, "Overbought", color=color.red)
hline(30, "Oversold", color=color.green)

// Plot divergence signals
bgcolor(bearishDiv ? color.new(color.red, 90) : na, title="Bearish Divergence")
bgcolor(bullishDiv ? color.new(color.green, 90) : na, title="Bullish Divergence")
```

### RSI Overbought/Oversold with Confirmation
```pine
//@version=6
indicator("RSI OB/OS", overlay=true)

rsiLength = input.int(14, "RSI Length")
obLevel = input.float(70, "Overbought Level")
osLevel = input.float(30, "Oversold Level")

rsi = ta.rsi(close, rsiLength)

// Conditions
overbought = rsi > obLevel
oversold = rsi < osLevel
exitOB = rsi < obLevel and rsi[1] >= obLevel
exitOS = rsi > osLevel and rsi[1] <= osLevel

// Confirmation with price action
bearishSignal = overbought and close < open
bullishSignal = oversold and close > open

plotshape(bearishSignal, style=shape.triangledown, location=location.abovebar, color=color.red, size=size.small)
plotshape(bullishSignal, style=shape.triangleup, location=location.belowbar, color=color.green, size=size.small)
```

## Support and Resistance Levels

### Dynamic Support/Resistance
```pine
//@version=6
indicator("Dynamic S/R", overlay=true)

lookback = input.int(20, "Lookback Period")
strength = input.int(3, "Pivot Strength")

// Find pivot highs and lows
ph = ta.pivothigh(high, strength, strength)
pl = ta.pivotlow(low, strength, strength)

// Store levels
var array<float> resistanceLevels = array.new<float>()
var array<float> supportLevels = array.new<float>()

// Add new levels
if not na(ph)
    array.push(resistanceLevels, ph)
    if array.size(resistanceLevels) > 10
        array.shift(resistanceLevels)

if not na(pl)
    array.push(supportLevels, pl)
    if array.size(supportLevels) > 10
        array.shift(supportLevels)

// Find nearest levels
getNearestResistance() =>
    nearest = 999999.0
    if array.size(resistanceLevels) > 0
        for i = 0 to array.size(resistanceLevels) - 1
            level = array.get(resistanceLevels, i)
            if level > close and level < nearest
                nearest := level
    nearest

getNearestSupport() =>
    nearest = 0.0
    if array.size(supportLevels) > 0
        for i = 0 to array.size(supportLevels) - 1
            level = array.get(supportLevels, i)
            if level < close and level > nearest
                nearest := level
    nearest

resistance = getNearestResistance()
support = getNearestSupport()

// Plot levels
plot(resistance != 999999.0 ? resistance : na, color=color.red, style=plot.style_line, linewidth=2, title="Resistance")
plot(support != 0.0 ? support : na, color=color.green, style=plot.style_line, linewidth=2, title="Support")
```

## Trend Detection Patterns

### Multi-Timeframe Trend
```pine
//@version=6
indicator("MTF Trend", overlay=true)

higherTF = input.timeframe("1D", "Higher Timeframe")

// Get higher timeframe data
htfClose = request.security(syminfo.tickerid, higherTF, close, lookahead=barmerge.lookahead_off)
htfEMA = request.security(syminfo.tickerid, higherTF, ta.ema(close, 20), lookahead=barmerge.lookahead_off)

// Current timeframe trend
currentTrend = ta.ema(close, 20)
currentUptrend = close > currentTrend and currentTrend > currentTrend[1]
currentDowntrend = close < currentTrend and currentTrend < currentTrend[1]

// Higher timeframe trend
htfUptrend = htfClose > htfEMA
htfDowntrend = htfClose < htfEMA

// Combined signals
strongUptrend = currentUptrend and htfUptrend
strongDowntrend = currentDowntrend and htfDowntrend

// Visual feedback
bgcolor(strongUptrend ? color.new(color.green, 90) : na)
bgcolor(strongDowntrend ? color.new(color.red, 90) : na)

plot(currentTrend, color=strongUptrend ? color.green : strongDowntrend ? color.red : color.gray, linewidth=2)
```

### ADX Trend Strength
```pine
//@version=6
indicator("ADX Trend Strength", overlay=false)

adxLength = input.int(14, "ADX Length")
trendThreshold = input.float(25, "Trend Threshold")

adxValue = ta.adx(high, low, close, adxLength)
diPlus = ta.dmi(high, low, close, adxLength)[0]
diMinus = ta.dmi(high, low, close, adxLength)[1]

// Trend conditions
strongTrend = adxValue > trendThreshold
uptrend = strongTrend and diPlus > diMinus
downtrend = strongTrend and diMinus > diPlus

// Plot ADX
plot(adxValue, color=color.purple, title="ADX")
hline(trendThreshold, "Trend Threshold", color=color.gray)

// Color background based on trend
bgcolor(uptrend ? color.new(color.green, 90) : downtrend ? color.new(color.red, 90) : na)
```

## Volume Analysis Patterns

### Volume Confirmation
```pine
//@version=6
indicator("Volume Confirmation", overlay=true)

volumeLength = input.int(20, "Volume MA Length")
volumeMultiplier = input.float(1.5, "Volume Spike Multiplier")

avgVolume = ta.sma(volume, volumeLength)
volumeSpike = volume > avgVolume * volumeMultiplier

// Price movement with volume
bullishVolumeConfirmation = close > open and volumeSpike
bearishVolumeConfirmation = close < open and volumeSpike

plotshape(bullishVolumeConfirmation, style=shape.circle, location=location.belowbar, color=color.green, size=size.tiny)
plotshape(bearishVolumeConfirmation, style=shape.circle, location=location.abovebar, color=color.red, size=size.tiny)
```

### On-Balance Volume Divergence
```pine
//@version=6
indicator("OBV Divergence", overlay=false)

// Calculate OBV
obv = ta.obv

// Find price and OBV pivots
pricePivotHigh = ta.pivothigh(close, 5, 5)
pricePivotLow = ta.pivotlow(close, 5, 5)
obvPivotHigh = ta.pivothigh(obv, 5, 5)
obvPivotLow = ta.pivotlow(obv, 5, 5)

// Simple divergence detection (last 2 pivots)
var float lastPriceHigh = na
var float lastObvHigh = na
var float lastPriceLow = na
var float lastObvLow = na

if not na(pricePivotHigh) and not na(obvPivotHigh)
    if not na(lastPriceHigh) and not na(lastObvHigh)
        bearishDiv = pricePivotHigh > lastPriceHigh and obvPivotHigh < lastObvHigh
        if bearishDiv
            bgcolor(color.new(color.red, 80))
    lastPriceHigh := pricePivotHigh
    lastObvHigh := obvPivotHigh

if not na(pricePivotLow) and not na(obvPivotLow)
    if not na(lastPriceLow) and not na(lastObvLow)
        bullishDiv = pricePivotLow < lastPriceLow and obvPivotLow > lastObvLow
        if bullishDiv
            bgcolor(color.new(color.green, 80))
    lastPriceLow := pricePivotLow
    lastObvLow := obvPivotLow

plot(obv, color=color.blue, title="OBV")
```

## Entry and Exit Signal Patterns

### Triple Confirmation Entry
```pine
//@version=6
indicator("Triple Confirmation", overlay=true)

// 1. Trend confirmation (EMA)
emaLength = input.int(20, "EMA Length")
ema = ta.ema(close, emaLength)
trendUp = close > ema

// 2. Momentum confirmation (RSI)
rsiLength = input.int(14, "RSI Length")
rsi = ta.rsi(close, rsiLength)
momentumUp = rsi > 50 and rsi < 70

// 3. Volume confirmation
volumeLength = input.int(20, "Volume Length")
avgVol = ta.sma(volume, volumeLength)
volumeConfirm = volume > avgVol

// Combined signal
bullishEntry = trendUp and momentumUp and volumeConfirm
bearishEntry = not trendUp and rsi < 50 and rsi > 30 and volumeConfirm

plotshape(bullishEntry, style=shape.triangleup, location=location.belowbar, color=color.green, size=size.normal)
plotshape(bearishEntry, style=shape.triangledown, location=location.abovebar, color=color.red, size=size.normal)

plot(ema, color=trendUp ? color.green : color.red, linewidth=2)
```

### Stop Loss and Take Profit Levels
```pine
//@version=6
indicator("S/L and T/P Levels", overlay=true)

atrLength = input.int(14, "ATR Length")
atrMultiplier = input.float(2.0, "ATR Multiplier")
riskReward = input.float(2.0, "Risk:Reward Ratio")

atr = ta.atr(atrLength)

// Entry signals (simplified)
longEntry = ta.crossover(ta.ema(close, 10), ta.ema(close, 20))
shortEntry = ta.crossunder(ta.ema(close, 10), ta.ema(close, 20))

// Calculate levels
var float entryPrice = na
var float stopLoss = na
var float takeProfit = na

if longEntry
    entryPrice := close
    stopLoss := close - atr * atrMultiplier
    takeProfit := close + (close - stopLoss) * riskReward

if shortEntry
    entryPrice := close
    stopLoss := close + atr * atrMultiplier
    takeProfit := close - (stopLoss - close) * riskReward

// Plot levels
plot(entryPrice, color=color.blue, style=plot.style_line, linewidth=1, title="Entry")
plot(stopLoss, color=color.red, style=plot.style_line, linewidth=1, title="Stop Loss")
plot(takeProfit, color=color.green, style=plot.style_line, linewidth=1, title="Take Profit")
```

## Candlestick Patterns

### Doji Detection
```pine
//@version=6
indicator("Doji Patterns", overlay=true)

dojiThreshold = input.float(0.1, "Doji Body Threshold %") / 100

// Calculate body and shadow sizes
bodySize = math.abs(close - open)
upperShadow = high - math.max(close, open)
lowerShadow = math.min(close, open) - low
totalRange = high - low

// Doji conditions
isDoji = bodySize <= totalRange * dojiThreshold and totalRange > 0

// Different types of doji
gravestoneDoji = isDoji and upperShadow > bodySize * 2 and lowerShadow < bodySize
dragonflyDoji = isDoji and lowerShadow > bodySize * 2 and upperShadow < bodySize
standardDoji = isDoji and not gravestoneDoji and not dragonflyDoji

plotshape(standardDoji, style=shape.circle, location=location.abovebar, color=color.yellow, size=size.tiny)
plotshape(gravestoneDoji, style=shape.triangledown, location=location.abovebar, color=color.red, size=size.small)
plotshape(dragonflyDoji, style=shape.triangleup, location=location.belowbar, color=color.green, size=size.small)
```

### Hammer and Shooting Star
```pine
//@version=6
indicator("Hammer & Shooting Star", overlay=true)

// Hammer: small body, long lower shadow, little/no upper shadow
// Shooting Star: small body, long upper shadow, little/no lower shadow

bodySize = math.abs(close - open)
upperShadow = high - math.max(close, open)
lowerShadow = math.min(close, open) - low
totalRange = high - low

isHammer = lowerShadow > bodySize * 2 and upperShadow < bodySize and totalRange > 0
isShootingStar = upperShadow > bodySize * 2 and lowerShadow < bodySize and totalRange > 0

// Context matters - look for these at key levels
recentLow = ta.lowest(low, 10)[1] == low[1]  // Previous bar was recent low
recentHigh = ta.highest(high, 10)[1] == high[1]  // Previous bar was recent high

bullishHammer = isHammer and recentLow
bearishShootingStar = isShootingStar and recentHigh

plotshape(bullishHammer, style=shape.labelup, location=location.belowbar, color=color.green, text="H", size=size.small)
plotshape(bearishShootingStar, style=shape.labeldown, location=location.abovebar, color=color.red, text="SS", size=size.small)
```

## Best Practices for Pattern Implementation

1. **Combine Multiple Confirmations**: Don't rely on single indicators
2. **Use Proper Timeframes**: Match pattern timeframe to trading style
3. **Add Volume Confirmation**: Volume validates price movements
4. **Consider Market Context**: Patterns work differently in different market conditions
5. **Backtest Thoroughly**: Verify pattern effectiveness historically
6. **Use Risk Management**: Always define stop losses and position sizes
7. **Avoid Over-optimization**: Keep patterns simple and robust