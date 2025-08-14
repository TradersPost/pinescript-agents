# Pine Script v6 Indicator Calculations

## Moving Averages

### Simple Moving Average (SMA)
```pinescript
//@version=6
indicator("SMA Examples", overlay=true)

length = input.int(20, "Length", minval=1)
source = input.source(close, "Source")

// Basic SMA
sma_basic = ta.sma(source, length)
plot(sma_basic, "SMA", color.blue)

// Weighted by volume
sma_volume = ta.sma(source * volume, length) / ta.sma(volume, length)
plot(sma_volume, "Volume Weighted SMA", color.orange)

// Multiple timeframe SMA
sma_htf = request.security(syminfo.tickerid, "1D", ta.sma(close, 20))
plot(sma_htf, "Daily SMA", color.red, linewidth=2)
```

### Exponential Moving Average (EMA)
```pinescript
//@version=6
indicator("EMA Examples", overlay=true)

length = input.int(21, "Length", minval=1)
source = input.source(close, "Source")

// Standard EMA
ema_standard = ta.ema(source, length)
plot(ema_standard, "EMA", color.blue)

// Double EMA (DEMA)
ema1 = ta.ema(source, length)
ema2 = ta.ema(ema1, length)
dema = 2 * ema1 - ema2
plot(dema, "DEMA", color.green)

// Triple EMA (TEMA)
ema3 = ta.ema(ema2, length)
tema = 3 * ema1 - 3 * ema2 + ema3
plot(tema, "TEMA", color.red)

// Adaptive EMA using volatility
atr_period = 14
volatility = ta.atr(atr_period) / close
adaptive_alpha = math.min(volatility * 10, 1)
var float adaptive_ema = na
adaptive_ema := na(adaptive_ema) ? source : adaptive_alpha * source + (1 - adaptive_alpha) * adaptive_ema[1]
plot(adaptive_ema, "Adaptive EMA", color.purple)
```

### Hull Moving Average (HMA)
```pinescript
//@version=6
indicator("Hull Moving Average", overlay=true)

length = input.int(21, "Length", minval=1)
source = input.source(close, "Source")

// Hull Moving Average calculation
hma_calc(src, len) =>
    wma1 = ta.wma(src, len / 2) * 2
    wma2 = ta.wma(src, len)
    ta.wma(wma1 - wma2, math.round(math.sqrt(len)))

hma = hma_calc(source, length)
plot(hma, "HMA", color.blue, linewidth=2)

// HMA trend detection
hma_rising = hma > hma[1]
plot_color = hma_rising ? color.lime : color.red
plot(hma, "HMA Trend", plot_color, linewidth=3)
```

### Volume Weighted Moving Average (VWMA)
```pinescript
//@version=6
indicator("VWMA Examples", overlay=true)

length = input.int(20, "Length", minval=1)
source = input.source(close, "Source")

// Standard VWMA
vwma_standard = ta.vwma(source, length)
plot(vwma_standard, "VWMA", color.blue)

// VWMA with price-volume confirmation
vwma_slope = vwma_standard - vwma_standard[1]
volume_slope = volume - ta.sma(volume, length)
confirmed_trend = (vwma_slope > 0 and volume_slope > 0) or (vwma_slope < 0 and volume_slope < 0)
plot_color = confirmed_trend ? (vwma_slope > 0 ? color.lime : color.red) : color.gray
plot(vwma_standard, "VWMA Confirmed", plot_color, linewidth=2)
```

## Momentum Indicators

