# Pine Script v6 Plotting Guide

## Basic plot() Function

### Standard Plotting Syntax
```pinescript
//@version=6
indicator("Basic Plotting", overlay=true)

// Basic plot parameters
length = input.int(20, "Length", minval=1)
source = input.source(close, "Source")

// Simple plot
sma_value = ta.sma(source, length)
plot(sma_value, "SMA", color.blue, linewidth=1, style=plot.style_line)

// Plot with all parameters
ema_value = ta.ema(source, length)
plot(ema_value, 
     title="EMA", 
     color=color.red, 
     linewidth=2, 
     style=plot.style_line,
     trackprice=false,
     histbase=0.0,
     offset=0,
     join=true,
     editable=true,
     display=display.all)
```

### Plot Styles
```pinescript
//@version=6
indicator("Plot Styles", overlay=true)

source = close
length = 20
ma = ta.sma(source, length)

// Different plot styles
plot(ma, "Line", color.blue, style=plot.style_line)
plot(ma + 1, "Stepline", color.red, style=plot.style_stepline)
plot(ma + 2, "Histogram", color.green, style=plot.style_histogram)
plot(ma + 3, "Cross", color.orange, style=plot.style_cross)
plot(ma + 4, "Area", color.purple, style=plot.style_area)
plot(ma + 5, "Columns", color.yellow, style=plot.style_columns)
plot(ma + 6, "Circles", color.gray, style=plot.style_circles)
```

### Conditional Plotting
```pinescript
//@version=6
indicator("Conditional Plotting", overlay=true)

length = input.int(20, "Length")
show_sma = input.bool(true, "Show SMA")
show_ema = input.bool(true, "Show EMA")

sma_value = ta.sma(close, length)
ema_value = ta.ema(close, length)

// Conditional plotting using na
plot(show_sma ? sma_value : na, "SMA", color.blue)
plot(show_ema ? ema_value : na, "EMA", color.red)

// Conditional plotting with display parameter
plot(sma_value, "SMA Hidden", color.blue, display=show_sma ? display.all : display.none)

// Plot based on market conditions
trending = ta.atr(14) > ta.sma(ta.atr(14), 50)
plot(trending ? sma_value : na, "Trend SMA", color.lime, linewidth=3)
```

### Dynamic Colors
```pinescript
//@version=6
indicator("Dynamic Colors", overlay=true)

length = input.int(20, "Length")
source = close
ma = ta.sma(source, length)

// Color based on direction
ma_color = ma > ma[1] ? color.lime : color.red
plot(ma, "Directional MA", ma_color, linewidth=2)

// Color based on price relationship
price_color = close > ma ? color.lime : close < ma ? color.red : color.gray
plot(ma, "Price Relative MA", price_color)

// Gradient color based on distance
distance = math.abs(close - ma) / ma * 100
gradient_color = distance > 2 ? color.red : 
                 distance > 1 ? color.orange : 
                 distance > 0.5 ? color.yellow : color.green
plot(ma, "Distance MA", gradient_color)

// Color intensity based on volume
volume_intensity = volume / ta.sma(volume, 50)
intense_color = color.new(color.blue, math.max(0, 100 - volume_intensity * 50))
plot(ma, "Volume Intensity MA", intense_color, linewidth=3)

// Rainbow moving average
fast_ma = ta.ema(close, 5)
slow_ma = ta.ema(close, 50)
momentum = (fast_ma - slow_ma) / slow_ma * 100
rainbow_color = momentum > 3 ? color.lime :
                momentum > 1 ? color.green :
                momentum > 0 ? color.yellow :
                momentum > -1 ? color.orange :
                momentum > -3 ? color.red : color.maroon
plot(ma, "Rainbow MA", rainbow_color, linewidth=3)
```

## plotshape() for Signals

### Basic Shapes
```pinescript
//@version=6
indicator("Plot Shapes", overlay=true)

// Moving average crossover signals
fast_ma = ta.ema(close, 10)
slow_ma = ta.ema(close, 20)

bullish_cross = ta.crossover(fast_ma, slow_ma)
bearish_cross = ta.crossunder(fast_ma, slow_ma)

// Basic shapes
plotshape(bullish_cross, "Buy Signal", shape.triangleup, location.belowbar, color.lime, size=size.normal)
plotshape(bearish_cross, "Sell Signal", shape.triangledown, location.abovebar, color.red, size=size.normal)

// Different shape types
rsi = ta.rsi(close, 14)
oversold = rsi < 30
overbought = rsi > 70

plotshape(oversold, "Oversold", shape.circle, location.belowbar, color.green, size=size.small)
plotshape(overbought, "Overbought", shape.xcross, location.abovebar, color.red, size=size.small)

// Support and resistance levels
support_level = ta.lowest(low, 20)
resistance_level = ta.highest(high, 20)

touching_support = low <= support_level * 1.001
touching_resistance = high >= resistance_level * 0.999

plotshape(touching_support, "Support Test", shape.diamond, location.belowbar, color.blue, size=size.tiny)
plotshape(touching_resistance, "Resistance Test", shape.diamond, location.abovebar, color.purple, size=size.tiny)
```

