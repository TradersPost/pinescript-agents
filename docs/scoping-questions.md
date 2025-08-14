# Pine Script Project Scoping Questions

## Quick Reference for pine-manager Agent

### Core Question Set (Minimal Path)

#### 1. Script Type
**Question**: "What type of Pine Script would you like to create?"
- **Indicator** - Displays information or generates signals
- **Strategy** - Executes trades with entry/exit logic
- **Library** - Reusable functions for other scripts
- **Not sure** - [Explain differences and re-ask]

#### 2A. For INDICATORS - Primary Purpose
**Question**: "What is the main purpose of your indicator?"
- **Signal Generation** - Buy/sell signals and alerts
- **Information Display** - Show data/calculations on chart
- **Both** - Signals + visual information
- **Not sure** - [Explain differences]

#### 2B. For STRATEGIES - Complexity
**Question**: "How complex is your trading logic?"
- **Standard** - Trade one asset, long/short positions
- **Complex** - Multiple assets, hedging, or special requirements
- **Not sure** - [Explain: Standard = normal TV strategy, Complex = pairs trading, portfolio, etc.]

#### 3. Automation Needs
**Question**: "Will you need automated trading alerts?"
- **Yes** - Configure alerts/webhooks
- **No** - Manual trading only
- **Not sure** - [Explain automation options]

If Yes: "What type of automation?"
- **TradingView Alerts** - Native TV alerts
- **Webhook Alerts** - For external automation
- **Both** - Multiple alert types

#### 4. Project Purpose
**Question**: "What is this script for?"
- **Personal Use** - Private trading
- **Publish Free** - Share with community
- **Sell Access** - Premium/paid script
- **Client Work** - For a specific client

#### 5. Development Approach
**Question**: "How quickly do you need this?"
- **Rapid Prototype** - Quick and functional
- **Production Quality** - Polished and optimized

#### 6. Dependencies
**Question**: "Will you use external libraries?"
- **None** - Self-contained script
- **TradingView Libraries** - Public TV libraries
- **Custom Libraries** - Private/custom libraries

### Conditional Questions (Based on Previous Answers)

#### For Signal Indicators
- "How complex are your signals?"
  - Simple (single condition)
  - Complex (multiple conditions)
  - Multi-timeframe

#### For Display Indicators
- "Where should information display?"
  - Overlay (on price chart)
  - Oscillator (separate pane)
  - Tables/Labels
  - Mixed

#### For Complex Strategies
- "What special features do you need?"
  - Pairs Trading
  - Hedging (long+short same asset)
  - Portfolio (multiple assets)
  - Grid/DCA Trading

#### For Production Quality
- "Performance requirements?"
  - Critical (must be fast)
  - Standard (balanced)
  - Feature-rich (performance secondary)

- "Visual polish level?"
  - Basic (functional only)
  - Professional (polished UI)
  - Custom (specific requirements)

- "Testing requirements?"
  - Basic (syntax check)
  - Full (backtesting + debugging)
  - Custom (specific metrics)

### Project Specification Template

After gathering answers, generate:

```
PROJECT SPECIFICATION
=====================
Script Type: [Indicator/Strategy/Library]
Purpose: [Signals/Display/Trading/etc.]
Complexity: [Simple/Standard/Complex]
Automation: [None/Alerts/Webhooks]
Target: [Personal/Community/Premium/Client]
Quality: [Prototype/Production]
Dependencies: [None/List libraries]

File Name: [descriptive-name].pine
Primary Agent: [pine-developer/pine-visualizer]
Support Agents: [List of agents needed]
Templates: [Applicable templates]
Estimated Time: [Quick/Medium/Extended]

Special Requirements:
- [List any special needs]
- [Performance requirements]
- [Visual requirements]
- [Testing requirements]
```

## Scoping Examples

### Example 1: Simple RSI Alert Indicator
**User Input**: "I need RSI alerts"

**Questions Asked**:
1. Script Type? → Indicator
2. Primary Purpose? → Signal Generation
3. Signal Complexity? → Simple
4. Need Automation? → Yes → TradingView Alerts
5. Project Purpose? → Personal Use
6. Development Speed? → Rapid Prototype

**Result**: 
- File: `rsi-alerts-indicator.pine`
- Agents: pine-developer (primary)
- Template: `templates/indicators/momentum/rsi-basic.pine`
- Time: 5-10 minutes

### Example 2: Complex Pairs Trading Strategy
**User Input**: "Pairs trading strategy for crypto"

**Questions Asked**:
1. Script Type? → Strategy
2. Trading Complexity? → Complex
3. Complex Features? → Pairs Trading
4. Need Automation? → Yes → Webhooks
5. Project Purpose? → Sell Access
6. Development Speed? → Production Quality
7. Dependencies? → None
8. Performance Critical? → Yes
9. Visual Polish? → Professional
10. Testing Needs? → Full

**Result**:
- File: `pairs-trading-strategy.pine`
- Agents: pine-manager → pine-visualizer → pine-developer → pine-backtester → pine-optimizer
- Custom implementation (no TV strategy functions)
- Time: 2-3 hours

### Example 3: Community Indicator Library
**User Input**: "Want to share my TA calculations"

**Questions Asked**:
1. Script Type? → Library
2. Library Type? → Calculation Functions
3. Project Purpose? → Publish Free
4. Development Speed? → Production Quality
5. Dependencies? → None

**Result**:
- File: `ta-calculations-library.pine`
- Agents: pine-developer → pine-publisher
- Focus on documentation and examples
- Time: 1-2 hours

## Decision Rules

### When to Ask Follow-up Questions
1. User selects "Not sure" → Explain and re-ask
2. User selects "Complex" → Ask for specifics
3. User selects "Custom" → Ask for details
4. User mentions specific features → Confirm understanding

### When to Skip Questions
1. Simple indicator + Personal use → Skip many quality questions
2. Rapid prototype → Skip optimization questions
3. No automation → Skip alert configuration
4. No dependencies → Skip library questions

### When to Suggest Alternatives
1. User wants pairs trading → Suggest custom framework
2. User wants hedging → Explain TV limitations
3. User wants portfolio → Suggest alternative approaches
4. User wants complex automation → Recommend webhook approach

## Implementation Notes

The pine-manager agent should:
1. Ask questions conversationally, not as a rigid form
2. Explain options when user is unsure
3. Make intelligent defaults when obvious
4. Confirm understanding before proceeding
5. Generate clear project specification
6. Pass specification to appropriate agents