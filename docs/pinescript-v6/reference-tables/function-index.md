# Pine Script v6 Complete Function Index

## Technical Analysis Functions (ta.*)

### Moving Averages
| Function | Description | Example |
|----------|-------------|---------|
| `ta.sma(source, length)` | Simple Moving Average | `ta.sma(close, 20)` |
| `ta.ema(source, length)` | Exponential Moving Average | `ta.ema(close, 12)` |
| `ta.wma(source, length)` | Weighted Moving Average | `ta.wma(close, 10)` |
| `ta.vwma(source, length)` | Volume Weighted Moving Average | `ta.vwma(close, 20)` |
| `ta.alma(source, length, offset, sigma)` | Arnaud Legoux Moving Average | `ta.alma(close, 14, 0.85, 6)` |
| `ta.hma(source, length)` | Hull Moving Average | `ta.hma(close, 16)` |
| `ta.rma(source, length)` | Rolling Moving Average (Wilder's) | `ta.rma(close, 14)` |
| `ta.swma(source)` | Symmetrically Weighted Moving Average | `ta.swma(close)` |

### Momentum Indicators
| Function | Description | Example |
|----------|-------------|---------|
| `ta.rsi(source, length)` | Relative Strength Index | `ta.rsi(close, 14)` |
| `ta.stoch(source, high, low, length)` | Stochastic %K | `ta.stoch(close, high, low, 14)` |
| `ta.macd(source, fastlen, slowlen, siglen)` | MACD [macd, signal, histogram] | `ta.macd(close, 12, 26, 9)` |
| `ta.cci(source, length)` | Commodity Channel Index | `ta.cci(hlc3, 20)` |
| `ta.wpr(length)` | Williams Percent Range | `ta.wpr(14)` |
| `ta.roc(source, length)` | Rate of Change | `ta.roc(close, 10)` |
| `ta.mom(source, length)` | Momentum | `ta.mom(close, 10)` |
| `ta.cmo(source, length)` | Chande Momentum Oscillator | `ta.cmo(close, 14)` |

### Volatility Indicators
| Function | Description | Example |
|----------|-------------|---------|
| `ta.atr(length)` | Average True Range | `ta.atr(14)` |
| `ta.tr()` | True Range | `ta.tr()` |
| `ta.bb(source, length, mult)` | Bollinger Bands [upper, basis, lower] | `ta.bb(close, 20, 2.0)` |
| `ta.kc(source, length, mult, use_true_range)` | Keltner Channels [upper, basis, lower] | `ta.kc(close, 20, 2.0, true)` |
| `ta.stdev(source, length, biased)` | Standard Deviation | `ta.stdev(close, 20, false)` |
| `ta.variance(source, length, biased)` | Variance | `ta.variance(close, 20, false)` |
| `ta.dev(source, length)` | Mean Deviation | `ta.dev(close, 20)` |

### Volume Indicators
| Function | Description | Example |
|----------|-------------|---------|
| `ta.obv` | On Balance Volume | `ta.obv` |
| `ta.pvt` | Price Volume Trend | `ta.pvt` |
| `ta.nvi` | Negative Volume Index | `ta.nvi` |
| `ta.pvi` | Positive Volume Index | `ta.pvi` |
| `ta.mfi(source, length)` | Money Flow Index | `ta.mfi(hlc3, 14)` |
| `ta.ad` | Accumulation/Distribution | `ta.ad` |
| `ta.adl` | Accumulation/Distribution Line | `ta.adl` |

### Directional Movement
| Function | Description | Example |
|----------|-------------|---------|
| `ta.adx(diplus, diminus, adxlen)` | Average Directional Index | `ta.adx(dip, dim, 14)` |
| `ta.dmi(high, low, close, length)` | DMI [diplus, diminus, adx] | `ta.dmi(high, low, close, 14)` |

### Support/Resistance
| Function | Description | Example |
|----------|-------------|---------|
| `ta.highest(source, length)` | Highest value over length bars | `ta.highest(high, 20)` |
| `ta.lowest(source, length)` | Lowest value over length bars | `ta.lowest(low, 20)` |
| `ta.highestbars(source, length)` | Bars since highest value | `ta.highestbars(high, 20)` |
| `ta.lowestbars(source, length)` | Bars since lowest value | `ta.lowestbars(low, 20)` |
| `ta.pivothigh(source, leftbars, rightbars)` | Pivot High | `ta.pivothigh(high, 5, 5)` |
| `ta.pivotlow(source, leftbars, rightbars)` | Pivot Low | `ta.pivotlow(low, 5, 5)` |

### Signal Detection
| Function | Description | Example |
|----------|-------------|---------|
| `ta.crossover(source1, source2)` | Source1 crosses over source2 | `ta.crossover(close, sma)` |
| `ta.crossunder(source1, source2)` | Source1 crosses under source2 | `ta.crossunder(close, sma)` |
| `ta.cross(source1, source2)` | Source1 crosses source2 (either way) | `ta.cross(close, sma)` |
| `ta.change(source, length)` | Difference from previous value | `ta.change(close, 1)` |
| `ta.rising(source, length)` | True if rising over length bars | `ta.rising(close, 3)` |
| `ta.falling(source, length)` | True if falling over length bars | `ta.falling(close, 3)` |

### Additional Technical Functions
| Function | Description | Example |
|----------|-------------|---------|
| `ta.linreg(source, length, offset)` | Linear Regression | `ta.linreg(close, 14, 0)` |
| `ta.pearsonr(source1, source2, length)` | Pearson Correlation | `ta.pearsonr(close, volume, 20)` |
| `ta.slope(source, length)` | Slope of Linear Regression | `ta.slope(close, 14)` |
| `ta.cum(source)` | Cumulative sum | `ta.cum(volume)` |
| `ta.median(source, length)` | Median value | `ta.median(close, 20)` |
| `ta.percentile_linear_interpolation(source, length, percentage)` | Percentile with linear interpolation | `ta.percentile_linear_interpolation(close, 20, 80)` |
| `ta.percentile_nearest_rank(source, length, percentage)` | Percentile with nearest rank | `ta.percentile_nearest_rank(close, 20, 80)` |
| `ta.fisher(source, length)` | Fisher Transform | `ta.fisher(hlc3, 10)` |
| `ta.supertrend(factor, atrPeriod)` | Supertrend [supertrend, direction] | `ta.supertrend(3.0, 10)` |

## Mathematical Functions (math.*)

### Basic Math
| Function | Description | Example |
|----------|-------------|---------|
| `math.abs(number)` | Absolute value | `math.abs(-5)` |
| `math.sign(number)` | Sign of number (-1, 0, 1) | `math.sign(-5)` |
| `math.max(num1, num2)` | Maximum of two numbers | `math.max(close, open)` |
| `math.min(num1, num2)` | Minimum of two numbers | `math.min(close, open)` |

### Rounding
| Function | Description | Example |
|----------|-------------|---------|
| `math.round(number, precision)` | Round to precision | `math.round(3.14159, 2)` |
| `math.floor(number)` | Round down | `math.floor(3.7)` |
| `math.ceil(number)` | Round up | `math.ceil(3.2)` |

### Power and Roots
| Function | Description | Example |
|----------|-------------|---------|
| `math.pow(base, exponent)` | Power function | `math.pow(2, 3)` |
| `math.sqrt(number)` | Square root | `math.sqrt(16)` |
| `math.exp(number)` | e raised to power | `math.exp(1)` |
| `math.log(number)` | Natural logarithm | `math.log(2.718)` |
| `math.log10(number)` | Base-10 logarithm | `math.log10(100)` |

### Trigonometric
| Function | Description | Example |
|----------|-------------|---------|
| `math.sin(radians)` | Sine | `math.sin(math.pi/2)` |
| `math.cos(radians)` | Cosine | `math.cos(0)` |
| `math.tan(radians)` | Tangent | `math.tan(math.pi/4)` |
| `math.asin(number)` | Arcsine | `math.asin(1)` |
| `math.acos(number)` | Arccosine | `math.acos(1)` |
| `math.atan(number)` | Arctangent | `math.atan(1)` |

### Constants
| Constant | Description | Value |
|----------|-------------|-------|
| `math.pi` | Pi constant | 3.14159... |
| `math.e` | Euler's number | 2.71828... |
| `math.phi` | Golden ratio | 1.61803... |

### Random
| Function | Description | Example |
|----------|-------------|---------|
| `math.random()` | Random between 0 and 1 | `math.random()` |
| `math.random(min, max)` | Random between min and max | `math.random(1, 10)` |

## String Functions (str.*)

### Basic String Operations
| Function | Description | Example |
|----------|-------------|---------|
| `str.length(string)` | Length of string | `str.length("hello")` |
| `str.tonumber(string)` | Convert string to number | `str.tonumber("123")` |
| `str.tostring(number, format)` | Convert number to string | `str.tostring(3.14, "#.##")` |
| `str.upper(string)` | Convert to uppercase | `str.upper("hello")` |
| `str.lower(string)` | Convert to lowercase | `str.lower("HELLO")` |

### String Manipulation
| Function | Description | Example |
|----------|-------------|---------|
| `str.substring(string, begin, end)` | Extract substring | `str.substring("hello", 0, 2)` |
| `str.replace(string, target, replacement)` | Replace text | `str.replace("hello", "l", "x")` |
| `str.replace_all(string, target, replacement)` | Replace all occurrences | `str.replace_all("hello", "l", "x")` |
| `str.split(string, separator)` | Split string into array | `str.split("a,b,c", ",")` |
| `str.trim(string)` | Remove whitespace | `str.trim(" hello ")` |

### String Searching
| Function | Description | Example |
|----------|-------------|---------|
| `str.contains(string, substring)` | Check if contains | `str.contains("hello", "ell")` |
| `str.startswith(string, substring)` | Check if starts with | `str.startswith("hello", "he")` |
| `str.endswith(string, substring)` | Check if ends with | `str.endswith("hello", "lo")` |
| `str.pos(string, substring)` | Find position | `str.pos("hello", "l")` |

### String Formatting
| Function | Description | Example |
|----------|-------------|---------|
| `str.format(format, arguments...)` | Format string | `str.format("Price: {0}", close)` |

## Array Functions (array.*)

### Array Creation
| Function | Description | Example |
|----------|-------------|---------|
| `array.new<type>(size, initial_value)` | Create new array | `array.new<float>(0)` |
| `array.from(element1, element2, ...)` | Create from elements | `array.from(1, 2, 3)` |
| `array.copy(array_id)` | Copy array | `array.copy(myArray)` |

### Array Information
| Function | Description | Example |
|----------|-------------|---------|
| `array.size(array_id)` | Get array size | `array.size(myArray)` |

### Adding Elements
| Function | Description | Example |
|----------|-------------|---------|
| `array.push(array_id, value)` | Add to end | `array.push(myArray, close)` |
| `array.unshift(array_id, value)` | Add to beginning | `array.unshift(myArray, close)` |
| `array.insert(array_id, index, value)` | Insert at index | `array.insert(myArray, 0, close)` |

### Removing Elements
| Function | Description | Example |
|----------|-------------|---------|
| `array.pop(array_id)` | Remove from end | `array.pop(myArray)` |
| `array.shift(array_id)` | Remove from beginning | `array.shift(myArray)` |
| `array.remove(array_id, index)` | Remove at index | `array.remove(myArray, 0)` |
| `array.clear(array_id)` | Remove all elements | `array.clear(myArray)` |

### Accessing Elements
| Function | Description | Example |
|----------|-------------|---------|
| `array.get(array_id, index)` | Get element at index | `array.get(myArray, 0)` |
| `array.set(array_id, index, value)` | Set element at index | `array.set(myArray, 0, close)` |
| `array.first(array_id)` | Get first element | `array.first(myArray)` |
| `array.last(array_id)` | Get last element | `array.last(myArray)` |

### Array Operations
| Function | Description | Example |
|----------|-------------|---------|
| `array.sum(array_id)` | Sum of all elements | `array.sum(myArray)` |
| `array.avg(array_id)` | Average of elements | `array.avg(myArray)` |
| `array.min(array_id)` | Minimum element | `array.min(myArray)` |
| `array.max(array_id)` | Maximum element | `array.max(myArray)` |
| `array.stdev(array_id)` | Standard deviation | `array.stdev(myArray)` |
| `array.variance(array_id)` | Variance | `array.variance(myArray)` |
| `array.median(array_id)` | Median value | `array.median(myArray)` |
| `array.mode(array_id)` | Most frequent value | `array.mode(myArray)` |
| `array.range(array_id)` | Range (max - min) | `array.range(myArray)` |

### Array Searching
| Function | Description | Example |
|----------|-------------|---------|
| `array.includes(array_id, value)` | Check if contains value | `array.includes(myArray, close)` |
| `array.indexof(array_id, value)` | Find index of value | `array.indexof(myArray, close)` |
| `array.lastindexof(array_id, value)` | Find last index of value | `array.lastindexof(myArray, close)` |

### Array Sorting
| Function | Description | Example |
|----------|-------------|---------|
| `array.sort(array_id, order)` | Sort array | `array.sort(myArray, order.ascending)` |
| `array.reverse(array_id)` | Reverse array | `array.reverse(myArray)` |

### Array Transformation
| Function | Description | Example |
|----------|-------------|---------|
| `array.slice(array_id, index_from, index_to)` | Get slice of array | `array.slice(myArray, 0, 5)` |
| `array.concat(array_id1, array_id2)` | Concatenate arrays | `array.concat(array1, array2)` |
| `array.join(array_id, separator)` | Join elements to string | `array.join(myArray, ",")` |

## Matrix Functions (matrix.*)

### Matrix Creation
| Function | Description | Example |
|----------|-------------|---------|
| `matrix.new<type>(rows, columns, initial_value)` | Create new matrix | `matrix.new<float>(3, 3, 0.0)` |
| `matrix.copy(matrix_id)` | Copy matrix | `matrix.copy(myMatrix)` |

### Matrix Information
| Function | Description | Example |
|----------|-------------|---------|
| `matrix.rows(matrix_id)` | Number of rows | `matrix.rows(myMatrix)` |
| `matrix.columns(matrix_id)` | Number of columns | `matrix.columns(myMatrix)` |

### Matrix Element Access
| Function | Description | Example |
|----------|-------------|---------|
| `matrix.get(matrix_id, row, column)` | Get element | `matrix.get(myMatrix, 0, 0)` |
| `matrix.set(matrix_id, row, column, value)` | Set element | `matrix.set(myMatrix, 0, 0, close)` |

### Matrix Operations
| Function | Description | Example |
|----------|-------------|---------|
| `matrix.add(matrix_id1, matrix_id2)` | Add matrices | `matrix.add(m1, m2)` |
| `matrix.sub(matrix_id1, matrix_id2)` | Subtract matrices | `matrix.sub(m1, m2)` |
| `matrix.mult(matrix_id1, matrix_id2)` | Multiply matrices | `matrix.mult(m1, m2)` |
| `matrix.transpose(matrix_id)` | Transpose matrix | `matrix.transpose(myMatrix)` |
| `matrix.det(matrix_id)` | Determinant | `matrix.det(myMatrix)` |
| `matrix.inv(matrix_id)` | Inverse matrix | `matrix.inv(myMatrix)` |

### Row/Column Operations
| Function | Description | Example |
|----------|-------------|---------|
| `matrix.row(matrix_id, row)` | Get row as array | `matrix.row(myMatrix, 0)` |
| `matrix.col(matrix_id, column)` | Get column as array | `matrix.col(myMatrix, 0)` |
| `matrix.add_row(matrix_id, row, array_id)` | Add row | `matrix.add_row(myMatrix, 0, myArray)` |
| `matrix.add_col(matrix_id, column, array_id)` | Add column | `matrix.add_col(myMatrix, 0, myArray)` |
| `matrix.remove_row(matrix_id, row)` | Remove row | `matrix.remove_row(myMatrix, 0)` |
| `matrix.remove_col(matrix_id, column)` | Remove column | `matrix.remove_col(myMatrix, 0)` |

## Map Functions (map.*)

### Map Creation
| Function | Description | Example |
|----------|-------------|---------|
| `map.new<keyType, valueType>()` | Create new map | `map.new<string, float>()` |
| `map.copy(map_id)` | Copy map | `map.copy(myMap)` |

### Map Information
| Function | Description | Example |
|----------|-------------|---------|
| `map.size(map_id)` | Number of key-value pairs | `map.size(myMap)` |

### Map Operations
| Function | Description | Example |
|----------|-------------|---------|
| `map.put(map_id, key, value)` | Set key-value pair | `map.put(myMap, "price", close)` |
| `map.get(map_id, key)` | Get value by key | `map.get(myMap, "price")` |
| `map.remove(map_id, key)` | Remove key-value pair | `map.remove(myMap, "price")` |
| `map.clear(map_id)` | Remove all pairs | `map.clear(myMap)` |
| `map.contains(map_id, key)` | Check if key exists | `map.contains(myMap, "price")` |

### Map Iteration
| Function | Description | Example |
|----------|-------------|---------|
| `map.keys(map_id)` | Get all keys as array | `map.keys(myMap)` |
| `map.values(map_id)` | Get all values as array | `map.values(myMap)` |

## Request Functions (request.*)

### Security Data
| Function | Description | Example |
|----------|-------------|---------|
| `request.security(symbol, timeframe, expression, gaps, lookahead, ignore_invalid_symbol, currency)` | Get data from other symbol/timeframe | `request.security("AAPL", "1D", close)` |
| `request.security_lower_tf(symbol, timeframe, expression, ignore_invalid_symbol, currency, ignore_invalid_timeframe)` | Get lower timeframe data | `request.security_lower_tf(syminfo.tickerid, "1m", close)` |

### Economic Data
| Function | Description | Example |
|----------|-------------|---------|
| `request.economic(country_code, field, gaps, ignore_invalid_symbol)` | Get economic data | `request.economic("US", "GDP", barmerge.gaps_off)` |

### Financial Data
| Function | Description | Example |
|----------|-------------|---------|
| `request.financial(symbol, financial_id, period, gaps, ignore_invalid_symbol, currency)` | Get financial data | `request.financial(syminfo.tickerid, "TOTAL_REVENUE", "FY")` |

### Dividend Data
| Function | Description | Example |
|----------|-------------|---------|
| `request.dividends(symbol, field, gaps, lookahead, ignore_invalid_symbol, currency)` | Get dividend data | `request.dividends(syminfo.tickerid, dividends.gross, barmerge.gaps_off)` |

### Split Data
| Function | Description | Example |
|----------|-------------|---------|
| `request.splits(symbol, field, gaps, lookahead, ignore_invalid_symbol)` | Get split data | `request.splits(syminfo.tickerid, splits.numerator, barmerge.gaps_off)` |

### Earnings Data
| Function | Description | Example |
|----------|-------------|---------|
| `request.earnings(symbol, field, gaps, lookahead, ignore_invalid_symbol, currency)` | Get earnings data | `request.earnings(syminfo.tickerid, earnings.actual, barmerge.gaps_off)` |

## Strategy Functions (strategy.*)

### Position Information
| Function | Description | Example |
|----------|-------------|---------|
| `strategy.position_size` | Current position size | `strategy.position_size` |
| `strategy.position_avg_price` | Average entry price | `strategy.position_avg_price` |
| `strategy.equity` | Current equity | `strategy.equity` |
| `strategy.initial_capital` | Starting capital | `strategy.initial_capital` |
| `strategy.openprofit` | Unrealized P&L | `strategy.openprofit` |
| `strategy.closedtrades` | Number of closed trades | `strategy.closedtrades` |
| `strategy.opentrades` | Number of open trades | `strategy.opentrades` |

### Performance Metrics
| Function | Description | Example |
|----------|-------------|---------|
| `strategy.netprofit` | Net profit | `strategy.netprofit` |
| `strategy.grossprofit` | Gross profit | `strategy.grossprofit` |
| `strategy.grossloss` | Gross loss | `strategy.grossloss` |
| `strategy.wintrades` | Number of winning trades | `strategy.wintrades` |
| `strategy.losstrades` | Number of losing trades | `strategy.losstrades` |
| `strategy.max_drawdown` | Maximum drawdown | `strategy.max_drawdown` |

### Trade Functions
| Function | Description | Example |
|----------|-------------|---------|
| `strategy.entry(id, direction, qty, limit, stop, oca_name, oca_type, comment, when, alert_message)` | Enter position | `strategy.entry("Long", strategy.long)` |
| `strategy.exit(id, from_entry, qty, qty_percent, profit, loss, trail_price, trail_points, trail_offset, limit, stop, oca_name, comment, when, alert_message)` | Exit position | `strategy.exit("Exit", "Long", stop=low*0.95)` |
| `strategy.close(id, when, qty, qty_percent, comment, alert_message, immediately)` | Close position | `strategy.close("Long", when=exitCondition)` |
| `strategy.close_all(when, comment, alert_message, immediately)` | Close all positions | `strategy.close_all(when=exitCondition)` |
| `strategy.cancel(id, when)` | Cancel order | `strategy.cancel("Long", when=cancelCondition)` |
| `strategy.cancel_all(when)` | Cancel all orders | `strategy.cancel_all(when=cancelCondition)` |

### Order Types
| Function | Description | Example |
|----------|-------------|---------|
| `strategy.order(id, direction, qty, limit, stop, oca_name, oca_type, comment, when, alert_message)` | Place order | `strategy.order("Buy", strategy.long, qty=100)` |

## Indicator Functions (indicator.*)

### Indicator Declaration
| Function | Description | Example |
|----------|-------------|---------|
| `indicator(title, shorttitle, overlay, format, precision, scale, max_bars_back, timeframe, timeframe_gaps, explicit_plot_zorder)` | Declare indicator | `indicator("My Indicator", overlay=true)` |

## Plot Functions

### Basic Plotting
| Function | Description | Example |
|----------|-------------|---------|
| `plot(series, title, color, linewidth, style, trackprice, histbase, offset, join, editable, show_last, display)` | Plot line | `plot(close, color=color.blue)` |
| `plotshape(series, title, style, location, color, textcolor, text, tooltip, size, editable, show_last, display)` | Plot shape | `plotshape(buySignal, style=shape.triangleup)` |
| `plotchar(series, title, char, location, color, textcolor, text, tooltip, size, editable, show_last, display)` | Plot character | `plotchar(sellSignal, char="S")` |
| `plotarrow(series, title, colorup, colordown, offset, minheight, maxheight, editable, show_last, display)` | Plot arrow | `plotarrow(momentum)` |

### Candle Plotting
| Function | Description | Example |
|----------|-------------|---------|
| `plotcandle(open, high, low, close, title, color, wickcolor, editable, show_last, bordercolor, display)` | Plot candlestick | `plotcandle(o, h, l, c)` |
| `plotbar(open, high, low, close, title, color, editable, show_last, display)` | Plot OHLC bar | `plotbar(o, h, l, c)` |

### Background and Fill
| Function | Description | Example |
|----------|-------------|---------|
| `bgcolor(color, offset, editable, show_last, title, display)` | Background color | `bgcolor(color.red)` |
| `fill(plot1, plot2, color, title, editable, show_last, fillgaps, display)` | Fill between plots | `fill(plot1, plot2, color.blue)` |

### Horizontal Lines
| Function | Description | Example |
|----------|-------------|---------|
| `hline(price, title, color, linestyle, linewidth, editable, display)` | Horizontal line | `hline(50, "Midline")` |

## Drawing Functions

### Lines
| Function | Description | Example |
|----------|-------------|---------|
| `line.new(x1, y1, x2, y2, extend, color, style, width, xloc)` | Create line | `line.new(bar_index, high, bar_index+10, low)` |
| `line.delete(line_id)` | Delete line | `line.delete(myLine)` |
| `line.get_x1(line_id)` | Get x1 coordinate | `line.get_x1(myLine)` |
| `line.get_y1(line_id)` | Get y1 coordinate | `line.get_y1(myLine)` |
| `line.set_x1(line_id, x)` | Set x1 coordinate | `line.set_x1(myLine, bar_index)` |
| `line.set_y1(line_id, y)` | Set y1 coordinate | `line.set_y1(myLine, high)` |
| `line.set_extend(line_id, extend)` | Set extend property | `line.set_extend(myLine, extend.right)` |
| `line.set_color(line_id, color)` | Set line color | `line.set_color(myLine, color.red)` |

### Labels
| Function | Description | Example |
|----------|-------------|---------|
| `label.new(x, y, text, xloc, yloc, color, style, textcolor, size, textalign, tooltip)` | Create label | `label.new(bar_index, high, "High")` |
| `label.delete(label_id)` | Delete label | `label.delete(myLabel)` |
| `label.get_x(label_id)` | Get x coordinate | `label.get_x(myLabel)` |
| `label.get_y(label_id)` | Get y coordinate | `label.get_y(myLabel)` |
| `label.set_x(label_id, x)` | Set x coordinate | `label.set_x(myLabel, bar_index)` |
| `label.set_y(label_id, y)` | Set y coordinate | `label.set_y(myLabel, high)` |
| `label.set_text(label_id, text)` | Set label text | `label.set_text(myLabel, "New Text")` |
| `label.set_color(label_id, color)` | Set label color | `label.set_color(myLabel, color.red)` |

### Boxes
| Function | Description | Example |
|----------|-------------|---------|
| `box.new(left, top, right, bottom, border_color, border_style, border_width, bgcolor, extend, xloc)` | Create box | `box.new(bar_index, high, bar_index+10, low)` |
| `box.delete(box_id)` | Delete box | `box.delete(myBox)` |
| `box.get_left(box_id)` | Get left coordinate | `box.get_left(myBox)` |
| `box.get_top(box_id)` | Get top coordinate | `box.get_top(myBox)` |
| `box.set_left(box_id, left)` | Set left coordinate | `box.set_left(myBox, bar_index)` |
| `box.set_top(box_id, top)` | Set top coordinate | `box.set_top(myBox, high)` |
| `box.set_bgcolor(box_id, color)` | Set background color | `box.set_bgcolor(myBox, color.blue)` |

### Polylines
| Function | Description | Example |
|----------|-------------|---------|
| `polyline.new(points, line_color, line_style, line_width)` | Create polyline | `polyline.new(array.from(point1, point2))` |
| `polyline.delete(polyline_id)` | Delete polyline | `polyline.delete(myPolyline)` |

### Tables
| Function | Description | Example |
|----------|-------------|---------|
| `table.new(position, columns, rows, bgcolor, border_color, border_width, frame_color, frame_width)` | Create table | `table.new(position.top_right, 2, 3)` |
| `table.cell(table_id, column, row, text, width, height, text_color, text_size, bgcolor)` | Set table cell | `table.cell(myTable, 0, 0, "Price")` |
| `table.delete(table_id)` | Delete table | `table.delete(myTable)` |

## Alert Functions

### Alert Management
| Function | Description | Example |
|----------|-------------|---------|
| `alert(message, freq)` | Send alert | `alert("Buy Signal", alert.freq_once_per_bar)` |
| `alertcondition(condition, title, message)` | Create alert condition | `alertcondition(buySignal, "Buy", "Buy signal triggered")` |

## Input Functions

### User Inputs
| Function | Description | Example |
|----------|-------------|---------|
| `input.int(defval, title, minval, maxval, step, tooltip, inline, group, confirm)` | Integer input | `input.int(14, "Length", minval=1)` |
| `input.float(defval, title, minval, maxval, step, tooltip, inline, group, confirm)` | Float input | `input.float(2.0, "Multiplier")` |
| `input.bool(defval, title, tooltip, inline, group, confirm)` | Boolean input | `input.bool(true, "Show MA")` |
| `input.string(defval, title, options, tooltip, inline, group, confirm)` | String input | `input.string("SMA", "MA Type", options=["SMA", "EMA"])` |
| `input.color(defval, title, tooltip, inline, group, confirm)` | Color input | `input.color(color.blue, "Line Color")` |
| `input.source(defval, title, tooltip, inline, group, confirm)` | Source input | `input.source(close, "Source")` |
| `input.timeframe(defval, title, tooltip, inline, group, confirm)` | Timeframe input | `input.timeframe("1D", "Timeframe")` |
| `input.session(defval, title, tooltip, inline, group, confirm)` | Session input | `input.session("0930-1600", "Session")` |
| `input.symbol(defval, title, tooltip, inline, group, confirm)` | Symbol input | `input.symbol("AAPL", "Symbol")` |
| `input.text_area(defval, title, tooltip, confirm)` | Text area input | `input.text_area("Notes", "Comments")` |
| `input.table_cell(defval, title, tooltip, inline, group, confirm)` | Table cell input | `input.table_cell("", "Cell Content")` |

## Timeframe Functions (timeframe.*)

### Timeframe Information
| Function | Description | Example |
|----------|-------------|---------|
| `timeframe.period` | Current timeframe | `timeframe.period` |
| `timeframe.multiplier` | Timeframe multiplier | `timeframe.multiplier` |
| `timeframe.isseconds` | Is seconds timeframe | `timeframe.isseconds` |
| `timeframe.isminutes` | Is minutes timeframe | `timeframe.isminutes` |
| `timeframe.ishours` | Is hours timeframe | `timeframe.ishours` |
| `timeframe.isdaily` | Is daily timeframe | `timeframe.isdaily` |
| `timeframe.isweekly` | Is weekly timeframe | `timeframe.isweekly` |
| `timeframe.ismonthly` | Is monthly timeframe | `timeframe.ismonthly` |
| `timeframe.isdwm` | Is daily, weekly, or monthly | `timeframe.isdwm` |
| `timeframe.isintraday` | Is intraday timeframe | `timeframe.isintraday` |

## Symbol Information (syminfo.*)

### Symbol Properties
| Function | Description | Example |
|----------|-------------|---------|
| `syminfo.ticker` | Symbol ticker | `syminfo.ticker` |
| `syminfo.tickerid` | Full symbol ID | `syminfo.tickerid` |
| `syminfo.prefix` | Exchange prefix | `syminfo.prefix` |
| `syminfo.root` | Root symbol | `syminfo.root` |
| `syminfo.currency` | Symbol currency | `syminfo.currency` |
| `syminfo.description` | Symbol description | `syminfo.description` |
| `syminfo.type` | Instrument type | `syminfo.type` |
| `syminfo.timezone` | Symbol timezone | `syminfo.timezone` |
| `syminfo.session` | Trading session | `syminfo.session` |
| `syminfo.mintick` | Minimum tick size | `syminfo.mintick` |
| `syminfo.pointvalue` | Point value | `syminfo.pointvalue` |

## Runtime Functions (runtime.*)

### Runtime Information
| Function | Description | Example |
|----------|-------------|---------|
| `runtime.error(message)` | Throw runtime error | `runtime.error("Invalid input")` |

## Currency Functions (currency.*)

### Currency Conversion
| Function | Description | Example |
|----------|-------------|---------|
| `currency.convert(value, from_currency, to_currency)` | Convert currency | `currency.convert(100, currency.USD, currency.EUR)` |

This comprehensive function index covers all major Pine Script v6 built-in functions organized by namespace. Use this as a reference when developing indicators and strategies to quickly find the functions you need for specific tasks.