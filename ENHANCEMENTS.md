# ENHANCEMENTS — EvilURL (Sharon-Needles fork)

## Origin

Forked from [UndeadSec/EvilURL](https://github.com/UndeadSec/EvilURL)

EvilURL generates IDN homograph attack payloads — unicode lookalike domains that visually impersonate legitimate domains. Used for phishing awareness training, red team domain spoofing, and detecting inbound IDN attacks.

---

## Changes vs Upstream

### 2026-04-24 — Dependency fix + install.sh + CLAUDE.md + ENHANCEMENTS.md

#### Fixed: Missing `python-nmap` dependency

**Problem**: Fresh installs failed immediately with:
```
ModuleNotFoundError: No module named 'nmap'
```
The `nmap` import (`from nmap import PortScanner`) was used for the `-c` connection-check flag, but `python-nmap` was never listed in `requirements.txt`. The upstream repo included pre-bundled `.whl` files as a workaround, but these were fragile and platform-specific.

**Fix**: Added `python-nmap` to `requirements.txt` so `pip3 install -r requirements.txt` handles it automatically on any platform.

#### Added: `install.sh` — cross-platform installer

| Platform | Package Manager | System packages installed |
|----------|----------------|--------------------------|
| Kali / Debian / Ubuntu / Parrot | `apt-get` | python3, python3-pip, nmap |
| Arch / BlackArch / Manjaro | `pacman` | python, python-pip, nmap |
| Fedora / RHEL / CentOS Stream | `dnf` | python3, python3-pip, nmap |
| macOS (Homebrew) | `brew` | python3, nmap |

After system package install, all platforms run `pip3 install -r requirements.txt`.

The script also prints usage examples on completion so new users know immediately how to run the tool.

#### Added: `CLAUDE.md`

Full documentation covering:
- What IDN homograph attacks are and how they work
- The Unicode character mappings used by EvilURL
- Install instructions (install.sh and manual)
- All flags with descriptions
- Security research use cases (phishing awareness training, red team pre-engagement, brand protection monitoring, incident response URL scanning, OAuth redirect URI testing)
- Code architecture map
- Upstream attribution

#### Added: `ENHANCEMENTS.md` (this file)

Changelog tracking all fork modifications vs upstream.

---

## What Was NOT Changed

- `evilurl.py` core logic — untouched. The Unicode mappings, generation algorithm, nmap integration, WHOIS check, and argparse CLI are all original.
- Unicode character selection — the 9 lookalike mappings (a/c/e/o/p/s/d/q/w) are unchanged.
- Output format — terminal color codes and display layout are unchanged.
- `Pipfile` — left as-is for users who prefer pipenv.
- Pre-bundled `.whl` files — left in place for reference/offline use.

---

## Potential Future Improvements

- Add `--json` output flag for integration with OSINT pipelines
- Extend Unicode mappings (more chars have lookalikes than the current 9)
- Add bulk domain input mode (generate evil domains for a list of targets at once)
- Add DNS resolution check as alternative to nmap (avoids root requirement)
- Add Punycode (`xn--`) display alongside the visual IDN form
- Python 3.10+ type hints on new functions
