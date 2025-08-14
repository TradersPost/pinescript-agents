# Pine Script v6 Language Reference

## Version Declaration
```pinescript
//@version=6
```
Must be the first line of any Pine Script v6 code.

## Script Types

### Indicator
```pinescript
indicator(title, shorttitle, overlay, format, precision, scale, max_bars_back, max_lines_count, max_labels_count, max_boxes_count)
```

### Strategy
```pinescript
strategy(title, shorttitle, overlay, format, precision, scale, pyramiding, calc_on_order_fills, calc_on_every_tick, max_bars_back, backtest_fill_limits_assumption, default_qty_type, default_qty_value, initial_capital, currency, slippage, commission_type, commission_value, process_orders_on_close, close_entries_rule, margin_long, margin_short, explicit_plot_zorder, max_lines_count, max_labels_count, max_boxes_count)
```

### Library
```pinescript
library(title, overlay)
```

## Data Types

### Basic Types
- `int` - Integer numbers
- `float` - Floating point numbers
- `bool` - Boolean values (true/false)
- `color` - Color values
- `string` - Text strings

### Special Types
- `line` - Line drawings
- `label` - Text labels
- `box` - Box drawings
- `table` - Table objects
- `linefill` - Fill between lines
- `polyline` - Connected line segments

### Series vs Simple
- Series: Values that can change on each bar `series float`
- Simple: Constant values `simple int`
- Const: Compile-time constants `const string`

## Variables

### Declaration
```pinescript
var variableName = initialValue  // Persistent across bars
varip variableName = initialValue  // Persistent intrabar
variableName = value  // Regular variable
```

### Type Declaration
```pinescript
float myFloat = 10.5
int myInt = 10
bool myBool = true
string myString = "text"
color myColor = color.red
```

## Operators

### Arithmetic
- `+` Addition
- `-` Subtraction
- `*` Multiplication
- `/` Division
- `%` Modulo
- `+=`, `-=`, `*=`, `/=` Compound assignment

### Comparison
- `==` Equal
- `!=` Not equal
- `>` Greater than
- `<` Less than
- `>=` Greater than or equal
- `<=` Less than or equal

### Logical
- `and` Logical AND
- `or` Logical OR
- `not` Logical NOT
- `?:` Ternary operator

### Series Subscript
- `[]` Historical reference operator
- `[1]` Previous bar value
- `[n]` Value n bars ago

## Control Structures

### If Statement
```pinescript
if condition
    // code
else if anotherCondition
    // code
else
    // code
```

### Switch Statement
```pinescript
switch expression
    value1 => result1
    value2 => result2
    => defaultResult
```

### For Loop
```pinescript
for i = 0 to 10
    // code

for i = 0 to 10 by 2
    // code
```

### While Loop
```pinescript
while condition
    // code
    break  // Optional
    continue  // Optional
```

## Functions

### User-Defined Functions
```pinescript
myFunction(param1, param2) =>
    result = param1 + param2
    result  // Return value

// Multi-line function
myFunction(param1, param2) =>
    var1 = param1 * 2
    var2 = param2 * 3
    result = var1 + var2
    result
```

### Method Syntax
```pinescript
// New in v5/v6
myArray.push(value)
myString.contains("text")
```

## Arrays

### Declaration
```pinescript
myArray = array.new<float>()
myArray = array.new<float>(10)  // With initial size
myArray = array.new<float>(10, 0.0)  // With initial value
```

### Common Operations
```pinescript
array.push(myArray, value)
array.pop(myArray)
array.get(myArray, index)
array.set(myArray, index, value)
array.size(myArray)
array.clear(myArray)
array.remove(myArray, index)
```

## Matrices

### Declaration
```pinescript
myMatrix = matrix.new<float>()
myMatrix = matrix.new<float>(rows, columns)
myMatrix = matrix.new<float>(rows, columns, initial_value)
```

### Operations
```pinescript
matrix.set(myMatrix, row, column, value)
matrix.get(myMatrix, row, column)
matrix.rows(myMatrix)
matrix.columns(myMatrix)
```

## Maps

### Declaration
```pinescript
myMap = map.new<string, float>()
```

### Operations
```pinescript
myMap.put(key, value)
myMap.get(key)
myMap.remove(key)
myMap.contains(key)
myMap.clear()
```

## User Inputs

