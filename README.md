# Pine Script Development Assistant for Claude Code

A comprehensive Pine Script development environment powered by Claude Code's Skills system. This tool helps you create professional TradingView indicators and strategies with AI assistance.

**Just type `start` to begin!**

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/TradersPost/pinescript-agents.git
   cd pinescript-agents
   ```

2. **Install dependencies** (for YouTube video analysis)
   ```bash
   pip install -r requirements.txt

   # Also need FFmpeg for audio processing (optional, for Whisper fallback)
   # macOS: brew install ffmpeg
   # Ubuntu: sudo apt install ffmpeg
   ```

3. **Open in your IDE with Claude Code**
   ```bash
   # VS Code with Claude extension
   code .

   # Or use Claude Code CLI
   claude
   ```

4. **Just type "start" in Claude chat**
   ```
   start
   ```
   This launches an interactive guide that helps you:
   - Create custom scripts
   - Analyze YouTube videos
   - Choose from templates
   - Understand system capabilities

5. **Or jump straight to creating**
   ```
   Create an RSI divergence indicator with alerts
   Build a mean reversion strategy using Bollinger Bands
   Analyze this video: https://youtube.com/watch?v=...
   ```

   **Other helpful commands:**
   - `help` - Show all available commands
   - `examples` - List example scripts
   - `templates` - Show quick templates
   - `status` - Show system status and available skills

## 🎯 Specialized AI Skills

This project uses Claude Code's **Skills system** - specialized capabilities that **automatically activate** based on your request. No explicit commands needed!

### How Skills Work

1. **Automatic Discovery**: Skills are loaded when you open the project
2. **Context-Based Activation**: Claude reads your request and activates the appropriate skill
3. **Seamless Integration**: Skills feel like natural capabilities, not separate tools

### Available Skills

| Skill | Activates When You... | What It Does |
|-------|----------------------|--------------|
| 📊 **pine-visualizer** | Ask conceptual questions, share YouTube videos, say "how would I build" | Breaks down trading ideas into implementable components |
| 💻 **pine-developer** | Say "create", "write", "implement", "code" | Writes production-quality Pine Script v6 code |
| 🐛 **pine-debugger** | Say "debug", "fix", "error", "not working" | Adds debugging tools and troubleshoots issues |
| 📈 **pine-backtester** | Say "backtest", "metrics", "win rate", "performance" | Implements comprehensive testing capabilities |
| ⚡ **pine-optimizer** | Say "optimize", "faster", "improve", "better UX" | Enhances performance and user experience |
| 🎯 **pine-manager** | Have complex multi-part requests, say "complete trading system" | Orchestrates complex multi-step development |
| 📝 **pine-publisher** | Say "publish", "release", "documentation" | Prepares scripts for TradingView publication |

### Skill Activation Examples

```
You: "Create an RSI indicator"
→ pine-developer skill activates automatically

You: "My script has errors"
→ pine-debugger skill activates automatically

You: "How would I build a mean reversion strategy?"
→ pine-visualizer skill activates automatically

You: "Build a complete trading system with backtesting"
→ pine-manager skill orchestrates multiple skills
```

## 📁 Project Structure

```
pinescript-agents/
├── .claude/
│   ├── skills/          # AI skill configurations (SKILL.md files)
│   ├── commands/         # Slash commands (start, create, video, etc.)
│   └── hooks/            # System hooks for commands
├── docs/
│   ├── docs/             # User guide (concepts, language, FAQ, errors)
│   ├── manual/           # Complete Pine Script v6 reference
│   └── server/           # MCP documentation server
├── templates/            # Ready-to-use templates
│   ├── indicators/       # Indicator templates
│   ├── strategies/       # Strategy templates
│   └── utilities/        # Helper functions
├── projects/             # Your Pine Script projects
├── examples/             # Example scripts
├── tools/                # Utility scripts
├── CLAUDE.md             # Claude Code instructions
└── CHANGELOG.md          # Version history
```

## 💡 Usage Examples

### Quick Commands
Just type these single words in Claude chat:
- `start` - Launch interactive setup guide
- `help` - Show available commands
- `status` - Show system status and available skills
- `examples` - List all example scripts
- `templates` - Show quick templates
- `lock` - Protect system files (only `/projects/` writable)
- `unlock` - Allow all file modifications

### Analyze a YouTube Video
```
You: Analyze this video: https://youtube.com/watch?v=...
Claude: [pine-visualizer extracts transcript, identifies components, creates specification]
```

### Create a Simple Indicator
```
You: "Create a moving average crossover indicator"
Claude: [pine-developer creates the indicator with proper inputs and alerts]
```

### Build a Complex Strategy
```
You: "Build a strategy that combines RSI, MACD, and volume analysis with proper risk management"
Claude: [pine-manager coordinates multiple skills for complete implementation]
```

### Debug Existing Code
```
You: "My script is repainting, help me fix it"
Claude: [pine-debugger identifies and fixes repainting issues]
```

### Optimize Performance
```
You: "Make my script load faster"
Claude: [pine-optimizer improves calculation efficiency]
```

### Prepare for Publishing
```
You: "Prepare my script for TradingView publication"
Claude: [pine-publisher adds documentation and ensures compliance]
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

## 🗣️ Natural Language Interface

No need for complex commands! Just talk to Claude naturally:

- **Simple words trigger actions**: Type `start`, `help`, `status`, `examples`
- **Describe what you want**: "Create a strategy that buys on RSI oversold"
- **Share videos**: "Analyze this YouTube video: [URL]"
- **Ask for help**: "What can you do?" or "Show me examples"

Skills activate automatically based on what you're trying to accomplish.

## 🎯 Key Features

- **Pine Script v6 Support**: Full compatibility with latest Pine Script version
- **Intelligent Workflow**: Automatic skill activation based on task context
- **Template Library**: Pre-built components for rapid development
- **Debug Tools**: Built-in debugging capabilities
- **Performance Metrics**: Comprehensive backtesting statistics
- **Publication Ready**: Scripts prepared for TradingView community
- **File Protection**: Lock system files while developing in `/projects/`

## 🛠️ Development Workflow

1. **Describe Your Idea**: Tell Claude what you want to create
2. **Automatic Planning**: Skills break down requirements
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

| Command | What Happens |
|---------|--------------|
| `"Create indicator"` | pine-developer activates for implementation |
| `"Create strategy"` | pine-developer activates with strategy focus |
| `"Debug my script"` | pine-debugger activates for troubleshooting |
| `"Add backtesting"` | pine-backtester adds performance metrics |
| `"Optimize performance"` | pine-optimizer improves efficiency |
| `"Prepare for publishing"` | pine-publisher adds documentation |
| `"Build complete system"` | pine-manager orchestrates full workflow |

## 📖 Documentation

- [Pine Script v6 Reference](docs/manual/pinescriptv6_complete_reference.md)
- [User Guide](docs/docs/index.md)
- [Skill Documentation](.claude/skills/)
- [Changelog](CHANGELOG.md)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch
3. Add new templates or improve skills
4. Submit a pull request

## 📄 License

MIT License - feel free to use this project for any purpose.

## 🙏 Acknowledgments

- Built for use with [Claude Code](https://claude.ai/code)
- Powered by Claude Code's Skills system
- Designed for [TradingView](https://www.tradingview.com) Pine Script v6
- Community contributions and feedback

## 💬 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing documentation
- Review example scripts

---

**Ready to create professional Pine Scripts?** Open this project in Claude Code and start building!