### Relative Strength Index (RSI)
```pinescript
//@version=6
indicator("Advanced RSI", subplot=true)

length = input.int(14, "RSI Length", minval=1)
source = input.source(close, "Source")
overbought = input.float(70, "Overbought Level")
oversold = input.float(30, "Oversold Level")

// Standard RSI
rsi = ta.rsi(source, length)
plot(rsi, "RSI", color.blue)

// RSI with smoothing
smooth_length = input.int(3, "Smoothing Length", minval=1)
rsi_smooth = ta.sma(rsi, smooth_length)
plot(rsi_smooth, "Smoothed RSI", color.orange)

// Multi-timeframe RSI
rsi_htf = request.security(syminfo.tickerid, "1D", ta.rsi(close, length))
plot(rsi_htf, "Daily RSI", color.red)

// RSI divergence detection
rsi_higher_low = rsi[1] < rsi and rsi[1] < rsi[2] and low[1] < low and low[1] < low[2]
rsi_lower_high = rsi[1] > rsi and rsi[1] > rsi[2] and high[1] > high and high[1] > high[2]

plotshape(rsi_higher_low, "Bullish Divergence", shape.triangleup, location.bottom, color.lime, size=size.small)
plotshape(rsi_lower_high, "Bearish Divergence", shape.triangledown, location.top, color.red, size=size.small)

// Overbought/Oversold levels
hline(overbought, "Overbought", color.red, linestyle=hline.style_dashed)
hline(oversold, "Oversold", color.green, linestyle=hline.style_dashed)
hline(50, "Midline", color.gray, linestyle=hline.style_dotted)
```

### MACD (Moving Average Convergence Divergence)
```pinescript
//@version=6
indicator("Advanced MACD", subplot=true)

source = input.source(close, "Source")
fast_length = input.int(12, "Fast Length", minval=1)
slow_length = input.int(26, "Slow Length", minval=1)
signal_length = input.int(9, "Signal Length", minval=1)

// MACD calculation
fast_ema = ta.ema(source, fast_length)
slow_ema = ta.ema(source, slow_length)
macd = fast_ema - slow_ema
signal = ta.ema(macd, signal_length)
histogram = macd - signal

// Plotting
plot(macd, "MACD", color.blue)
plot(signal, "Signal", color.red)
plot(histogram, "Histogram", color=histogram >= 0 ? color.lime : color.red, style=plot.style_columns)

// MACD crossover signals
macd_crossover = ta.crossover(macd, signal)
macd_crossunder = ta.crossunder(macd, signal)

plotshape(macd_crossover, "Bullish Cross", shape.triangleup, location.bottom, color.lime)
plotshape(macd_crossunder, "Bearish Cross", shape.triangledown, location.top, color.red)

// Zero line
hline(0, "Zero Line", color.gray, linestyle=hline.style_solid)

// MACD momentum
macd_momentum = macd - macd[1]
plot(macd_momentum * 10, "MACD Momentum", color.purple, display=display.none)
```

### Stochastic Oscillator
```pinescript
//@version=6
indicator("Advanced Stochastic", subplot=true)

k_length = input.int(14, "K Length", minval=1)
k_smooth = input.int(3, "K Smoothing", minval=1)
d_length = input.int(3, "D Length", minval=1)
overbought = input.float(80, "Overbought")
oversold = input.float(20, "Oversold")

// Stochastic calculation
lowest_low = ta.lowest(low, k_length)
highest_high = ta.highest(high, k_length)
k_fast = 100 * (close - lowest_low) / (highest_high - lowest_low)
k = ta.sma(k_fast, k_smooth)
d = ta.sma(k, d_length)

// Plotting
plot(k, "K", color.blue)
plot(d, "D", color.red)

// Stochastic signals
bullish_cross = ta.crossover(k, d) and k < oversold
bearish_cross = ta.crossunder(k, d) and k > overbought

plotshape(bullish_cross, "Bullish Signal", shape.triangleup, location.bottom, color.lime)
plotshape(bearish_cross, "Bearish Signal", shape.triangledown, location.top, color.red)

// Levels
hline(overbought, "Overbought", color.red, linestyle=hline.style_dashed)
hline(oversold, "Oversold", color.green, linestyle=hline.style_dashed)
hline(50, "Midline", color.gray, linestyle=hline.style_dotted)

// Stochastic divergence
stoch_higher_low = k[1] < k and k[1] < k[2] and low[1] < low and low[1] < low[2]
stoch_lower_high = k[1] > k and k[1] > k[2] and high[1] > high and high[1] > high[2]

bgcolor(stoch_higher_low ? color.new(color.lime, 90) : na, title="Bullish Divergence")
bgcolor(stoch_lower_high ? color.new(color.red, 90) : na, title="Bearish Divergence")
```