### Advanced Shape Plotting
```pinescript
//@version=6
indicator("Advanced Shapes", overlay=true)

// Volume spike detection
avg_volume = ta.sma(volume, 20)
volume_spike = volume > avg_volume * 2

// High volume with price action
high_vol_up = volume_spike and close > open
high_vol_down = volume_spike and close < open

plotshape(high_vol_up, "Volume Spike Up", shape.arrowup, location.belowbar, color.lime, size=size.large)
plotshape(high_vol_down, "Volume Spike Down", shape.arrowdown, location.abovebar, color.red, size=size.large)

// Pattern recognition shapes
hammer = (close - low) > 2 * (high - close) and (high - low) > 3 * (open - close)
doji = math.abs(open - close) < (high - low) * 0.1

plotshape(hammer, "Hammer", shape.labelup, location.belowbar, color.green, size=size.small, text="H")
plotshape(doji, "Doji", shape.labeldown, location.abovebar, color.orange, size=size.small, text="D")

// Breakout signals with shapes
bb_length = 20
bb_mult = 2
bb_basis = ta.sma(close, bb_length)
bb_dev = bb_mult * ta.stdev(close, bb_length)
bb_upper = bb_basis + bb_dev
bb_lower = bb_basis - bb_dev

bb_breakout_up = close[1] <= bb_upper[1] and close > bb_upper
bb_breakout_down = close[1] >= bb_lower[1] and close < bb_lower

plotshape(bb_breakout_up, "BB Breakout Up", shape.flag, location.abovebar, color.yellow, size=size.normal)
plotshape(bb_breakout_down, "BB Breakout Down", shape.flag, location.belowbar, color.orange, size=size.normal)
```

### Custom Shape Text and Tooltips
```pinescript
//@version=6
indicator("Shape Text and Tooltips", overlay=true)

// RSI signals with custom text
rsi = ta.rsi(close, 14)
rsi_oversold = ta.crossover(rsi, 30)
rsi_overbought = ta.crossunder(rsi, 70)

plotshape(rsi_oversold, 
          title="RSI Bullish", 
          text="BUY\nRSI:30", 
          textcolor=color.white,
          style=shape.labelup, 
          location=location.belowbar, 
          color=color.green, 
          size=size.normal)

plotshape(rsi_overbought, 
          title="RSI Bearish", 
          text="SELL\nRSI:70", 
          textcolor=color.white,
          style=shape.labeldown, 
          location=location.abovebar, 
          color=color.red, 
          size=size.normal)

// Dynamic text based on conditions
macd_line = ta.ema(close, 12) - ta.ema(close, 26)
macd_signal = ta.ema(macd_line, 9)
macd_cross_up = ta.crossover(macd_line, macd_signal)

plotshape(macd_cross_up, 
          title="MACD Signal", 
          text="MACD\n" + str.tostring(macd_line, "#.####"), 
          style=shape.labelup, 
          location=location.belowbar, 
          color=color.blue, 
          textcolor=color.white,
          size=size.small)
```

## plotchar() for Minimal Indicators

