# Pine Script Development Workflows

## Overview

This document outlines standardized workflows for Pine Script development, from initial concept to publication. Each workflow is designed to ensure quality, performance, and maintainability while leveraging the specialized agents available in this project.

---

## 1. Indicator Development Workflow

```
Start → Gather Requirements → Validate Concept → Implement Core Logic → Add Visualizations → Test & Debug → Optimize Performance → Add User Inputs → Document → Publish
```

### Phase 1: Requirements & Planning
**Agent**: `pine-visualizer`

**Requirements Checklist:**
- [ ] Clear indicator purpose and target use case
- [ ] Input parameters needed (price source, periods, thresholds)
- [ ] Output visualization requirements (plots, shapes, alerts)
- [ ] Performance constraints (calculation complexity, historical lookback)
- [ ] TradingView publication requirements

**Example**: RSI Divergence Indicator
```pinescript
// Requirements:
// - RSI calculation with customizable period
// - Divergence detection (bullish/bearish)
// - Visual divergence lines
// - Alert conditions
// - Configurable lookback period
```

### Phase 2: Core Implementation
**Agent**: `pine-developer`

**Implementation Steps:**
1. **Script Structure Setup**
   ```pinescript
   //@version=6
   indicator("Custom RSI Divergence", shorttitle="RSI Div", overlay=false)
   
   // Input parameters
   rsi_length = input.int(14, "RSI Length", minval=1)
   divergence_lookback = input.int(5, "Divergence Lookback", minval=2)
   ```

2. **Core Logic Implementation**
   ```pinescript
   // RSI calculation
   rsi = ta.rsi(close, rsi_length)
   
   // Pivot detection
   pivotHigh = ta.pivothigh(rsi, divergence_lookback, divergence_lookback)
   pivotLow = ta.pivotlow(rsi, divergence_lookback, divergence_lookback)
   ```

3. **Divergence Logic**
   ```pinescript
   // Bullish divergence: price makes lower low, RSI makes higher low
   bullishDiv = not na(pivotLow) and pivotLow > pivotLow[1] and low < low[1]
   
   // Bearish divergence: price makes higher high, RSI makes lower high
   bearishDiv = not na(pivotHigh) and pivotHigh < pivotHigh[1] and high > high[1]
   ```

### Phase 3: Testing & Debugging
**Agent**: `pine-debugger`

**Testing Procedures:**
1. **Syntax Validation**
   - Verify Pine Script v6 compliance
   - Check for compilation errors
   - Validate all function calls

2. **Logic Testing**
   ```pinescript
   // Add debugging plots
   plotchar(bullishDiv, "Bullish Div", "▲", location.bottom, color.green, size=size.small)
   plotchar(bearishDiv, "Bearish Div", "▼", location.top, color.red, size=size.small)
   
   // Debug table for real-time values
   if barstate.islast
       var table debugTable = table.new(position.top_right, 2, 5, bgcolor=color.white, border_width=1)
       table.cell(debugTable, 0, 0, "RSI", text_color=color.black)
       table.cell(debugTable, 1, 0, str.tostring(rsi, "#.##"), text_color=color.black)
   ```

3. **Edge Case Testing**
   - Test with different timeframes
   - Verify behavior on low-volume periods
   - Check historical vs real-time calculations

### Phase 4: Optimization
**Agent**: `pine-optimizer`

**Performance Optimization:**
- Minimize security() calls
- Optimize array operations
- Reduce redundant calculations
- Implement efficient na handling

**User Experience Enhancement:**
```pinescript
// Grouped inputs
rsi_group = "RSI Settings"
rsi_length = input.int(14, "Period", minval=1, group=rsi_group, tooltip="Number of bars for RSI calculation")
rsi_source = input.source(close, "Source", group=rsi_group, tooltip="Price source for RSI")

div_group = "Divergence Settings"
lookback = input.int(5, "Lookback", minval=2, group=div_group, tooltip="Bars to look back for pivot detection")
```

### Phase 5: Documentation & Publishing
**Agent**: `pine-publisher`

**Documentation Requirements:**
- Clear script description
- Input parameter explanations
- Usage instructions
- Interpretation guidelines

