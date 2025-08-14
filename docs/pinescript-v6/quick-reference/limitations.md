# Pine Script v6 Limitations and Constraints

## Historical Data Limitations

### Maximum Bars Lookback
- **Limit**: 500 bars maximum for historical reference
- **Impact**: `close[500]` is the furthest you can look back
- **Workaround**: Use arrays to store more historical data
```pine
// This will cause an error if trying to access more than 500 bars back
tooFarBack = close[501]  // ERROR!

// Use arrays for longer history
var array<float> priceHistory = array.new<float>()
if array.size(priceHistory) < 1000
    array.push(priceHistory, close)
else
    array.shift(priceHistory)
    array.push(priceHistory, close)
```

### Data Availability
- **Intraday data**: Usually limited to recent years depending on subscription
- **Daily data**: More historical data available
- **Higher timeframes**: Generally more history available

## Visual Elements Limitations

### Maximum Plots
- **Limit**: 500 plots maximum per script
- **Includes**: plot(), plotshape(), plotchar(), plotcandle(), plotbar()
```pine
// This would eventually hit the 500 plot limit
for i = 1 to 600  // DON'T DO THIS
    plot(close[i])  // Will error after 500 plots
```

### Lines, Labels, and Boxes
- **Lines**: Maximum 500 lines on chart
- **Labels**: Maximum 500 labels on chart  
- **Boxes**: Maximum 500 boxes on chart
- **Polylines**: Maximum 100 polylines on chart
- **Tables**: Maximum 1 table per script

```pine
// Manage line limit
var array<line> lines = array.new<line>()
if array.size(lines) >= 500
    line.delete(array.shift(lines))  // Remove oldest
newLine = line.new(bar_index, high, bar_index, low)
array.push(lines, newLine)
```

## Function Call Limitations

### Security() Calls
- **Limit**: Maximum 40 `request.security()` calls per script
- **Impact**: Limits multi-timeframe analysis complexity
- **Optimization**: Combine multiple data requests when possible

```pine
// Instead of multiple calls:
// htfHigh = request.security(syminfo.tickerid, "1D", high)     // Call 1
// htfLow = request.security(syminfo.tickerid, "1D", low)      // Call 2
// htfClose = request.security(syminfo.tickerid, "1D", close)  // Call 3

// Use one call with tuple:
[htfHigh, htfLow, htfClose] = request.security(syminfo.tickerid, "1D", [high, low, close])  // 1 call
```

### Array/Matrix/Map Limitations
- **Array size**: Limited by available memory (typically 100,000 elements)
- **Matrix size**: Limited by available memory
- **Map size**: Limited by available memory
- **Performance**: Large collections impact script performance

## Script Size Limitations

### Code Length
- **Compiled size**: Scripts have maximum compiled size limit
- **Line count**: Very long scripts may hit compilation limits
- **Characters**: Extremely long lines may cause issues

### Memory Usage
- **Variable storage**: Limited memory for variables and collections
- **String length**: Very long strings may cause memory issues
- **Complex calculations**: Deep recursion or complex loops may timeout

## Performance Limitations

### Execution Timeout
- **Time limit**: Scripts must complete execution within time limits
- **Complex calculations**: May cause timeout errors
- **Optimization required**: Use efficient algorithms

```pine
// Avoid deep loops that may timeout
// BAD:
sum = 0.0
for i = 1 to 10000  // May timeout
    for j = 1 to 1000
        sum := sum + close[i % 500]

// BETTER:
sum = 0.0
for i = 1 to math.min(10000, 500)  // Limit iterations
    sum := sum + close[i - 1]
```

### Real-time vs Historical Calculation
- **Difference**: Scripts behave differently on historical vs real-time bars
- **Performance**: Real-time calculations are more resource intensive
- **Limitation**: Some functions behave differently in real-time

## Alert Limitations

### Alert Frequency
- **Rate limiting**: TradingView limits alert frequency per user
- **Per script**: Each script has alert frequency limits
- **Subscription dependent**: Higher plans allow more alerts

### Alert Message Size
- **Character limit**: Alert messages have maximum character limits
- **JSON payload**: Limited size for webhook payloads

```pine
// Keep alert messages concise
alertMessage = "Buy " + syminfo.ticker + " at " + str.tostring(close)  // Good
// Avoid extremely long alert messages
```

## Library Limitations