### Character-Based Signals
```pinescript
//@version=6
indicator("Plot Characters", overlay=true)

// Simple character signals
sma_short = ta.sma(close, 10)
sma_long = ta.sma(close, 30)

bull_signal = ta.crossover(sma_short, sma_long)
bear_signal = ta.crossunder(sma_short, sma_long)

// Basic plotchar usage
plotchar(bull_signal, "Bull", "▲", location.belowbar, color.lime, size=size.small)
plotchar(bear_signal, "Bear", "▼", location.abovebar, color.red, size=size.small)

// Custom characters for different signals
stoch_k = ta.stoch(close, high, low, 14)
stoch_oversold = stoch_k < 20
stoch_overbought = stoch_k > 80

plotchar(stoch_oversold, "Stoch OS", "◆", location.belowbar, color.green, size=size.tiny)
plotchar(stoch_overbought, "Stoch OB", "◆", location.abovebar, color.red, size=size.tiny)

// Volume confirmation characters
avg_vol = ta.sma(volume, 20)
high_volume = volume > avg_vol * 1.5

plotchar(high_volume and close > open, "Vol Up", "●", location.absolute, color.lime, size=size.tiny)
plotchar(high_volume and close < open, "Vol Down", "●", location.absolute, color.red, size=size.tiny)

// Multiple timeframe signals
htf_trend = request.security(syminfo.tickerid, "1D", ta.ema(close, 20) > ta.ema(close, 50))
plotchar(htf_trend and not htf_trend[1], "HTF Bull", "↑", location.top, color.blue, size=size.normal)
plotchar(not htf_trend and htf_trend[1], "HTF Bear", "↓", location.top, color.purple, size=size.normal)
```

### ASCII Art and Symbols
```pinescript
//@version=6
indicator("ASCII Symbols", overlay=true)

// Trend strength indicators
atr = ta.atr(14)
atr_avg = ta.sma(atr, 20)
high_volatility = atr > atr_avg * 1.5
low_volatility = atr < atr_avg * 0.7

plotchar(high_volatility, "High Vol", "🔥", location.top, color.orange, size=size.small)
plotchar(low_volatility, "Low Vol", "❄", location.bottom, color.blue, size=size.small)

// Support/Resistance touches
pivot_high = ta.pivothigh(high, 5, 5)
pivot_low = ta.pivotlow(low, 5, 5)

plotchar(not na(pivot_high), "Resistance", "R", location.abovebar, color.red, size=size.tiny)
plotchar(not na(pivot_low), "Support", "S", location.belowbar, color.green, size=size.tiny)

// Fibonacci levels
fib_length = input.int(50, "Fibonacci Length")
fib_high = ta.highest(high, fib_length)
fib_low = ta.lowest(low, fib_length)
fib_range = fib_high - fib_low

fib_618 = fib_low + fib_range * 0.618
fib_382 = fib_low + fib_range * 0.382

near_618 = math.abs(close - fib_618) < atr * 0.5
near_382 = math.abs(close - fib_382) < atr * 0.5

plotchar(near_618, "Fib 618", "⚡", location.absolute, color.yellow, size=size.small)
plotchar(near_382, "Fib 382", "⚡", location.absolute, color.orange, size=size.small)
```

## plotarrow() for Directional Signals

### Basic Arrow Plotting
```pinescript
//@version=6
indicator("Plot Arrows", subplot=true)

// Momentum arrows
rsi = ta.rsi(close, 14)
macd = ta.ema(close, 12) - ta.ema(close, 26)
signal = ta.ema(macd, 9)
histogram = macd - signal

// Arrow based on histogram changes
hist_increasing = histogram > histogram[1]
hist_decreasing = histogram < histogram[1]

plotarrow(hist_increasing ? 1 : hist_decreasing ? -1 : na, 
          title="MACD Momentum", 
          colorup=color.lime, 
          colordown=color.red, 
          offset=0, 
          minheight=10, 
          maxheight=100)

// RSI momentum arrows
rsi_momentum = rsi - rsi[1]
strong_momentum = math.abs(rsi_momentum) > 2

plotarrow(strong_momentum ? math.sign(rsi_momentum) : na,
          title="RSI Momentum",
          colorup=color.blue,
          colordown=color.orange,
          minheight=5,
          maxheight=50)
```

### Advanced Arrow Techniques
```pinescript
//@version=6
indicator("Advanced Arrows", subplot=true)

// Volume-weighted momentum arrows
volume_avg = ta.sma(volume, 20)
volume_factor = volume / volume_avg
price_change = (close - close[1]) / close[1] * 100
momentum_strength = price_change * volume_factor

// Scaled arrows based on momentum strength
arrow_size = math.min(math.abs(momentum_strength) * 10, 100)

plotarrow(momentum_strength > 0.1 ? 1 : momentum_strength < -0.1 ? -1 : na,
          title="Volume Momentum",
          colorup=color.new(color.lime, 20),
          colordown=color.new(color.red, 20),
          minheight=10,
          maxheight=arrow_size)

// Divergence arrows
price_momentum = ta.roc(close, 5)
volume_momentum = ta.roc(volume, 5)

// Positive divergence: price down, volume up
pos_divergence = price_momentum < -1 and volume_momentum > 10
// Negative divergence: price up, volume down  
neg_divergence = price_momentum > 1 and volume_momentum < -10

plotarrow(pos_divergence ? 2 : neg_divergence ? -2 : na,
          title="Price-Volume Divergence",
          colorup=color.yellow,
          colordown=color.purple,
          minheight=20,
          maxheight=80)
```