---

## 2. Strategy Development Workflow

```
Ideation → Backtest Setup → Core Logic → Risk Management → Performance Analysis → Walk-Forward Test → Live Preparation
```

### Phase 1: Strategy Planning
**Agent**: `pine-visualizer`

**Strategy Planning Checklist:**
- [ ] Entry/exit conditions clearly defined
- [ ] Risk management rules specified
- [ ] Position sizing methodology
- [ ] Market conditions and timeframes
- [ ] Expected performance metrics

**Example**: Mean Reversion Strategy
```pinescript
// Strategy Concept:
// - Enter long when price is oversold (RSI < 30) and bouncing off support
// - Exit when RSI > 70 or stop loss hit
// - Position size: 2% risk per trade
// - Markets: Trending stocks, 1H timeframe
```

### Phase 2: Backtesting Framework
**Agent**: `pine-backtester`

**Backtesting Setup:**
```pinescript
//@version=6
strategy("Mean Reversion Strategy", shorttitle="MR", overlay=true, 
         default_qty_type=strategy.percent_of_equity, default_qty_value=10,
         commission_type=strategy.commission.percent, commission_value=0.1)

// Performance tracking
var table perfTable = table.new(position.top_left, 4, 8, bgcolor=color.white, border_width=1)
```

**Key Metrics Implementation:**
```pinescript
// Trade statistics
totalTrades = strategy.closedtrades
winRate = strategy.closedtrades > 0 ? (strategy.wintrades / strategy.closedtrades) * 100 : 0
avgWin = strategy.wintrades > 0 ? strategy.grossprofit / strategy.wintrades : 0
avgLoss = strategy.losstrades > 0 ? strategy.grossloss / strategy.losstrades : 0
profitFactor = strategy.grossloss != 0 ? strategy.grossprofit / math.abs(strategy.grossloss) : 0
```

### Phase 3: Risk Management Integration
**Agent**: `pine-developer`

**Risk Management Components:**
```pinescript
// Position sizing based on risk percentage
riskPercent = input.float(2.0, "Risk Per Trade %", minval=0.1, maxval=10.0)
stopLossPercent = input.float(2.0, "Stop Loss %", minval=0.5, maxval=10.0)

// Calculate position size
equity = strategy.equity
riskAmount = equity * (riskPercent / 100)
stopLossPrice = strategy.position_avg_price * (1 - stopLossPercent / 100)
positionSize = riskAmount / (strategy.position_avg_price - stopLossPrice)
```

### Phase 4: Performance Analysis
**Agent**: `pine-backtester`

**Performance Metrics:**
- Win rate and profit factor
- Maximum drawdown analysis
- Sharpe ratio calculation
- Monthly/yearly returns breakdown
- Risk-adjusted returns

```pinescript
// Drawdown calculation
peak = strategy.equity
drawdown = (peak - strategy.equity) / peak * 100
maxDrawdown = math.max(maxDrawdown, drawdown)
```

---

## 3. Debugging Workflow

**Agent**: `pine-debugger`

### Error Identification Steps
1. **Compilation Errors**
   - Check syntax errors
   - Verify function signatures
   - Validate variable declarations

2. **Runtime Errors**
   - Identify na value propagation
   - Check array/matrix bounds
   - Verify security() call limits

3. **Logic Errors**
   - Compare expected vs actual behavior
   - Test edge cases
   - Validate calculations

### Systematic Debugging Approach
```pinescript
// 1. Add debug plots
plot(debug_value, "Debug", color=color.yellow, display=display.data_window)

// 2. Use debug table
if barstate.islast and debugging_enabled
    table.cell(debugTable, 0, 0, "Current Bar: " + str.tostring(bar_index))
    table.cell(debugTable, 0, 1, "Condition: " + str.tostring(entry_condition))

// 3. Add alertcondition for testing
alertcondition(debug_condition, "Debug Alert", "Debug condition triggered")
```

### Fix Validation
- Re-test with original scenarios
- Verify no regression in other functionality
- Confirm performance impact is minimal

---

## 4. Multi-Agent Workflow

