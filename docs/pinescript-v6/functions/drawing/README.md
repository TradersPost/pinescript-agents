# Pine Script v6 Drawing Functions

## Overview

Pine Script v6 provides powerful drawing capabilities through four main namespaces that allow you to create visual elements on charts. These functions enable you to draw lines, labels, boxes, and complex polylines to enhance your indicators and strategies with visual context.

## Drawing Object Namespaces

- **`line.*`** - Create and manage straight lines
- **`label.*`** - Create and manage text labels with customizable styles
- **`box.*`** - Create and manage rectangular boxes
- **`polyline.*`** - Create and manage multi-point lines and shapes

## Drawing Limits

- **Total Objects**: Maximum 500 drawing objects per script
- **Polyline Points**: Maximum 10,000 points per polyline
- **Lines per Polyline**: Maximum 100 lines per polyline
- **Historical References**: Drawing objects persist across bars unless deleted

---

# Line Functions (`line.*`)

Lines are the most fundamental drawing objects, used to connect two points on the chart.

## Core Line Functions

### `line.new()`
Creates a new line object.

```pinescript
line.new(x1, y1, x2, y2, xloc, extend, color, style, width) → series line
```

**Parameters:**
- `x1` (int): X-coordinate of the first point (bar index or time)
- `y1` (float): Y-coordinate of the first point (price)
- `x2` (int): X-coordinate of the second point
- `y2` (float): Y-coordinate of the second point
- `xloc` (string): `xloc.bar_index` or `xloc.bar_time`
- `extend` (string): `extend.none`, `extend.left`, `extend.right`, or `extend.both`
- `color` (color): Line color
- `style` (string): Line style
- `width` (int): Line width (1-4)

### `line.set_xy1()` and `line.set_xy2()`
Modify line endpoints.

```pinescript
line.set_xy1(id, x, y) → void
line.set_xy2(id, x, y) → void
```

### `line.delete()`
Removes a line from the chart.

```pinescript
line.delete(id) → void
```

### Line Property Functions

```pinescript
line.set_color(id, color) → void
line.set_extend(id, extend) → void
line.set_style(id, style) → void
line.set_width(id, width) → void

line.get_x1(id) → int
line.get_y1(id) → float
line.get_x2(id) → int
line.get_y2(id) → float
```

## Line Styles

```pinescript
line.style_solid
line.style_dashed
line.style_dotted
line.style_arrow_left
line.style_arrow_right
line.style_arrow_both
```

## Line Examples

### Example 1: Dynamic Support/Resistance Lines

```pinescript
//@version=6
indicator("Dynamic Support/Resistance", overlay=true)

// Input parameters
lookback = input.int(20, "Lookback Period", minval=5, maxval=100)
line_extend = input.string("right", "Extend Lines", options=["none", "right", "both"])
resistance_color = input.color(color.red, "Resistance Color")
support_color = input.color(color.green, "Support Color")

// Variables to store lines
var line resistance_line = na
var line support_line = na

// Find pivot highs and lows
pivot_high = ta.pivothigh(high, lookback, lookback)
pivot_low = ta.pivotlow(low, lookback, lookback)

// Function to create or update resistance line
update_resistance_line() =>
    if not na(pivot_high)
        // Delete previous line
        if not na(resistance_line)
            line.delete(resistance_line)
        
        // Create new resistance line
        resistance_line := line.new(
             x1=bar_index - lookback, 
             y1=pivot_high, 
             x2=bar_index, 
             y2=pivot_high,
             xloc=xloc.bar_index,
             extend=line_extend == "none" ? extend.none : 
                    line_extend == "right" ? extend.right : extend.both,
             color=resistance_color,
             style=line.style_solid,
             width=2
             )

// Function to create or update support line
update_support_line() =>
    if not na(pivot_low)
        // Delete previous line
        if not na(support_line)
            line.delete(support_line)
        
        // Create new support line
        support_line := line.new(
             x1=bar_index - lookback, 
             y1=pivot_low, 
             x2=bar_index, 
             y2=pivot_low,
             xloc=xloc.bar_index,
             extend=line_extend == "none" ? extend.none : 
                    line_extend == "right" ? extend.right : extend.both,
             color=support_color,
             style=line.style_solid,
             width=2
             )

// Update lines
update_resistance_line()
update_support_line()
```