### Import Limits
- **Maximum imports**: Limited number of library imports per script
- **Version dependency**: Must specify exact library versions
- **Circular dependencies**: Libraries cannot import each other circularly

### Export Limits
- **Function count**: Libraries have limits on exported functions
- **Complexity**: Very complex libraries may hit compilation limits

## Data Type Limitations

### Number Precision
- **Float precision**: Limited decimal precision for float calculations
- **Integer range**: Limited range for integer values
- **Overflow**: Large numbers may cause overflow

```pine
// Be aware of float precision limits
price1 = 1.234567890123456789  // Will be rounded
price2 = 1.234567890123456780  // May be considered equal

// Use math.round() for specific precision
roundedPrice = math.round(price1, 4)  // 4 decimal places
```

### String Limitations
- **Length**: Very long strings may cause memory issues
- **Concatenation**: Excessive string concatenation may impact performance

## Real-time Data Limitations

### Tick Data
- **Availability**: Limited tick-by-tick data access
- **Subscription dependent**: Higher subscriptions get more real-time data
- **Delayed data**: Some data may be delayed based on exchange agreements

### Data Updates
- **Frequency**: Real-time data updates limited by exchange feeds
- **Gaps**: Weekend and holiday gaps in data
- **Quality**: Data quality depends on exchange feed reliability

## Strategy-Specific Limitations

### Backtest Limitations
- **Commission**: Simplified commission models
- **Slippage**: Basic slippage simulation
- **Liquidity**: No real liquidity modeling
- **Market hours**: Limited market hours simulation

### Order Management
- **Order types**: Limited order types available
- **Execution**: Simplified execution model
- **Position sizing**: Limited position sizing options

## Security and Access Limitations

### External Data
- **API calls**: No direct external API access
- **File system**: No file system access
- **Network**: No direct network access
- **Databases**: No database connectivity

### User Data
- **Privacy**: Cannot access user account information
- **Personal data**: Cannot store or access personal information

## Debugging Limitations

### Error Messages
- **Detail level**: Limited error message detail
- **Line numbers**: Error locations may be approximate
- **Runtime errors**: Some errors only appear at runtime

### Debugging Tools
- **Print statements**: Limited to log and label display
- **Breakpoints**: No traditional debugger breakpoints
- **Step through**: No step-through debugging capability

## Best Practices for Working with Limitations

### Optimization Strategies
1. **Minimize security() calls**: Combine data requests
2. **Manage visual elements**: Remove old lines/labels/boxes
3. **Optimize loops**: Avoid nested loops when possible
4. **Use efficient data structures**: Choose appropriate collections
5. **Monitor performance**: Test with long historical data

### Error Prevention
1. **Validate inputs**: Check user inputs for valid ranges
2. **Handle NA values**: Always check for NA before calculations
3. **Avoid array index errors**: Check array size before access
4. **Memory management**: Clean up unused objects

### Workarounds
1. **Use libraries**: Split complex logic into libraries
2. **Data persistence**: Use var and varip for state management
3. **Conditional execution**: Use if statements to limit calculations
4. **Batch operations**: Group similar operations together

```pine
// Example of limitation-aware code
//@version=6
indicator("Limitation-Aware Script", overlay=true)

// Manage line limit
var int MAX_LINES = 450  // Stay below 500 limit
var array<line> trendLines = array.new<line>()

// Efficient security call
[htfHLOC] = request.security(syminfo.tickerid, "1D", [high, low, open, close])

// Memory-efficient calculation
if bar_index % 10 == 0  // Only calculate every 10 bars
    if array.size(trendLines) >= MAX_LINES
        line.delete(array.shift(trendLines))
    
    newLine = line.new(bar_index, high, bar_index + 10, high)
    array.push(trendLines, newLine)
```

## Error Handling Best Practices

```pine
// Always validate data before use
safeRSI = na(ta.rsi(close, 14)) ? 50 : ta.rsi(close, 14)

// Check array bounds
getArrayValue(arr, index) =>
    index >= 0 and index < array.size(arr) ? array.get(arr, index) : na

// Handle division by zero
safeDivision(numerator, denominator) =>
    denominator == 0 ? na : numerator / denominator

// Validate user inputs
validatedLength = input.int(14, "Length", minval=1, maxval=100)
```

Understanding these limitations is crucial for developing robust Pine Script indicators and strategies that perform well in all market conditions and don't encounter runtime errors.