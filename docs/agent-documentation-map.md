# Agent Documentation Map

## Purpose
This map helps each Pine Script agent quickly locate the exact documentation needed for their specific tasks.

## pine-visualizer
**Primary Role**: Break down trading ideas into components

### Essential Docs:
```
/docs/pinescript-v6/quick-reference/common-patterns.md     # Trading patterns
/docs/pinescript-v6/functions/technical/README.md          # Available indicators
/docs/pinescript-v6/indicators/structure.md                # Indicator anatomy
/docs/pinescript-v6/strategies/structure.md                # Strategy anatomy
/docs/pinescript-v6/visual-components/                     # Visualization options
```

### When to reference:
- User describes a trading idea → Check common-patterns.md
- User mentions specific indicator → Check functions/technical/
- Planning visualization → Check visual-components/

---

## pine-developer
**Primary Role**: Write production Pine Script code

### Essential Docs:
```
/docs/pinescript-v6/quick-reference/syntax-basics.md       # Core syntax
/docs/pinescript-v6/reference-tables/function-index.md     # All functions
/docs/pinescript-v6/core-concepts/execution-model.md       # How Pine works
/docs/pinescript-v6/core-concepts/repainting.md           # Avoid repainting
/docs/pinescript-v6/quick-reference/limitations.md        # Platform limits
```

### Quick lookups:
- Function syntax → reference-tables/function-index.md
- Variable types → quick-reference/syntax-basics.md#data-types
- Series vs simple → core-concepts/execution-model.md#series-context
- Performance issues → quick-reference/limitations.md

---

## pine-debugger
**Primary Role**: Troubleshoot and fix Pine Script issues

### Essential Docs:
```
/docs/pinescript-v6/debugging/common-errors.md            # Error solutions
/docs/pinescript-v6/debugging/debugging-tools.md          # Debug techniques
/docs/pinescript-v6/core-concepts/execution-model.md      # Understanding flow
/docs/pinescript-v6/core-concepts/repainting.md          # Repainting issues
/docs/pinescript-v6/debugging/edge-cases.md              # Special scenarios
```

### Error patterns:
- "Cannot use mutable variable" → execution-model.md#variable-scope
- "Syntax error" → syntax-basics.md
- "Script too large" → limitations.md#script-size
- Repainting issues → repainting.md
- Na value errors → common-errors.md#na-handling

---

## pine-optimizer
**Primary Role**: Optimize performance and user experience

### Essential Docs:
```
/docs/pinescript-v6/debugging/performance.md              # Optimization
/docs/pinescript-v6/quick-reference/limitations.md        # Know the limits
/docs/pinescript-v6/visual-components/inputs-ui.md        # Better UX
/docs/pinescript-v6/visual-components/colors.md           # Visual appeal
/docs/pinescript-v6/functions/request/                    # Data efficiency
```

### Optimization targets:
- Reduce security() calls → performance.md#request-optimization
- Improve UX → inputs-ui.md
- Visual enhancement → colors.md, tables.md
- Array operations → performance.md#array-efficiency

---

## pine-backtester
**Primary Role**: Implement comprehensive testing metrics

### Essential Docs:
```
/docs/pinescript-v6/strategies/backtesting.md            # Testing guide
/docs/pinescript-v6/strategies/broker-emulator.md        # How TV simulates
/docs/pinescript-v6/strategies/risk-management.md        # Risk metrics
/docs/pinescript-v6/functions/strategy/                  # Strategy functions
/docs/pinescript-v6/visual-components/tables.md          # Metrics display
```

### Key metrics:
- Win rate → backtesting.md#win-rate
- Sharpe ratio → risk-management.md#sharpe
- Max drawdown → backtesting.md#drawdown
- Profit factor → backtesting.md#profit-factor

---

## pine-publisher
**Primary Role**: Prepare scripts for TradingView publication

### Essential Docs:
```
/docs/pinescript-v6/quick-reference/syntax-basics.md      # Clean code
/docs/pinescript-v6/visual-components/inputs-ui.md        # User inputs
/docs/pinescript-v6/debugging/common-errors.md           # No errors
/docs/pinescript-v6/indicators/alerts.md                 # Alert setup
Publication guidelines: https://www.tradingview.com/house-rules/
```

### Publishing checklist:
- ✅ No syntax errors → syntax-basics.md
- ✅ User-friendly inputs → inputs-ui.md
- ✅ Clear descriptions → Use tooltips
- ✅ No repainting → repainting.md
- ✅ Follows house rules → Check TV guidelines

---

## pine-manager
**Primary Role**: Orchestrate multi-agent workflows

### Essential Docs:
```
/docs/project-scoping-flow.md                            # Standard flow
/docs/comprehensive-scoping-flow.md                      # Unknown patterns
/docs/edge-case-handler.md                               # Edge cases
/docs/pinescript-v6/README.md                            # Doc structure
/docs/agent-documentation-map.md                         # This file
```

### Workflow patterns:
- Simple indicator → Use pine-developer directly
- Complex strategy → Orchestrate visualizer → developer → debugger → optimizer
- Debugging request → Route to pine-debugger
- Publishing prep → Route to pine-publisher
- Performance issues → Route to pine-optimizer

---

## Quick Reference Paths

### By Task Type:

**"Create indicator"**
1. pine-visualizer: `/common-patterns.md`
2. pine-developer: `/syntax-basics.md`, `/function-index.md`
3. pine-debugger: `/debugging-tools.md`

**"Create strategy"**
1. pine-visualizer: `/strategies/structure.md`
2. pine-developer: `/functions/strategy/`
3. pine-backtester: `/backtesting.md`
4. pine-optimizer: `/risk-management.md`

**"Fix error"**
1. pine-debugger: `/common-errors.md`
2. pine-developer: `/execution-model.md`

**"Optimize performance"**
1. pine-optimizer: `/performance.md`
2. pine-developer: `/limitations.md`

**"Add debugging"**
1. pine-debugger: `/debugging-tools.md`
2. pine-developer: `/visual-components/labels.md`

**"Prepare for publishing"**
1. pine-publisher: Check all guidelines
2. pine-optimizer: `/inputs-ui.md`
3. pine-debugger: Verify no errors

---

## Documentation Access Pattern

### Efficient Loading Strategy:
1. **Initial Load**: Agent loads only their essential docs section
2. **Task-Specific**: Load additional docs based on user request
3. **Cross-Reference**: Load related docs when needed
4. **Cache**: Keep frequently used docs in context

### Example Flow:
```
User: "Create RSI divergence indicator"
→ pine-manager: Loads /project-scoping-flow.md
→ pine-visualizer: Loads /common-patterns.md#divergence
→ pine-developer: Loads /functions/technical/README.md#rsi
→ pine-optimizer: Loads /visual-components/colors.md
```

This targeted approach ensures agents have exactly what they need without overwhelming context.