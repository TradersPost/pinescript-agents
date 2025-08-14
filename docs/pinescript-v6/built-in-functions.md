# Pine Script v6 Built-in Functions Reference

## Technical Analysis Functions (ta namespace)

### Moving Averages
```pinescript
ta.sma(source, length)  // Simple Moving Average
ta.ema(source, length)  // Exponential Moving Average
ta.wma(source, length)  // Weighted Moving Average
ta.vwma(source, length)  // Volume Weighted Moving Average
ta.rma(source, length)  // Running Moving Average (Wilder's smoothing)
ta.hma(source, length)  // Hull Moving Average
ta.swma(source)  // Symmetrically Weighted Moving Average
ta.alma(series, length, offset, sigma)  // Arnaud Legoux Moving Average
ta.vwap(source)  // Volume Weighted Average Price
```

### Momentum Indicators
```pinescript
ta.rsi(source, length)  // Relative Strength Index
ta.stoch(source, high, low, length)  // Stochastic
ta.cci(source, length)  // Commodity Channel Index
ta.mom(source, length)  // Momentum
ta.roc(source, length)  // Rate of Change
ta.cmo(source, length)  // Chande Momentum Oscillator
ta.mfi(series, length)  // Money Flow Index
ta.wpr(length)  // Williams %R
```

### Trend Indicators
```pinescript
ta.macd(source, fastlen, slowlen, siglen)  // MACD
ta.adx(dilen)  // Average Directional Index
ta.dmi(dilen, adxlen)  // Directional Movement Index
ta.sar(start, inc, max)  // Parabolic SAR
ta.supertrend(factor, atrPeriod)  // Supertrend
```

### Volatility Indicators
```pinescript
ta.bb(series, length, mult)  // Bollinger Bands
ta.bbw(series, length, mult)  // Bollinger Band Width
ta.kc(series, length, mult, useTrueRange)  // Keltner Channels
ta.atr(length)  // Average True Range
ta.tr(handle_na)  // True Range
ta.natr(length)  // Normalized ATR
```

### Volume Indicators
```pinescript
ta.obv()  // On Balance Volume
ta.pvt()  // Price Volume Trend
ta.nvi()  // Negative Volume Index
ta.pvi()  // Positive Volume Index
ta.ad()  // Accumulation/Distribution
```

### Statistical Functions
```pinescript
ta.correlation(source1, source2, length)  // Correlation coefficient
ta.stdev(source, length, biased)  // Standard Deviation
ta.variance(source, length, biased)  // Variance
ta.covariance(source1, source2, length)  // Covariance
ta.linreg(source, length, offset)  // Linear Regression
ta.median(source, length)  // Median
ta.mode(source, length)  // Mode
ta.range(source, length)  // Range
ta.percentile_linear_interpolation(source, length, percentage)  // Percentile
ta.percentrank(source, length)  // Percent Rank
```

### Price Action Functions
```pinescript
ta.rising(source, length)  // Rising values
ta.falling(source, length)  // Falling values
ta.change(source, length)  // Change from n bars ago
ta.crossover(source1, source2)  // Crossover
ta.crossunder(source1, source2)  // Crossunder
ta.cross(source1, source2)  // Cross either direction
ta.barssince(condition)  // Bars since condition
ta.highest(source, length)  // Highest value
ta.lowest(source, length)  // Lowest value
ta.highestbars(source, length)  // Bars since highest
ta.lowestbars(source, length)  // Bars since lowest
ta.valuewhen(condition, source, occurrence)  // Value when condition true
```

### Pivot Functions
```pinescript
ta.pivot_point_levels(type, anchor, developing)  // Pivot levels
ta.pivothigh(source, leftbars, rightbars)  // Pivot high
ta.pivotlow(source, leftbars, rightbars)  // Pivot low
```

## Math Functions (math namespace)

### Basic Math
```pinescript
math.abs(number)  // Absolute value
math.sign(number)  // Sign of number (-1, 0, 1)
math.min(number1, number2, ...)  // Minimum
math.max(number1, number2, ...)  // Maximum
math.avg(number1, number2, ...)  // Average
math.sum(source, length)  // Sum
math.round(number, precision)  // Round
math.floor(number)  // Floor
math.ceil(number)  // Ceiling
```

### Exponential and Logarithmic
```pinescript
math.exp(number)  // Exponential
math.log(number)  // Natural logarithm
math.log10(number)  // Base-10 logarithm
math.pow(base, exponent)  // Power
math.sqrt(number)  // Square root
```

### Trigonometric
```pinescript
math.sin(angle)  // Sine
math.cos(angle)  // Cosine
math.tan(angle)  // Tangent
math.asin(number)  // Arcsine
math.acos(number)  // Arccosine
math.atan(number)  // Arctangent
math.todegrees(radians)  // Convert to degrees
math.toradians(degrees)  // Convert to radians
```

