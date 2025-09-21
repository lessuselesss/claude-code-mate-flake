# Claude Code Mate

A companion tool for Claude Code, enabling flexible LLM integration through LiteLLM proxy.

The code (as well as the README) of Claude Code Mate is mainly vibe coded by Claude Code, with some adjustments and enhancements made by the author. 🤖✨

中文博客：[轻松解锁Claude Code：国内用户的多元模型新玩法](https://russellluo.com/2025/08/easily-unlock-claude-code)。


## Installation

```bash
# Install with uv
uv pip install --system claude-code-mate

# Or with pip
pip install claude-code-mate
```

Or with Admin UI enabled (only support Python 3.9-3.12 for now):

```bash
# Install with uv
uv pip install --system --python 3.12 "claude-code-mate[ui]"

# Or with pip
pip install "claude-code-mate[ui]"
```


## Usage

```bash
$ ccm -h
usage: ccm [-h] {start,stop,restart,status,logs} ...

A companion tool for Claude Code, enabling flexible LLM integration through LiteLLM proxy.

positional arguments:
  {start,stop,restart,status,logs}
                        Available commands
    start               Start the LiteLLM proxy in background
    stop                Stop the running LiteLLM proxy
    restart             Restart the LiteLLM proxy
    status              Show current proxy status
    logs                Show proxy logs

options:
  -h, --help            show this help message and exit

Examples:
  ccm start
  ccm stop
  ccm restart
  ccm status
  ccm logs
  ccm logs -f -n 100

This tool manages a LiteLLM proxy running with: litellm --config ~/.claude-code-mate/config.yaml
```


## Quick Start

Start the LiteLLM proxy:

```bash
export OPENROUTER_API_KEY=your-api-key
ccm start
```

Set up the environment variables according to the output instructions:

```bash
export ANTHROPIC_BASE_URL=http://0.0.0.0:4000
export ANTHROPIC_AUTH_TOKEN=sk-1234567890
```

Then run Claude Code with your desired model:

```bash
claude --model claude-3.5-haiku
```


## Configuration

Default config (at `~/.claude-code-mate/config.yaml`):

```yaml
litellm_settings:
  master_key: sk-1234567890

model_list:
  - model_name: claude-3.5-haiku
    litellm_params:
      model: openrouter/anthropic/claude-3.5-haiku
      api_key: os.environ/OPENROUTER_API_KEY
      api_base: https://openrouter.ai/api/v1
```

Edit the config as needed, then restart the proxy to apply changes:

```bash
ccm restart
```

Note that you need to update the environment variables if `master_key` is changed.


## Admin UI

If you installed Claude Code Mate with Admin UI enabled, you can access the UI for model management and usage tracking:

```bash
ccm ui
```

> [!NOTE]
> The default username and password are `admin` and `sk-1234567890` (i.e., the `master_key`) respectively.

### Model Management

![Add Model](./assets/litellm-model-management.png)

### Usage Tracking

![Usage Tracking](./assets/litellm-usage-tracking.png)


## Resources

- [LiteLLM Documentation](https://docs.litellm.ai/docs/tutorials/claude_responses_api)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code/llm-gateway)


## License

[MIT](http://opensource.org/licenses/MIT)
