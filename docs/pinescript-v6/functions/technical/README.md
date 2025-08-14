# Pine Script v6 Technical Analysis Functions (ta.*)

## Overview
This document provides a comprehensive index of all technical analysis functions available in Pine Script v6 under the `ta.*` namespace. These functions are essential for creating indicators and implementing trading strategies.

## Trend Indicators

### Moving Averages
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.sma(source, length)` | Simple Moving Average | source: series, length: int | `ta.sma(close, 20)` |
| `ta.ema(source, length)` | Exponential Moving Average | source: series, length: int | `ta.ema(close, 12)` |
| `ta.wma(source, length)` | Weighted Moving Average | source: series, length: int | `ta.wma(close, 10)` |
| `ta.vwma(source, length)` | Volume Weighted Moving Average | source: series, length: int | `ta.vwma(close, 20)` |
| `ta.alma(source, length, offset, sigma)` | Arnaud Legoux Moving Average | source: series, length: int, offset: float, sigma: int | `ta.alma(close, 14, 0.85, 6)` |
| `ta.hma(source, length)` | Hull Moving Average | source: series, length: int | `ta.hma(close, 16)` |
| `ta.rma(source, length)` | Rolling Moving Average (Wilder's) | source: series, length: int | `ta.rma(close, 14)` |
| `ta.swma(source)` | Symmetrically Weighted Moving Average | source: series | `ta.swma(close)` |

### Trend Detection
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.linreg(source, length, offset)` | Linear Regression | source: series, length: int, offset: int | `ta.linreg(close, 14, 0)` |
| `ta.pearsonr(source1, source2, length)` | Pearson Correlation Coefficient | source1: series, source2: series, length: int | `ta.pearsonr(close, volume, 20)` |
| `ta.slope(source, length)` | Slope of Linear Regression | source: series, length: int | `ta.slope(close, 14)` |

## Momentum Indicators

### RSI Family
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.rsi(source, length)` | Relative Strength Index | source: series, length: int | `ta.rsi(close, 14)` |
| `ta.stoch(source, high, low, length)` | Stochastic %K | source: series, high: series, low: series, length: int | `ta.stoch(close, high, low, 14)` |

### MACD and Derivatives
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.macd(source, fastlen, slowlen, siglen)` | MACD (returns [macd, signal, histogram]) | source: series, fastlen: int, slowlen: int, siglen: int | `ta.macd(close, 12, 26, 9)` |

### Rate of Change
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.roc(source, length)` | Rate of Change | source: series, length: int | `ta.roc(close, 10)` |
| `ta.mom(source, length)` | Momentum | source: series, length: int | `ta.mom(close, 10)` |

### Commodity Channel Index
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.cci(source, length)` | Commodity Channel Index | source: series, length: int | `ta.cci(hlc3, 20)` |

### Williams %R
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.wpr(length)` | Williams Percent Range | length: int | `ta.wpr(14)` |

## Volatility Indicators

### Bollinger Bands
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.bb(source, length, mult)` | Bollinger Bands (returns [upper, basis, lower]) | source: series, length: int, mult: float | `ta.bb(close, 20, 2.0)` |

### Average True Range
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.atr(length)` | Average True Range | length: int | `ta.atr(14)` |
| `ta.tr()` | True Range | none | `ta.tr()` |
| `ta.tr(handle_na)` | True Range with NA handling | handle_na: bool | `ta.tr(true)` |

### Standard Deviation
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.stdev(source, length, biased)` | Standard Deviation | source: series, length: int, biased: bool | `ta.stdev(close, 20, false)` |
| `ta.dev(source, length)` | Mean Deviation | source: series, length: int | `ta.dev(close, 20)` |
| `ta.variance(source, length, biased)` | Variance | source: series, length: int, biased: bool | `ta.variance(close, 20, false)` |