## Volatility Measures

### Average True Range (ATR)
```pinescript
//@version=6
indicator("Advanced ATR", subplot=true)

length = input.int(14, "ATR Length", minval=1)
multiplier = input.float(2.0, "ATR Multiplier", minval=0.1)

// ATR calculation
atr = ta.atr(length)
plot(atr, "ATR", color.blue)

// ATR as percentage of price
atr_percent = (atr / close) * 100
plot(atr_percent, "ATR %", color.orange)

// ATR bands (overlay on price chart)
atr_upper = close + atr * multiplier
atr_lower = close - atr * multiplier

// ATR-based stop loss levels
atr_stop_long = close - atr * multiplier
atr_stop_short = close + atr * multiplier

// ATR expansion/contraction
atr_sma = ta.sma(atr, length)
atr_expanding = atr > atr_sma * 1.2
atr_contracting = atr < atr_sma * 0.8

bgcolor(atr_expanding ? color.new(color.red, 90) : na, title="High Volatility")
bgcolor(atr_contracting ? color.new(color.green, 90) : na, title="Low Volatility")

// ATR percentile ranking
atr_rank = ta.percentrank(atr, 100)
plot(atr_rank, "ATR Rank", color.purple)
```

### Bollinger Bands
```pinescript
//@version=6
indicator("Advanced Bollinger Bands", overlay=true)

length = input.int(20, "Length", minval=1)
mult = input.float(2.0, "Standard Deviation", minval=0.1)
source = input.source(close, "Source")

// Bollinger Bands calculation
basis = ta.sma(source, length)
dev = mult * ta.stdev(source, length)
upper = basis + dev
lower = basis - dev

// Plotting
plot(basis, "Basis", color.blue)
p1 = plot(upper, "Upper", color.red)
p2 = plot(lower, "Lower", color.red)
fill(p1, p2, color.new(color.blue, 95), title="Background")

// Bollinger Band width
bb_width = (upper - lower) / basis * 100
bb_width_sma = ta.sma(bb_width, length)

// Squeeze detection
squeeze = bb_width < bb_width_sma * 0.7
expansion = bb_width > bb_width_sma * 1.3

plotshape(squeeze, "Squeeze", shape.diamond, location.belowbar, color.orange, size=size.tiny)
plotshape(expansion, "Expansion", shape.circle, location.belowbar, color.yellow, size=size.tiny)

// Bollinger Band %B
bb_percent = (source - lower) / (upper - lower) * 100

// Mean reversion signals
bb_oversold = bb_percent < 10
bb_overbought = bb_percent > 90

plotshape(bb_oversold, "BB Oversold", shape.triangleup, location.belowbar, color.lime)
plotshape(bb_overbought, "BB Overbought", shape.triangledown, location.abovebar, color.red)
```

### Keltner Channels
```pinescript
//@version=6
indicator("Keltner Channels", overlay=true)

length = input.int(20, "Length", minval=1)
mult = input.float(2.0, "Multiplier", minval=0.1)
use_ema = input.bool(true, "Use EMA (vs SMA)")

// Keltner Channel calculation
ma = use_ema ? ta.ema(close, length) : ta.sma(close, length)
atr = ta.atr(length)
upper = ma + atr * mult
lower = ma - atr * mult

// Plotting
plot(ma, "Middle", color.blue)
p1 = plot(upper, "Upper", color.red)
p2 = plot(lower, "Lower", color.red)
fill(p1, p2, color.new(color.blue, 95))

// Keltner Channel breakouts
breakout_up = close > upper[1] and close[1] <= upper[2]
breakout_down = close < lower[1] and close[1] >= lower[2]

plotshape(breakout_up, "Breakout Up", shape.triangleup, location.belowbar, color.lime)
plotshape(breakout_down, "Breakout Down", shape.triangledown, location.abovebar, color.red)

// Channel position
kc_position = (close - lower) / (upper - lower) * 100
```

