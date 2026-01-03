# TreeMapper Diff Context

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-TreeMapper-blue?logo=github)](https://github.com/marketplace/actions/treemapper-diff-context)
[![License](https://img.shields.io/github/license/nikolay-e/treemapper-action)](LICENSE)

**Smart diff context for AI code reviews. Uses PageRank to extract relevant code, not just changed lines.**

## Quick Start

```yaml
# .github/workflows/diff-context.yml
name: Diff Context
on: [pull_request]

permissions:
  contents: read
  pull-requests: write

jobs:
  diff:
    uses: nikolay-e/treemapper-action/.github/workflows/diff-context.yml@v1
```

Extracts context, uploads artifact, comments on PR with download link.

## Why TreeMapper?

| Traditional Diff | TreeMapper |
|-----------------|------------|
| Line-by-line changes | Complete functions and classes |
| No context | Related callers/callees included |
| Unlimited output | Token-budget aware (LLM-ready) |
| All changes equal | PageRank ranks by relevance |

## Inputs

| Input | Default | Description |
|-------|---------|-------------|
| `diff-range` | Auto | Git range. Auto: PR=base..head, Push=before..after |
| `budget` | `50000` | Token limit |
| `format` | `yaml` | Output: `yaml`, `json`, `txt`, `md` |
| `full` | `false` | Include all changed code (skip smart selection) |

## Outputs

| Output | Description |
|--------|-------------|
| `context` | Extracted diff context |
| `context-file` | Path to output file |
| `fragment-count` | Number of code fragments |
| `token-count` | Approximate tokens |

## Custom Usage

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0

- uses: nikolay-e/treemapper-action@v1
  id: ctx
  with:
    budget: '25000'

- uses: actions/upload-artifact@v4
  with:
    name: diff-context
    path: ${{ steps.ctx.outputs.context-file }}
```

## Output Example

```yaml
name: myproject
type: diff_context
fragments:
  - path: src/main.py
    lines: "10-25"
    kind: function
    symbol: process_data
    content: |
      def process_data(items):
          for item in items:
              validate(item)
          return transform(items)
```

## Requirements

- `fetch-depth: 0` in checkout (full git history)
- Valid diff range (both commits exist)

## Links

- [TreeMapper CLI](https://github.com/nikolay-e/treemapper)
- [PyPI](https://pypi.org/project/treemapper/)

## License

Apache 2.0