### Basic Inputs
```pinescript
intInput = input.int(defval, title, minval, maxval, step, tooltip, inline, group, confirm)
floatInput = input.float(defval, title, minval, maxval, step, tooltip, inline, group, confirm)
boolInput = input.bool(defval, title, tooltip, inline, group, confirm)
stringInput = input.string(defval, title, options, tooltip, inline, group, confirm)
```

### Special Inputs
```pinescript
colorInput = input.color(defval, title, tooltip, inline, group, confirm)
timeInput = input.time(defval, title, tooltip, inline, group, confirm)
sourceInput = input.source(defval, title, tooltip, inline, group)
symbolInput = input.symbol(defval, title, tooltip, inline, group, confirm)
timeframeInput = input.timeframe(defval, title, tooltip, inline, group, confirm)
```

## Plotting

### Basic Plots
```pinescript
plot(series, title, color, linewidth, style, trackprice, histbase, offset, join, editable, show_last, display)
plotshape(series, title, style, location, color, offset, text, textcolor, editable, size, show_last, display)
plotchar(series, title, char, location, color, offset, text, textcolor, editable, size, show_last, display)
plotarrow(series, title, colorup, colordown, offset, minheight, maxheight, editable, show_last, display)
```

### Advanced Plotting
```pinescript
plotcandle(open, high, low, close, title, color, wickcolor, editable, show_last, bordercolor, display)
plotbar(open, high, low, close, title, color, editable, show_last, display)
```

### Horizontal Lines
```pinescript
hline(price, title, color, linestyle, linewidth, editable, display)
```

### Fills
```pinescript
fill(hline1/plot1, hline2/plot2, color, title, editable, fillgaps, display)
```

## Drawing Objects

### Lines
```pinescript
line.new(x1, y1, x2, y2, xloc, extend, color, style, width)
line.set_xy1(id, x, y)
line.set_xy2(id, x, y)
line.delete(id)
```

### Labels
```pinescript
label.new(x, y, text, xloc, yloc, color, style, textcolor, size, textalign, tooltip)
label.set_xy(id, x, y)
label.set_text(id, text)
label.delete(id)
```

### Boxes
```pinescript
box.new(left, top, right, bottom, border_color, border_width, border_style, extend, xloc, bgcolor, text, text_size, text_color, text_halign, text_valign, text_wrap)
box.set_lefttop(id, left, top)
box.set_rightbottom(id, right, bottom)
box.delete(id)
```

### Tables
```pinescript
table.new(position, columns, rows, bgcolor, frame_color, frame_width, border_color, border_width)
table.cell(table_id, column, row, text, width, height, text_color, text_halign, text_valign, text_size, bgcolor, tooltip)
table.delete(id)
```

## Alerts

### Alert Condition
```pinescript
alertcondition(condition, title, message)
```

### Alert Function
```pinescript
alert(message, freq)
```

### Strategy Alerts
```pinescript
strategy.entry(id, direction, qty, limit, stop, oca_name, oca_type, comment, when, alert_message)
strategy.exit(id, from_entry, qty, qty_percent, profit, limit, loss, stop, trail_price, trail_points, trail_offset, oca_name, comment, when, alert_message)
```

## Error Handling

### Runtime Errors
```pinescript
runtime.error(message)
```

### NA Handling
```pinescript
na(x)  // Check if value is na
nz(x, y)  // Replace na with y (default 0)
fixnan(x)  // Replace NaN with previous value
```

## Namespaces

### Built-in Namespaces
- `ta` - Technical Analysis
- `math` - Mathematical functions
- `str` - String functions
- `array` - Array functions
- `matrix` - Matrix functions
- `map` - Map functions
- `request` - Data requests
- `strategy` - Strategy functions
- `ticker` - Ticker functions
- `time` - Time functions
- `input` - Input functions

## Compilation Directives

### Export (for libraries)
```pinescript
export myFunction(param) =>
    result
```

### Import
```pinescript
import username/libraryname/version as alias
```

## Comments

### Single Line
```pinescript
// This is a comment
```

### Multi-line
```pinescript
/* 
This is a
multi-line comment
*/
```

## Best Practices

1. Always declare version at the top
2. Use meaningful variable names
3. Group related inputs
4. Add tooltips to inputs
5. Handle na values properly
6. Avoid repainting when possible
7. Optimize for performance
8. Comment complex logic
9. Use consistent formatting
10. Test on multiple timeframes and symbols