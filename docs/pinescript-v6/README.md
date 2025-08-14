# Pine Script v6 Documentation Structure

## Organization Philosophy

This documentation is organized as a **categorized toolset** optimized for AI agents to quickly find and reference the exact information needed for specific tasks.

## Directory Structure

```
docs/pinescript-v6/
├── README.md                    # This file - navigation guide
├── quick-reference/             # Essential references
│   ├── syntax-basics.md        # Core syntax and structure
│   ├── common-patterns.md      # Frequently used patterns
│   └── limitations.md          # Platform limits and constraints
│
├── core-concepts/              # Fundamental concepts
│   ├── execution-model.md     # How Pine Script executes
│   ├── type-system.md         # Data types and conversions
│   ├── series-vs-simple.md    # Understanding series context
│   └── repainting.md          # Avoiding repainting issues
│
├── functions/                  # Function reference by category
│   ├── math/                  # Mathematical operations
│   ├── technical/             # Technical indicators (ta.*)
│   ├── request/               # Data requests (request.*)
│   ├── strategy/              # Strategy functions
│   ├── drawing/               # Visual elements
│   ├── input/                 # User inputs
│   ├── timeframe/             # Time and session
│   └── array-matrix-map/      # Data structures
│
├── indicators/                # Indicator development
│   ├── structure.md          # Indicator anatomy
│   ├── calculations.md       # Common calculations
│   ├── plotting.md           # Visualization techniques
│   └── alerts.md             # Alert implementation
│
├── strategies/               # Strategy development
│   ├── structure.md         # Strategy anatomy
│   ├── entries-exits.md    # Order management
│   ├── risk-management.md  # Position sizing, stops
│   ├── backtesting.md      # Testing considerations
│   └── broker-emulator.md  # How TV simulates trades
│
├── debugging/               # Debugging and troubleshooting
│   ├── common-errors.md    # Error messages and fixes
│   ├── debugging-tools.md  # Built-in debugging features
│   ├── performance.md      # Optimization techniques
│   └── edge-cases.md       # Handling special scenarios
│
├── visual-components/      # UI and visualization
│   ├── plots.md           # Line and shape plotting
│   ├── tables.md          # Data tables
│   ├── labels-boxes.md    # Annotations
│   ├── colors.md          # Color management
│   └── inputs-ui.md       # User interface design
│
├── advanced/              # Advanced topics
│   ├── libraries.md      # Creating libraries
│   ├── security.md       # Multi-timeframe/symbol
│   ├── collections.md    # Arrays, matrices, maps
│   ├── polylines.md      # Complex drawings
│   └── type-casting.md   # Type conversions
│
└── reference-tables/     # Quick lookup tables
    ├── built-in-variables.md
    ├── function-index.md
    ├── operators.md
    ├── keywords.md
    └── namespaces.md
```

## Agent Usage Guide

### For pine-developer:
Primary references:
- `/quick-reference/syntax-basics.md`
- `/functions/` (all categories)
- `/indicators/structure.md` or `/strategies/structure.md`
- `/reference-tables/function-index.md`

### For pine-debugger:
Primary references:
- `/debugging/` (all files)
- `/core-concepts/execution-model.md`
- `/core-concepts/repainting.md`
- `/quick-reference/limitations.md`

### For pine-optimizer:
Primary references:
- `/debugging/performance.md`
- `/core-concepts/execution-model.md`
- `/functions/request/` (for optimization)
- `/visual-components/` (for UX improvements)

### For pine-backtester:
Primary references:
- `/strategies/backtesting.md`
- `/strategies/broker-emulator.md`
- `/strategies/risk-management.md`
- `/functions/strategy/`

### For pine-visualizer:
Primary references:
- `/visual-components/` (all files)
- `/indicators/plotting.md`
- `/functions/drawing/`
- `/functions/technical/`

### For pine-publisher:
Primary references:
- `/quick-reference/syntax-basics.md`
- `/debugging/common-errors.md`
- `/visual-components/inputs-ui.md`
- Publication guidelines (external)

## Quick Access Patterns

### "I need to create a..."
- **Moving Average**: `/functions/technical/ta-sma.md`
- **Custom Oscillator**: `/indicators/calculations.md`
- **Entry Strategy**: `/strategies/entries-exits.md`
- **Data Table**: `/visual-components/tables.md`
- **Multi-timeframe**: `/advanced/security.md`

### "How do I fix..."
- **Repainting**: `/core-concepts/repainting.md`
- **Na values**: `/debugging/common-errors.md#na-handling`
- **Performance**: `/debugging/performance.md`
- **Type mismatch**: `/advanced/type-casting.md`

### "What's the limit for..."
- All limits: `/quick-reference/limitations.md`

## Documentation Sources

- Official Pine Script v6 Docs: https://www.tradingview.com/pine-script-docs/
- Pine Script Reference: https://www.tradingview.com/pine-script-reference/v6/
- Community Scripts: https://www.tradingview.com/scripts/