### Example 2: Trend Channel Lines

```pinescript
//@version=6
indicator("Trend Channel", overlay=true)

// Input parameters
channel_length = input.int(50, "Channel Length", minval=10)
deviation_multiplier = input.float(2.0, "Deviation Multiplier", minval=0.1, step=0.1)

// Variables
var line upper_line = na
var line middle_line = na
var line lower_line = na

// Calculate linear regression
slope = ta.linreg(close, channel_length, 1) - ta.linreg(close, channel_length, 0)
intercept = ta.linreg(close, channel_length, 0) - slope * (channel_length - 1) / 2
deviation = ta.stdev(close, channel_length) * deviation_multiplier

// Calculate line points
start_x = bar_index - channel_length + 1
end_x = bar_index
start_y = intercept + slope * (-channel_length + 1) / 2
end_y = intercept + slope * (channel_length - 1) / 2

// Update lines on last bar
if barstate.islast
    // Delete previous lines
    line.delete(upper_line)
    line.delete(middle_line)
    line.delete(lower_line)
    
    // Create new lines
    middle_line := line.new(start_x, start_y, end_x, end_y, 
                           color=color.blue, width=1, extend=extend.right)
    upper_line := line.new(start_x, start_y + deviation, end_x, end_y + deviation, 
                          color=color.red, width=1, extend=extend.right)
    lower_line := line.new(start_x, start_y - deviation, end_x, end_y - deviation, 
                          color=color.green, width=1, extend=extend.right)
```

---

# Label Functions (`label.*`)

Labels display text on the chart and are essential for annotations, signals, and information display.

## Core Label Functions

### `label.new()`
Creates a new label object.

```pinescript
label.new(x, y, text, xloc, yloc, color, style, textcolor, size, textalign, tooltip) → series label
```

**Parameters:**
- `x` (int): X-coordinate (bar index or time)
- `y` (float): Y-coordinate (price)
- `text` (string): Label text
- `xloc` (string): `xloc.bar_index` or `xloc.bar_time`
- `yloc` (string): `yloc.price`, `yloc.abovebar`, `yloc.belowbar`
- `color` (color): Background color
- `style` (string): Label style
- `textcolor` (color): Text color
- `size` (string): Text size
- `textalign` (string): Text alignment
- `tooltip` (string): Tooltip text

### Label Property Functions

```pinescript
label.set_x(id, x) → void
label.set_y(id, y) → void
label.set_xy(id, x, y) → void
label.set_text(id, text) → void
label.set_color(id, color) → void
label.set_style(id, style) → void
label.set_textcolor(id, textcolor) → void
label.set_size(id, size) → void
label.set_tooltip(id, tooltip) → void

label.get_x(id) → int
label.get_y(id) → float
label.get_text(id) → string
```

### `label.delete()`
Removes a label from the chart.

```pinescript
label.delete(id) → void
```

## Label Styles

```pinescript
label.style_none
label.style_xcross
label.style_cross
label.style_triangleup
label.style_triangledown
label.style_flag
label.style_circle
label.style_arrowup
label.style_arrowdown
label.style_label_up
label.style_label_down
label.style_label_left
label.style_label_right
label.style_label_lower_left
label.style_label_lower_right
label.style_label_upper_left
label.style_label_upper_right
label.style_square
label.style_diamond
```

## Label Sizes

```pinescript
size.auto
size.tiny
size.small
size.normal
size.large
size.huge
```

## Label Examples

### Example 1: Buy/Sell Signal Labels