## Volume Indicators

### On Balance Volume (OBV)
```pinescript
//@version=6
indicator("Advanced OBV", subplot=true)

// OBV calculation
obv = ta.obv
plot(obv, "OBV", color.blue)

// OBV moving average
obv_length = input.int(20, "OBV MA Length", minval=1)
obv_ma = ta.sma(obv, obv_length)
plot(obv_ma, "OBV MA", color.red)

// OBV divergence detection
obv_higher_low = obv[1] < obv and obv[1] < obv[2] and low[1] < low and low[1] < low[2]
obv_lower_high = obv[1] > obv and obv[1] > obv[2] and high[1] > high and high[1] > high[2]

plotshape(obv_higher_low, "OBV Bull Div", shape.triangleup, location.bottom, color.lime)
plotshape(obv_lower_high, "OBV Bear Div", shape.triangledown, location.top, color.red)

// OBV trend
obv_trend = obv > obv_ma ? 1 : -1
bgcolor(obv_trend == 1 ? color.new(color.lime, 95) : color.new(color.red, 95))

// OBV momentum
obv_momentum = obv - obv[1]
plot(obv_momentum, "OBV Momentum", color.purple, display=display.none)
```

### Volume Weighted Average Price (VWAP)
```pinescript
//@version=6
indicator("Advanced VWAP", overlay=true)

// Standard VWAP
vwap_value = ta.vwap(hlc3)
plot(vwap_value, "VWAP", color.blue, linewidth=2)

// VWAP bands
vwap_stdev = ta.stdev(hlc3, 20)
vwap_upper1 = vwap_value + vwap_stdev
vwap_lower1 = vwap_value - vwap_stdev
vwap_upper2 = vwap_value + vwap_stdev * 2
vwap_lower2 = vwap_value - vwap_stdev * 2

plot(vwap_upper1, "VWAP +1", color.red, linestyle=line.style_dashed)
plot(vwap_lower1, "VWAP -1", color.green, linestyle=line.style_dashed)
plot(vwap_upper2, "VWAP +2", color.red, linestyle=line.style_dotted)
plot(vwap_lower2, "VWAP -2", color.green, linestyle=line.style_dotted)

// Anchored VWAP (session start)
var float anchored_vwap = na
var float sum_pv = na
var float sum_v = na

if barstate.isfirst or session.isfirstbar
    anchored_vwap := hlc3
    sum_pv := hlc3 * volume
    sum_v := volume
else
    sum_pv := sum_pv + hlc3 * volume
    sum_v := sum_v + volume
    anchored_vwap := sum_pv / sum_v

plot(anchored_vwap, "Anchored VWAP", color.orange, linewidth=2)

// VWAP mean reversion
vwap_distance = (close - vwap_value) / vwap_value * 100
extreme_distance = math.abs(vwap_distance) > 2

plotshape(extreme_distance and close < vwap_value, "VWAP Support", shape.triangleup, location.belowbar, color.lime)
plotshape(extreme_distance and close > vwap_value, "VWAP Resistance", shape.triangledown, location.abovebar, color.red)
```

## Custom Oscillators

### Commodity Channel Index (CCI)
```pinescript
//@version=6
indicator("Custom CCI", subplot=true)

length = input.int(20, "Length", minval=1)
source = input.source(hlc3, "Source")

// CCI calculation
mean_price = ta.sma(source, length)
mean_deviation = ta.sma(math.abs(source - mean_price), length)
cci = (source - mean_price) / (0.015 * mean_deviation)

plot(cci, "CCI", color.blue)

// CCI levels
hline(100, "Overbought", color.red, linestyle=hline.style_dashed)
hline(-100, "Oversold", color.green, linestyle=hline.style_dashed)
hline(0, "Zero", color.gray, linestyle=hline.style_dotted)

// CCI signals
cci_oversold = cci < -100 and cci[1] >= -100
cci_overbought = cci > 100 and cci[1] <= 100

plotshape(cci_oversold, "CCI Buy", shape.triangleup, location.bottom, color.lime)
plotshape(cci_overbought, "CCI Sell", shape.triangledown, location.top, color.red)

// CCI trend filter
cci_bullish = cci > 0 and cci > cci[1]
cci_bearish = cci < 0 and cci < cci[1]

bgcolor(cci_bullish ? color.new(color.lime, 95) : cci_bearish ? color.new(color.red, 95) : na)
```

