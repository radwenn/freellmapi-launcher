# FreeLLMAPI Launcher

> **Unofficial launcher for [FreeLLMAPI](https://github.com/tashfeenahmed/freellmapi), not affiliated with FreeLLMAPI or OpenCode.**

A tiny Windows launcher with a Start/Shutdown window, live status indicator, tray shortcut, and multi-language support (English, French, Arabic).

## Prerequisites

- Windows 10 / 11 (x64)
- Node.js 20+ (for running `npm run dev` inside the FreeLLMAPI folder)
- Git (for cloning the upstream project on first run)
- Internet connection (to fetch the upstream repository and API models)

## Installation

1. Download the latest `FreeLLMAPI-Launcher-Setup.exe` or `freellmapi-launcher-pack.zip` from the [Releases](https://github.com/radwenn/freellmapi-launcher/releases) page.
2. Run the installer. If Windows SmartScreen warns you, click **More info → Run anyway**.  
   ⚠️ You can always read the scripts first: all `.ps1` and `.bat` files are plain text in the repository.

**Default install folder:** `%LOCALAPPDATA%\freellmapi` (e.g. `C:\Users\<you>\AppData\Local\freellmapi`).  
The launcher files (`start.bat`, `stop.bat`, `launcher.ps1`, `make-icon.ps1`, `make-shortcut.ps1`) are copied into `<installation>\launcher\`.  
On first run, if the FreeLLMAPI folder does not exist, the setup script clones the upstream repository at the pinned commit. If it already exists, it is left untouched (no checkout, no modification).

## Usage

After installation, a **FreeLLMAPI** shortcut appears on your Desktop.

Double-click it → a small window opens:

- **Start** / **Démarrer** / **تشغيل** — launches the FreeLLMAPI proxy (`npm run dev`) in the background.
- **Shutdown** / **Arrêter** / **إيقاف** — stops the proxy (kills processes on ports 3001 and 5173).
- **● En marche / Running / يعمل** (green) — proxy is listening on `http://localhost:3001`.
- **● Arrêté / Stopped / متوقف** (red) — proxy is not running.
- Languages: English, French, Arabic (auto-detected from Windows display language, or forced with `-Lang`).

The window stays open so you can see the status and control the proxy at any time.

## Connecting OpenCode

1. Start the proxy with the **Start** button. Wait for the green dot.
2. In OpenCode, create or edit your global config:
   `%USERPROFILE%\.config\opencode\opencode.jsonc`
3. Add this provider block (adapt `model` to one of the models listed by `GET /v1/models`):
   ```jsonc
   {
     "$schema": "https://opencode.ai/config.json",
     "model": "freellmapi/auto",
     "providers": {
       "freellmapi": {
         "name": "FreeLLMAPI",
         "env": ["FREELLMAPI_KEY"],
         "package": "@opencode/ai/providers/openai-compatible",
         "settings": {
           "baseURL": "http://localhost:3001/v1"
         },
         "models": {
           "auto": { "name": "FreeLLMAPI Auto" }
         }
       }
     }
   }
   ```
4. Get your **Unified API Key** from the FreeLLMAPI web UI: open `http://localhost:5173`, go to **Keys → Unified API Key**, copy it.
5. Set it as an environment variable:
   ```powershell
   setx FREELLMAPI_KEY "your-copied-key"
   ```
6. Restart OpenCode (or run `/reload`), then select the model with `/models`.

## Free API Keys

FreeLLMAPI aggregates multiple free LLM providers. **Each user must create their own free API keys** with the respective providers (Anthropic, Google, OpenRouter, etc.) and paste them into FreeLLMAPI's **Keys** page.  
Respect the terms of service of each provider. FreeLLMAPI is intended for personal experimentation only.

## Security

- **Never share** your `.env`, `freeapi.db`, or the **Unified API Key** (the one you copy from the Keys page).
- Do not post keys in issues, PRs, or logs.
- The launcher scripts contain no secrets — they only start the local proxy.
- If you believe you found a security issue, see [SECURITY.md](SECURITY.md).

## Verify Your Download

After downloading `FreeLLMAPI-Launcher-Setup.exe` or `freellmapi-launcher-pack.zip`, verify the SHA-256 checksum matches the one published in the Release (`checksums.txt`) on [GitHub](https://github.com/radwenn/freellmapi-launcher/releases):

```powershell
Get-FileHash -Algorithm SHA256 .\FreeLLMAPI-Launcher-Setup.exe
Get-FileHash -Algorithm SHA256 .\freellmapi-launcher-pack.zip
```

Compare the output with `checksums.txt` from the same Release.

## Contributing

1. Fork the repo.
2. Create a feature branch (`git checkout -b feature/foo`).
3. Make your changes. Keep PowerShell scripts in **UTF-8 with BOM**.
4. Run local checks: parse all `.ps1` with `Parser::ParseFile`, ensure no hardcoded `C:\Users\` paths.
5. Open a PR with a clear description.

---

## Français (résumé)

**Lanceur non officiel pour FreeLLMAPI**, sans lien avec FreeLLMAPI ni OpenCode.

### Prérequis
- Windows 10/11 (x64), Node.js 20+, Git, connexion Internet.

### Installation
Téléchargez `FreeLLMAPI-Launcher-Setup.exe` ou le zip depuis les **Releases**. Si SmartScreen bloque : « Plus d'infos → Exécuter quand même ». Les scripts sont lisibles dans le dépôt.

### Utilisation
Raccourci **FreeLLMAPI** sur le Bureau → fenêtre avec **Démarrer / Arrêter**, voyant vert/rouge, langues auto (fr/en/ar).

### Connecter OpenCode
1. Lancez le proxy (bouton Démarrer, attendre le point vert).
2. Config OpenCode (`%USERPROFILE%\.config\opencode\opencode.jsonc`) → ajoutez le bloc provider `freellmapi` (voir exemple ci-dessus).
3. Clé unifiée : interface FreeLLMAPI (`http://localhost:5173` → Keys → Unified API Key) → `setx FREELLMAPI_KEY "..."`.
4. `/reload` dans OpenCode, puis `/models`.

### Clés API gratuites
Chaque utilisateur crée ses propres clés gratuites chez les fournisseurs (Anthropic, Google, OpenRouter…). Respectez leurs CGU. Usage personnel uniquement.

### Sécurité
Ne partagez **jamais** `.env`, `freeapi.db`, ni la clé unifiée. Voir [SECURITY.md](SECURITY.md).

### Vérification
`Get-FileHash -Algorithm SHA256 .\fichier.exe` et comparez avec `checksums.txt` de la Release.

---

## Links

- Upstream FreeLLMAPI: https://github.com/tashfeenahmed/freellmapi
- OpenCode docs: https://opencode.ai/v2/docs/