### Keltner Channels
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.kc(source, length, mult, use_true_range)` | Keltner Channels (returns [upper, basis, lower]) | source: series, length: int, mult: float, use_true_range: bool | `ta.kc(close, 20, 2.0, true)` |

## Volume Indicators

### Volume-based Indicators
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.obv` | On Balance Volume | none (built-in calculation) | `ta.obv` |
| `ta.pvt` | Price Volume Trend | none (built-in calculation) | `ta.pvt` |
| `ta.nvi` | Negative Volume Index | none (built-in calculation) | `ta.nvi` |
| `ta.pvi` | Positive Volume Index | none (built-in calculation) | `ta.pvi` |
| `ta.mfi(source, length)` | Money Flow Index | source: series, length: int | `ta.mfi(hlc3, 14)` |
| `ta.ad` | Accumulation/Distribution | none (built-in calculation) | `ta.ad` |
| `ta.adl` | Accumulation/Distribution Line | none (built-in calculation) | `ta.adl` |
| `ta.cmo(source, length)` | Chande Momentum Oscillator | source: series, length: int | `ta.cmo(close, 14)` |

## Directional Movement System

### ADX and DMI
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.adx(diplus, diminus, adxlen)` | Average Directional Index | diplus: series, diminus: series, adxlen: int | `ta.adx(ta.dmi(high, low, close, 14)[0], ta.dmi(high, low, close, 14)[1], 14)` |
| `ta.dmi(high, low, close, length)` | Directional Movement Index (returns [diplus, diminus, adx]) | high: series, low: series, close: series, length: int | `ta.dmi(high, low, close, 14)` |

## Price Action Indicators

### Support and Resistance
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.highest(source, length)` | Highest value over length bars | source: series, length: int | `ta.highest(high, 20)` |
| `ta.lowest(source, length)` | Lowest value over length bars | source: series, length: int | `ta.lowest(low, 20)` |
| `ta.highestbars(source, length)` | Bars since highest value | source: series, length: int | `ta.highestbars(high, 20)` |
| `ta.lowestbars(source, length)` | Bars since lowest value | source: series, length: int | `ta.lowestbars(low, 20)` |

### Pivot Points
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.pivothigh(source, leftbars, rightbars)` | Pivot High | source: series, leftbars: int, rightbars: int | `ta.pivothigh(high, 5, 5)` |
| `ta.pivotlow(source, leftbars, rightbars)` | Pivot Low | source: series, leftbars: int, rightbars: int | `ta.pivotlow(low, 5, 5)` |

## Signal Detection

### Crossover Functions
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.crossover(source1, source2)` | Source1 crosses over source2 | source1: series, source2: series | `ta.crossover(close, ta.sma(close, 20))` |
| `ta.crossunder(source1, source2)` | Source1 crosses under source2 | source1: series, source2: series | `ta.crossunder(close, ta.sma(close, 20))` |
| `ta.cross(source1, source2)` | Source1 crosses source2 (either direction) | source1: series, source2: series | `ta.cross(close, ta.sma(close, 20))` |

### Change Detection
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.change(source)` | Difference from previous value | source: series | `ta.change(close)` |
| `ta.change(source, length)` | Difference from value length bars ago | source: series, length: int | `ta.change(close, 5)` |
| `ta.rising(source, length)` | True if source is rising over length bars | source: series, length: int | `ta.rising(close, 3)` |
| `ta.falling(source, length)` | True if source is falling over length bars | source: series, length: int | `ta.falling(close, 3)` |

## Oscillator Functions

### Fisher Transform
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.fisher(source, length)` | Fisher Transform | source: series, length: int | `ta.fisher(hlc3, 10)` |

### Supertrend
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.supertrend(factor, atrPeriod)` | Supertrend (returns [supertrend, direction]) | factor: float, atrPeriod: int | `ta.supertrend(3.0, 10)` |

## Miscellaneous Functions

### Median and Percentiles
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.median(source, length)` | Median value | source: series, length: int | `ta.median(close, 20)` |
| `ta.percentile_linear_interpolation(source, length, percentage)` | Percentile with linear interpolation | source: series, length: int, percentage: float | `ta.percentile_linear_interpolation(close, 20, 80)` |
| `ta.percentile_nearest_rank(source, length, percentage)` | Percentile with nearest rank | source: series, length: int, percentage: float | `ta.percentile_nearest_rank(close, 20, 80)` |

### Sum and Count
| Function | Description | Parameters | Example |
|----------|-------------|------------|---------|
| `ta.cum(source)` | Cumulative sum | source: series | `ta.cum(volume)` |
| `ta.sma(source, length)` | Can also be used for sum when multiplied by length | source: series, length: int | `ta.sma(close, 20) * 20` |

