# Pine Script v6 Request Functions

## Overview

The `request.*` namespace provides functions for fetching data from different timeframes, symbols, and external sources. These functions are essential for multi-timeframe analysis, symbol comparison, and accessing fundamental/economic data.

## Performance Considerations

- **Security Call Limit**: Maximum 40 `request.security()` calls per script
- **Execution Context**: Request functions execute in their own context
- **Memory Usage**: Lower timeframe requests return arrays, consume more memory
- **Calculation Priority**: Security calls execute before main script logic

---

## request.security()

**Multi-timeframe and multi-symbol data access**

### Syntax
```pinescript
request.security(symbol, timeframe, expression, lookahead, gaps, ignore_invalid_symbol) → series<type>
```

### Parameters
- **symbol** (simple string): Symbol identifier (e.g., "NASDAQ:AAPL", "BINANCE:BTCUSDT")
- **timeframe** (simple string): Timeframe specification (e.g., "1D", "4H", "15")
- **expression**: Expression to evaluate in the security context
- **lookahead** (barmerge_lookahead): `barmerge.lookahead_off` (default) or `barmerge.lookahead_on`
- **gaps** (barmerge_gaps): `barmerge.gaps_off` (default) or `barmerge.gaps_on`
- **ignore_invalid_symbol** (simple bool): Whether to ignore invalid symbols (default: false)

### Lookahead Parameter

**barmerge.lookahead_off (Recommended)**
- Uses only confirmed/closed bar data
- Prevents repainting in real-time
- Historical and real-time behavior consistent

**barmerge.lookahead_on (Use with caution)**
- Uses real-time data including current bar
- Can cause repainting
- Historical vs real-time behavior differs

### Gaps Parameter

**barmerge.gaps_off (Default)**
- Missing data filled with previous value
- Continuous data series

**barmerge.gaps_on**
- Missing data returns `na`
- Preserves actual data gaps

### Expression Evaluation

The expression is evaluated in the security's context with its own:
- OHLCV data
- Time values
- Bar index

```pinescript
// Simple OHLC access
higher_tf_close = request.security(syminfo.tickerid, "1D", close)

// Complex expression
higher_tf_sma = request.security(syminfo.tickerid, "1D", ta.sma(close, 20))

// Multiple values using tuple
[htf_high, htf_low] = request.security(syminfo.tickerid, "4H", [high, low])
```

### Avoiding Repainting

**Problem**: Using real-time data that changes during bar formation

**Solution**: Use confirmed data only
```pinescript
// WRONG - Repaints
htf_close_repainting = request.security(syminfo.tickerid, "1D", close)

// CORRECT - No repainting
htf_close_confirmed = request.security(syminfo.tickerid, "1D", close[1])

// ALTERNATIVE - Use lookahead_off explicitly
htf_close_safe = request.security(syminfo.tickerid, "1D", close, lookahead=barmerge.lookahead_off)
```

### Common Patterns

**Higher Timeframe Analysis**
```pinescript
//@version=6
indicator("HTF Analysis", overlay=true)

// Daily levels on intraday chart
daily_high = request.security(syminfo.tickerid, "1D", high[1])
daily_low = request.security(syminfo.tickerid, "1D", low[1])
daily_open = request.security(syminfo.tickerid, "1D", open)

plot(daily_high, "Daily High", color.red, linewidth=2)
plot(daily_low, "Daily Low", color.green, linewidth=2)
plot(daily_open, "Daily Open", color.blue, linewidth=2)
```

**Multiple Symbol Comparison**
```pinescript
//@version=6
indicator("Symbol Comparison")

// Compare current symbol with SPY
spy_close = request.security("AMEX:SPY", timeframe.period, close)
current_close = close

// Relative strength
relative_strength = (current_close / current_close[252]) / (spy_close / spy_close[252])
plot(relative_strength, "Relative Strength vs SPY")
```

**Custom Calculations**
```pinescript
//@version=6
indicator("HTF Custom Calculation")

// Higher timeframe RSI
htf_rsi = request.security(syminfo.tickerid, "1D", ta.rsi(close, 14))
plot(htf_rsi, "Daily RSI")

// Higher timeframe volatility
htf_volatility = request.security(syminfo.tickerid, "1D", 
     ta.stdev(math.log(close / close[1]) * 100, 20))
plot(htf_volatility, "Daily Volatility")
```

---

## request.security_lower_tf()

**Access lower timeframe data within higher timeframe bars**

### Syntax
```pinescript
request.security_lower_tf(symbol, timeframe, expression, ignore_invalid_symbol) → array<type>
```

### Parameters
- **symbol** (simple string): Symbol identifier
- **timeframe** (simple string): Lower timeframe (must be < current timeframe)
- **expression**: Expression to evaluate
- **ignore_invalid_symbol** (simple bool): Ignore invalid symbols

### Return Value
Returns an array containing all values from the lower timeframe within the current bar.

### Use Cases

