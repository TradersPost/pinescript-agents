# Pine Script v6 Polylines Comprehensive Guide

Polylines in Pine Script v6 enable the creation of complex multi-point line drawings on charts. This guide covers everything from basic polyline creation to advanced shape drawing and chart pattern visualization.

## Table of Contents
1. [Polyline Creation](#polyline-creation)
2. [Complex Shape Drawing](#complex-shape-drawing)
3. [Chart Patterns with Polylines](#chart-patterns-with-polylines)
4. [Wave Analysis Visualization](#wave-analysis-visualization)
5. [Performance Considerations](#performance-considerations)
6. [Managing Polyline Objects](#managing-polyline-objects)
7. [Animation Effects](#animation-effects)
8. [Interactive Polylines](#interactive-polylines)

---

## Polyline Creation

### Basic Polyline Syntax
```pinescript
//@version=6
indicator("Basic Polyline Creation", overlay=true, max_polylines_count=100)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 BASIC POLYLINE CREATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Create a simple polyline connecting multiple points
if barstate.islast
    # Create points array
    points = array.new<polyline.point>()
    
    # Add points (time, price)
    array.push(points, polyline.point.new(time[20], low[20]))
    array.push(points, polyline.point.new(time[15], high[15]))
    array.push(points, polyline.point.new(time[10], low[10]))
    array.push(points, polyline.point.new(time[5], high[5]))
    array.push(points, polyline.point.new(time, close))
    
    # Create polyline
    line_id = polyline.new(
        points = points,
        line_color = color.blue,
        line_style = line.style_solid,
        line_width = 2
    )

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                DYNAMIC POLYLINE BUILDING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Build polyline dynamically based on pivot points
var current_polyline = polyline(na)
var polyline_points = array.new<polyline.point>()
pivot_threshold = input.float(2.0, "Pivot Threshold %")

// Detect pivot points
is_pivot_high = ta.pivothigh(high, 5, 5)
is_pivot_low = ta.pivotlow(low, 5, 5)

// Add pivot points to polyline
if not na(is_pivot_high) or not na(is_pivot_low)
    pivot_price = not na(is_pivot_high) ? is_pivot_high : is_pivot_low
    pivot_time = time[5]  # 5 bars back due to pivot calculation
    
    # Add point to array
    new_point = polyline.point.new(pivot_time, pivot_price)
    array.push(polyline_points, new_point)
    
    # Maintain maximum number of points
    max_points = 20
    if array.size(polyline_points) > max_points
        array.shift(polyline_points)
    
    # Recreate polyline with updated points
    if not na(current_polyline)
        polyline.delete(current_polyline)
    
    if array.size(polyline_points) >= 2
        current_polyline := polyline.new(
            points = array.copy(polyline_points),
            line_color = color.purple,
            line_width = 1
        )

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              POLYLINE WITH CUSTOM STYLES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to create styled polylines
create_styled_polyline(points_array, style_type) =>
    if array.size(points_array) >= 2
        line_color = switch style_type
            "bullish" => color.green
            "bearish" => color.red
            "neutral" => color.gray
            "warning" => color.orange
            => color.blue
        
        line_style = switch style_type
            "bullish" => line.style_solid
            "bearish" => line.style_solid
            "neutral" => line.style_dashed
            "warning" => line.style_dotted
            => line.style_solid
        
        line_width = switch style_type
            "bullish" => 3
            "bearish" => 3
            "neutral" => 1
            "warning" => 2
            => 2
        
        polyline.new(
            points = points_array,
            line_color = line_color,
            line_style = line_style,
            line_width = line_width
        )
    else
        polyline(na)

// Example: Create different styled polylines based on trend
var trend_points = array.new<polyline.point>()
var trend_polyline = polyline(na)

# Determine trend
sma_fast = ta.sma(close, 10)
sma_slow = ta.sma(close, 20)
current_trend = sma_fast > sma_slow ? "bullish" : "bearish"

# Add point every 10 bars
if bar_index % 10 == 0
    array.push(trend_points, polyline.point.new(time, close))
    
    if array.size(trend_points) > 5
        array.shift(trend_points)
    
    if not na(trend_polyline)
        polyline.delete(trend_polyline)
    
    trend_polyline := create_styled_polyline(array.copy(trend_points), current_trend)
```

### Advanced Point Management
```pinescript
//@version=6
indicator("Advanced Point Management", overlay=true, max_polylines_count=50)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               POINT INTERPOLATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to interpolate points between two existing points
interpolate_points(point1, point2, num_points) =>
    interpolated = array.new<polyline.point>()
    
    time1 = polyline.point.time(point1)
    price1 = polyline.point.index(point1)
    time2 = polyline.point.time(point2)
    price2 = polyline.point.index(point2)
    
    for i = 1 to num_points
        ratio = i / (num_points + 1)
        interp_time = int(time1 + (time2 - time1) * ratio)
        interp_price = price1 + (price2 - price1) * ratio
        
        array.push(interpolated, polyline.point.new(interp_time, interp_price))
    
    interpolated

// Function to smooth polyline by adding interpolated points
smooth_polyline(original_points, smoothing_factor) =>
    if array.size(original_points) < 2
        original_points
    else
        smoothed_points = array.new<polyline.point>()
        
        for i = 0 to array.size(original_points) - 1
            # Add original point
            array.push(smoothed_points, array.get(original_points, i))
            
            # Add interpolated points between this and next point
            if i < array.size(original_points) - 1
                current_point = array.get(original_points, i)
                next_point = array.get(original_points, i + 1)
                interpolated = interpolate_points(current_point, next_point, smoothing_factor)
                
                for j = 0 to array.size(interpolated) - 1
                    array.push(smoothed_points, array.get(interpolated, j))
        
        smoothed_points

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               GEOMETRIC TRANSFORMATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to translate (move) polyline points
translate_points(points_array, time_offset, price_offset) =>
    translated = array.new<polyline.point>()
    
    for i = 0 to array.size(points_array) - 1
        original_point = array.get(points_array, i)
        original_time = polyline.point.time(original_point)
        original_price = polyline.point.index(original_point)
        
        new_time = original_time + time_offset
        new_price = original_price + price_offset
        
        array.push(translated, polyline.point.new(new_time, new_price))
    
    translated

// Function to scale polyline points
scale_points(points_array, time_scale, price_scale, anchor_point = na) =>
    if array.size(points_array) == 0
        points_array
    else
        # Use first point as anchor if none provided
        anchor = na(anchor_point) ? array.get(points_array, 0) : anchor_point
        anchor_time = polyline.point.time(anchor)
        anchor_price = polyline.point.index(anchor)
        
        scaled = array.new<polyline.point>()
        
        for i = 0 to array.size(points_array) - 1
            original_point = array.get(points_array, i)
            original_time = polyline.point.time(original_point)
            original_price = polyline.point.index(original_point)
            
            # Scale relative to anchor point
            time_diff = original_time - anchor_time
            price_diff = original_price - anchor_price
            
            new_time = anchor_time + int(time_diff * time_scale)
            new_price = anchor_price + price_diff * price_scale
            
            array.push(scaled, polyline.point.new(new_time, new_price))
        
        scaled

// Function to rotate points around a center
rotate_points(points_array, angle_degrees, center_point = na) =>
    if array.size(points_array) == 0
        points_array
    else
        # Calculate center if not provided
        if na(center_point)
            avg_time = 0
            avg_price = 0.0
            
            for i = 0 to array.size(points_array) - 1
                point = array.get(points_array, i)
                avg_time += polyline.point.time(point)
                avg_price += polyline.point.index(point)
            
            center_time = avg_time / array.size(points_array)
            center_price = avg_price / array.size(points_array)
        else
            center_time = polyline.point.time(center_point)
            center_price = polyline.point.index(center_point)
        
        angle_rad = angle_degrees * math.pi / 180
        cos_angle = math.cos(angle_rad)
        sin_angle = math.sin(angle_rad)
        
        rotated = array.new<polyline.point>()
        
        for i = 0 to array.size(points_array) - 1
            original_point = array.get(points_array, i)
            original_time = polyline.point.time(original_point)
            original_price = polyline.point.index(original_point)
            
            # Translate to origin
            rel_time = original_time - center_time
            rel_price = original_price - center_price
            
            # Rotate
            new_rel_time = rel_time * cos_angle - rel_price * sin_angle
            new_rel_price = rel_time * sin_angle + rel_price * cos_angle
            
            # Translate back
            new_time = center_time + int(new_rel_time)
            new_price = center_price + new_rel_price
            
            array.push(rotated, polyline.point.new(new_time, new_price))
        
        rotated

// Example usage of transformations
var demo_points = array.new<polyline.point>()
var demo_polyline = polyline(na)

if barstate.islast and bar_index > 50
    # Create original points
    array.push(demo_points, polyline.point.new(time[30], low[30]))
    array.push(demo_points, polyline.point.new(time[20], high[20]))
    array.push(demo_points, polyline.point.new(time[10], low[10]))
    array.push(demo_points, polyline.point.new(time, high))
    
    # Apply transformations
    smoothed = smooth_polyline(demo_points, 2)
    scaled = scale_points(smoothed, 1.0, 1.2)  # Scale price by 20%
    
    demo_polyline := polyline.new(
        points = scaled,
        line_color = color.new(color.blue, 30),
        line_width = 2
    )
```

---

## Complex Shape Drawing

### Geometric Shapes with Polylines
```pinescript
//@version=6
indicator("Complex Shapes", overlay=true, max_polylines_count=200)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  SHAPE GENERATORS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to create a circle using polylines
create_circle(center_time, center_price, radius_time, radius_price, segments = 36) =>
    points = array.new<polyline.point>()
    
    for i = 0 to segments
        angle = 2 * math.pi * i / segments
        x_offset = radius_time * math.cos(angle)
        y_offset = radius_price * math.sin(angle)
        
        point_time = center_time + int(x_offset)
        point_price = center_price + y_offset
        
        array.push(points, polyline.point.new(point_time, point_price))
    
    polyline.new(
        points = points,
        line_color = color.blue,
        line_width = 1
    )

// Function to create an ellipse
create_ellipse(center_time, center_price, radius_time, radius_price, segments = 36) =>
    points = array.new<polyline.point>()
    
    for i = 0 to segments
        angle = 2 * math.pi * i / segments
        x_offset = radius_time * math.cos(angle)
        y_offset = radius_price * math.sin(angle)
        
        point_time = center_time + int(x_offset)
        point_price = center_price + y_offset
        
        array.push(points, polyline.point.new(point_time, point_price))
    
    polyline.new(
        points = points,
        line_color = color.green,
        line_width = 1
    )

// Function to create a polygon
create_polygon(center_time, center_price, radius_time, radius_price, sides) =>
    points = array.new<polyline.point>()
    
    for i = 0 to sides
        angle = 2 * math.pi * i / sides
        x_offset = radius_time * math.cos(angle)
        y_offset = radius_price * math.sin(angle)
        
        point_time = center_time + int(x_offset)
        point_price = center_price + y_offset
        
        array.push(points, polyline.point.new(point_time, point_price))
    
    polyline.new(
        points = points,
        line_color = color.red,
        line_width = 2
    )

// Function to create a spiral
create_spiral(center_time, center_price, initial_radius_time, initial_radius_price, 
              turns, growth_factor, segments = 100) =>
    points = array.new<polyline.point>()
    
    total_angle = 2 * math.pi * turns
    
    for i = 0 to segments
        progress = i / segments
        angle = total_angle * progress
        radius_multiplier = 1 + growth_factor * progress
        
        x_offset = initial_radius_time * radius_multiplier * math.cos(angle)
        y_offset = initial_radius_price * radius_multiplier * math.sin(angle)
        
        point_time = center_time + int(x_offset)
        point_price = center_price + y_offset
        
        array.push(points, polyline.point.new(point_time, point_price))
    
    polyline.new(
        points = points,
        line_color = color.purple,
        line_width = 1
    )

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               COMPLEX PATTERN SHAPES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to create a sine wave
create_sine_wave(start_time, start_price, end_time, amplitude, frequency, segments = 50) =>
    points = array.new<polyline.point>()
    time_span = end_time - start_time
    
    for i = 0 to segments
        progress = i / segments
        current_time = start_time + int(time_span * progress)
        
        # Calculate sine wave
        angle = 2 * math.pi * frequency * progress
        wave_offset = amplitude * math.sin(angle)
        current_price = start_price + wave_offset
        
        array.push(points, polyline.point.new(current_time, current_price))
    
    polyline.new(
        points = points,
        line_color = color.orange,
        line_width = 2
    )

// Function to create Fibonacci spiral
create_fibonacci_spiral(center_time, center_price, initial_size, segments = 200) =>
    points = array.new<polyline.point>()
    
    # Golden ratio
    phi = 1.618033988749895
    
    for i = 0 to segments
        # Fibonacci spiral equation
        angle = i * 0.1  # Small angle increment
        radius = initial_size * math.pow(phi, angle / (2 * math.pi))
        
        x_offset = radius * math.cos(angle)
        y_offset = radius * math.sin(angle)
        
        point_time = center_time + int(x_offset)
        point_price = center_price + y_offset
        
        array.push(points, polyline.point.new(point_time, point_price))
    
    polyline.new(
        points = points,
        line_color = color.yellow,
        line_width = 1
    )

// Function to create a star shape
create_star(center_time, center_price, outer_radius_time, outer_radius_price, 
           inner_radius_time, inner_radius_price, points_count = 5) =>
    points = array.new<polyline.point>()
    
    total_points = points_count * 2  # Outer and inner points
    
    for i = 0 to total_points
        is_outer = i % 2 == 0
        radius_time = is_outer ? outer_radius_time : inner_radius_time
        radius_price = is_outer ? outer_radius_price : inner_radius_price
        
        angle = 2 * math.pi * i / total_points
        x_offset = radius_time * math.cos(angle)
        y_offset = radius_price * math.sin(angle)
        
        point_time = center_time + int(x_offset)
        point_price = center_price + y_offset
        
        array.push(points, polyline.point.new(point_time, point_price))
    
    # Close the shape
    array.push(points, array.get(points, 0))
    
    polyline.new(
        points = points,
        line_color = color.white,
        line_width = 2
    )

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                SHAPE DEMONSTRATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var shape_polylines = array.new<polyline>()

# Create shapes on last bar
if barstate.islast and bar_index > 100
    center_time = time[50]
    center_price = (high[50] + low[50]) / 2
    
    time_radius = 20 * 60000  # 20 minutes in milliseconds
    price_radius = ta.atr(14)[50] * 2
    
    # Clear previous shapes
    for i = 0 to array.size(shape_polylines) - 1
        polyline.delete(array.get(shape_polylines, i))
    array.clear(shape_polylines)
    
    # Create various shapes
    circle = create_circle(center_time - time_radius * 3, center_price, time_radius * 0.5, price_radius * 0.5)
    array.push(shape_polylines, circle)
    
    hexagon = create_polygon(center_time, center_price, time_radius * 0.7, price_radius * 0.7, 6)
    array.push(shape_polylines, hexagon)
    
    star = create_star(center_time + time_radius * 3, center_price, 
                       time_radius * 0.8, price_radius * 0.8,
                       time_radius * 0.4, price_radius * 0.4, 5)
    array.push(shape_polylines, star)
    
    sine = create_sine_wave(center_time - time_radius * 4, center_price - price_radius * 2,
                           center_time + time_radius * 4, price_radius * 0.5, 3)
    array.push(shape_polylines, sine)
```

---

## Chart Patterns with Polylines

### Technical Analysis Patterns
```pinescript
//@version=6
indicator("Chart Patterns with Polylines", overlay=true, max_polylines_count=100)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PATTERN DETECTION FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to detect head and shoulders pattern
detect_head_shoulders(lookback = 20) =>
    # Find significant peaks
    peaks = array.new<int>()
    peak_values = array.new<float>()
    
    for i = lookback to 1
        if ta.pivothigh(high, 3, 3)[i] != na
            array.push(peaks, bar_index - i)
            array.push(peak_values, high[i])
    
    # Need at least 3 peaks for head and shoulders
    if array.size(peaks) >= 3
        # Check if middle peak is highest (head)
        peak1_val = array.get(peak_values, array.size(peak_values) - 3)
        peak2_val = array.get(peak_values, array.size(peak_values) - 2)  # Head
        peak3_val = array.get(peak_values, array.size(peak_values) - 1)
        
        is_head_shoulders = peak2_val > peak1_val and peak2_val > peak3_val and
                           math.abs(peak1_val - peak3_val) / peak1_val < 0.05  # Similar height shoulders
        
        if is_head_shoulders
            [array.get(peaks, array.size(peaks) - 3),
             array.get(peaks, array.size(peaks) - 2),
             array.get(peaks, array.size(peaks) - 1)]
        else
            [na, na, na]
    else
        [na, na, na]

// Function to draw head and shoulders pattern
draw_head_shoulders(left_shoulder, head, right_shoulder) =>
    if not na(left_shoulder) and not na(head) and not na(right_shoulder)
        points = array.new<polyline.point>()
        
        # Get prices at pattern points
        ls_time = time[bar_index - left_shoulder]
        ls_price = high[bar_index - left_shoulder]
        
        h_time = time[bar_index - head]
        h_price = high[bar_index - head]
        
        rs_time = time[bar_index - right_shoulder]
        rs_price = high[bar_index - right_shoulder]
        
        # Create pattern outline
        array.push(points, polyline.point.new(ls_time, ls_price))
        array.push(points, polyline.point.new(h_time, h_price))
        array.push(points, polyline.point.new(rs_time, rs_price))
        
        # Draw neckline (connect valley points)
        # Simplified: draw from left shoulder to right shoulder
        neckline_points = array.new<polyline.point>()
        array.push(neckline_points, polyline.point.new(ls_time, ls_price * 0.98))
        array.push(neckline_points, polyline.point.new(rs_time, rs_price * 0.98))
        
        # Create polylines
        pattern_line = polyline.new(
            points = points,
            line_color = color.red,
            line_width = 2
        )
        
        neckline = polyline.new(
            points = neckline_points,
            line_color = color.blue,
            line_style = line.style_dashed,
            line_width = 1
        )
        
        [pattern_line, neckline]
    else
        [polyline(na), polyline(na)]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               TRIANGLE PATTERNS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to detect triangle patterns
detect_triangle_pattern(lookback = 30) =>
    # Find swing highs and lows
    swing_highs = array.new<int>()
    swing_lows = array.new<int>()
    swing_high_prices = array.new<float>()
    swing_low_prices = array.new<float>()
    
    for i = lookback to 1
        pivot_high = ta.pivothigh(high, 3, 3)[i]
        pivot_low = ta.pivotlow(low, 3, 3)[i]
        
        if not na(pivot_high)
            array.push(swing_highs, bar_index - i)
            array.push(swing_high_prices, pivot_high)
        
        if not na(pivot_low)
            array.push(swing_lows, bar_index - i)
            array.push(swing_low_prices, pivot_low)
    
    # Need at least 2 highs and 2 lows
    if array.size(swing_highs) >= 2 and array.size(swing_lows) >= 2
        # Get most recent points
        high1_bar = array.get(swing_highs, array.size(swing_highs) - 2)
        high2_bar = array.get(swing_highs, array.size(swing_highs) - 1)
        high1_price = array.get(swing_high_prices, array.size(swing_high_prices) - 2)
        high2_price = array.get(swing_high_prices, array.size(swing_high_prices) - 1)
        
        low1_bar = array.get(swing_lows, array.size(swing_lows) - 2)
        low2_bar = array.get(swing_lows, array.size(swing_lows) - 1)
        low1_price = array.get(swing_low_prices, array.size(swing_low_prices) - 2)
        low2_price = array.get(swing_low_prices, array.size(swing_low_prices) - 1)
        
        # Determine triangle type
        highs_declining = high2_price < high1_price
        lows_rising = low2_price > low1_price
        
        triangle_type = if highs_declining and lows_rising
            "symmetrical"
        else if highs_declining and not lows_rising
            "descending"
        else if not highs_declining and lows_rising
            "ascending"
        else
            "none"
        
        if triangle_type != "none"
            [high1_bar, high1_price, high2_bar, high2_price,
             low1_bar, low1_price, low2_bar, low2_price, triangle_type]
        else
            [na, na, na, na, na, na, na, na, "none"]
    else
        [na, na, na, na, na, na, na, na, "none"]

// Function to draw triangle pattern
draw_triangle_pattern(h1_bar, h1_price, h2_bar, h2_price, 
                     l1_bar, l1_price, l2_bar, l2_price, triangle_type) =>
    if triangle_type != "none"
        # Create upper trendline (highs)
        upper_points = array.new<polyline.point>()
        array.push(upper_points, polyline.point.new(time[bar_index - h1_bar], h1_price))
        array.push(upper_points, polyline.point.new(time[bar_index - h2_bar], h2_price))
        
        # Extend upper line to current bar
        bars_diff = h2_bar - h1_bar
        price_diff = h2_price - h1_price
        if bars_diff != 0
            slope = price_diff / bars_diff
            extended_price = h2_price + slope * (bar_index - h2_bar)
            array.push(upper_points, polyline.point.new(time, extended_price))
        
        # Create lower trendline (lows)
        lower_points = array.new<polyline.point>()
        array.push(lower_points, polyline.point.new(time[bar_index - l1_bar], l1_price))
        array.push(lower_points, polyline.point.new(time[bar_index - l2_bar], l2_price))
        
        # Extend lower line to current bar
        bars_diff := l2_bar - l1_bar
        price_diff := l2_price - l1_price
        if bars_diff != 0
            slope := price_diff / bars_diff
            extended_price := l2_price + slope * (bar_index - l2_bar)
            array.push(lower_points, polyline.point.new(time, extended_price))
        
        # Color based on triangle type
        line_color = switch triangle_type
            "ascending" => color.green
            "descending" => color.red
            "symmetrical" => color.blue
            => color.gray
        
        upper_line = polyline.new(
            points = upper_points,
            line_color = line_color,
            line_width = 2
        )
        
        lower_line = polyline.new(
            points = lower_points,
            line_color = line_color,
            line_width = 2
        )
        
        [upper_line, lower_line]
    else
        [polyline(na), polyline(na)]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PATTERN EXECUTION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

# Detect and draw patterns
if bar_index % 20 == 0  # Check every 20 bars for performance
    # Head and shoulders detection
    [ls, h, rs] = detect_head_shoulders(30)
    if not na(ls)
        [hs_pattern, hs_neckline] = draw_head_shoulders(ls, h, rs)
    
    # Triangle pattern detection
    [h1_bar, h1_price, h2_bar, h2_price, l1_bar, l1_price, l2_bar, l2_price, tri_type] = 
        detect_triangle_pattern(40)
    
    if tri_type != "none"
        [tri_upper, tri_lower] = draw_triangle_pattern(
            h1_bar, h1_price, h2_bar, h2_price,
            l1_bar, l1_price, l2_bar, l2_price, tri_type)
```

---

## Wave Analysis Visualization

### Elliott Wave Pattern Drawing
```pinescript
//@version=6
indicator("Elliott Wave Analysis", overlay=true, max_polylines_count=50, max_labels_count=50)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               ELLIOTT WAVE DETECTION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to find significant pivots for wave analysis
find_wave_pivots(lookback = 50, threshold_percent = 2.0) =>
    pivots = array.new<int>()
    pivot_prices = array.new<float>()
    pivot_types = array.new<string>()
    
    for i = lookback to 5  # Leave some bars for pivot confirmation
        pivot_high = ta.pivothigh(high, 5, 5)[i]
        pivot_low = ta.pivotlow(low, 5, 5)[i]
        
        if not na(pivot_high)
            # Check if this is a significant high
            prev_significant = na
            for j = 0 to array.size(pivot_prices) - 1
                if array.get(pivot_types, j) == "high"
                    prev_significant := array.get(pivot_prices, j)
                    break
            
            if na(prev_significant) or math.abs(pivot_high - prev_significant) / prev_significant * 100 > threshold_percent
                array.push(pivots, bar_index - i)
                array.push(pivot_prices, pivot_high)
                array.push(pivot_types, "high")
        
        if not na(pivot_low)
            # Check if this is a significant low
            prev_significant = na
            for j = 0 to array.size(pivot_prices) - 1
                if array.get(pivot_types, j) == "low"
                    prev_significant := array.get(pivot_prices, j)
                    break
            
            if na(prev_significant) or math.abs(pivot_low - prev_significant) / prev_significant * 100 > threshold_percent
                array.push(pivots, bar_index - i)
                array.push(pivot_prices, pivot_low)
                array.push(pivot_types, "low")
    
    [pivots, pivot_prices, pivot_types]

// Function to identify potential Elliott Wave sequence
identify_elliott_waves(pivots, prices, types) =>
    if array.size(pivots) < 8  # Need at least 8 points for 5 waves + 3 corrective
        array.new<string>()
    else
        waves = array.new<string>()
        
        # Simplified Elliott Wave rules:
        # 1. Wave 2 never retraces more than 100% of wave 1
        # 2. Wave 3 is never the shortest wave
        # 3. Wave 4 never overlaps wave 1 price territory
        
        for i = 0 to math.min(array.size(pivots) - 1, 7)  # Analyze up to 8 points
            wave_num = i + 1
            wave_label = wave_num <= 5 ? str.tostring(wave_num) : 
                        wave_num == 6 ? "A" : 
                        wave_num == 7 ? "B" : "C"
            array.push(waves, wave_label)
        
        waves

// Function to draw Elliott Wave pattern
draw_elliott_waves(pivots, prices, types, wave_labels) =>
    if array.size(pivots) >= 5
        wave_polylines = array.new<polyline>()
        wave_labels_drawn = array.new<label>()
        
        # Create points for the wave pattern
        wave_points = array.new<polyline.point>()
        
        for i = 0 to math.min(array.size(pivots) - 1, 7)  # Draw up to 8 points
            pivot_bar = array.get(pivots, i)
            pivot_price = array.get(prices, i)
            pivot_time = time[bar_index - pivot_bar]
            
            array.push(wave_points, polyline.point.new(pivot_time, pivot_price))
            
            # Add wave label
            if i < array.size(wave_labels)
                wave_label = array.get(wave_labels, i)
                label_color = i < 5 ? color.blue : color.red  # Impulse vs corrective
                
                label_id = label.new(
                    x = pivot_time,
                    y = pivot_price,
                    text = wave_label,
                    style = label.style_circle,
                    color = label_color,
                    textcolor = color.white,
                    size = size.normal
                )
                array.push(wave_labels_drawn, label_id)
        
        # Create main wave polyline
        main_wave = polyline.new(
            points = wave_points,
            line_color = color.blue,
            line_width = 3
        )
        array.push(wave_polylines, main_wave)
        
        # Draw Fibonacci retracement levels for wave corrections
        if array.size(pivots) >= 3
            draw_fibonacci_levels(pivots, prices, wave_polylines)
        
        [wave_polylines, wave_labels_drawn]
    else
        [array.new<polyline>(), array.new<label>()]

// Function to draw Fibonacci retracement levels
draw_fibonacci_levels(pivots, prices, polylines_array) =>
    if array.size(pivots) >= 2
        # Get the last two significant points
        point1_bar = array.get(pivots, array.size(pivots) - 2)
        point2_bar = array.get(pivots, array.size(pivots) - 1)
        point1_price = array.get(prices, array.size(prices) - 2)
        point2_price = array.get(prices, array.size(prices) - 1)
        
        point1_time = time[bar_index - point1_bar]
        point2_time = time[bar_index - point2_bar]
        
        # Fibonacci levels
        fib_levels = array.from(0.236, 0.382, 0.5, 0.618, 0.786)
        
        for i = 0 to array.size(fib_levels) - 1
            fib_ratio = array.get(fib_levels, i)
            fib_price = point1_price + (point2_price - point1_price) * fib_ratio
            
            # Create horizontal line at Fibonacci level
            fib_points = array.new<polyline.point>()
            array.push(fib_points, polyline.point.new(point1_time, fib_price))
            array.push(fib_points, polyline.point.new(point2_time, fib_price))
            
            # Extend line to current time
            array.push(fib_points, polyline.point.new(time, fib_price))
            
            fib_line = polyline.new(
                points = fib_points,
                line_color = color.new(color.orange, 70),
                line_style = line.style_dashed,
                line_width = 1
            )
            
            array.push(polylines_array, fib_line)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               HARMONIC PATTERNS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to detect Gartley pattern
detect_gartley_pattern(pivots, prices) =>
    if array.size(pivots) >= 5
        # Get the 5 most recent significant points (X, A, B, C, D)
        x_price = array.get(prices, array.size(prices) - 5)
        a_price = array.get(prices, array.size(prices) - 4)
        b_price = array.get(prices, array.size(prices) - 3)
        c_price = array.get(prices, array.size(prices) - 2)
        d_price = array.get(prices, array.size(prices) - 1)
        
        # Calculate ratios
        xa_range = math.abs(a_price - x_price)
        ab_ratio = xa_range == 0 ? 0 : math.abs(b_price - a_price) / xa_range
        ac_ratio = xa_range == 0 ? 0 : math.abs(c_price - a_price) / xa_range
        ad_ratio = xa_range == 0 ? 0 : math.abs(d_price - a_price) / xa_range
        
        # Gartley pattern ratios (with tolerance)
        tolerance = 0.05
        is_gartley = math.abs(ab_ratio - 0.618) < tolerance and
                     math.abs(ac_ratio - 0.382) < tolerance and
                     math.abs(ad_ratio - 0.786) < tolerance
        
        if is_gartley
            # Return the 5 points for drawing
            [array.get(pivots, array.size(pivots) - 5),
             array.get(pivots, array.size(pivots) - 4),
             array.get(pivots, array.size(pivots) - 3),
             array.get(pivots, array.size(pivots) - 2),
             array.get(pivots, array.size(pivots) - 1)]
        else
            [na, na, na, na, na]
    else
        [na, na, na, na, na]

// Function to draw Gartley pattern
draw_gartley_pattern(x_bar, a_bar, b_bar, c_bar, d_bar, prices) =>
    if not na(x_bar)
        points = array.new<polyline.point>()
        
        # Add all points
        array.push(points, polyline.point.new(time[bar_index - x_bar], array.get(prices, array.size(prices) - 5)))
        array.push(points, polyline.point.new(time[bar_index - a_bar], array.get(prices, array.size(prices) - 4)))
        array.push(points, polyline.point.new(time[bar_index - b_bar], array.get(prices, array.size(prices) - 3)))
        array.push(points, polyline.point.new(time[bar_index - c_bar], array.get(prices, array.size(prices) - 2)))
        array.push(points, polyline.point.new(time[bar_index - d_bar], array.get(prices, array.size(prices) - 1)))
        
        # Create Gartley polyline
        gartley_line = polyline.new(
            points = points,
            line_color = color.purple,
            line_width = 2
        )
        
        gartley_line
    else
        polyline(na)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               WAVE ANALYSIS EXECUTION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var wave_analysis_active = input.bool(true, "Enable Wave Analysis")

if wave_analysis_active and bar_index % 30 == 0  # Update every 30 bars
    # Find wave pivots
    [pivots, prices, types] = find_wave_pivots(100, 1.5)
    
    if array.size(pivots) >= 5
        # Identify Elliott waves
        wave_labels = identify_elliott_waves(pivots, prices, types)
        
        # Draw Elliott wave pattern
        [wave_polylines, label_array] = draw_elliott_waves(pivots, prices, types, wave_labels)
        
        # Detect Gartley pattern
        [x_bar, a_bar, b_bar, c_bar, d_bar] = detect_gartley_pattern(pivots, prices)
        if not na(x_bar)
            gartley_polyline = draw_gartley_pattern(x_bar, a_bar, b_bar, c_bar, d_bar, prices)
```

---

## Performance Considerations

### Optimizing Polyline Performance
```pinescript
//@version=6
indicator("Polyline Performance Optimization", overlay=true, max_polylines_count=500)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PERFORMANCE MONITORING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Track performance metrics
var performance_stats = map.new<string, array<float>>()
var polyline_count = 0
var operation_count = 0

// Initialize performance tracking
init_performance_tracking() =>
    metrics = array.from("creation_time", "update_time", "deletion_time", "memory_usage")
    for i = 0 to array.size(metrics) - 1
        metric = array.get(metrics, i)
        map.put(performance_stats, metric, array.new<float>())

if barstate.isfirst
    init_performance_tracking()

// Performance measurement wrapper
measure_operation(operation_name, operation_func) =>
    start_time = timenow
    result = operation_func
    end_time = timenow
    
    execution_time = end_time - start_time
    operation_count += 1
    
    if map.contains(performance_stats, operation_name)
        time_array = map.get(performance_stats, operation_name)
        array.push(time_array, execution_time)
        
        # Keep only last 50 measurements
        if array.size(time_array) > 50
            array.shift(time_array)
    
    result

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               EFFICIENT POLYLINE MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Polyline pool for reusing objects
var polyline_pool = array.new<polyline>()
var active_polylines = array.new<polyline>()
pool_size = 50

// Initialize polyline pool
init_polyline_pool() =>
    for i = 0 to pool_size - 1
        # Create a basic polyline and add to pool
        dummy_points = array.new<polyline.point>()
        array.push(dummy_points, polyline.point.new(time, close))
        array.push(dummy_points, polyline.point.new(time, close))
        
        pooled_line = polyline.new(
            points = dummy_points,
            line_color = color.gray,
            line_width = 1
        )
        
        polyline.delete(pooled_line)  # Hide it initially
        array.push(polyline_pool, pooled_line)

if barstate.isfirst
    init_polyline_pool()

// Get polyline from pool
get_pooled_polyline() =>
    if array.size(polyline_pool) > 0
        polyline_count += 1
        array.pop(polyline_pool)
    else
        # Create new if pool is empty
        dummy_points = array.new<polyline.point>()
        array.push(dummy_points, polyline.point.new(time, close))
        array.push(dummy_points, polyline.point.new(time, close))
        polyline_count += 1
        
        polyline.new(
            points = dummy_points,
            line_color = color.gray,
            line_width = 1
        )

// Return polyline to pool
return_to_pool(line_id) =>
    polyline.delete(line_id)  # Hide the polyline
    
    if array.size(polyline_pool) < pool_size
        array.push(polyline_pool, line_id)
        polyline_count -= 1

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               LEVEL OF DETAIL (LOD) SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Adaptive detail based on zoom level and performance
get_detail_level() =>
    # Estimate chart zoom level based on visible bars
    visible_bars = math.max(1, bar_index - ta.lowest(bar_index, 100))
    
    if visible_bars > 1000
        "low"        # Low detail for zoomed out view
    else if visible_bars > 500
        "medium"     # Medium detail
    else
        "high"       # High detail for zoomed in view

// Adaptive point reduction based on detail level
reduce_points_by_detail(points_array, detail_level) =>
    reduction_factor = switch detail_level
        "low" => 4      # Keep every 4th point
        "medium" => 2   # Keep every 2nd point
        "high" => 1     # Keep all points
        => 1
    
    if reduction_factor == 1 or array.size(points_array) <= reduction_factor
        points_array
    else
        reduced_points = array.new<polyline.point>()
        
        for i = 0 to array.size(points_array) - 1
            if i % reduction_factor == 0
                array.push(reduced_points, array.get(points_array, i))
        
        # Always include the last point
        if array.size(points_array) % reduction_factor != 0
            array.push(reduced_points, array.get(points_array, array.size(points_array) - 1))
        
        reduced_points

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               BATCH OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Batch create multiple polylines efficiently
batch_create_polylines(polylines_data) =>
    created_lines = array.new<polyline>()
    
    for i = 0 to array.size(polylines_data) - 1
        line_data = array.get(polylines_data, i)
        
        # Extract data (assuming specific format)
        if map.contains(line_data, "points") and map.contains(line_data, "color")
            points = map.get(line_data, "points")
            color_val = map.get(line_data, "color")
            
            # Create polyline with performance monitoring
            new_line = measure_operation("creation_time", 
                polyline.new(
                    points = points,
                    line_color = color_val,
                    line_width = 1
                ))
            
            array.push(created_lines, new_line)
    
    created_lines

// Batch delete polylines
batch_delete_polylines(lines_array) =>
    deletion_count = 0
    
    for i = 0 to array.size(lines_array) - 1
        line_id = array.get(lines_array, i)
        
        measure_operation("deletion_time", polyline.delete(line_id))
        deletion_count += 1
    
    array.clear(lines_array)
    deletion_count

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               MEMORY MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Estimate memory usage
estimate_memory_usage() =>
    # Rough estimates in bytes
    polyline_base_size = 64      # Base polyline object
    point_size = 16              # Each point (time + price)
    
    total_memory = 0
    
    # Count active polylines and their points
    for i = 0 to array.size(active_polylines) - 1
        # This is an approximation since we can't directly query point count
        estimated_points = 10  # Average estimate
        total_memory += polyline_base_size + (estimated_points * point_size)
    
    total_memory

// Cleanup old polylines when memory limit is approached
cleanup_old_polylines(max_memory_kb = 1024) =>
    current_memory = estimate_memory_usage()
    
    if current_memory > max_memory_kb * 1024  # Convert to bytes
        # Remove oldest polylines (FIFO)
        cleanup_count = array.size(active_polylines) / 4  # Remove 25%
        
        for i = 0 to cleanup_count - 1
            if array.size(active_polylines) > 0
                old_line = array.shift(active_polylines)
                return_to_pool(old_line)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PERFORMANCE DEMONSTRATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var demo_polylines = array.new<polyline>()

# Performance test: Create multiple polylines efficiently
if bar_index % 50 == 0 and bar_index > 100
    # Clean up old polylines first
    cleanup_old_polylines(512)  # 512KB limit
    
    # Get current detail level
    detail_level = get_detail_level()
    
    # Create demo points with adaptive detail
    demo_points = array.new<polyline.point>()
    for i = 20 to 1
        array.push(demo_points, polyline.point.new(time[i], close[i] + ta.atr(14) * math.random()))
    
    # Reduce points based on detail level
    optimized_points = reduce_points_by_detail(demo_points, detail_level)
    
    # Create polyline using pool
    new_line = get_pooled_polyline()
    # Note: In real implementation, you'd update the polyline with new points
    
    array.push(active_polylines, new_line)
    array.push(demo_polylines, new_line)
    
    # Maintain array size
    if array.size(demo_polylines) > 20
        old_line = array.shift(demo_polylines)
        return_to_pool(old_line)

// Display performance metrics
var table performance_table = table.new(position.bottom_left, 2, 4)

if barstate.islast
    table.clear(performance_table, 0, 0, 1, 3)
    
    table.cell(performance_table, 0, 0, "Performance", bgcolor=color.navy, text_color=color.white)
    table.cell(performance_table, 1, 0, "Value", bgcolor=color.navy, text_color=color.white)
    
    table.cell(performance_table, 0, 1, "Active Polylines")
    table.cell(performance_table, 1, 1, str.tostring(array.size(active_polylines)))
    
    table.cell(performance_table, 0, 2, "Memory (Est. KB)")
    table.cell(performance_table, 1, 2, str.tostring(estimate_memory_usage() / 1024, "0.1"))
    
    table.cell(performance_table, 0, 3, "Detail Level")
    table.cell(performance_table, 1, 3, get_detail_level())

// Plot performance metrics
creation_times = map.get(performance_stats, "creation_time")
avg_creation_time = array.size(creation_times) > 0 ? array.avg(creation_times) : 0
plot(avg_creation_time, "Avg Creation Time", color.blue)
plot(array.size(active_polylines), "Active Polylines", color.green)
```

---

## Managing Polyline Objects

### Advanced Polyline Management System
```pinescript
//@version=6
indicator("Polyline Management System", overlay=true, max_polylines_count=100, max_labels_count=50)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               POLYLINE REGISTRY SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Polyline registry for tracking and managing all polylines
var polyline_registry = map.new<string, polyline>()
var polyline_metadata = map.new<string, map<string, string>>()
var polyline_groups = map.new<string, array<string>>()

// Function to register a new polyline
register_polyline(id, line_obj, group = "default", metadata = na) =>
    # Store the polyline
    map.put(polyline_registry, id, line_obj)
    
    # Store metadata
    if not na(metadata)
        map.put(polyline_metadata, id, metadata)
    else
        default_metadata = map.new<string, string>()
        map.put(default_metadata, "created", str.tostring(time))
        map.put(default_metadata, "group", group)
        map.put(polyline_metadata, id, default_metadata)
    
    # Add to group
    if map.contains(polyline_groups, group)
        group_array = map.get(polyline_groups, group)
        array.push(group_array, id)
    else
        new_group = array.new<string>()
        array.push(new_group, id)
        map.put(polyline_groups, group, new_group)

// Function to unregister and delete polyline
unregister_polyline(id) =>
    if map.contains(polyline_registry, id)
        line_obj = map.get(polyline_registry, id)
        polyline.delete(line_obj)
        map.remove(polyline_registry, id)
        
        # Remove from metadata
        if map.contains(polyline_metadata, id)
            map.remove(polyline_metadata, id)
        
        # Remove from groups
        group_keys = map.keys(polyline_groups)
        for i = 0 to array.size(group_keys) - 1
            group_key = array.get(group_keys, i)
            group_array = map.get(polyline_groups, group_key)
            
            # Find and remove the ID
            for j = array.size(group_array) - 1 to 0
                if array.get(group_array, j) == id
                    array.remove(group_array, j)
                    break

// Function to get polyline by ID
get_polyline(id) =>
    if map.contains(polyline_registry, id)
        map.get(polyline_registry, id)
    else
        polyline(na)

// Function to update polyline properties
update_polyline_style(id, new_color = na, new_width = na, new_style = na) =>
    if map.contains(polyline_registry, id)
        line_obj = map.get(polyline_registry, id)
        
        # Note: Pine Script doesn't allow direct property updates
        # This would typically require recreating the polyline
        # For demonstration, we'll update metadata
        
        if map.contains(polyline_metadata, id)
            metadata = map.get(polyline_metadata, id)
            
            if not na(new_color)
                map.put(metadata, "color", str.tostring(new_color))
            if not na(new_width)
                map.put(metadata, "width", str.tostring(new_width))
            if not na(new_style)
                map.put(metadata, "style", str.tostring(new_style))
            
            map.put(metadata, "last_updated", str.tostring(time))

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               GROUP MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to show/hide entire groups
toggle_group_visibility(group_name, visible) =>
    if map.contains(polyline_groups, group_name)
        group_array = map.get(polyline_groups, group_name)
        
        for i = 0 to array.size(group_array) - 1
            polyline_id = array.get(group_array, i)
            
            if map.contains(polyline_registry, polyline_id)
                line_obj = map.get(polyline_registry, polyline_id)
                
                # In a full implementation, you'd modify visibility
                # For now, we'll delete if not visible
                if not visible
                    polyline.delete(line_obj)

// Function to delete entire group
delete_group(group_name) =>
    if map.contains(polyline_groups, group_name)
        group_array = map.get(polyline_groups, group_name)
        
        # Delete all polylines in group
        for i = 0 to array.size(group_array) - 1
            polyline_id = array.get(group_array, i)
            unregister_polyline(polyline_id)
        
        # Remove group
        map.remove(polyline_groups, group_name)

// Function to get group statistics
get_group_stats(group_name) =>
    if map.contains(polyline_groups, group_name)
        group_array = map.get(polyline_groups, group_name)
        
        active_count = 0
        total_points = 0
        
        for i = 0 to array.size(group_array) - 1
            polyline_id = array.get(group_array, i)
            
            if map.contains(polyline_registry, polyline_id)
                active_count += 1
                # Note: Can't directly count points in Pine Script
                total_points += 5  # Estimated average
        
        [active_count, total_points]
    else
        [0, 0]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               LIFECYCLE MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to manage polyline lifecycle
manage_polyline_lifecycle(max_age_ms = 3600000) =>  # 1 hour default
    current_time = time
    expired_ids = array.new<string>()
    
    # Check all polylines for expiration
    registry_keys = map.keys(polyline_registry)
    
    for i = 0 to array.size(registry_keys) - 1
        polyline_id = array.get(registry_keys, i)
        
        if map.contains(polyline_metadata, polyline_id)
            metadata = map.get(polyline_metadata, polyline_id)
            
            if map.contains(metadata, "created")
                created_time = str.tonumber(map.get(metadata, "created"))
                
                if not na(created_time) and (current_time - created_time) > max_age_ms
                    array.push(expired_ids, polyline_id)
    
    # Remove expired polylines
    for i = 0 to array.size(expired_ids) - 1
        expired_id = array.get(expired_ids, i)
        unregister_polyline(expired_id)
    
    array.size(expired_ids)  # Return count of expired

// Function to cleanup by usage pattern
cleanup_by_usage(keep_recent_count = 50) =>
    registry_keys = map.keys(polyline_registry)
    
    if array.size(registry_keys) > keep_recent_count
        # Sort by creation time (simplified - just remove oldest)
        removal_count = array.size(registry_keys) - keep_recent_count
        
        for i = 0 to removal_count - 1
            oldest_id = array.get(registry_keys, i)
            unregister_polyline(oldest_id)
        
        removal_count
    else
        0

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               QUERY AND SEARCH FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to find polylines by criteria
find_polylines_by_criteria(criteria_key, criteria_value) =>
    matching_ids = array.new<string>()
    registry_keys = map.keys(polyline_registry)
    
    for i = 0 to array.size(registry_keys) - 1
        polyline_id = array.get(registry_keys, i)
        
        if map.contains(polyline_metadata, polyline_id)
            metadata = map.get(polyline_metadata, polyline_id)
            
            if map.contains(metadata, criteria_key)
                value = map.get(metadata, criteria_key)
                
                if value == criteria_value
                    array.push(matching_ids, polyline_id)
    
    matching_ids

// Function to get polylines within time range
get_polylines_in_time_range(start_time, end_time) =>
    matching_ids = array.new<string>()
    registry_keys = map.keys(polyline_registry)
    
    for i = 0 to array.size(registry_keys) - 1
        polyline_id = array.get(registry_keys, i)
        
        if map.contains(polyline_metadata, polyline_id)
            metadata = map.get(polyline_metadata, polyline_id)
            
            if map.contains(metadata, "created")
                created_time = str.tonumber(map.get(metadata, "created"))
                
                if not na(created_time) and created_time >= start_time and created_time <= end_time
                    array.push(matching_ids, polyline_id)
    
    matching_ids

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               DEMONSTRATION SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Create demonstration polylines with management
if bar_index % 25 == 0 and bar_index > 50
    # Create trend lines group
    trend_points = array.new<polyline.point>()
    array.push(trend_points, polyline.point.new(time[20], low[20]))
    array.push(trend_points, polyline.point.new(time[10], high[10]))
    array.push(trend_points, polyline.point.new(time, close))
    
    trend_line = polyline.new(
        points = trend_points,
        line_color = color.blue,
        line_width = 2
    )
    
    # Register with metadata
    line_id = "trend_" + str.tostring(bar_index)
    trend_metadata = map.new<string, string>()
    map.put(trend_metadata, "type", "trend")
    map.put(trend_metadata, "timeframe", timeframe.period)
    map.put(trend_metadata, "created", str.tostring(time))
    
    register_polyline(line_id, trend_line, "trends", trend_metadata)

# Periodic cleanup
if bar_index % 100 == 0
    expired_count = manage_polyline_lifecycle(1800000)  # 30 minutes
    cleanup_count = cleanup_by_usage(30)

# Management controls
show_trends = input.bool(true, "Show Trend Lines")
show_patterns = input.bool(true, "Show Pattern Lines")

if not show_trends
    toggle_group_visibility("trends", false)

if not show_patterns
    toggle_group_visibility("patterns", false)

// Display management statistics
var table mgmt_table = table.new(position.top_left, 2, 5)

if barstate.islast
    table.clear(mgmt_table, 0, 0, 1, 4)
    
    table.cell(mgmt_table, 0, 0, "Polyline Manager", bgcolor=color.navy, text_color=color.white)
    table.cell(mgmt_table, 1, 0, "Stats", bgcolor=color.navy, text_color=color.white)
    
    total_lines = array.size(map.keys(polyline_registry))
    table.cell(mgmt_table, 0, 1, "Total Lines")
    table.cell(mgmt_table, 1, 1, str.tostring(total_lines))
    
    total_groups = array.size(map.keys(polyline_groups))
    table.cell(mgmt_table, 0, 2, "Groups")
    table.cell(mgmt_table, 1, 2, str.tostring(total_groups))
    
    [trend_count, trend_points] = get_group_stats("trends")
    table.cell(mgmt_table, 0, 3, "Trend Lines")
    table.cell(mgmt_table, 1, 3, str.tostring(trend_count))
    
    recent_lines = array.size(get_polylines_in_time_range(time - 3600000, time))
    table.cell(mgmt_table, 0, 4, "Recent (1h)")
    table.cell(mgmt_table, 1, 4, str.tostring(recent_lines))
```

---

## Animation Effects

### Dynamic Polyline Animation
```pinescript
//@version=6
indicator("Polyline Animation Effects", overlay=true, max_polylines_count=100)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               ANIMATION FRAMEWORK
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Animation state management
var animation_states = map.new<string, map<string, float>>()
var animation_polylines = map.new<string, polyline>()

// Function to create animation state
create_animation_state(animation_id, start_value, end_value, duration_bars, easing_type = "linear") =>
    state = map.new<string, float>()
    map.put(state, "start_value", start_value)
    map.put(state, "end_value", end_value)
    map.put(state, "duration", duration_bars)
    map.put(state, "start_bar", bar_index)
    map.put(state, "current_value", start_value)
    map.put(state, "progress", 0.0)
    map.put(state, "easing", easing_type == "ease_in" ? 1.0 : easing_type == "ease_out" ? 2.0 : 0.0)
    
    map.put(animation_states, animation_id, state)

// Function to update animation
update_animation(animation_id) =>
    if map.contains(animation_states, animation_id)
        state = map.get(animation_states, animation_id)
        
        start_bar = map.get(state, "start_bar")
        duration = map.get(state, "duration")
        start_value = map.get(state, "start_value")
        end_value = map.get(state, "end_value")
        easing = map.get(state, "easing")
        
        # Calculate progress
        elapsed_bars = bar_index - start_bar
        progress = math.min(1.0, elapsed_bars / duration)
        
        # Apply easing
        eased_progress = switch
            easing == 1.0 => progress * progress  # Ease in
            easing == 2.0 => 1 - math.pow(1 - progress, 2)  # Ease out
            => progress  # Linear
        
        # Calculate current value
        current_value = start_value + (end_value - start_value) * eased_progress
        
        # Update state
        map.put(state, "progress", progress)
        map.put(state, "current_value", current_value)
        
        # Return current value and completion status
        [current_value, progress >= 1.0]
    else
        [na, true]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               GROWING LINE ANIMATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to create growing line effect
create_growing_line(start_time, start_price, end_time, end_price, duration_bars, line_id) =>
    # Create animation for line growth
    create_animation_state(line_id + "_growth", 0.0, 1.0, duration_bars, "ease_out")
    
    # Store line parameters
    line_data = map.new<string, float>()
    map.put(line_data, "start_time", start_time)
    map.put(line_data, "start_price", start_price)
    map.put(line_data, "end_time", end_time)
    map.put(line_data, "end_price", end_price)
    
    map.put(animation_states, line_id + "_data", line_data)

// Function to update growing line
update_growing_line(line_id) =>
    [growth_progress, is_complete] = update_animation(line_id + "_growth")
    
    if not na(growth_progress) and map.contains(animation_states, line_id + "_data")
        line_data = map.get(animation_states, line_id + "_data")
        
        start_time = map.get(line_data, "start_time")
        start_price = map.get(line_data, "start_price")
        end_time = map.get(line_data, "end_time")
        end_price = map.get(line_data, "end_price")
        
        # Calculate current end point
        current_end_time = start_time + (end_time - start_time) * growth_progress
        current_end_price = start_price + (end_price - start_price) * growth_progress
        
        # Create/update polyline
        points = array.new<polyline.point>()
        array.push(points, polyline.point.new(int(start_time), start_price))
        array.push(points, polyline.point.new(int(current_end_time), current_end_price))
        
        # Remove previous polyline if exists
        if map.contains(animation_polylines, line_id)
            old_line = map.get(animation_polylines, line_id)
            polyline.delete(old_line)
        
        # Create new polyline
        new_line = polyline.new(
            points = points,
            line_color = color.new(color.blue, int(50 * (1 - growth_progress))),  # Fade in
            line_width = int(1 + 2 * growth_progress)  # Grow width
        )
        
        map.put(animation_polylines, line_id, new_line)
        
        is_complete

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PULSING ANIMATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to create pulsing effect
create_pulsing_polyline(points_array, base_color, pulse_duration, line_id) =>
    # Store polyline data
    pulse_data = map.new<string, float>()
    map.put(pulse_data, "base_color", base_color)
    map.put(pulse_data, "pulse_duration", pulse_duration)
    map.put(pulse_data, "start_bar", bar_index)
    
    map.put(animation_states, line_id + "_pulse_data", pulse_data)
    
    # Create initial polyline
    initial_line = polyline.new(
        points = points_array,
        line_color = base_color,
        line_width = 2
    )
    
    map.put(animation_polylines, line_id, initial_line)

// Function to update pulsing effect
update_pulsing_polyline(line_id, points_array) =>
    if map.contains(animation_states, line_id + "_pulse_data")
        pulse_data = map.get(animation_states, line_id + "_pulse_data")
        
        start_bar = map.get(pulse_data, "start_bar")
        pulse_duration = map.get(pulse_data, "pulse_duration")
        base_color = map.get(pulse_data, "base_color")
        
        # Calculate pulse phase
        elapsed = (bar_index - start_bar) % int(pulse_duration)
        pulse_progress = elapsed / pulse_duration
        
        # Create sine wave pulse
        pulse_intensity = (math.sin(pulse_progress * 2 * math.pi) + 1) / 2
        
        # Calculate pulsing properties
        pulse_transparency = int(20 + 60 * pulse_intensity)
        pulse_width = int(1 + 3 * pulse_intensity)
        
        # Remove old polyline
        if map.contains(animation_polylines, line_id)
            old_line = map.get(animation_polylines, line_id)
            polyline.delete(old_line)
        
        # Create new polyline with pulse effect
        pulse_line = polyline.new(
            points = points_array,
            line_color = color.new(base_color, pulse_transparency),
            line_width = pulse_width
        )
        
        map.put(animation_polylines, line_id, pulse_line)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               WAVE ANIMATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to create animated wave
create_wave_animation(start_time, start_price, end_time, amplitude, frequency, wave_id) =>
    wave_data = map.new<string, float>()
    map.put(wave_data, "start_time", start_time)
    map.put(wave_data, "start_price", start_price)
    map.put(wave_data, "end_time", end_time)
    map.put(wave_data, "amplitude", amplitude)
    map.put(wave_data, "frequency", frequency)
    map.put(wave_data, "start_bar", bar_index)
    
    map.put(animation_states, wave_id + "_wave_data", wave_data)

// Function to update wave animation
update_wave_animation(wave_id, segments = 50) =>
    if map.contains(animation_states, wave_id + "_wave_data")
        wave_data = map.get(animation_states, wave_id + "_wave_data")
        
        start_time = map.get(wave_data, "start_time")
        start_price = map.get(wave_data, "start_price")
        end_time = map.get(wave_data, "end_time")
        amplitude = map.get(wave_data, "amplitude")
        frequency = map.get(wave_data, "frequency")
        start_bar = map.get(wave_data, "start_bar")
        
        # Calculate animation phase
        animation_time = (bar_index - start_bar) * 0.1  # Animation speed
        
        # Create wave points
        wave_points = array.new<polyline.point>()
        time_span = end_time - start_time
        
        for i = 0 to segments
            progress = i / segments
            current_time = start_time + time_span * progress
            
            # Create moving wave
            wave_phase = 2 * math.pi * frequency * progress + animation_time
            wave_offset = amplitude * math.sin(wave_phase)
            current_price = start_price + wave_offset
            
            array.push(wave_points, polyline.point.new(int(current_time), current_price))
        
        # Remove old wave
        if map.contains(animation_polylines, wave_id)
            old_wave = map.get(animation_polylines, wave_id)
            polyline.delete(old_wave)
        
        # Create new wave
        new_wave = polyline.new(
            points = wave_points,
            line_color = color.new(color.purple, 30),
            line_width = 2
        )
        
        map.put(animation_polylines, wave_id, new_wave)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               MORPHING ANIMATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to morph between two polylines
create_morph_animation(start_points, end_points, duration_bars, morph_id) =>
    if array.size(start_points) == array.size(end_points)
        morph_data = map.new<string, float>()
        map.put(morph_data, "duration", duration_bars)
        map.put(morph_data, "start_bar", bar_index)
        map.put(morph_data, "point_count", array.size(start_points))
        
        map.put(animation_states, morph_id + "_morph_data", morph_data)
        
        # Store start and end points (simplified storage)
        # In real implementation, you'd need more sophisticated point storage

// Function to update morph animation
update_morph_animation(morph_id, start_points, end_points) =>
    if map.contains(animation_states, morph_id + "_morph_data") and 
       array.size(start_points) == array.size(end_points)
        
        morph_data = map.get(animation_states, morph_id + "_morph_data")
        duration = map.get(morph_data, "duration")
        start_bar = map.get(morph_data, "start_bar")
        
        # Calculate morph progress
        elapsed = bar_index - start_bar
        morph_progress = math.min(1.0, elapsed / duration)
        
        # Interpolate between start and end points
        morphed_points = array.new<polyline.point>()
        
        for i = 0 to array.size(start_points) - 1
            start_point = array.get(start_points, i)
            end_point = array.get(end_points, i)
            
            start_time = polyline.point.time(start_point)
            start_price = polyline.point.index(start_point)
            end_time = polyline.point.time(end_point)
            end_price = polyline.point.index(end_point)
            
            # Interpolate
            current_time = start_time + (end_time - start_time) * morph_progress
            current_price = start_price + (end_price - start_price) * morph_progress
            
            array.push(morphed_points, polyline.point.new(int(current_time), current_price))
        
        # Remove old morph
        if map.contains(animation_polylines, morph_id)
            old_morph = map.get(animation_polylines, morph_id)
            polyline.delete(old_morph)
        
        # Create morphed polyline
        morphed_line = polyline.new(
            points = morphed_points,
            line_color = color.new(color.orange, int(80 * (1 - morph_progress))),
            line_width = 2
        )
        
        map.put(animation_polylines, morph_id, morphed_line)
        
        morph_progress >= 1.0

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               ANIMATION DEMONSTRATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

# Create growing line animation every 50 bars
if bar_index % 50 == 0 and bar_index > 50
    line_id = "growing_" + str.tostring(bar_index)
    create_growing_line(time[30], low[30], time, high, 20, line_id)

# Update all growing lines
growing_line_id = "growing_" + str.tostring(bar_index - (bar_index % 50))
if map.contains(animation_states, growing_line_id + "_growth")
    update_growing_line(growing_line_id)

# Create pulsing polyline
if bar_index % 100 == 0 and bar_index > 50
    pulse_points = array.new<polyline.point>()
    array.push(pulse_points, polyline.point.new(time[20], close[20]))
    array.push(pulse_points, polyline.point.new(time[10], close[10]))
    array.push(pulse_points, polyline.point.new(time, close))
    
    pulse_id = "pulse_" + str.tostring(bar_index)
    create_pulsing_polyline(pulse_points, color.green, 20, pulse_id)

# Update pulsing polylines
pulse_id = "pulse_" + str.tostring(bar_index - (bar_index % 100))
if map.contains(animation_states, pulse_id + "_pulse_data")
    pulse_points = array.new<polyline.point>()
    array.push(pulse_points, polyline.point.new(time[20], close[20]))
    array.push(pulse_points, polyline.point.new(time[10], close[10]))
    array.push(pulse_points, polyline.point.new(time, close))
    
    update_pulsing_polyline(pulse_id, pulse_points)

# Create wave animation
if bar_index % 75 == 0 and bar_index > 50
    wave_id = "wave_" + str.tostring(bar_index)
    create_wave_animation(time[40], close[40], time, ta.atr(14), 3, wave_id)

# Update wave animations
wave_id = "wave_" + str.tostring(bar_index - (bar_index % 75))
if map.contains(animation_states, wave_id + "_wave_data")
    update_wave_animation(wave_id, 30)

plot(close, "Price", color.gray, 1)  # Reference price line
```

---

## Interactive Polylines

### User Interaction and Dynamic Response
```pinescript
//@version=6
indicator("Interactive Polylines", overlay=true, max_polylines_count=50, max_labels_count=20)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               INTERACTIVE FRAMEWORK
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Input controls for user interaction
enable_drawing = input.bool(true, "Enable Drawing Mode", group="Interactive Controls")
drawing_mode = input.string("Trend Line", "Drawing Mode", 
                           options=["Trend Line", "Support/Resistance", "Pattern", "Wave"], 
                           group="Interactive Controls")
line_color = input.color(color.blue, "Line Color", group="Interactive Controls")
line_width = input.int(2, "Line Width", minval=1, maxval=5, group="Interactive Controls")
auto_extend = input.bool(true, "Auto Extend Lines", group="Interactive Controls")

// Advanced interaction settings
snap_to_highs_lows = input.bool(true, "Snap to Highs/Lows", group="Advanced")
min_touch_points = input.int(2, "Minimum Touch Points", minval=2, maxval=5, group="Advanced")
sensitivity = input.float(1.0, "Price Sensitivity %", minval=0.1, maxval=5.0, group="Advanced")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               CLICK DETECTION SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Simulate click detection using price and time criteria
var click_points = array.new<map<string, float>>()
var drawing_state = "waiting"  # "waiting", "drawing", "complete"
var current_drawing = array.new<polyline.point>()

// Function to detect significant price points (simulating clicks)
detect_significant_points() =>
    is_significant = false
    current_time = time
    current_price = close
    
    # Detect based on volume spikes and price action
    volume_threshold = ta.sma(volume, 20) * 1.5
    price_change = math.abs(ta.change(close))
    avg_change = ta.sma(math.abs(ta.change(close)), 20)
    
    # Significant if high volume or large price movement
    if volume > volume_threshold or price_change > avg_change * 2
        is_significant := true
    
    # Snap to highs/lows if enabled
    if is_significant and snap_to_highs_lows
        high_pivot = ta.pivothigh(high, 2, 2)
        low_pivot = ta.pivotlow(low, 2, 2)
        
        if not na(high_pivot)
            current_price := high_pivot
            current_time := time[2]
        else if not na(low_pivot)
            current_price := low_pivot
            current_time := time[2]
    
    [is_significant, current_time, current_price]

// Function to add point to current drawing
add_point_to_drawing(point_time, point_price) =>
    new_point = polyline.point.new(point_time, point_price)
    array.push(current_drawing, new_point)
    
    # Store click metadata
    click_data = map.new<string, float>()
    map.put(click_data, "time", point_time)
    map.put(click_data, "price", point_price)
    map.put(click_data, "bar_index", bar_index)
    array.push(click_points, click_data)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               SMART LINE DRAWING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var interactive_polylines = array.new<polyline>()
var line_labels = array.new<label>()

// Function to create intelligent trend line
create_smart_trend_line(points_array) =>
    if array.size(points_array) >= 2
        # Validate points for trend line quality
        is_valid_trend = validate_trend_line_quality(points_array)
        
        if is_valid_trend
            # Create polyline
            trend_line = polyline.new(
                points = array.copy(points_array),
                line_color = line_color,
                line_width = line_width
            )
            
            array.push(interactive_polylines, trend_line)
            
            # Add extension if enabled
            if auto_extend
                extend_trend_line(points_array, trend_line)
            
            # Add label with line statistics
            add_trend_line_label(points_array, trend_line)
            
            trend_line
        else
            polyline(na)
    else
        polyline(na)

// Function to validate trend line quality
validate_trend_line_quality(points_array) =>
    if array.size(points_array) < 2
        false
    else
        # Check if points form a meaningful trend
        point1 = array.get(points_array, 0)
        point2 = array.get(points_array, array.size(points_array) - 1)
        
        time_diff = polyline.point.time(point2) - polyline.point.time(point1)
        price_diff = math.abs(polyline.point.index(point2) - polyline.point.index(point1))
        
        # Minimum time and price difference required
        min_time_diff = 5 * 60000  # 5 minutes
        min_price_diff = ta.atr(14) * 0.5
        
        time_diff > min_time_diff and price_diff > min_price_diff

// Function to extend trend line
extend_trend_line(points_array, trend_line) =>
    if array.size(points_array) >= 2
        # Calculate trend line slope
        point1 = array.get(points_array, 0)
        point2 = array.get(points_array, array.size(points_array) - 1)
        
        time1 = polyline.point.time(point1)
        price1 = polyline.point.index(point1)
        time2 = polyline.point.time(point2)
        price2 = polyline.point.index(point2)
        
        # Calculate slope
        time_diff = time2 - time1
        price_diff = price2 - price1
        
        if time_diff != 0
            slope = price_diff / time_diff
            
            # Extend into future
            future_time = time + 20 * 60000  # 20 minutes ahead
            future_price = price2 + slope * (future_time - time2)
            
            # Add extension point
            extension_point = polyline.point.new(future_time, future_price)
            extended_points = array.copy(points_array)
            array.push(extended_points, extension_point)
            
            # Update polyline (create new one)
            polyline.delete(trend_line)
            extended_line = polyline.new(
                points = extended_points,
                line_color = color.new(line_color, 50),
                line_style = line.style_dashed,
                line_width = line_width
            )
            
            extended_line

// Function to add informative label
add_trend_line_label(points_array, trend_line) =>
    if array.size(points_array) >= 2
        # Calculate line statistics
        point1 = array.get(points_array, 0)
        point2 = array.get(points_array, array.size(points_array) - 1)
        
        price1 = polyline.point.index(point1)
        price2 = polyline.point.index(point2)
        time1 = polyline.point.time(point1)
        time2 = polyline.point.time(point2)
        
        # Calculate angle and strength
        price_change = ((price2 - price1) / price1) * 100
        time_hours = (time2 - time1) / 3600000  # Convert to hours
        
        # Create label text
        label_text = drawing_mode + "\n" +
                    "Change: " + str.tostring(price_change, "0.2") + "%\n" +
                    "Time: " + str.tostring(time_hours, "0.1") + "h"
        
        # Position label at midpoint
        mid_time = time1 + (time2 - time1) / 2
        mid_price = price1 + (price2 - price1) / 2
        
        trend_label = label.new(
            x = int(mid_time),
            y = mid_price,
            text = label_text,
            style = label.style_label_down,
            color = color.new(line_color, 80),
            textcolor = color.white,
            size = size.small
        )
        
        array.push(line_labels, trend_label)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PATTERN RECOGNITION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to detect drawing patterns automatically
detect_drawing_patterns(points_array) =>
    if array.size(points_array) >= 3
        pattern_type = "unknown"
        
        # Analyze point relationships
        if array.size(points_array) == 3
            pattern_type := analyze_triangle_pattern(points_array)
        else if array.size(points_array) >= 4
            pattern_type := analyze_complex_pattern(points_array)
        
        pattern_type
    else
        "incomplete"

// Function to analyze triangle patterns
analyze_triangle_pattern(points_array) =>
    if array.size(points_array) == 3
        p1 = array.get(points_array, 0)
        p2 = array.get(points_array, 1)
        p3 = array.get(points_array, 2)
        
        price1 = polyline.point.index(p1)
        price2 = polyline.point.index(p2)
        price3 = polyline.point.index(p3)
        
        # Simple triangle classification
        if price2 > price1 and price2 > price3
            "triangle_peak"
        else if price2 < price1 and price2 < price3
            "triangle_valley"
        else
            "triangle_side"
    else
        "unknown"

// Function to analyze complex patterns
analyze_complex_pattern(points_array) =>
    # Simplified pattern analysis
    trend_changes = 0
    
    for i = 1 to array.size(points_array) - 1
        prev_point = array.get(points_array, i - 1)
        curr_point = array.get(points_array, i)
        
        prev_price = polyline.point.index(prev_point)
        curr_price = polyline.point.index(curr_point)
        
        if i == 1
            last_trend = curr_price > prev_price ? "up" : "down"
        else
            current_trend = curr_price > prev_price ? "up" : "down"
            if current_trend != last_trend
                trend_changes += 1
            last_trend := current_trend
    
    # Classify based on trend changes
    if trend_changes >= 3
        "complex_pattern"
    else if trend_changes == 2
        "wave_pattern"
    else
        "trend_line"

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               INTERACTIVE PROCESSING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

# Process user interaction simulation
if enable_drawing
    [is_significant, point_time, point_price] = detect_significant_points()
    
    if is_significant
        if drawing_state == "waiting"
            # Start new drawing
            array.clear(current_drawing)
            drawing_state := "drawing"
            add_point_to_drawing(point_time, point_price)
            
        else if drawing_state == "drawing"
            # Add point to current drawing
            add_point_to_drawing(point_time, point_price)
            
            # Check if drawing is complete
            if array.size(current_drawing) >= min_touch_points
                # Analyze pattern
                pattern_type = detect_drawing_patterns(current_drawing)
                
                # Create appropriate polyline based on mode and pattern
                final_line = switch drawing_mode
                    "Trend Line" => create_smart_trend_line(current_drawing)
                    "Support/Resistance" => create_support_resistance_line(current_drawing)
                    "Pattern" => create_pattern_line(current_drawing, pattern_type)
                    "Wave" => create_wave_line(current_drawing)
                    => create_smart_trend_line(current_drawing)
                
                # Reset for next drawing
                drawing_state := "waiting"
                array.clear(current_drawing)

// Function to create support/resistance line
create_support_resistance_line(points_array) =>
    if array.size(points_array) >= 2
        # Find horizontal level that best fits points
        prices = array.new<float>()
        for i = 0 to array.size(points_array) - 1
            point = array.get(points_array, i)
            array.push(prices, polyline.point.index(point))
        
        avg_price = array.avg(prices)
        
        # Create horizontal line
        first_point = array.get(points_array, 0)
        last_point = array.get(points_array, array.size(points_array) - 1)
        
        sr_points = array.new<polyline.point>()
        array.push(sr_points, polyline.point.new(polyline.point.time(first_point), avg_price))
        array.push(sr_points, polyline.point.new(polyline.point.time(last_point), avg_price))
        
        # Extend if enabled
        if auto_extend
            array.push(sr_points, polyline.point.new(time + 30 * 60000, avg_price))
        
        sr_line = polyline.new(
            points = sr_points,
            line_color = color.orange,
            line_width = line_width,
            line_style = line.style_dashed
        )
        
        array.push(interactive_polylines, sr_line)
        sr_line
    else
        polyline(na)

// Function to create pattern line
create_pattern_line(points_array, pattern_type) =>
    if array.size(points_array) >= 2
        pattern_color = switch pattern_type
            "triangle_peak" => color.red
            "triangle_valley" => color.green
            "wave_pattern" => color.purple
            "complex_pattern" => color.orange
            => color.blue
        
        pattern_line = polyline.new(
            points = array.copy(points_array),
            line_color = pattern_color,
            line_width = line_width + 1
        )
        
        array.push(interactive_polylines, pattern_line)
        pattern_line
    else
        polyline(na)

// Function to create wave line
create_wave_line(points_array) =>
    if array.size(points_array) >= 3
        # Smooth the wave using interpolation
        smoothed_points = array.new<polyline.point>()
        
        for i = 0 to array.size(points_array) - 1
            array.push(smoothed_points, array.get(points_array, i))
            
            # Add interpolated points between consecutive points
            if i < array.size(points_array) - 1
                current_point = array.get(points_array, i)
                next_point = array.get(points_array, i + 1)
                
                # Add one interpolated point
                mid_time = (polyline.point.time(current_point) + polyline.point.time(next_point)) / 2
                mid_price = (polyline.point.index(current_point) + polyline.point.index(next_point)) / 2
                
                array.push(smoothed_points, polyline.point.new(int(mid_time), mid_price))
        
        wave_line = polyline.new(
            points = smoothed_points,
            line_color = color.new(color.purple, 30),
            line_width = 3
        )
        
        array.push(interactive_polylines, wave_line)
        wave_line
    else
        polyline(na)

// Display interaction status
var table status_table = table.new(position.bottom_right, 2, 4)

if barstate.islast
    table.clear(status_table, 0, 0, 1, 3)
    
    table.cell(status_table, 0, 0, "Interactive Drawing", bgcolor=color.navy, text_color=color.white)
    table.cell(status_table, 1, 0, "Status", bgcolor=color.navy, text_color=color.white)
    
    table.cell(status_table, 0, 1, "Mode")
    table.cell(status_table, 1, 1, drawing_mode)
    
    table.cell(status_table, 0, 2, "State")
    table.cell(status_table, 1, 2, drawing_state)
    
    table.cell(status_table, 0, 3, "Lines Drawn")
    table.cell(status_table, 1, 3, str.tostring(array.size(interactive_polylines)))

# Cleanup old drawings periodically
if array.size(interactive_polylines) > 20
    old_line = array.shift(interactive_polylines)
    polyline.delete(old_line)

if array.size(line_labels) > 10
    old_label = array.shift(line_labels)
    label.delete(old_label)
```

This comprehensive guide demonstrates the full power of Pine Script v6 polylines, from basic creation to advanced interactive systems. These techniques enable the creation of sophisticated chart analysis tools and dynamic visual elements that enhance trading analysis and user experience.