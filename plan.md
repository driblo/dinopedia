| Risk | Mitigation |

|---|---|

| Quiz requires internet (images from Wikipedia) | Show friendly "needs internet" state; catalog browsing still works offline once visited |

| Some genera lack thumbnails | Preflight scan flags entries without images; quiz pool filters them out |

| 25-locale translations balloon scope | Start with EN + SK + CS for v0, scaffold the other 22 as English copies, add gradually. Per skill: infra must be in place, not all content translated immediately |

| Wikipedia REST API rate limits | Aggressive Hive caching (30-day TTL) — typical user hits each entry once |

| Distractors feel unfair for kids in early tiers | Curated tier-1 pool of famous dinosaurs; distractors from different clades for tiers 1–3 |

| Splash slogan per locale across native splash | Acceptable to ship English native splash and brief Flutter localized splash after (per §8.5) |

| Memory on older Android | `memCacheWidth` cap, evict Hive cache >50MB, profile early on real device |

| Hardcoded balance values (tier difficulty, lifeline counts) in code | Extract `quiz\_config.json` from day one — data-driven |

&#x20;

\---

&#x20;

\## 14. Milestones (suggested)

&#x20;

1\. \*\*M0 — Scaffolding (½ day)\*\* ✅ — Flutter project, `flutter\_native\_splash` configured, 25 ARB files (English content, others stubbed), Riverpod + go\_router wired, Hive boxes opened, system bar config done, theme done.

2\. \*\*M1 — Catalog (1 day)\*\* ✅ — Load JSON, list with clade chips + search, DinoCard widget.

3\. \*\*M2 — Detail (1 day)\*\* — WikiRepository + cache, DetailScreen with Hero, attribution, source link.

4\. \*\*M3 — Quiz (2–3 days)\*\* — QuizBuilder, state machine, ladder UI, lifelines, SFX, confetti, checkpoints.

5\. \*\*M4 — Settings (½ day)\*\* — Language picker, Support page, License page, sound toggle.

6\. \*\*M5 — Polish (1–2 days)\*\* — Animations, app icons, store listings, accessibility check, real-device test.

7\. \*\*M6 — Translation pass\*\* — Send EN ARB out for SK + the rest; until then, fallback to EN is visible but acceptable.

\---

&#x20;

\## Mandatory features check

&#x20;

\- \[x] Localization scaffolded (25 locales) — §8.1

\- \[x] Strings go through translation layer — §8.2 (no inline literals)

\- \[x] System bottom bar stays visible (no immersive/fullscreen) — §8.3

\- \[x] Settings → "Support our work" link wired up — §8.4

\- \[ ] Splash screen shows slogan — §8.5, \*\*pending Peter's slogan approval\*\* (proposed: "Meet the giants of long ago.")

\- \[x] Settings → "Open source licenses" sub-page (auto-generated from deps) — §8.6 via `showLicensePage()`

&#x20;





