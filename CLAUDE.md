# CLAUDE.md — EvilURL (Sharon-Needles fork)

## What This Tool Does

EvilURL generates **IDN homograph attack** payloads — unicode lookalike domain names that visually impersonate legitimate domains in browsers, email clients, and messaging apps.

## What IDN Homograph Attacks Are

**IDN** (Internationalized Domain Names) allow domain names to contain non-ASCII Unicode characters. Browsers display them as readable text (e.g., `xn--googl-e8a.com` displays as `googlе.com`).

**The attack**: Some Unicode characters are visually identical (or near-identical) to ASCII characters:
- Cyrillic `а` (U+0430) looks like Latin `a`
- Cyrillic `е` (U+0435) looks like Latin `e`
- Cyrillic `о` (U+043E) looks like Latin `o`
- Greek `ϲ` (U+03F2) looks like Latin `c`/`s`

An attacker registers `аpple.com` (Cyrillic а) instead of `apple.com`. Victims see identical-looking text but land on a different server.

**Real-world use**: Phishing campaigns, credential harvesting, malware distribution, session hijacking via lookalike OAuth redirect URIs.

## How EvilURL Works

1. Takes a target domain (e.g., `google.com`)
2. Finds all characters in the domain that have Unicode lookalikes (a, c, e, o, p, s, d, q, w)
3. Generates every combination of character substitutions (single-char, two-char, three-char swaps, etc.)
4. Reports each evil variant with: the substituted chars, Unicode names, and the resulting IDN domain
5. Optionally: checks domain availability via WHOIS, checks connectivity via nmap ping scan

## Unicode Mappings Used

| Latin | Unicode | Name |
|-------|---------|------|
| a | U+0430 | Cyrillic Small Letter A |
| c | U+03F2 | Greek Lunate Sigma Symbol |
| e | U+0435 | Cyrillic Small Letter Ie |
| o | U+043E | Cyrillic Small Letter O |
| p | U+0440 | Cyrillic Small Letter Er |
| s | U+0455 | Cyrillic Small Letter Dze |
| d | U+0501 | Cyrillic Small Letter Komi De |
| q | U+051B | Cyrillic Small Letter Qa |
| w | U+051D | Cyrillic Small Letter We |

## Install

```bash
chmod +x install.sh
./install.sh
```

Manual install:
```bash
pip3 install -r requirements.txt
# Also requires nmap system binary for -c (connection check) flag
```

## Requirements

- Python 3.x
- `python-nmap` — Python wrapper for nmap (was missing from upstream requirements.txt)
- `python-whois` — WHOIS lookups for availability check (`-a`)
- `nmap` — system binary, required for `-c` connection testing

## Usage

```bash
# Generate all evil lookalike domains for a target
python3 evilurl.py -g -d google.com

# Generate and check WHOIS availability for each evil domain
python3 evilurl.py -g -d google.com -a

# Check a single URL for IDN homograph characters
python3 evilurl.py -d gооgle.com

# Check a file of URLs for evil chars
python3 evilurl.py -f urls.txt

# Save output to file
python3 evilurl.py -g -d apple.com -o output.txt

# Test connectivity of generated domains (requires nmap/root)
sudo python3 evilurl.py -g -d paypal.com -c

# Full flags
python3 evilurl.py --help
```

## Flags

| Flag | Description |
|------|-------------|
| `-g` | Generate evil domains |
| `-d DOMAIN` | Target domain (e.g., `google.com`) |
| `-a` | Check WHOIS availability of each generated domain |
| `-c` | Ping-check each domain via nmap `-sn` |
| `-o FILE` | Write output to file |
| `-f FILE` | Read list of URLs from file and check each for evil chars |

## Security Research Use Cases

### Phishing Awareness Training
Generate a full list of lookalike domains for your organization's domain. Show employees how visually identical these are to build recognition skills.

### Pre-Engagement Domain Spoofing Assessment
Before a red team engagement, enumerate all viable IDN spoofs of the client's domain. Check availability. Register the most convincing one for authorized phishing simulations.

### Brand Protection / Monitoring
Run EvilURL against your brand domain, then monitor the generated domains for registration activity (combine with WHOIS monitoring). Early detection of phishing infrastructure setup.

### Detecting Inbound IDN Attacks
Use `-f` mode to scan suspicious URLs (from email headers, logs, SIEM alerts) for IDN homograph characters. Useful in incident response.

### OAuth / SSO Redirect URI Testing
Generate IDN lookalike variants of your application's redirect URIs and test if your authorization server validates them strictly.

## Architecture

```
evilurl.py
├── unicodes[]          — mapping of Unicode chars to names
├── evils[]             — mapping of Latin chars to Unicode lookalikes
├── gen()               — core generator: finds replaceable chars, builds all combinations
├── makeEvil()          — formats and prints each generated evil domain
├── check_url()         — nmap -sn ping scan wrapper
├── check_EVIL()        — detects IDN chars in a given URL
├── checkAval()         — WHOIS availability check
├── urls_list()         — batch check from file
└── parseHandler()      — argparse CLI entry point
```

## What Was Changed in This Fork

See `ENHANCEMENTS.md` for a full changelog vs upstream `UndeadSec/EvilURL`.

Summary:
- Added `python-nmap` to `requirements.txt` (was missing, caused ModuleNotFoundError on fresh install)
- Added `install.sh` with cross-platform support (apt/pacman/dnf/brew)
- Added `CLAUDE.md` (this file)
- Added `ENHANCEMENTS.md`
- Core `evilurl.py` logic is untouched

## Upstream

Original tool: https://github.com/UndeadSec/EvilURL  
Author: Alisson Moretto (@UndeadSec)  
This fork: https://github.com/Sharon-Needles/EvilURL
