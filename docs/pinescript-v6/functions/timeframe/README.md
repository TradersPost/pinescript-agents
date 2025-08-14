# Timeframe Functions - Pine Script v6

This documentation covers all timeframe, time, and session-related functions in Pine Script v6.

## Table of Contents

1. [Timeframe Functions](#timeframe-functions)
2. [Time Functions](#time-functions)
3. [Session Functions](#session-functions)
4. [Practical Examples](#practical-examples)
5. [Best Practices](#best-practices)

---

## Timeframe Functions

### timeframe.change()

Detects when a new bar begins on the specified timeframe.

**Syntax:**
```pinescript
timeframe.change(timeframe) → series bool
```

**Parameters:**
- `timeframe` (simple string): Timeframe string (e.g., "1D", "4H", "15")

**Returns:** `true` when a new bar begins on the specified timeframe

**Example:**
```pinescript
//@version=6
indicator("Timeframe Change Detection", overlay=true)

// Detect new daily bar
newDay = timeframe.change("1D")
newWeek = timeframe.change("1W")

// Plot markers
plotshape(newDay, style=shape.labelup, location=location.belowbar, 
          color=color.blue, text="D", size=size.small)
plotshape(newWeek, style=shape.labelup, location=location.belowbar, 
          color=color.red, text="W", size=size.normal)
```

### timeframe.in_seconds()

Converts a timeframe string to its equivalent in seconds.

**Syntax:**
```pinescript
timeframe.in_seconds(timeframe) → simple int
```

**Parameters:**
- `timeframe` (simple string): Timeframe string

**Returns:** Number of seconds in the timeframe

**Example:**
```pinescript
//@version=6
indicator("Timeframe to Seconds")

// Convert various timeframes
tf1m = timeframe.in_seconds("1")     // 60 seconds
tf5m = timeframe.in_seconds("5")     // 300 seconds
tf1h = timeframe.in_seconds("60")    // 3600 seconds
tf1d = timeframe.in_seconds("1D")    // 86400 seconds

// Display in table
var table infoTable = table.new(position.top_right, 2, 5, bgcolor=color.white, border_width=1)
if barstate.islast
    table.cell(infoTable, 0, 0, "Timeframe", text_color=color.black, bgcolor=color.gray)
    table.cell(infoTable, 1, 0, "Seconds", text_color=color.black, bgcolor=color.gray)
    table.cell(infoTable, 0, 1, "1m", text_color=color.black)
    table.cell(infoTable, 1, 1, str.tostring(tf1m), text_color=color.black)
    table.cell(infoTable, 0, 2, "5m", text_color=color.black)
    table.cell(infoTable, 1, 2, str.tostring(tf5m), text_color=color.black)
    table.cell(infoTable, 0, 3, "1h", text_color=color.black)
    table.cell(infoTable, 1, 3, str.tostring(tf1h), text_color=color.black)
    table.cell(infoTable, 0, 4, "1D", text_color=color.black)
    table.cell(infoTable, 1, 4, str.tostring(tf1d), text_color=color.black)
```

### timeframe.from_seconds()

Converts seconds to a timeframe string.

**Syntax:**
```pinescript
timeframe.from_seconds(seconds) → simple string
```

**Parameters:**
- `seconds` (simple int): Number of seconds

**Returns:** Timeframe string representation

**Example:**
```pinescript
//@version=6
indicator("Seconds to Timeframe")

// Convert seconds to timeframes
tf1 = timeframe.from_seconds(300)    // "5"
tf2 = timeframe.from_seconds(3600)   // "60"
tf3 = timeframe.from_seconds(86400)  // "1D"

// Display current timeframe info
currentTfSeconds = timeframe.in_seconds(timeframe.period)
convertedBack = timeframe.from_seconds(currentTfSeconds)

var label infoLabel = na
if barstate.islast
    label.delete(infoLabel)
    infoLabel := label.new(bar_index, high, 
                          "Current TF: " + timeframe.period + "\n" +
                          "Seconds: " + str.tostring(currentTfSeconds) + "\n" +
                          "Converted back: " + convertedBack,
                          style=label.style_label_down, color=color.blue, textcolor=color.white)
```

### Timeframe Checks

#### timeframe.isdaily

```pinescript
timeframe.isdaily → simple bool
```

Returns `true` if the current timeframe is daily (1D).

#### timeframe.isdwm

```pinescript
timeframe.isdwm → simple bool
```

Returns `true` if the current timeframe is daily, weekly, or monthly.

#### timeframe.isintraday

```pinescript
timeframe.isintraday → simple bool
```

Returns `true` if the current timeframe is less than daily.

#### timeframe.isminutes

```pinescript
timeframe.isminutes → simple bool
```

Returns `true` if the current timeframe is in minutes.

#### timeframe.ismonthly

```pinescript
timeframe.ismonthly → simple bool
```

Returns `true` if the current timeframe is monthly.

#### timeframe.isseconds

```pinescript
timeframe.isseconds → simple bool
```

Returns `true` if the current timeframe is in seconds.

#### timeframe.isweekly

```pinescript
timeframe.isweekly → simple bool
```

Returns `true` if the current timeframe is weekly.

**Example of Timeframe Checks:**
```pinescript
//@version=6
indicator("Timeframe Classifier", overlay=true)

// Check timeframe type
isDaily = timeframe.isdaily
isIntraday = timeframe.isintraday
isDWM = timeframe.isdwm
isMinutes = timeframe.isminutes
isSeconds = timeframe.isseconds

// Color background based on timeframe type
bgcolor(isSeconds ? color.new(color.red, 90) : 
        isMinutes ? color.new(color.orange, 90) :
        isDaily ? color.new(color.blue, 90) :
        timeframe.isweekly ? color.new(color.purple, 90) :
        timeframe.ismonthly ? color.new(color.gray, 90) : na)

// Display timeframe info
var table tfTable = table.new(position.top_left, 2, 6, bgcolor=color.white, border_width=1)
if barstate.islast
    table.cell(tfTable, 0, 0, "Property", bgcolor=color.gray, text_color=color.white)
    table.cell(tfTable, 1, 0, "Value", bgcolor=color.gray, text_color=color.white)
    table.cell(tfTable, 0, 1, "Is Daily", text_color=color.black)
    table.cell(tfTable, 1, 1, str.tostring(isDaily), text_color=color.black)
    table.cell(tfTable, 0, 2, "Is Intraday", text_color=color.black)
    table.cell(tfTable, 1, 2, str.tostring(isIntraday), text_color=color.black)
    table.cell(tfTable, 0, 3, "Is DWM", text_color=color.black)
    table.cell(tfTable, 1, 3, str.tostring(isDWM), text_color=color.black)
    table.cell(tfTable, 0, 4, "Is Minutes", text_color=color.black)
    table.cell(tfTable, 1, 4, str.tostring(isMinutes), text_color=color.black)
    table.cell(tfTable, 0, 5, "Is Seconds", text_color=color.black)
    table.cell(tfTable, 1, 5, str.tostring(isSeconds), text_color=color.black)
```

### timeframe.multiplier

Returns the multiplier of the current timeframe.

**Syntax:**
```pinescript
timeframe.multiplier → simple int
```

**Returns:** Timeframe multiplier (e.g., 15 for "15m", 4 for "4H")

### timeframe.period

Returns the current timeframe as a string.

**Syntax:**
```pinescript
timeframe.period → simple string
```

**Returns:** Current timeframe string

**Example:**
```pinescript
//@version=6
indicator("Timeframe Info", overlay=true)

// Get timeframe info
currentTF = timeframe.period
multiplier = timeframe.multiplier
seconds = timeframe.in_seconds(currentTF)

// Display info
var label infoLabel = na
if barstate.islast
    label.delete(infoLabel)
    infoLabel := label.new(bar_index, high,
                          "Timeframe: " + currentTF + "\n" +
                          "Multiplier: " + str.tostring(multiplier) + "\n" +
                          "Seconds: " + str.tostring(seconds),
                          style=label.style_label_down, color=color.blue, textcolor=color.white)
```

---

## Time Functions

### time()

Returns the timestamp of the current bar.

**Syntax:**
```pinescript
time → series int
time(timeframe) → series int
time(timeframe, session) → series int
time(timeframe, session, timezone) → series int
```

**Parameters:**
- `timeframe` (simple string): Timeframe specification
- `session` (simple string): Session specification
- `timezone` (simple string): Timezone (default: syminfo.timezone)

**Returns:** UNIX timestamp in milliseconds

### time_close()

Returns the close time of the current bar.

**Syntax:**
```pinescript
time_close → series int
time_close(timeframe) → series int
time_close(timeframe, session) → series int
time_close(timeframe, session, timezone) → series int
```

### timestamp()

Creates a timestamp from date and time components.

**Syntax:**
```pinescript
timestamp(year, month, day, hour, minute, second) → simple int
timestamp(timezone, year, month, day, hour, minute, second) → simple int
```

**Example:**
```pinescript
//@version=6
indicator("Time Functions", overlay=true)

// Get current time components
currentYear = year(time)
currentMonth = month(time)
currentDay = dayofmonth(time)
currentHour = hour(time)
currentMinute = minute(time)

// Create specific timestamp
newYearTimestamp = timestamp(currentYear + 1, 1, 1, 0, 0, 0)

// Time calculations
barDuration = time_close - time
millisecondsInDay = 24 * 60 * 60 * 1000

// Display time info
var table timeTable = table.new(position.top_right, 2, 7, bgcolor=color.white, border_width=1)
if barstate.islast
    table.cell(timeTable, 0, 0, "Time Component", bgcolor=color.gray, text_color=color.white)
    table.cell(timeTable, 1, 0, "Value", bgcolor=color.gray, text_color=color.white)
    table.cell(timeTable, 0, 1, "Year", text_color=color.black)
    table.cell(timeTable, 1, 1, str.tostring(currentYear), text_color=color.black)
    table.cell(timeTable, 0, 2, "Month", text_color=color.black)
    table.cell(timeTable, 1, 2, str.tostring(currentMonth), text_color=color.black)
    table.cell(timeTable, 0, 3, "Day", text_color=color.black)
    table.cell(timeTable, 1, 3, str.tostring(currentDay), text_color=color.black)
    table.cell(timeTable, 0, 4, "Hour", text_color=color.black)
    table.cell(timeTable, 1, 4, str.tostring(currentHour), text_color=color.black)
    table.cell(timeTable, 0, 5, "Minute", text_color=color.black)
    table.cell(timeTable, 1, 5, str.tostring(currentMinute), text_color=color.black)
    table.cell(timeTable, 0, 6, "Bar Duration (ms)", text_color=color.black)
    table.cell(timeTable, 1, 6, str.tostring(barDuration), text_color=color.black)
```

### Date and Time Component Functions

#### Date Functions
- `year(time)` → series int: Year (e.g., 2024)
- `month(time)` → series int: Month (1-12)
- `dayofmonth(time)` → series int: Day of month (1-31)
- `dayofweek(time)` → series int: Day of week (1=Sunday, 7=Saturday)
- `weekofyear(time)` → series int: Week of year (1-53)

#### Time Functions
- `hour(time)` → series int: Hour (0-23)
- `minute(time)` → series int: Minute (0-59)
- `second(time)` → series int: Second (0-59)

**Example:**
```pinescript
//@version=6
indicator("Date/Time Components", overlay=true)

// Get all time components
y = year(time)
m = month(time)
d = dayofmonth(time)
dow = dayofweek(time)
woy = weekofyear(time)
h = hour(time)
min = minute(time)
sec = second(time)

// Day names
dayName = dow == 1 ? "Sunday" :
          dow == 2 ? "Monday" :
          dow == 3 ? "Tuesday" :
          dow == 4 ? "Wednesday" :
          dow == 5 ? "Thursday" :
          dow == 6 ? "Friday" : "Saturday"

// Month names
monthName = m == 1 ? "January" : m == 2 ? "February" : m == 3 ? "March" :
            m == 4 ? "April" : m == 5 ? "May" : m == 6 ? "June" :
            m == 7 ? "July" : m == 8 ? "August" : m == 9 ? "September" :
            m == 10 ? "October" : m == 11 ? "November" : "December"

// Format date string
dateStr = dayName + ", " + monthName + " " + str.tostring(d) + ", " + str.tostring(y)
timeStr = str.format("{0,number,00}:{1,number,00}:{2,number,00}", h, min, sec)

// Display formatted date/time
var label dateLabel = na
if barstate.islast
    label.delete(dateLabel)
    dateLabel := label.new(bar_index, high,
                          dateStr + "\n" + timeStr + "\n" +
                          "Week " + str.tostring(woy) + " of " + str.tostring(y),
                          style=label.style_label_down, color=color.blue, textcolor=color.white)
```

---

## Session Functions

### Session String Format

Session strings define trading hours using the format: `"HHMM-HHMM:1234567"`

- `HHMM-HHMM`: Start and end times in 24-hour format
- `:1234567`: Optional days of week (1=Sunday, 2=Monday, etc.)

**Examples:**
- `"0930-1600"`: 9:30 AM to 4:00 PM, all days
- `"0930-1600:23456"`: 9:30 AM to 4:00 PM, Monday to Friday
- `"1800-0600+1"`: 6:00 PM to 6:00 AM next day

### Session-based time() Function

```pinescript
time(timeframe, session) → series int
```

Returns the bar's timestamp only if it falls within the specified session, otherwise returns `na`.

**Example:**
```pinescript
//@version=6
indicator("Session Detection", overlay=true)

// Define sessions
nySession = "0930-1600:23456"  // NYSE regular hours
londonSession = "0800-1630:23456"  // London session
tokyoSession = "0000-0900:23456"   // Tokyo session
sydneySession = "2100-0600+1:23456" // Sydney session

// Check if current bar is in session
inNY = not na(time(timeframe.period, nySession))
inLondon = not na(time(timeframe.period, londonSession))
inTokyo = not na(time(timeframe.period, tokyoSession))
inSydney = not na(time(timeframe.period, sydneySession))

// Color background based on active session
sessionColor = inNY ? color.new(color.blue, 90) :
               inLondon ? color.new(color.red, 90) :
               inTokyo ? color.new(color.yellow, 90) :
               inSydney ? color.new(color.green, 90) : na

bgcolor(sessionColor)

// Plot session markers
plotshape(inNY and not inNY[1], style=shape.labelup, location=location.belowbar,
          color=color.blue, text="NY", size=size.small)
plotshape(inLondon and not inLondon[1], style=shape.labelup, location=location.belowbar,
          color=color.red, text="LON", size=size.small)
```

### Market Hours Detection

```pinescript
//@version=6
indicator("Market Hours", overlay=true)

// Define market sessions
preMarket = "0400-0930:23456"
regularHours = "0930-1600:23456"
afterHours = "1600-2000:23456"

// Check current session
inPreMarket = not na(time(timeframe.period, preMarket))
inRegularHours = not na(time(timeframe.period, regularHours))
inAfterHours = not na(time(timeframe.period, afterHours))

// Market status
marketStatus = inPreMarket ? "Pre-Market" :
               inRegularHours ? "Regular Hours" :
               inAfterHours ? "After Hours" : "Closed"

// Color coding
bgColor = inPreMarket ? color.new(color.orange, 95) :
          inRegularHours ? color.new(color.green, 95) :
          inAfterHours ? color.new(color.purple, 95) : color.new(color.gray, 95)

bgcolor(bgColor)

// Display market status
var label statusLabel = na
if barstate.islast
    label.delete(statusLabel)
    statusLabel := label.new(bar_index, high, marketStatus,
                            style=label.style_label_down, 
                            color=inRegularHours ? color.green : color.orange,
                            textcolor=color.white)
```

---

## Practical Examples

### 1. Session-based Trading Filter

```pinescript
//@version=6
strategy("Session Trading", overlay=true)

// Input for session
sessionInput = input.session("0930-1600:23456", "Trading Session")

// Check if in session
inSession = not na(time(timeframe.period, sessionInput))

// Simple moving average strategy
sma20 = ta.sma(close, 20)
sma50 = ta.sma(close, 50)

// Entry conditions (only during session)
longCondition = ta.crossover(sma20, sma50) and inSession
shortCondition = ta.crossunder(sma20, sma50) and inSession

// Execute trades
if longCondition
    strategy.entry("Long", strategy.long)
if shortCondition
    strategy.entry("Short", strategy.short)

// Plot SMAs
plot(sma20, color=color.blue, title="SMA 20")
plot(sma50, color=color.red, title="SMA 50")

// Highlight trading session
bgcolor(inSession ? color.new(color.blue, 95) : na)
```

### 2. Time-based Alerts

```pinescript
//@version=6
indicator("Time-based Alerts", overlay=true)

// Inputs
alertHour = input.int(9, "Alert Hour", minval=0, maxval=23)
alertMinute = input.int(30, "Alert Minute", minval=0, maxval=59)
enableWeekends = input.bool(false, "Enable Weekend Alerts")

// Check if it's the alert time
isAlertTime = hour(time) == alertHour and minute(time) == alertMinute
isWeekday = dayofweek(time) >= 2 and dayofweek(time) <= 6
shouldAlert = isAlertTime and (enableWeekends or isWeekday)

// Alert condition
if shouldAlert and not shouldAlert[1]
    alert("Daily market alert triggered at " + str.tostring(alertHour) + ":" + 
          str.format("{0,number,00}", alertMinute))

// Visual indicator
plotshape(shouldAlert, style=shape.labeldown, location=location.abovebar,
          color=color.yellow, text="ALERT", size=size.normal)
```

### 3. Multi-Timeframe Synchronization

```pinescript
//@version=6
indicator("MTF Sync", overlay=true)

// Higher timeframe data
htfTimeframe = input.timeframe("1D", "Higher Timeframe")

// Get HTF data
htfHigh = request.security(syminfo.tickerid, htfTimeframe, high)
htfLow = request.security(syminfo.tickerid, htfTimeframe, low)
htfClose = request.security(syminfo.tickerid, htfTimeframe, close)

// Detect new HTF bar
newHTFBar = timeframe.change(htfTimeframe)

// Plot HTF levels
plot(htfHigh, color=color.red, linewidth=2, title="HTF High")
plot(htfLow, color=color.green, linewidth=2, title="HTF Low")
plot(htfClose, color=color.blue, linewidth=2, title="HTF Close")

// Mark new HTF bars
plotshape(newHTFBar, style=shape.labeldown, location=location.abovebar,
          color=color.purple, text="NEW " + htfTimeframe, size=size.small)

// Background color for new HTF bars
bgcolor(newHTFBar ? color.new(color.purple, 90) : na)
```

### 4. Market Hours Highlighting

```pinescript
//@version=6
indicator("Market Hours Highlighter", overlay=true)

// Define sessions with timezone
nySession = "0930-1600:23456"
londonSession = "0300-1200:23456"  // London in NY time
tokyoSession = "1800-0300+1:23456" // Tokyo in NY time

// Session detection
inNY = not na(time(timeframe.period, nySession, "America/New_York"))
inLondon = not na(time(timeframe.period, londonSession, "America/New_York"))
inTokyo = not na(time(timeframe.period, tokyoSession, "America/New_York"))

// Session overlaps
nyLondonOverlap = inNY and inLondon
londonTokyoOverlap = inLondon and inTokyo

// Colors
nyColor = color.new(color.blue, 92)
londonColor = color.new(color.red, 92)
tokyoColor = color.new(color.yellow, 92)
overlapColor = color.new(color.purple, 85)

// Apply background colors (priority to overlaps)
sessionBgColor = nyLondonOverlap or londonTokyoOverlap ? overlapColor :
                 inNY ? nyColor :
                 inLondon ? londonColor :
                 inTokyo ? tokyoColor : na

bgcolor(sessionBgColor)

// Session labels
var line nyLine = na
var line londonLine = na
var line tokyoLine = na

if barstate.islast
    // Clean up old lines
    line.delete(nyLine)
    line.delete(londonLine)
    line.delete(tokyoLine)
    
    // Create legend
    nyLine := line.new(bar_index + 5, high * 1.02, bar_index + 10, high * 1.02, 
                       color=color.blue, width=3)
    londonLine := line.new(bar_index + 5, high * 1.01, bar_index + 10, high * 1.01, 
                          color=color.red, width=3)
    tokyoLine := line.new(bar_index + 5, high, bar_index + 10, high, 
                         color=color.yellow, width=3)

// Volume analysis by session
var float nyVolume = 0
var float londonVolume = 0
var float tokyoVolume = 0

if inNY
    nyVolume := nyVolume + volume
if inLondon
    londonVolume := londonVolume + volume
if inTokyo
    tokyoVolume := tokyoVolume + volume

// Display session info
var table sessionTable = table.new(position.bottom_right, 3, 4, bgcolor=color.white, border_width=1)
if barstate.islast
    table.cell(sessionTable, 0, 0, "Session", bgcolor=color.gray, text_color=color.white)
    table.cell(sessionTable, 1, 0, "Active", bgcolor=color.gray, text_color=color.white)
    table.cell(sessionTable, 2, 0, "Volume", bgcolor=color.gray, text_color=color.white)
    
    table.cell(sessionTable, 0, 1, "New York", text_color=color.black)
    table.cell(sessionTable, 1, 1, inNY ? "YES" : "NO", 
               text_color=inNY ? color.green : color.red)
    table.cell(sessionTable, 2, 1, str.tostring(nyVolume, "#.##M"), text_color=color.black)
    
    table.cell(sessionTable, 0, 2, "London", text_color=color.black)
    table.cell(sessionTable, 1, 2, inLondon ? "YES" : "NO", 
               text_color=inLondon ? color.green : color.red)
    table.cell(sessionTable, 2, 2, str.tostring(londonVolume, "#.##M"), text_color=color.black)
    
    table.cell(sessionTable, 0, 3, "Tokyo", text_color=color.black)
    table.cell(sessionTable, 1, 3, inTokyo ? "YES" : "NO", 
               text_color=inTokyo ? color.green : color.red)
    table.cell(sessionTable, 2, 3, str.tostring(tokyoVolume, "#.##M"), text_color=color.black)
```

---

## Best Practices

### 1. Timezone Considerations

Always specify timezone when working with sessions to avoid confusion:

```pinescript
// Good - explicit timezone
nyTime = time(timeframe.period, "0930-1600:23456", "America/New_York")

// Avoid - uses chart timezone
chartTime = time(timeframe.period, "0930-1600:23456")
```

### 2. Session Validation

Validate that sessions are properly defined:

```pinescript
//@version=6
indicator("Session Validator")

sessionInput = input.session("0930-1600:23456", "Session")

// Test session validity
testTime = time(timeframe.period, sessionInput)
sessionValid = not na(testTime)

// Alert if session never triggers
var bool sessionSeen = false
if sessionValid
    sessionSeen := true

// Warning if session not seen after 100 bars
if bar_index > 100 and not sessionSeen
    runtime.error("Session may be invalid or not matching current timeframe")
```

### 3. Performance Optimization

Use session checks efficiently:

```pinescript
// Good - calculate session once
inTradingHours = not na(time(timeframe.period, "0930-1600:23456"))

// Use the boolean variable multiple times
if inTradingHours
    // Trading logic here

plotshape(inTradingHours and someCondition, ...)
bgcolor(inTradingHours ? color.blue : na)

// Avoid - multiple calculations
// if not na(time(timeframe.period, "0930-1600:23456"))
//     // logic
// plotshape(not na(time(timeframe.period, "0930-1600:23456")) and someCondition, ...)
```

### 4. Cross-Market Analysis

When analyzing multiple markets, standardize to one timezone:

```pinescript
//@version=6
indicator("Cross-Market Sessions", overlay=true)

// All sessions in UTC
nySessionUTC = "1430-2100:23456"      // NY in UTC
londonSessionUTC = "0800-1630:23456"  // London in UTC
tokyoSessionUTC = "0000-0900:23456"   // Tokyo in UTC

inNY = not na(time(timeframe.period, nySessionUTC, "UTC"))
inLondon = not na(time(timeframe.period, londonSessionUTC, "UTC"))
inTokyo = not na(time(timeframe.period, tokyoSessionUTC, "UTC"))

// Now all sessions are comparable
```

### 5. Error Handling

Handle edge cases with time functions:

```pinescript
//@version=6
indicator("Time Error Handling")

// Safe timeframe conversion
safeToSeconds(tf) =>
    result = 0
    try
        result := timeframe.in_seconds(tf)
    catch
        result := na
    result

// Safe timestamp creation
safeTimestamp(y, m, d, h, min, s) =>
    result = 0
    if y >= 1970 and m >= 1 and m <= 12 and d >= 1 and d <= 31
        try
            result := timestamp(y, m, d, h, min, s)
        catch
            result := na
    else
        result := na
    result

// Usage
tf_seconds = safeToSeconds("1D")
custom_time = safeTimestamp(2024, 1, 1, 9, 30, 0)
```

This comprehensive documentation covers all timeframe, time, and session-related functions in Pine Script v6, providing practical examples and best practices for effective time-based trading script development.