### Williams %R
```pinescript
//@version=6
indicator("Williams %R", subplot=true)

length = input.int(14, "Length", minval=1)

// Williams %R calculation
highest_high = ta.highest(high, length)
lowest_low = ta.lowest(low, length)
williams_r = -100 * (highest_high - close) / (highest_high - lowest_low)

plot(williams_r, "Williams %R", color.blue)

// Williams %R levels
hline(-20, "Overbought", color.red, linestyle=hline.style_dashed)
hline(-80, "Oversold", color.green, linestyle=hline.style_dashed)
hline(-50, "Midline", color.gray, linestyle=hline.style_dotted)

// Williams %R signals
wr_oversold = williams_r < -80 and williams_r[1] >= -80
wr_overbought = williams_r > -20 and williams_r[1] <= -20

plotshape(wr_oversold, "WR Buy", shape.triangleup, location.bottom, color.lime)
plotshape(wr_overbought, "WR Sell", shape.triangledown, location.top, color.red)
```

## Divergence Detection Algorithms

### Generic Divergence Function
```pinescript
//@version=6
indicator("Divergence Detection", overlay=true)

// Generic divergence detection function
detect_divergence(osc, price, lookback, threshold) =>
    // Find pivot highs and lows
    pivot_high_osc = ta.pivothigh(osc, lookback, lookback)
    pivot_low_osc = ta.pivotlow(osc, lookback, lookback)
    pivot_high_price = ta.pivothigh(price, lookback, lookback)
    pivot_low_price = ta.pivotlow(price, lookback, lookback)
    
    // Bearish divergence (price higher high, oscillator lower high)
    bearish_div = not na(pivot_high_osc) and not na(pivot_high_price) and 
                  pivot_high_price > pivot_high_price[1] and 
                  pivot_high_osc < pivot_high_osc[1]
    
    // Bullish divergence (price lower low, oscillator higher low)
    bullish_div = not na(pivot_low_osc) and not na(pivot_low_price) and 
                  pivot_low_price < pivot_low_price[1] and 
                  pivot_low_osc > pivot_low_osc[1]
    
    [bullish_div, bearish_div]

// Example usage with RSI
rsi = ta.rsi(close, 14)
[bullish_rsi_div, bearish_rsi_div] = detect_divergence(rsi, close, 5, 0.02)

plotshape(bullish_rsi_div, "Bullish RSI Div", shape.triangleup, location.belowbar, color.lime, size=size.small)
plotshape(bearish_rsi_div, "Bearish RSI Div", shape.triangledown, location.abovebar, color.red, size=size.small)

// Hidden divergence detection
detect_hidden_divergence(osc, price, lookback) =>
    pivot_high_osc = ta.pivothigh(osc, lookback, lookback)
    pivot_low_osc = ta.pivotlow(osc, lookback, lookback)
    pivot_high_price = ta.pivothigh(price, lookback, lookback)
    pivot_low_price = ta.pivotlow(price, lookback, lookback)
    
    // Hidden bullish (price higher low, oscillator lower low)
    hidden_bullish = not na(pivot_low_osc) and not na(pivot_low_price) and 
                     pivot_low_price > pivot_low_price[1] and 
                     pivot_low_osc < pivot_low_osc[1]
    
    // Hidden bearish (price lower high, oscillator higher high)
    hidden_bearish = not na(pivot_high_osc) and not na(pivot_high_price) and 
                     pivot_high_price < pivot_high_price[1] and 
                     pivot_high_osc > pivot_high_osc[1]
    
    [hidden_bullish, hidden_bearish]

[hidden_bull_rsi, hidden_bear_rsi] = detect_hidden_divergence(rsi, close, 5)

plotshape(hidden_bull_rsi, "Hidden Bull", shape.diamond, location.belowbar, color.yellow, size=size.tiny)
plotshape(hidden_bear_rsi, "Hidden Bear", shape.diamond, location.abovebar, color.orange, size=size.tiny)
```

