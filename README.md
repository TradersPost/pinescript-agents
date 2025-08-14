# Pine Script Development Assistant for Claude Code

A comprehensive Pine Script development environment powered by Claude Code's subagent system. This tool helps you create professional TradingView indicators and strategies with AI assistance.

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pinescript-agents.git
   cd pinescript-agents
   ```

2. **Open in your IDE with Claude Code**
   ```bash
   # VS Code with Claude extension
   code .
   
   # Or use Claude Code CLI
   claude code .
   ```

3. **Start creating Pine Scripts!**
   ```
   "Create an RSI divergence indicator with alerts"
   "Build a mean reversion strategy using Bollinger Bands"
   "Debug my Pine Script that's showing errors"
   ```

## 🤖 Specialized AI Agents

This project includes 7 specialized Pine Script agents:

### 📊 Pine Visualizer
Breaks down your trading ideas into implementable components
- Analyzes requirements
- Creates implementation roadmaps
- Identifies potential challenges

### 💻 Pine Developer
Writes production-quality Pine Script v6 code
- Implements indicators and strategies
- Follows TradingView best practices
- Handles edge cases properly

### 🐛 Pine Debugger
Adds debugging tools and troubleshoots issues
- Inserts debug labels and tables
- Identifies repainting problems
- Fixes calculation errors

### 📈 Pine Backtester
Implements comprehensive testing capabilities
- Adds performance metrics
- Calculates win rates and drawdowns
- Provides trade statistics

### ⚡ Pine Optimizer
Enhances script performance and user experience
- Reduces loading times
- Improves visual presentation
- Optimizes calculations

### 🎯 Pine Manager
Orchestrates complex multi-step development
- Coordinates all agents
- Manages workflows
- Ensures quality

### 📝 Pine Publisher
Prepares scripts for TradingView publication
- Adds documentation
- Ensures compliance
- Optimizes for discoverability

## 📁 Project Structure

```
pinescript-agents/
├── .claude/
│   └── agents/          # AI agent configurations
├── docs/
│   ├── pinescript-v6/   # Pine Script documentation
│   └── tradingview/     # Platform documentation
├── templates/           # Ready-to-use templates
│   ├── indicators/      # Indicator templates
│   ├── strategies/      # Strategy templates
│   └── utilities/       # Helper functions
├── examples/            # Example scripts
├── tools/              # Utility scripts
└── CLAUDE.md           # Claude Code instructions
```

## 💡 Usage Examples

### Analyze a YouTube Video
```bash
# Provide a YouTube video about a trading strategy
./analyze-video.sh "https://youtube.com/watch?v=..."

# Or in conversation:
You: "Analyze this video: https://youtube.com/watch?v=..."
Claude: [Extracts transcript, identifies components, creates specification]
```

### Create a Simple Indicator
```
You: "Create a moving average crossover indicator"
Claude: [Uses pine-developer to create the indicator with proper inputs and alerts]
```

### Build a Complex Strategy
```
You: "Build a strategy that combines RSI, MACD, and volume analysis with proper risk management"
Claude: [Uses pine-manager to coordinate multiple agents for complete implementation]
```

### Debug Existing Code
```
You: "My script is repainting, help me fix it"
Claude: [Uses pine-debugger to identify and fix repainting issues]
```

### Optimize Performance
```
You: "Make my script load faster"
Claude: [Uses pine-optimizer to improve calculation efficiency]
```

### Prepare for Publishing
```
You: "Prepare my script for TradingView publication"
Claude: [Uses pine-publisher to add documentation and ensure compliance]
```

## 📚 Available Templates

### Indicators
- **Momentum**: RSI, Stochastic, MACD variations
- **Trend**: Moving average systems, Supertrend
- **Volume**: OBV, Volume Profile, CVD
- **Volatility**: Bollinger Bands, ATR, Keltner Channels

### Strategies
- **Trend Following**: MA crosses, trend riders
- **Mean Reversion**: Oversold/overbought systems
- **Breakout**: Range breakouts, Donchian channels
- **Scalping**: Quick entry/exit systems

### Utilities
- **Risk Management**: Position sizing, stop losses
- **Debugging**: Label outputs, table monitors
- **Backtesting**: Performance metrics, statistics

## 🎯 Key Features

- **Pine Script v6 Support**: Full compatibility with latest Pine Script version
- **Intelligent Workflow**: Automatic agent selection based on task
- **Template Library**: Pre-built components for rapid development
- **Debug Tools**: Built-in debugging capabilities
- **Performance Metrics**: Comprehensive backtesting statistics
- **Publication Ready**: Scripts prepared for TradingView community

## 🛠️ Development Workflow

1. **Describe Your Idea**: Tell Claude what you want to create
2. **Automatic Planning**: Agents break down requirements
3. **Implementation**: Code is written following best practices
4. **Testing**: Debug tools and backtesting added
5. **Optimization**: Performance and UX enhanced
6. **Delivery**: Complete, production-ready script

## 📋 Best Practices

- Always test scripts on multiple timeframes
- Include proper error handling
- Add tooltips to all inputs
- Document complex logic
- Avoid repainting issues
- Optimize for performance
- Follow TradingView guidelines

## 🚨 Common Commands

- `"Create indicator"` - Start new indicator development
- `"Create strategy"` - Start new strategy development
- `"Debug my script"` - Fix issues in existing code
- `"Add backtesting"` - Include performance metrics
- `"Optimize performance"` - Improve script efficiency
- `"Prepare for publishing"` - Get ready for TradingView

## 📖 Documentation

- [Pine Script v6 Reference](docs/pinescript-v6/language-reference.md)
- [Built-in Functions](docs/pinescript-v6/built-in-functions.md)
- [TradingView Environment](docs/tradingview/environment.md)
- [Agent Documentation](.claude/agents/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch
3. Add new templates or improve agents
4. Submit a pull request

## 📄 License

MIT License - feel free to use this project for any purpose.

## 🙏 Acknowledgments

- Built for use with [Claude Code](https://claude.ai/code)
- Designed for [TradingView](https://www.tradingview.com) Pine Script v6
- Community contributions and feedback

## 💬 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing documentation
- Review example scripts

---

**Ready to create professional Pine Scripts?** Open this project in Claude Code and start building!