```pinescript
//@version=6
indicator("Buy/Sell Signals", overlay=true)

// Input parameters
rsi_length = input.int(14, "RSI Length")
rsi_oversold = input.int(30, "RSI Oversold Level")
rsi_overbought = input.int(70, "RSI Overbought Level")
show_labels = input.bool(true, "Show Labels")

// Calculate RSI
rsi = ta.rsi(close, rsi_length)

// Define signals
buy_signal = ta.crossover(rsi, rsi_oversold)
sell_signal = ta.crossunder(rsi, rsi_overbought)

// Create labels for signals
if show_labels and buy_signal
    label.new(
         x=bar_index, 
         y=low, 
         text="BUY\nRSI: " + str.tostring(rsi, "#.##"), 
         xloc=xloc.bar_index,
         yloc=yloc.belowbar,
         color=color.green,
         style=label.style_label_up,
         textcolor=color.white,
         size=size.normal,
         tooltip="RSI Oversold Buy Signal"
         )

if show_labels and sell_signal
    label.new(
         x=bar_index, 
         y=high, 
         text="SELL\nRSI: " + str.tostring(rsi, "#.##"), 
         xloc=xloc.bar_index,
         yloc=yloc.abovebar,
         color=color.red,
         style=label.style_label_down,
         textcolor=color.white,
         size=size.normal,
         tooltip="RSI Overbought Sell Signal"
         )

// Plot RSI in separate pane
hline(rsi_overbought, "Overbought", color=color.red, linestyle=hline.style_dashed)
hline(rsi_oversold, "Oversold", color=color.green, linestyle=hline.style_dashed)
plot(rsi, "RSI", color=color.blue)
```

### Example 2: Price Level Information Labels

```pinescript
//@version=6
indicator("Price Level Info", overlay=true)

// Input parameters
update_frequency = input.string("On Bar Close", "Update Frequency", 
                               options=["Real-time", "On Bar Close"])
label_position = input.string("Top Right", "Label Position", 
                             options=["Top Left", "Top Right", "Bottom Left", "Bottom Right"])

// Variables for label management
var label info_label = na

// Function to get label position
get_label_position() =>
    switch label_position
        "Top Left" => [bar_index - 20, high + (high - low) * 0.1]
        "Top Right" => [bar_index, high + (high - low) * 0.1]
        "Bottom Left" => [bar_index - 20, low - (high - low) * 0.1]
        "Bottom Right" => [bar_index, low - (high - low) * 0.1]

// Function to create info text
create_info_text() =>
    price_change = close - close[1]
    price_change_pct = (price_change / close[1]) * 100
    volume_ma = ta.sma(volume, 20)
    volume_ratio = volume / volume_ma
    
    text = "Price: " + str.tostring(close, "#.####") + "\n" +
           "Change: " + str.tostring(price_change, "#.####") + " (" + 
           str.tostring(price_change_pct, "#.##") + "%)\n" +
           "Volume: " + str.tostring(volume, format.volume) + "\n" +
           "Vol Ratio: " + str.tostring(volume_ratio, "#.##") + "x\n" +
           "Time: " + str.format_time(time, "HH:mm")
    text

// Update condition
should_update = update_frequency == "Real-time" or barstate.isconfirmed

if should_update
    // Delete previous label
    label.delete(info_label)
    
    // Get position
    [x_pos, y_pos] = get_label_position()
    
    // Create new label
    info_label := label.new(
         x=x_pos,
         y=y_pos,
         text=create_info_text(),
         xloc=xloc.bar_index,
         yloc=yloc.price,
         color=color.new(color.black, 20),
         style=label.style_label_left,
         textcolor=color.white,
         size=size.normal,
         tooltip="Real-time market information"
         )
```

---

# Box Functions (`box.*`)

Boxes create rectangular areas on the chart, useful for highlighting zones, time periods, or price ranges.

## Core Box Functions

### `box.new()`
Creates a new box object.

```pinescript
box.new(left, top, right, bottom, border_color, border_width, border_style, 
        extend, xloc, bgcolor, text, text_color, text_size, text_halign, 
        text_valign, text_wrap, text_font_family) → series box
```

**Parameters:**
- `left` (int): Left edge X-coordinate
- `top` (float): Top edge Y-coordinate
- `right` (int): Right edge X-coordinate  
- `bottom` (float): Bottom edge Y-coordinate
- `border_color` (color): Border color
- `border_width` (int): Border width
- `border_style` (string): Border style
- `extend` (string): Extension direction
- `xloc` (string): X-location type
- `bgcolor` (color): Background color
- `text` (string): Box text
- `text_color` (color): Text color
- `text_size` (string): Text size
- Other text formatting parameters

### Box Property Functions

```pinescript
box.set_left(id, left) → void
box.set_top(id, top) → void
box.set_right(id, right) → void
box.set_bottom(id, bottom) → void
box.set_lefttop(id, left, top) → void
box.set_rightbottom(id, right, bottom) → void
box.set_border_color(id, color) → void
box.set_border_width(id, width) → void
box.set_border_style(id, style) → void
box.set_bgcolor(id, color) → void
box.set_text(id, text) → void
box.set_text_color(id, color) → void
box.set_text_size(id, size) → void

box.get_left(id) → int
box.get_top(id) → float
box.get_right(id) → int
box.get_bottom(id) → float
```