## Statistical Calculations

### Z-Score and Standard Deviations
```pinescript
//@version=6
indicator("Statistical Analysis", subplot=true)

length = input.int(20, "Calculation Length", minval=1)
source = input.source(close, "Source")

// Z-Score calculation
mean = ta.sma(source, length)
std_dev = ta.stdev(source, length)
z_score = (source - mean) / std_dev

plot(z_score, "Z-Score", color.blue)

// Z-Score extreme levels
hline(2, "Z+2", color.red, linestyle=hline.style_dashed)
hline(-2, "Z-2", color.green, linestyle=hline.style_dashed)
hline(0, "Mean", color.gray, linestyle=hline.style_solid)

// Z-Score percentile
z_percentile = ta.percentrank(z_score, 100)
plot(z_percentile, "Z-Score Percentile", color.orange)

// Statistical moments
skewness_calc(src, len) =>
    m = ta.sma(src, len)
    s = ta.stdev(src, len)
    ta.sma(math.pow((src - m) / s, 3), len)

kurtosis_calc(src, len) =>
    m = ta.sma(src, len)
    s = ta.stdev(src, len)
    ta.sma(math.pow((src - m) / s, 4), len) - 3

skew = skewness_calc(source, length)
kurt = kurtosis_calc(source, length)

plot(skew, "Skewness", color.purple, display=display.data_window)
plot(kurt, "Kurtosis", color.maroon, display=display.data_window)

// Outlier detection
outlier_threshold = input.float(2.5, "Outlier Threshold", minval=1)
is_outlier = math.abs(z_score) > outlier_threshold

plotshape(is_outlier, "Outlier", shape.xcross, location.absolute, color.red, size=size.small)

// Rolling correlation with volume
correlation_length = input.int(50, "Correlation Length", minval=2)
price_volume_corr = ta.correlation(source, volume, correlation_length)
plot(price_volume_corr, "Price-Volume Correlation", color.yellow)
```

### Advanced Statistics
```pinescript
//@version=6
indicator("Advanced Statistics", subplot=true)

length = input.int(50, "Length", minval=2)
source = input.source(close, "Source")

// Coefficient of Variation
cv = ta.stdev(source, length) / ta.sma(source, length) * 100
plot(cv, "Coefficient of Variation", color.blue)

// Hurst Exponent approximation
hurst_length = input.int(100, "Hurst Length", minval=10)
log_returns = math.log(source / source[1])
rs_calc(returns, len) =>
    mean_return = ta.sma(returns, len)
    deviations = returns - mean_return
    cumulative_deviations = math.sum(deviations, len)
    range_val = ta.highest(cumulative_deviations, len) - ta.lowest(cumulative_deviations, len)
    std_dev = ta.stdev(returns, len)
    range_val / std_dev

rs_ratio = rs_calc(log_returns, hurst_length)
hurst_exponent = math.log(rs_ratio) / math.log(hurst_length)
plot(hurst_exponent, "Hurst Exponent", color.orange)

// Mean reversion strength
mean_reversion_strength = 1 - math.abs(ta.correlation(source, source[1], length))
plot(mean_reversion_strength, "Mean Reversion", color.green)

// Trend strength using linear regression
lr_slope = ta.linreg(source, length, 0) - ta.linreg(source, length, 1)
lr_r2 = math.pow(ta.correlation(source, bar_index, length), 2)
trend_strength = math.abs(lr_slope) * lr_r2
plot(trend_strength, "Trend Strength", color.red)
```

This comprehensive calculations documentation covers all the essential mathematical foundations for Pine Script indicators, providing practical examples and advanced techniques for each category.