**Agent**: `pine-manager` (Orchestrator)

### When to Use pine-manager
- Complex multi-component projects
- Strategy development with multiple indicators
- Large-scale code refactoring
- Publication-ready project delivery

### Agent Coordination Process
1. **pine-visualizer**: Break down requirements
2. **pine-developer**: Implement core functionality
3. **pine-debugger**: Add debugging and testing
4. **pine-backtester**: Implement performance metrics
5. **pine-optimizer**: Enhance performance and UX
6. **pine-publisher**: Prepare for publication

### Quality Checkpoints
- [ ] Each agent completes assigned tasks
- [ ] Integration testing between components
- [ ] Overall performance validation
- [ ] User experience review
- [ ] Documentation completeness

---

## 5. Publishing Workflow

**Agent**: `pine-publisher`

### Code Review Checklist
- [ ] Pine Script v6 compliance
- [ ] No repainting (or clearly documented)
- [ ] Proper error handling
- [ ] Optimized performance
- [ ] Professional presentation

### Documentation Requirements
```pinescript
// Title and description
//@version=6
indicator("Professional RSI Divergence", 
         shorttitle="RSI Div Pro", 
         overlay=false)

// Description comment block
// This indicator identifies RSI divergences using pivot analysis
// Features:
// - Customizable RSI parameters
// - Visual divergence lines
// - Alert conditions
// - Multiple timeframe support
```

### Testing Checklist
- [ ] Multiple timeframe testing
- [ ] Different market conditions
- [ ] Real-time vs historical behavior
- [ ] Alert functionality
- [ ] Visual element display

### Submission Steps
1. Final code review and optimization
2. Complete documentation
3. Test on multiple symbols/timeframes
4. Export and prepare for TradingView
5. Create publication description
6. Submit to TradingView library

---

## 6. Maintenance Workflow

### Version Updates
- Monitor Pine Script version releases
- Update deprecated functions
- Test compatibility with new features
- Document breaking changes

### Bug Fixes
1. **Issue Identification**
   - User feedback analysis
   - Performance monitoring
   - Edge case discovery

2. **Fix Implementation**
   - Reproduce the issue
   - Implement targeted fix
   - Test thoroughly
   - Document the change

3. **Deployment**
   - Update version number
   - Publish updated script
   - Notify users of changes

### Feature Additions
- Evaluate user feature requests
- Assess impact on existing functionality
- Implement with backward compatibility
- Update documentation

### User Feedback Integration
- Monitor TradingView comments
- Analyze usage patterns
- Prioritize improvement requests
- Implement high-value enhancements

---

## Best Practices Summary

### Code Quality
- Use meaningful variable names
- Add comprehensive comments
- Implement proper error handling
- Follow Pine Script v6 conventions

### Performance
- Minimize security() calls
- Optimize calculations
- Use appropriate data types
- Implement efficient algorithms

### User Experience
- Group related inputs
- Provide helpful tooltips
- Use professional colors
- Ensure responsive design

### Testing
- Test across multiple timeframes
- Validate with different symbols
- Check real-time behavior
- Verify alert functionality

### Documentation
- Clear, concise descriptions
- Usage examples
- Parameter explanations
- Interpretation guidelines

---

## Quick Reference

### Common Pine Script v6 Patterns
```pinescript
// Input grouping
group1 = "Technical Settings"
period = input.int(20, "Period", minval=1, group=group1)

// Conditional plotting
plot(condition ? value : na, "Signal", color=color.blue)

// Table creation
var table infoTable = table.new(position.top_right, 2, 3, 
                                bgcolor=color.white, border_width=1)

// Alert conditions
alertcondition(signal, "Signal Alert", "Signal detected: {{close}}")
```

### Performance Tips
- Use `var` for variables that don't change on every bar
- Implement early exits in conditional logic
- Cache expensive calculations
- Use built-in functions when available

### Debugging Tips
- Use `plotchar()` for boolean debugging
- Implement debug tables for complex data
- Add conditional compilation for debug code
- Test with different data ranges

This workflow documentation provides a comprehensive guide for professional Pine Script development, ensuring consistent quality and efficient collaboration across all project phases.