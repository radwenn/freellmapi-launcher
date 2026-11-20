# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this launcher, **do not open a public issue**.  
Instead, please report it privately by emailing the maintainers or using GitHub's private vulnerability reporting feature (Security → Report a vulnerability).

## What to Never Post

- **Unified API Key** (the key shown in FreeLLMAPI's Keys → Unified API Key page)
- Contents of `.env` files
- `freeapi.db` or any SQLite database files
- Any personal API keys (Anthropic, OpenAI, Google, OpenRouter, etc.)
- Hardcoded credentials or tokens in scripts or config files

Issues or PRs containing secrets will be closed and deleted from history.

## Scope

This repository only contains the Windows launcher scripts (PowerShell, batch, Inno Setup).  
It does **not** contain the FreeLLMAPI upstream code.  
The launcher simply starts `npm run dev` in the cloned FreeLLMAPI folder and creates a Desktop shortcut.