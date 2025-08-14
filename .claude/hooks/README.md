# Claude Code Hooks for Pine Script Development

This directory contains hooks that ensure deterministic agent selection and code quality for Pine Script development.

## Active Hooks

### 1. user-prompt-submit.sh
**Trigger**: Before processing any user prompt
**Purpose**: Routes requests to appropriate Pine Script agents

**Features**:
- Keyword detection for agent routing
- Complexity scoring for multi-part projects
- Automatic pine-manager invocation for complex tasks
- Suggests specific agents based on request type

**Keywords Monitored**:
- Create/Build/New → pine-manager
- Debug/Error/Fix → pine-debugger
- Optimize/Improve/Performance → pine-optimizer
- Backtest/Test/Metrics → pine-backtester
- Publish/Share/Release → pine-publisher
- Plan/Design/Concept → pine-visualizer

### 2. before-write.sh
**Trigger**: Before writing any file
**Purpose**: Validates Pine Script files before saving

**Validations**:
- Ensures Pine Scripts are in `/projects/` directory
- Checks for //@version=6 declaration
- Warns about blank.pine modifications
- Path validation for Pine Script files

### 3. after-edit.sh
**Trigger**: After editing any file
**Purpose**: Validates Pine Script quality and suggests improvements

**Checks**:
- Repainting detection (security() with lookahead)
- NA value handling recommendations
- Risk management suggestions for strategies
- Input organization tips

## How Hooks Ensure Determinism

1. **Consistent Routing**: Every user request is analyzed for keywords and complexity, ensuring the same type of request always goes to the same agent.

2. **Validation Pipeline**: All Pine Script files go through the same validation checks, ensuring consistent quality.

3. **Automatic Suggestions**: The hooks provide real-time feedback, guiding users and Claude toward best practices.

4. **Project Structure Enforcement**: Files are automatically guided to the correct directories with proper naming.

## Configuration

Hooks are configured in `.claude/settings.json`:
- Enable/disable individual hooks
- Adjust keyword mappings
- Configure validation rules
- Set workflow preferences

## Adding Custom Hooks

To add a new hook:
1. Create a new `.sh` file in this directory
2. Make it executable: `chmod +x hook-name.sh`
3. Add configuration to `settings.json`
4. Document the hook's purpose here

## Debugging Hooks

If a hook isn't working:
1. Check file permissions (must be executable)
2. Review hook output in Claude Code logs
3. Test keywords and patterns manually
4. Verify paths are correct

## Best Practices

- Hooks should be fast (< 1 second execution)
- Always exit with code 0 (non-zero blocks execution)
- Provide clear, actionable feedback
- Don't modify files directly in hooks
- Use echo for user-visible messages