### `box.delete()`
Removes a box from the chart.

```pinescript
box.delete(id) → void
```

## Box Examples

### Example 1: Session Highlight Boxes

```pinescript
//@version=6
indicator("Session Highlighter", overlay=true)

// Input parameters
show_asian = input.bool(true, "Show Asian Session")
show_london = input.bool(true, "Show London Session")
show_ny = input.bool(true, "Show New York Session")

asian_color = input.color(color.new(color.yellow, 90), "Asian Session Color")
london_color = input.color(color.new(color.blue, 90), "London Session Color")
ny_color = input.color(color.new(color.red, 90), "New York Session Color")

// Session time definitions (in exchange timezone)
asian_session = time(timeframe.period, "0100-0900:1234567")
london_session = time(timeframe.period, "0800-1600:1234567")
ny_session = time(timeframe.period, "1330-2000:1234567")

// Variables to track session state
var bool in_asian = false
var bool in_london = false
var bool in_ny = false

var box asian_box = na
var box london_box = na
var box ny_box = na

var float asian_high = na
var float asian_low = na
var float london_high = na
var float london_low = na
var float ny_high = na
var float ny_low = na

var int asian_start = na
var int london_start = na
var int ny_start = na

// Function to create or update session box
update_session_box(session_active, was_active, box_ref, start_time, session_high, session_low, box_color, session_name) =>
    var box current_box = box_ref
    
    if session_active and not was_active
        // Session starting
        start_time := bar_index
        session_high := high
        session_low := low
        current_box := na  // Reset box reference
        
    else if session_active
        // Session continuing
        session_high := math.max(session_high, high)
        session_low := math.min(session_low, low)
        
        // Update or create box
        if na(current_box)
            current_box := box.new(
                 left=start_time,
                 top=session_high,
                 right=bar_index,
                 bottom=session_low,
                 border_color=color.new(box_color, 70),
                 border_width=1,
                 bgcolor=box_color,
                 text=session_name,
                 text_color=color.new(color.white, 30),
                 text_size=size.small
                 )
        else
            box.set_right(current_box, bar_index)
            box.set_top(current_box, session_high)
            box.set_bottom(current_box, session_low)
    
    [current_box, start_time, session_high, session_low]

// Track session states
was_asian = in_asian
was_london = in_london
was_ny = in_ny

in_asian := not na(asian_session)
in_london := not na(london_session)
in_ny := not na(ny_session)

// Update session boxes
if show_asian
    [asian_box, asian_start, asian_high, asian_low] := 
         update_session_box(in_asian, was_asian, asian_box, asian_start, 
                           asian_high, asian_low, asian_color, "Asian")

if show_london
    [london_box, london_start, london_high, london_low] := 
         update_session_box(in_london, was_london, london_box, london_start, 
                           london_high, london_low, london_color, "London")

if show_ny
    [ny_box, ny_start, ny_high, ny_low] := 
         update_session_box(in_ny, was_ny, ny_box, ny_start, 
                           ny_high, ny_low, ny_color, "New York")
```

### Example 2: Accumulation/Distribution Zones