**Intrabar Analysis**
```pinescript
//@version=6
indicator("Intrabar Analysis", overlay=true)

if timeframe.in_seconds() >= 3600 // Only on 1H or higher
    // Get 15-minute closes within current bar
    ltf_closes = request.security_lower_tf(syminfo.tickerid, "15", close)
    
    if array.size(ltf_closes) > 0
        // Intrabar high/low
        intrabar_high = array.max(ltf_closes)
        intrabar_low = array.min(ltf_closes)
        
        // Plot levels
        plot(intrabar_high, "Intrabar High", color.red)
        plot(intrabar_low, "Intrabar Low", color.green)
```

**Volume Profile**
```pinescript
//@version=6
indicator("Lower TF Volume Profile")

// Get 1-minute volume and close data
ltf_volume = request.security_lower_tf(syminfo.tickerid, "1", volume)
ltf_close = request.security_lower_tf(syminfo.tickerid, "1", close)

// Calculate volume-weighted average price
if array.size(ltf_volume) > 0 and array.size(ltf_close) > 0
    total_volume = array.sum(ltf_volume)
    vwap_sum = 0.0
    
    for i = 0 to array.size(ltf_volume) - 1
        vwap_sum := vwap_sum + (array.get(ltf_close, i) * array.get(ltf_volume, i))
    
    ltf_vwap = vwap_sum / total_volume
    plot(ltf_vwap, "Lower TF VWAP", color.orange)
```

### Limitations
- Only works with lower timeframes
- Limited by available historical intrabar data
- Higher memory usage with large arrays

---

## request.dividends()

**Access dividend payment data**

### Syntax
```pinescript
request.dividends(symbol, field, lookahead, ignore_invalid_symbol, currency) → series<float>
```

### Parameters
- **symbol** (simple string): Symbol identifier
- **field**: `dividends.ex_date`, `dividends.amount`, or `dividends.pay_date`
- **lookahead** (barmerge_lookahead): Lookahead setting
- **ignore_invalid_symbol** (simple bool): Ignore invalid symbols
- **currency** (simple string): Currency for amount conversion

### Example
```pinescript
//@version=6
indicator("Dividend Analysis", overlay=true)

// Get dividend information
div_amount = request.dividends(syminfo.tickerid, dividends.amount)
div_ex_date = request.dividends(syminfo.tickerid, dividends.ex_date)

// Mark ex-dividend dates
bgcolor(not na(div_ex_date) ? color.new(color.blue, 80) : na, title="Ex-Dividend Date")

// Display dividend amount
if not na(div_amount)
    label.new(bar_index, high, text="Div: $" + str.tostring(div_amount, "#.##"), 
              style=label.style_label_down, color=color.blue, textcolor=color.white)
```

---

## request.splits()

**Access stock split data**

### Syntax
```pinescript
request.splits(symbol, field, lookahead, ignore_invalid_symbol) → series<float>
```

### Parameters
- **symbol** (simple string): Symbol identifier
- **field**: `splits.date` or `splits.ratio`
- **lookahead** (barmerge_lookahead): Lookahead setting
- **ignore_invalid_symbol** (simple bool): Ignore invalid symbols

### Example
```pinescript
//@version=6
indicator("Stock Splits", overlay=true)

// Get split information
split_ratio = request.splits(syminfo.tickerid, splits.ratio)
split_date = request.splits(syminfo.tickerid, splits.date)

// Mark split dates
if not na(split_date)
    label.new(bar_index, high, text="Split: " + str.tostring(split_ratio, "#.##") + ":1",
              style=label.style_label_down, color=color.red, textcolor=color.white)
```

---

## request.earnings()

**Access earnings announcement data**

### Syntax
```pinescript
request.earnings(symbol, field, lookahead, ignore_invalid_symbol, currency) → series<float>
```

### Parameters
- **symbol** (simple string): Symbol identifier
- **field**: Various earnings fields (e.g., `earnings.actual`, `earnings.estimate`)
- **lookahead** (barmerge_lookahead): Lookahead setting
- **ignore_invalid_symbol** (simple bool): Ignore invalid symbols
- **currency** (simple string): Currency for conversion

### Example
```pinescript
//@version=6
indicator("Earnings Events", overlay=true)

// Get earnings data
earnings_actual = request.earnings(syminfo.tickerid, earnings.actual)
earnings_estimate = request.earnings(syminfo.tickerid, earnings.estimate)

// Mark earnings dates
earnings_surprise = earnings_actual - earnings_estimate
if not na(earnings_actual)
    surprise_color = earnings_surprise > 0 ? color.green : color.red
    label.new(bar_index, high, text="EPS: " + str.tostring(earnings_actual, "#.##"),
              color=surprise_color, textcolor=color.white)
```

---

## request.financial()

**Access financial statement data**

### Syntax
```pinescript
request.financial(symbol, financial_id, period, lookahead, ignore_invalid_symbol, currency) → series<float>
```

### Parameters
- **symbol** (simple string): Symbol identifier
- **financial_id** (simple string): Financial metric identifier
- **period**: Reporting period (e.g., `financial.period.annual`, `financial.period.quarterly`)
- **lookahead** (barmerge_lookahead): Lookahead setting
- **ignore_invalid_symbol** (simple bool): Ignore invalid symbols
- **currency** (simple string): Currency for conversion

