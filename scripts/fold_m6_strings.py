#!/usr/bin/env python3
"""One-shot M6 helper: fold strings introduced after the M0 scaffold back
into the ARB files and the generated app_localizations_*.dart files.

Per the plan we ship real translations for EN + SK + CS. The remaining 22
locales receive the English copy as a scaffold (matches the existing
strategy for the other strings in this codebase).

This script is idempotent — running it twice does not duplicate entries.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARB_DIR = ROOT / "l10n"
DART_DIR = ROOT / "lib" / "src" / "l10n"

# (key, en, sk, cs)
NEW_STRINGS = [
    (
        "settingsSystemDefault",
        "System default",
        "Systémový jazyk",
        "Systémový jazyk",
    ),
    (
        "detailWikiUnavailable",
        "Couldn't load Wikipedia details.",
        "Detaily z Wikipédie sa nepodarilo načítať.",
        "Nepodařilo se načíst detaily z Wikipedie.",
    ),
    (
        "quizContinueCheckpoint",
        "Continue from checkpoint",
        "Pokračovať z kontrolného bodu",
        "Pokračovat z kontrolního bodu",
    ),
    (
        "quizHighScore",
        "Best score",
        "Najlepšie skóre",
        "Nejlepší skóre",
    ),
]


def value_for(locale: str, key: str, en: str, sk: str, cs: str) -> str:
    if locale == "sk":
        return sk
    if locale == "cs":
        return cs
    return en  # English copy for every other locale (per plan)


# --- ARB ---------------------------------------------------------------

def update_arb(path: Path) -> None:
    locale = path.stem.split("_", 1)[1]
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    changed = False
    for key, en, sk, cs in NEW_STRINGS:
        if key in data:
            continue
        data[key] = value_for(locale, key, en, sk, cs)
        data[f"@{key}"] = {}
        changed = True
    if changed:
        path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )


# --- abstract base -----------------------------------------------------

def update_abstract_base() -> None:
    path = DART_DIR / "app_localizations.dart"
    text = path.read_text(encoding="utf-8")
    insertion_lines = []
    for key, en, *_ in NEW_STRINGS:
        if f"String get {key}" in text:
            continue
        insertion_lines.extend(
            [
                "",
                f"  /// No description provided for @{key}.",
                "  ///",
                "  /// In en, this message translates to:",
                f"  /// **'{en}'**",
                f"  String get {key};",
            ]
        )
    if not insertion_lines:
        return
    # The abstract class block ends with `  String get dietOmnivore;\n}\n`.
    marker = "  String get dietOmnivore;\n}\n"
    if marker not in text:
        raise SystemExit("could not find dietOmnivore marker in base file")
    replacement = "  String get dietOmnivore;\n" + "\n".join(insertion_lines) + "\n}\n"
    path.write_text(text.replace(marker, replacement, 1), encoding="utf-8")


# --- concrete subclasses -----------------------------------------------

def update_concrete(path: Path) -> None:
    locale = path.stem.split("_", 2)[2]
    text = path.read_text(encoding="utf-8")
    additions = []
    for key, en, sk, cs in NEW_STRINGS:
        if f"String get {key}" in text:
            continue
        value = value_for(locale, key, en, sk, cs).replace("'", r"\'")
        additions.append(
            "\n  @override\n"
            f"  String get {key} => '{value}';\n"
        )
    if not additions:
        return
    # Each concrete subclass closes with the final `}` at the end of the file.
    # Insert before that brace.
    stripped = text.rstrip()
    if not stripped.endswith("}"):
        raise SystemExit(f"unexpected file format: {path}")
    new_text = stripped[:-1] + "".join(additions) + "}\n"
    path.write_text(new_text, encoding="utf-8")


def main() -> None:
    for arb in sorted(ARB_DIR.glob("app_*.arb")):
        update_arb(arb)
    update_abstract_base()
    for dart in sorted(DART_DIR.glob("app_localizations_*.dart")):
        update_concrete(dart)
    print("ok")


if __name__ == "__main__":
    main()