## plotbar() and plotcandle()

### Custom Bar Plotting
```pinescript
//@version=6
indicator("Custom Bars", overlay=true)

// Heikin Ashi bars
ha_close = (open + high + low + close) / 4
ha_open = (nz(ha_open[1]) + nz(ha_close[1])) / 2
ha_high = math.max(high, math.max(ha_open, ha_close))
ha_low = math.min(low, math.min(ha_open, ha_close))

// Plot Heikin Ashi as bars
plotbar(ha_open, ha_high, ha_low, ha_close, 
        title="Heikin Ashi", 
        color=ha_close > ha_open ? color.lime : color.red,
        editable=false)

// Volume-weighted bars
vol_avg = ta.sma(volume, 20)
vol_color = volume > vol_avg * 1.5 ? color.yellow :
            volume > vol_avg ? color.blue :
            volume < vol_avg * 0.5 ? color.gray : color.white

plotbar(open, high, low, close,
        title="Volume Bars",
        color=vol_color)
```

### Custom Candle Plotting
```pinescript
//@version=6
indicator("Custom Candles", overlay=true)

// Trend-colored candles
ema21 = ta.ema(close, 21)
uptrend = close > ema21
downtrend = close < ema21

// Custom candle colors based on trend
candle_color = uptrend ? (close > open ? color.lime : color.green) :
               downtrend ? (close < open ? color.red : color.maroon) :
               color.gray

plotcandle(open, high, low, close,
           title="Trend Candles",
           color=candle_color,
           wickcolor=candle_color,
           bordercolor=candle_color)

// Volatility-based candle sizing
atr_current = ta.atr(14)
atr_avg = ta.sma(atr_current, 50)
volatility_ratio = atr_current / atr_avg

// Adjust candle appearance based on volatility
vol_intensity = math.min(volatility_ratio * 50, 90)
high_vol_color = color.new(close > open ? color.lime : color.red, 100 - vol_intensity)

plotcandle(open, high, low, close,
           title="Volatility Candles",
           color=high_vol_color,
           wickcolor=color.gray)
```

## fill() Between Plots

### Basic Fill Areas
```pinescript
//@version=6
indicator("Fill Areas", overlay=true)

// Moving average envelope
length = input.int(20, "Length")
envelope_pct = input.float(2.0, "Envelope %")

sma_mid = ta.sma(close, length)
sma_upper = sma_mid * (1 + envelope_pct / 100)
sma_lower = sma_mid * (1 - envelope_pct / 100)

// Plot the lines
upper_plot = plot(sma_upper, "Upper Band", color.red)
lower_plot = plot(sma_lower, "Lower Band", color.green)
mid_plot = plot(sma_mid, "Middle", color.blue)

// Fill between upper and lower
fill(upper_plot, lower_plot, color.new(color.blue, 95), title="Envelope Fill")

// Conditional fill based on price position
fill_color = close > sma_mid ? color.new(color.lime, 90) : color.new(color.red, 90)
fill(upper_plot, mid_plot, fill_color, title="Upper Fill")
```

### Advanced Fill Techniques
```pinescript
//@version=6
indicator("Advanced Fills", overlay=true)

// Bollinger Bands with gradient fill
bb_length = 20
bb_mult = 2.0
bb_basis = ta.sma(close, bb_length)
bb_dev = bb_mult * ta.stdev(close, bb_length)
bb_upper = bb_basis + bb_dev
bb_lower = bb_basis - bb_dev

// Create plots for fill
bb_upper_plot = plot(bb_upper, "BB Upper", color.red, linewidth=1)
bb_lower_plot = plot(bb_lower, "BB Lower", color.green, linewidth=1)
bb_mid_plot = plot(bb_basis, "BB Middle", color.blue)

// Gradient fill based on price position within bands
bb_position = (close - bb_lower) / (bb_upper - bb_lower)
fill_transparency = math.max(70, 95 - bb_position * 25)

upper_fill_color = color.new(color.red, fill_transparency)
lower_fill_color = color.new(color.green, fill_transparency)

fill(bb_upper_plot, bb_mid_plot, upper_fill_color)
fill(bb_mid_plot, bb_lower_plot, lower_fill_color)

// Ichimoku Cloud-style fill
tenkan = ta.sma(close, 9)
kijun = ta.sma(close, 26)
senkou_a = (tenkan + kijun) / 2
senkou_b = ta.sma(close, 52)

// Offset the Senkou lines
senkou_a_plot = plot(senkou_a[26], "Senkou A", color.green, offset=26)
senkou_b_plot = plot(senkou_b[26], "Senkou B", color.red, offset=26)

// Cloud color based on Senkou A vs B relationship
cloud_color = senkou_a[26] > senkou_b[26] ? color.new(color.lime, 85) : color.new(color.red, 85)
fill(senkou_a_plot, senkou_b_plot, cloud_color, title="Kumo Cloud")
```