### Random
```pinescript
math.random(min, max, seed)  // Random number
```

## String Functions (str namespace)

### String Manipulation
```pinescript
str.tostring(value, format)  // Convert to string
str.tonumber(string)  // Convert to number
str.length(string)  // String length
str.substring(string, begin_pos, end_pos)  // Substring
str.upper(string)  // Uppercase
str.lower(string)  // Lowercase
str.replace(string, target, replacement, occurrence)  // Replace
str.replace_all(string, target, replacement)  // Replace all
str.split(string, separator)  // Split string
str.trim(string)  // Trim whitespace
```

### String Testing
```pinescript
str.contains(source, str)  // Contains substring
str.startswith(source, str)  // Starts with
str.endswith(source, str)  // Ends with
str.match(string, regex)  // Regex match
```

### Formatting
```pinescript
str.format(formatString, arg0, arg1, ...)  // Format string
str.format_time(time, format, timezone)  // Format time
str.format_price(number, mintick)  // Format price
```

## Request Functions (request namespace)

### Security Data
```pinescript
request.security(symbol, timeframe, expression, gaps, lookahead, ignore_invalid_symbol, currency)
request.security_lower_tf(symbol, timeframe, expression, ignore_invalid_symbol, currency, ignore_invalid_timeframe)
```

### Economic Data
```pinescript
request.economic(country_code, field, gaps)
```

### Financial Data
```pinescript
request.financial(symbol, financial_id, period, gaps, ignore_invalid_symbol, currency)
request.quandl(ticker, gaps, index, ignore_invalid_symbol)
```

### Dividends and Splits
```pinescript
request.dividends(ticker, field, gaps, lookahead, ignore_invalid_symbol, currency)
request.splits(ticker, field, gaps, lookahead, ignore_invalid_symbol)
request.earnings(ticker, field, gaps, lookahead, ignore_invalid_symbol, currency)
```

## Time Functions

### Time Information
```pinescript
time  // Current bar time
time_close  // Current bar close time
timenow  // Current real-time
year  // Year
month  // Month
dayofmonth  // Day of month
dayofweek  // Day of week
hour  // Hour
minute  // Minute
second  // Second
```

### Time Testing
```pinescript
time(timeframe)  // Time of timeframe
time(timeframe, session, timezone)  // Time in session
timestamp(year, month, day, hour, minute, second, timezone)  // Create timestamp
```

## Array Functions (array namespace)

### Array Creation
```pinescript
array.new<type>(size, initial_value)
array.from(arg0, arg1, ...)
array.copy(id)
```

### Array Modification
```pinescript
array.push(id, value)
array.unshift(id, value)
array.pop(id)
array.shift(id)
array.insert(id, index, value)
array.remove(id, index)
array.clear(id)
array.set(id, index, value)
```

### Array Access
```pinescript
array.get(id, index)
array.first(id)
array.last(id)
array.size(id)
```

### Array Operations
```pinescript
array.concat(id1, id2)
array.join(id, separator)
array.sort(id, order)
array.reverse(id)
array.slice(id, index_from, index_to)
```

### Array Calculations
```pinescript
array.sum(id)
array.avg(id)
array.min(id)
array.max(id)
array.median(id)
array.mode(id)
array.stdev(id)
array.variance(id)
array.covariance(id1, id2)
```

### Array Search
```pinescript
array.indexof(id, value)
array.lastindexof(id, value)
array.includes(id, value)
array.binary_search(id, value)
```

## Color Functions

### Color Creation
```pinescript
color.new(color, transp)
color.rgb(red, green, blue, transp)
color.from_gradient(value, bottom_value, top_value, bottom_color, top_color)
```

### Color Components
```pinescript
color.r(color)  // Red component
color.g(color)  // Green component
color.b(color)  // Blue component
color.t(color)  // Transparency component
```

## Strategy Functions (strategy namespace)

### Entry and Exit
```pinescript
strategy.entry(id, direction, qty, limit, stop, oca_name, oca_type, comment, when, alert_message)
strategy.exit(id, from_entry, qty, qty_percent, profit, limit, loss, stop, trail_price, trail_points, trail_offset, oca_name, comment, when, alert_message)
strategy.close(id, when, comment, qty, qty_percent, alert_message, immediately)
strategy.close_all(when, comment, alert_message, immediately)
strategy.cancel(id, when)
strategy.cancel_all(when)
```

### Position Information
```pinescript
strategy.position_size  // Current position size
strategy.position_avg_price  // Average entry price
strategy.opentrades  // Number of open trades
strategy.closedtrades  // Number of closed trades
strategy.wintrades  // Number of winning trades
strategy.losstrades  // Number of losing trades
```