```pinescript
//@version=6
indicator("Accumulation/Distribution Zones", overlay=true)

// Input parameters
zone_length = input.int(20, "Zone Detection Length", minval=5)
volume_threshold = input.float(1.5, "Volume Threshold", minval=1.0, step=0.1)
min_zone_size = input.float(0.5, "Minimum Zone Size %", minval=0.1, step=0.1)

// Variables
var array<box> accumulation_zones = array.new<box>()
var array<box> distribution_zones = array.new<box>()

// Calculate volume moving average
volume_ma = ta.sma(volume, zone_length)

// Detect potential zones
is_high_volume = volume > volume_ma * volume_threshold
price_range = (high - low) / close * 100

// Accumulation: High volume + small price range + closing higher
is_accumulation = is_high_volume and price_range < min_zone_size and close > open

// Distribution: High volume + small price range + closing lower  
is_distribution = is_high_volume and price_range < min_zone_size and close < open

// Function to create zone box
create_zone_box(zone_type) =>
    zone_color = zone_type == "accumulation" ? 
                 color.new(color.green, 80) : color.new(color.red, 80)
    zone_text = zone_type == "accumulation" ? "ACC" : "DIST"
    
    zone_box = box.new(
         left=bar_index - zone_length / 4,
         top=high,
         right=bar_index + zone_length / 4,
         bottom=low,
         border_color=color.new(zone_color, 50),
         border_width=2,
         bgcolor=zone_color,
         text=zone_text + "\nVol: " + str.tostring(volume / volume_ma, "#.#") + "x",
         text_color=color.white,
         text_size=size.small,
         text_halign=text.align_center,
         text_valign=text.align_center
         )
    zone_box

// Create zones
if is_accumulation
    acc_box = create_zone_box("accumulation")
    array.push(accumulation_zones, acc_box)
    
    // Limit array size to prevent memory issues
    if array.size(accumulation_zones) > 50
        old_box = array.shift(accumulation_zones)
        box.delete(old_box)

if is_distribution
    dist_box = create_zone_box("distribution")
    array.push(distribution_zones, dist_box)
    
    // Limit array size
    if array.size(distribution_zones) > 50
        old_box = array.shift(distribution_zones)
        box.delete(old_box)
```

---

# Polyline Functions (`polyline.*`)

Polylines allow creation of complex multi-point shapes and patterns that cannot be achieved with simple lines.

## Core Polyline Functions

### `polyline.new()`
Creates a new polyline object.

```pinescript
polyline.new(points, line_color, line_style, line_width) → series polyline
```

**Parameters:**
- `points` (array<polyline.point>): Array of polyline points
- `line_color` (color): Line color
- `line_style` (string): Line style
- `line_width` (int): Line width

### `polyline.point.new()`
Creates a new polyline point.

```pinescript
polyline.point.new(x, y, xloc) → polyline.point
```

### Polyline Management Functions

```pinescript
polyline.delete(id) → void
polyline.clear(id) → void
polyline.copy(id) → series polyline
```

## Polyline Examples

### Example 1: Fibonacci Fan Lines

```pinescript
//@version=6
indicator("Fibonacci Fan", overlay=true)

// Input parameters
lookback_period = input.int(100, "Lookback Period", minval=20)
show_fan = input.bool(true, "Show Fibonacci Fan")

// Variables
var polyline fib_fan = na

// Fibonacci ratios
fib_ratios = array.from(0.236, 0.382, 0.5, 0.618, 0.786)

// Find significant high and low
highest_price = ta.highest(high, lookback_period)
lowest_price = ta.lowest(low, lookback_period)
highest_bar = ta.highestbars(high, lookback_period)
lowest_bar = ta.lowestbars(low, lookback_period)

// Check if we have a new high or low
new_extreme = (high == highest_price and highest_bar == 0) or 
              (low == lowest_price and lowest_bar == 0)

if show_fan and new_extreme and barstate.isconfirmed
    // Delete previous fan
    polyline.delete(fib_fan)
    
    // Determine trend direction
    is_uptrend = lowest_bar < highest_bar
    
    if is_uptrend
        // Uptrend: fan from low to high
        start_x = bar_index + lowest_bar
        start_y = lowest_price
        end_x = bar_index + highest_bar
        end_y = highest_price
    else
        // Downtrend: fan from high to low
        start_x = bar_index + highest_bar  
        start_y = highest_price
        end_x = bar_index + lowest_bar
        end_y = lowest_price
    
    // Calculate fan extension
    price_range = math.abs(end_y - start_y)
    time_range = math.abs(end_x - start_x)
    extension_bars = 50
    
    // Create points array for the fan
    fan_points = array.new<polyline.point>()
    
    // Add base line points
    array.push(fan_points, polyline.point.new(start_x, start_y))
    array.push(fan_points, polyline.point.new(end_x, end_y))
    
    // Add fibonacci fan lines
    for i = 0 to array.size(fib_ratios) - 1
        ratio = array.get(fib_ratios, i)
        fan_y = start_y + (end_y - start_y) * ratio
        fan_x = end_x + extension_bars
        
        // Add point for this fibonacci level
        array.push(fan_points, polyline.point.new(end_x, fan_y))
        array.push(fan_points, polyline.point.new(fan_x, fan_y))
    
    // Create the polyline
    fib_fan := polyline.new(
         points=fan_points,
         line_color=color.purple,
         line_style=line.style_solid,
         line_width=1
         )
```

