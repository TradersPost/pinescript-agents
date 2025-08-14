# Built-in Variables Reference

This document provides a comprehensive reference for all built-in variables available in Pine Script v6.

## Table of Contents

- [Bar State Variables (barstate.*)](#bar-state-variables)
- [Symbol Information (syminfo.*)](#symbol-information-variables)
- [Ticker Variables (ticker.*)](#ticker-variables)
- [Timeframe Variables](#timeframe-variables)
- [Strategy Variables (strategy.*)](#strategy-variables)
- [Price Variables](#price-variables)
- [Time Variables](#time-variables)
- [Display Variables (display.*)](#display-variables)
- [Format Variables (format.*)](#format-variables)

## Bar State Variables

Variables that provide information about the current bar's state in the execution cycle.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `barstate.isconfirmed` | bool | `true` if the current bar is confirmed (closed) | `if barstate.isconfirmed` |
| `barstate.isfirst` | bool | `true` on the first bar of the dataset | `if barstate.isfirst` |
| `barstate.ishistory` | bool | `true` if the current bar is a historical bar | `if barstate.ishistory` |
| `barstate.islast` | bool | `true` on the last bar of the dataset | `if barstate.islast` |
| `barstate.islastconfirmedhistory` | bool | `true` on the last confirmed historical bar | `if barstate.islastconfirmedhistory` |
| `barstate.isnew` | bool | `true` on the first tick of a new bar | `if barstate.isnew` |
| `barstate.isrealtime` | bool | `true` if the current bar is a real-time bar | `if barstate.isrealtime` |

## Symbol Information Variables

Variables that provide information about the current symbol/instrument.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `syminfo.basecurrency` | string | Base currency of the symbol | `syminfo.basecurrency == "USD"` |
| `syminfo.currency` | string | Currency of the symbol | `syminfo.currency == "EUR"` |
| `syminfo.description` | string | Description/full name of the symbol | `label.new(bar_index, high, syminfo.description)` |
| `syminfo.mintick` | float | Minimum tick value for the symbol | `round(price / syminfo.mintick) * syminfo.mintick` |
| `syminfo.pointvalue` | float | Point value of the symbol | `profit = points * syminfo.pointvalue` |
| `syminfo.prefix` | string | Exchange prefix of the symbol | `syminfo.prefix == "NASDAQ"` |
| `syminfo.root` | string | Root part of the symbol | `syminfo.root == "AAPL"` |
| `syminfo.session` | string | Session type of the symbol | `syminfo.session == session.regular` |
| `syminfo.ticker` | string | Ticker identifier | `syminfo.ticker == "AAPL"` |
| `syminfo.tickerid` | string | Full ticker ID including exchange | `request.security(syminfo.tickerid, "1D", close)` |
| `syminfo.timezone` | string | Timezone of the symbol | `syminfo.timezone == "America/New_York"` |
| `syminfo.type` | string | Type of the instrument | `syminfo.type == "stock"` |
| `syminfo.volumetype` | string | Volume type (base/quote) | `syminfo.volumetype == "base"` |

## Ticker Variables

Variables for creating ticker identifiers.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `ticker.heikinashi` | string | Heikin-Ashi ticker modifier | `request.security(ticker.heikinashi(syminfo.tickerid), timeframe.period, close)` |
| `ticker.kagi` | string | Kagi ticker modifier | `request.security(ticker.kagi(syminfo.tickerid, 1), timeframe.period, close)` |
| `ticker.linebreak` | string | Line Break ticker modifier | `request.security(ticker.linebreak(syminfo.tickerid, 3), timeframe.period, close)` |
| `ticker.pointfigure` | string | Point & Figure ticker modifier | `request.security(ticker.pointfigure(syminfo.tickerid, "traditional", 1, 3), timeframe.period, close)` |
| `ticker.renko` | string | Renko ticker modifier | `request.security(ticker.renko(syminfo.tickerid, "ATR", 10), timeframe.period, close)` |

## Timeframe Variables

Variables related to timeframe information.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `timeframe.period` | string | Current chart timeframe | `request.security(syminfo.tickerid, timeframe.period, close)` |
| `timeframe.multiplier` | int | Multiplier of the timeframe | `if timeframe.multiplier >= 60` |
| `timeframe.isseconds` | bool | `true` if timeframe is in seconds | `if timeframe.isseconds` |
| `timeframe.isminutes` | bool | `true` if timeframe is in minutes | `if timeframe.isminutes` |
| `timeframe.ishours` | bool | `true` if timeframe is in hours | `if timeframe.ishours` |
| `timeframe.isdays` | bool | `true` if timeframe is in days | `if timeframe.isdays` |
| `timeframe.isweeks` | bool | `true` if timeframe is in weeks | `if timeframe.isweeks` |
| `timeframe.ismonths` | bool | `true` if timeframe is in months | `if timeframe.ismonths` |
| `timeframe.isdwm` | bool | `true` if timeframe is daily, weekly, or monthly | `if timeframe.isdwm` |
| `timeframe.isintraday` | bool | `true` if timeframe is intraday | `if timeframe.isintraday` |

## Strategy Variables

Variables available only in strategy scripts that provide information about strategy state.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `strategy.position_size` | float | Current position size | `if strategy.position_size > 0` |
| `strategy.position_avg_price` | float | Average entry price of position | `profit = close - strategy.position_avg_price` |
| `strategy.equity` | float | Current equity value | `if strategy.equity > initial_capital * 1.1` |
| `strategy.netprofit` | float | Net profit of all closed trades | `if strategy.netprofit > 1000` |
| `strategy.openprofit` | float | Unrealized P&L of open position | `if strategy.openprofit < -500` |
| `strategy.wintrades` | int | Number of winning trades | `winrate = strategy.wintrades / strategy.closedtrades` |
| `strategy.losstrades` | int | Number of losing trades | `if strategy.losstrades > 10` |
| `strategy.closedtrades` | int | Total number of closed trades | `if strategy.closedtrades >= 100` |
| `strategy.opentrades` | int | Number of open trades | `if strategy.opentrades == 0` |
| `strategy.max_contracts_held_all` | int | Maximum contracts held in any direction | `risk_level = strategy.max_contracts_held_all` |
| `strategy.max_contracts_held_long` | int | Maximum long contracts held | `max_long = strategy.max_contracts_held_long` |
| `strategy.max_contracts_held_short` | int | Maximum short contracts held | `max_short = strategy.max_contracts_held_short` |
| `strategy.max_drawdown` | float | Maximum drawdown experienced | `if strategy.max_drawdown < -1000` |
| `strategy.grossprofit` | float | Gross profit of winning trades | `profit_factor = strategy.grossprofit / strategy.grossloss` |
| `strategy.grossloss` | float | Gross loss of losing trades | `total_loss = strategy.grossloss` |
| `strategy.initial_capital` | float | Initial capital amount | `roi = strategy.netprofit / strategy.initial_capital` |

## Price Variables

Basic price and volume variables for the current symbol.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `open` | float | Opening price of the current bar | `if close > open` |
| `high` | float | Highest price of the current bar | `range_size = high - low` |
| `low` | float | Lowest price of the current bar | `support = ta.lowest(low, 20)` |
| `close` | float | Closing price of the current bar | `sma = ta.sma(close, 14)` |
| `volume` | float | Volume of the current bar | `if volume > ta.sma(volume, 20)` |
| `hl2` | float | (high + low) / 2 | `pivot = hl2` |
| `hlc3` | float | (high + low + close) / 3 | `typical_price = hlc3` |
| `hlcc4` | float | (high + low + close + close) / 4 | `weighted_close = hlcc4` |
| `ohlc4` | float | (open + high + low + close) / 4 | `average_price = ohlc4` |

## Time Variables

Variables related to time and date information.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `time` | int | Unix timestamp of the current bar | `if time >= timestamp("2023-01-01")` |
| `time_close` | int | Unix timestamp of bar close time | `bar_duration = time_close - time` |
| `timenow` | int | Current Unix timestamp | `time_diff = timenow - time` |
| `year` | int | Year of the current bar | `if year >= 2023` |
| `month` | int | Month of the current bar (1-12) | `if month == 12` |
| `weekofyear` | int | Week number of the year | `if weekofyear == 1` |
| `dayofmonth` | int | Day of the month (1-31) | `if dayofmonth == 1` |
| `dayofweek` | int | Day of the week (1=Sunday, 7=Saturday) | `if dayofweek == dayofweek.monday` |
| `hour` | int | Hour of the day (0-23) | `if hour >= 9 and hour <= 16` |
| `minute` | int | Minute of the hour (0-59) | `if minute == 0` |
| `second` | int | Second of the minute (0-59) | `if second == 0` |

## Display Variables

Constants for controlling display locations.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `display.none` | const string | No display | `plot(rsi, display=display.none)` |
| `display.pane` | const string | Display in indicator pane | `plot(rsi, display=display.pane)` |
| `display.data_window` | const string | Display in data window only | `plot(volume, display=display.data_window)` |
| `display.status_line` | const string | Display in status line only | `plot(close, display=display.status_line)` |
| `display.all` | const string | Display everywhere | `plot(close, display=display.all)` |

## Format Variables

Constants for number formatting.

| Variable | Type | Description | Usage Example |
|----------|------|-------------|---------------|
| `format.inherit` | const string | Inherit format from symbol | `plot(close, format=format.inherit)` |
| `format.price` | const string | Format as price | `plot(pivot, format=format.price)` |
| `format.volume` | const string | Format as volume | `plot(vol_avg, format=format.volume)` |
| `format.percent` | const string | Format as percentage | `plot(change_pct, format=format.percent)` |
| `format.mintick` | const string | Format to minimum tick precision | `plot(level, format=format.mintick)` |

## Usage Examples

### Bar State Monitoring
```pinescript
//@version=6
indicator("Bar State Monitor")

// Check if we're on a new bar
if barstate.isnew
    label.new(bar_index, high, "New Bar", style=label.style_label_down)

// Only execute on confirmed bars
if barstate.isconfirmed
    // Your confirmed bar logic here
    rsi_value = ta.rsi(close, 14)
```

### Symbol Information Usage
```pinescript
//@version=6
indicator("Symbol Info Display")

// Create info table
if barstate.islast
    var table info_table = table.new(position.top_right, 2, 5)
    table.cell(info_table, 0, 0, "Symbol:", text_color=color.white)
    table.cell(info_table, 1, 0, syminfo.ticker, text_color=color.yellow)
    table.cell(info_table, 0, 1, "Exchange:", text_color=color.white)
    table.cell(info_table, 1, 1, syminfo.prefix, text_color=color.yellow)
    table.cell(info_table, 0, 2, "Currency:", text_color=color.white)
    table.cell(info_table, 1, 2, syminfo.currency, text_color=color.yellow)
```

### Strategy Performance Monitoring
```pinescript
//@version=6
strategy("Performance Monitor")

// Monitor strategy performance
if barstate.islast and strategy.closedtrades > 0
    win_rate = strategy.wintrades / strategy.closedtrades * 100
    profit_factor = strategy.grossprofit / math.abs(strategy.grossloss)
    
    // Display metrics
    var table perf_table = table.new(position.bottom_right, 2, 4)
    table.cell(perf_table, 0, 0, "Win Rate:", text_color=color.white)
    table.cell(perf_table, 1, 0, str.tostring(win_rate, "#.##") + "%", text_color=color.green)
    table.cell(perf_table, 0, 1, "Profit Factor:", text_color=color.white)
    table.cell(perf_table, 1, 1, str.tostring(profit_factor, "#.##"), text_color=color.blue)
```

## Notes

- Built-in variables are read-only and cannot be modified
- Some variables are only available in specific script types (e.g., strategy.* variables only in strategies)
- Bar state variables are crucial for controlling script execution flow
- Time variables use Unix timestamps (milliseconds since January 1, 1970)
- Always check variable availability in your script type before using

## Related Documentation

- [Language Reference](../language-reference.md)
- [Built-in Functions](../built-in-functions.md)
- [Execution Model](../core-concepts/execution-model.md)