## Usage Examples

### Complete Indicator Examples

#### RSI with Divergence Detection
```pine
//@version=6
indicator("RSI with Divergence", overlay=false)

// RSI calculation
rsiLength = input.int(14, "RSI Length")
rsi = ta.rsi(close, rsiLength)

// Divergence detection using pivot points
ph = ta.pivothigh(rsi, 5, 5)
pl = ta.pivotlow(rsi, 5, 5)

// Plot RSI
plot(rsi, color=color.purple, title="RSI")
hline(70, "Overbought", color=color.red)
hline(30, "Oversold", color=color.green)
hline(50, "Midline", color=color.gray, linestyle=hline.style_dashed)
```

#### Multi-Timeframe Moving Average
```pine
//@version=6
indicator("MTF Moving Average", overlay=true)

// Input parameters
maLength = input.int(20, "MA Length")
maType = input.string("EMA", "MA Type", options=["SMA", "EMA", "WMA"])
higherTF = input.timeframe("1D", "Higher Timeframe")

// Calculate MA based on type
getMA(source, length, type) =>
    switch type
        "SMA" => ta.sma(source, length)
        "EMA" => ta.ema(source, length)
        "WMA" => ta.wma(source, length)

// Current timeframe MA
currentMA = getMA(close, maLength, maType)

// Higher timeframe MA
htfMA = request.security(syminfo.tickerid, higherTF, getMA(close, maLength, maType), lookahead=barmerge.lookahead_off)

// Plot MAs
plot(currentMA, color=color.blue, title="Current TF MA")
plot(htfMA, color=color.red, linewidth=2, title="Higher TF MA")
```

#### Volatility Indicator Combo
```pine
//@version=6
indicator("Volatility Combo", overlay=false)

// ATR
atrLength = input.int(14, "ATR Length")
atr = ta.atr(atrLength)

// Bollinger Bands width
bbLength = input.int(20, "BB Length")
bbMult = input.float(2.0, "BB Multiplier")
[upper, basis, lower] = ta.bb(close, bbLength, bbMult)
bbWidth = (upper - lower) / basis * 100

// Standard deviation
stdevLength = input.int(20, "StdDev Length")
stdev = ta.stdev(close, stdevLength)

// Plot volatility measures
plot(atr, color=color.red, title="ATR")
plot(bbWidth, color=color.blue, title="BB Width %")
plot(stdev, color=color.green, title="Standard Deviation")
```

## Function Categories Summary

### **Trend Following**
- Moving Averages: `ta.sma()`, `ta.ema()`, `ta.wma()`, `ta.hma()`, `ta.alma()`
- Linear Regression: `ta.linreg()`, `ta.slope()`

### **Momentum**
- Oscillators: `ta.rsi()`, `ta.stoch()`, `ta.cci()`, `ta.wpr()`
- Rate of Change: `ta.roc()`, `ta.mom()`, `ta.cmo()`
- MACD: `ta.macd()`

### **Volatility**
- Bands: `ta.bb()`, `ta.kc()`
- Range: `ta.atr()`, `ta.tr()`
- Statistical: `ta.stdev()`, `ta.variance()`

### **Volume**
- Flow: `ta.obv`, `ta.pvt`, `ta.mfi()`
- Accumulation: `ta.ad`, `ta.adl`

### **Support/Resistance**
- Extremes: `ta.highest()`, `ta.lowest()`
- Pivots: `ta.pivothigh()`, `ta.pivotlow()`

### **Signal Detection**
- Crossovers: `ta.crossover()`, `ta.crossunder()`, `ta.cross()`
- Changes: `ta.change()`, `ta.rising()`, `ta.falling()`

## Best Practices

1. **Parameter Selection**: Use standard parameter values unless you have a specific reason to change them
2. **Combination Usage**: Combine multiple indicators for confirmation
3. **Timeframe Consideration**: Some indicators work better on specific timeframes
4. **Performance**: Be mindful of calculation-heavy indicators in complex scripts
5. **Validation**: Always validate inputs and handle edge cases
6. **Documentation**: Document which indicators you're using and why

This comprehensive reference should help you utilize the full power of Pine Script v6's technical analysis functions in your indicators and strategies.