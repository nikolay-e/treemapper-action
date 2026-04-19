FROM python:3.12-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install treemapper

FROM python:3.12-slim

LABEL maintainer="Nikolay Eremeev <nikolay.eremeev@outlook.com>"
LABEL org.opencontainers.image.source="https://github.com/nikolay-e/treemapper-claude-code-review-action"
LABEL org.opencontainers.image.description="GitHub Action for smart diff context extraction for Claude Code review"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/treemapper /usr/local/bin/treemapper

RUN useradd -m -u 1000 action
USER action

COPY entrypoint.py /entrypoint.py

ENTRYPOINT ["python", "/entrypoint.py"]