### Common Financial IDs
- `"TOTAL_REVENUE"`: Total revenue
- `"NET_INCOME"`: Net income
- `"TOTAL_DEBT"`: Total debt
- `"CASH_N_SHORT_TERM_INVEST"`: Cash and short-term investments
- `"SHAREHOLDERS_EQUITY"`: Shareholders' equity

### Example
```pinescript
//@version=6
indicator("Financial Ratios")

// Get financial data
revenue = request.financial(syminfo.tickerid, "TOTAL_REVENUE", financial.period.annual)
net_income = request.financial(syminfo.tickerid, "NET_INCOME", financial.period.annual)

// Calculate profit margin
profit_margin = net_income / revenue * 100
plot(profit_margin, "Profit Margin %", color.blue)
```

---

## request.economic()

**Access economic indicator data**

### Syntax
```pinescript
request.economic(country_code, field, lookahead, ignore_invalid_symbol) → series<float>
```

### Parameters
- **country_code** (simple string): Country code (e.g., "US", "EU", "CN")
- **field** (simple string): Economic indicator identifier
- **lookahead** (barmerge_lookahead): Lookahead setting
- **ignore_invalid_symbol** (simple bool): Ignore invalid symbols

### Common Economic Fields
- `"GDP"`: Gross Domestic Product
- `"INFLATION"`: Inflation rate
- `"UNEMPLOYMENT"`: Unemployment rate
- `"INTEREST_RATE"`: Interest rate

### Example
```pinescript
//@version=6
indicator("Economic Data")

// Get US economic data
us_gdp = request.economic("US", "GDP")
us_inflation = request.economic("US", "INFLATION")
us_unemployment = request.economic("US", "UNEMPLOYMENT")

plot(us_gdp, "US GDP", color.blue)
plot(us_inflation, "US Inflation", color.red)
plot(us_unemployment, "US Unemployment", color.orange)
```

---

## request.seed()

**Set random seed for reproducible results**

### Syntax
```pinescript
request.seed(seed) → void
```

### Parameters
- **seed** (simple int): Seed value for random number generation

### Example
```pinescript
//@version=6
indicator("Random with Seed")

// Set seed for reproducible random numbers
request.seed(12345)

// Generate random values
random_value = math.random(0, 100)
plot(random_value, "Random Value")
```

---

## Error Handling

### Common Errors and Solutions

**1. Security Call Limit Exceeded**
```pinescript
// Problem: Too many security calls
// Solution: Combine calls or use conditional logic

// WRONG - Multiple calls
htf_high = request.security(syminfo.tickerid, "1D", high)
htf_low = request.security(syminfo.tickerid, "1D", low)
htf_close = request.security(syminfo.tickerid, "1D", close)

// CORRECT - Single call with tuple
[htf_high, htf_low, htf_close] = request.security(syminfo.tickerid, "1D", [high, low, close])
```

**2. Invalid Timeframe**
```pinescript
// Validate timeframe before use
is_valid_tf = timeframe.in_seconds("4H") > timeframe.in_seconds()
htf_data = is_valid_tf ? request.security(syminfo.tickerid, "4H", close) : close
```

**3. Symbol Not Found**
```pinescript
// Use ignore_invalid_symbol parameter
safe_data = request.security("INVALID:SYMBOL", "1D", close, ignore_invalid_symbol=true)
```

### Best Practices

1. **Minimize Security Calls**: Use tuples to fetch multiple values in one call
2. **Avoid Repainting**: Use confirmed data (`close[1]`) or `lookahead_off`
3. **Handle NA Values**: Always check for `na` values in results
4. **Optimize Performance**: Cache results when possible
5. **Validate Inputs**: Check timeframe and symbol validity
6. **Use Appropriate Gaps Setting**: Choose based on data analysis needs

### Performance Optimization

```pinescript
//@version=6
indicator("Optimized Security Calls")

// Cache frequently used values
var float cached_daily_high = na
var float cached_daily_low = na

// Update only on new day
if dayofweek != dayofweek[1]
    [new_high, new_low] = request.security(syminfo.tickerid, "1D", [high[1], low[1]])
    cached_daily_high := new_high
    cached_daily_low := new_low

// Use cached values
plot(cached_daily_high, "Daily High", color.red)
plot(cached_daily_low, "Daily Low", color.green)
```

---

## Summary

Request functions are powerful tools for multi-timeframe analysis and external data access. Key points:

- Use `request.security()` for different timeframes and symbols
- Use `request.security_lower_tf()` for intrabar analysis
- Access fundamental data with `request.dividends()`, `request.splits()`, `request.earnings()`, `request.financial()`
- Get economic indicators with `request.economic()`
- Set random seeds with `request.seed()`
- Always consider repainting implications
- Optimize for performance and stay within limits
- Handle errors and invalid data appropriately

These functions enable sophisticated analysis combining technical indicators with fundamental and economic data across multiple timeframes and instruments.