## Multi-Pane Layouts

### Subplot Organization
```pinescript
//@version=6
indicator("Multi-Pane Layout", overlay=false)

// Main oscillator pane
rsi = ta.rsi(close, 14)
plot(rsi, "RSI", color.blue)
hline(70, "Overbought", color.red, linestyle=hline.style_dashed)
hline(30, "Oversold", color.green, linestyle=hline.style_dashed)
hline(50, "Midline", color.gray)

// Volume in separate subplot (would need separate script)
// This shows how to structure multiple related indicators
```

### Creating Composite Indicators
```pinescript
//@version=6
indicator("Composite Dashboard", overlay=false)

// Normalized indicators for comparison
rsi = ta.rsi(close, 14)
stoch = ta.stoch(close, high, low, 14)
cci = ta.cci(hlc3, 20)

// Normalize CCI to 0-100 scale
cci_normalized = (cci + 200) / 4

// Plot all on same scale
plot(rsi, "RSI", color.blue)
plot(stoch, "Stochastic", color.red)
plot(cci_normalized, "CCI Normalized", color.green)

// Consensus signal
consensus = (rsi + stoch + cci_normalized) / 3
plot(consensus, "Consensus", color.purple, linewidth=3)

// Reference lines
hline(80, "Extreme High", color.red, linestyle=hline.style_dashed)
hline(20, "Extreme Low", color.green, linestyle=hline.style_dashed)
hline(70, "High", color.orange, linestyle=hline.style_dotted)
hline(30, "Low", color.blue, linestyle=hline.style_dotted)
hline(50, "Neutral", color.gray)

// Background coloring for consensus zones
bgcolor(consensus > 70 ? color.new(color.red, 95) : 
        consensus < 30 ? color.new(color.green, 95) : na)
```

### Dynamic Visibility
```pinescript
//@version=6
indicator("Dynamic Visibility", overlay=true)

// Input controls for visibility
show_sma = input.bool(true, "Show SMA")
show_ema = input.bool(true, "Show EMA") 
show_bollinger = input.bool(false, "Show Bollinger Bands")
show_signals = input.bool(true, "Show Signals")

// Moving averages
sma20 = ta.sma(close, 20)
ema20 = ta.ema(close, 20)

// Conditional plotting
plot(show_sma ? sma20 : na, "SMA 20", color.blue, linewidth=2)
plot(show_ema ? ema20 : na, "EMA 20", color.red, linewidth=2)

// Bollinger Bands with conditional visibility
bb_upper = sma20 + 2 * ta.stdev(close, 20)
bb_lower = sma20 - 2 * ta.stdev(close, 20)

upper_plot = plot(show_bollinger ? bb_upper : na, "BB Upper", color.gray)
lower_plot = plot(show_bollinger ? bb_lower : na, "BB Lower", color.gray)
fill(upper_plot, lower_plot, color.new(color.blue, 95), title="BB Fill")

// Signals with visibility control
bullish_cross = ta.crossover(ema20, sma20)
bearish_cross = ta.crossunder(ema20, sma20)

plotshape(show_signals and bullish_cross, "Bull Signal", shape.triangleup, location.belowbar, color.lime)
plotshape(show_signals and bearish_cross, "Bear Signal", shape.triangledown, location.abovebar, color.red)

// Display mode controls
timeframe_visibility = input.string("All", "Show on Timeframes", options=["All", "Intraday Only", "Daily+"])

should_display = timeframe_visibility == "All" or
                 (timeframe_visibility == "Intraday Only" and timeframe.isintraday) or
                 (timeframe_visibility == "Daily+" and not timeframe.isintraday)

plot(should_display ? sma20 : na, "Conditional TF SMA", color.yellow, linewidth=3)
```

This comprehensive plotting guide covers all the essential visualization techniques in Pine Script v6, from basic line plots to complex multi-layered displays with dynamic behavior and conditional visibility.