### Performance Metrics
```pinescript
strategy.netprofit  // Net profit
strategy.grossprofit  // Gross profit
strategy.grossloss  // Gross loss
strategy.max_drawdown  // Maximum drawdown
strategy.equity  // Current equity
strategy.initial_capital  // Initial capital
```

### Risk Management
```pinescript
strategy.risk.allow_entry_in(value)
strategy.risk.max_cons_loss_days(count, alert_message)
strategy.risk.max_drawdown(value, type, alert_message)
strategy.risk.max_intraday_filled_orders(count, alert_message)
strategy.risk.max_intraday_loss(value, type, alert_message)
strategy.risk.max_position_size(contracts)
```

## Ticker Functions

### Ticker Creation
```pinescript
ticker.new(prefix, ticker, session, adjustment)
ticker.modify(tickerid, session, adjustment)
```

### Standard Tickers
```pinescript
ticker.heikinashi(symbol)
ticker.renko(symbol, style, param, request_wicks, source)
ticker.pointfigure(symbol, style, param, reversal)
ticker.kagi(symbol, style, param)
ticker.linebreak(symbol, style, param)
```

## Input Functions (input namespace)

### Basic Inputs
```pinescript
input.int(defval, title, minval, maxval, step, tooltip, inline, group, confirm)
input.float(defval, title, minval, maxval, step, tooltip, inline, group, confirm)
input.bool(defval, title, tooltip, inline, group, confirm)
input.string(defval, title, options, tooltip, inline, group, confirm)
```

### Special Inputs
```pinescript
input.color(defval, title, tooltip, inline, group, confirm)
input.price(defval, title, tooltip, inline, group, confirm)
input.source(defval, title, tooltip, inline, group)
input.session(defval, title, options, tooltip, inline, group, confirm)
input.symbol(defval, title, tooltip, inline, group, confirm)
input.timeframe(defval, title, options, tooltip, inline, group, confirm)
input.text_area(defval, title, tooltip, group, confirm)
```

## Bar State Variables

```pinescript
bar_index  // Current bar index
barstate.isconfirmed  // Bar is confirmed
barstate.isfirst  // First bar
barstate.islast  // Last bar
barstate.ishistory  // Historical bar
barstate.isrealtime  // Real-time bar
barstate.isnew  // New bar started
barstate.islastconfirmedhistory  // Last historical bar
```

## Symbol Information

```pinescript
syminfo.basecurrency  // Base currency
syminfo.currency  // Currency
syminfo.description  // Description
syminfo.mintick  // Minimum tick
syminfo.pointvalue  // Point value
syminfo.prefix  // Exchange prefix
syminfo.root  // Root symbol
syminfo.session  // Session
syminfo.ticker  // Ticker
syminfo.tickerid  // Full ticker ID
syminfo.timezone  // Timezone
syminfo.type  // Symbol type
```

## Timeframe Variables

```pinescript
timeframe.isdaily  // Daily timeframe
timeframe.isdwm  // Daily, weekly, or monthly
timeframe.isintraday  // Intraday timeframe
timeframe.isminutes  // Minutes timeframe
timeframe.ismonthly  // Monthly timeframe
timeframe.isseconds  // Seconds timeframe
timeframe.isweekly  // Weekly timeframe
timeframe.multiplier  // Timeframe multiplier
timeframe.period  // Timeframe period string
```

## Display Constants

```pinescript
display.none  // Don't display
display.all  // Display everywhere
display.data_window  // Display in data window only
display.status_line  // Display in status line only
display.pane  // Display in pane only
```

## Location Constants

```pinescript
location.abovebar  // Above bar
location.belowbar  // Below bar
location.top  // Top of chart
location.bottom  // Bottom of chart
location.absolute  // Absolute position
```

## Plot Styles

```pinescript
plot.style_line  // Line
plot.style_stepline  // Step line
plot.style_stepline_diamond  // Step line with diamonds
plot.style_histogram  // Histogram
plot.style_cross  // Cross
plot.style_area  // Area
plot.style_areabr  // Area with breaks
plot.style_columns  // Columns
plot.style_circles  // Circles
plot.style_linebr  // Line with breaks
```

## Shape Styles

```pinescript
shape.xcross  // X cross
shape.cross  // + cross
shape.triangleup  // Triangle up
shape.triangledown  // Triangle down
shape.flag  // Flag
shape.circle  // Circle
shape.arrowup  // Arrow up
shape.arrowdown  // Arrow down
shape.labelup  // Label up
shape.labeldown  // Label down
shape.square  // Square
shape.diamond  // Diamond
```