### Example 2: Market Structure Pattern

```pinescript
//@version=6
indicator("Market Structure Pattern", overlay=true)

// Input parameters
swing_length = input.int(10, "Swing Detection Length", minval=5)
pattern_color = input.color(color.blue, "Pattern Color")

// Variables
var array<polyline.point> structure_points = array.new<polyline.point>()
var polyline structure_line = na

// Detect swing highs and lows
swing_high = ta.pivothigh(high, swing_length, swing_length)
swing_low = ta.pivotlow(low, swing_length, swing_length)

// Function to add structure point
add_structure_point(price, is_high) =>
    point = polyline.point.new(
         x=bar_index - swing_length, 
         y=price, 
         xloc=xloc.bar_index
         )
    
    array.push(structure_points, point)
    
    // Limit points to prevent memory issues
    if array.size(structure_points) > 20
        array.shift(structure_points)
    
    // Recreate polyline with updated points
    polyline.delete(structure_line)
    if array.size(structure_points) > 1
        structure_line := polyline.new(
             points=structure_points,
             line_color=pattern_color,
             line_style=line.style_solid,
             line_width=2
             )

// Add points when swings are detected
if not na(swing_high)
    add_structure_point(swing_high, true)

if not na(swing_low)
    add_structure_point(swing_low, false)
```

---

# Performance Considerations

## Memory Management

1. **Limit Object Count**: Always limit the number of drawing objects to prevent memory issues
2. **Delete Unused Objects**: Use `delete()` functions to remove objects no longer needed
3. **Use Arrays Wisely**: When storing multiple objects, limit array sizes

```pinescript
// Good practice: Limit and clean up objects
var int max_objects = 100
var array<line> my_lines = array.new<line>()

if array.size(my_lines) >= max_objects
    old_line = array.shift(my_lines)
    line.delete(old_line)
```

## Execution Efficiency

1. **Conditional Creation**: Only create objects when necessary
2. **Batch Operations**: Update multiple properties in sequence
3. **Historical Context**: Consider using `barstate.isconfirmed` for historical accuracy

```pinescript
// Efficient object management
if condition_met and barstate.isconfirmed
    new_line = line.new(x1, y1, x2, y2, color=line_color)
    line.set_extend(new_line, extend.right)
    line.set_width(new_line, 2)
```

## Best Practices

1. **Use `var` for Persistent Objects**: Declare drawing objects with `var` to persist across bars
2. **Handle Real-time Updates**: Consider how objects behave in real-time vs historical context
3. **Provide User Controls**: Allow users to toggle drawing objects and customize appearance
4. **Document Object Limits**: Inform users of any limitations in your script

```pinescript
// Best practice template
var line my_line = na
show_line = input.bool(true, "Show Line")

if show_line and condition
    line.delete(my_line)  // Clean up previous
    my_line := line.new(...)  // Create new
```

---

# Common Patterns and Use Cases

## 1. Support/Resistance Levels
- Use `line.*` functions with `extend.right` for ongoing levels
- Update levels when price breaks through
- Color-code by strength or age

## 2. Chart Annotations
- Use `label.*` functions for trade signals and information
- Position labels relative to price action using `yloc` parameters
- Include tooltips for additional context

## 3. Zone Highlighting
- Use `box.*` functions for accumulation/distribution zones
- Highlight time-based sessions or events
- Show volatility or volume-based zones

## 4. Complex Patterns
- Use `polyline.*` functions for Elliott Wave patterns
- Create custom geometric patterns
- Build advanced technical analysis tools

## Summary

Pine Script v6 drawing functions provide powerful capabilities for creating visual enhancements to your indicators and strategies. The key to effective use is:

1. **Understanding Limits**: Respect the 500-object limit and manage memory
2. **Proper Cleanup**: Always delete unused objects
3. **User Experience**: Provide controls for customization
4. **Performance**: Use conditional logic to minimize unnecessary operations
5. **Documentation**: Comment your drawing logic clearly

These drawing functions enable you to create professional, visually appealing, and functionally rich Pine Script applications that enhance the trading experience on TradingView.