# Store listings

Copy these into Play Console / App Store Connect for each locale. The
folder layout mirrors Fastlane Supply conventions so a future fastlane
setup can read them as-is.

```
store/
  <locale>/
    title.txt              # max 30 chars (Play) / 30 (App Store name)
    short_description.txt  # max 80 chars (Play subtitle)
    full_description.txt   # max 4000 chars (Play long description)
```

Per the plan we ship EN + SK + CS hand-written; the other 22 locales
inherit EN until M6 translations land.

## Privacy & data

Dinopedia stores no user accounts and no analytics. The only outbound
traffic is to `*.wikipedia.org` to fetch article summaries and to
`upload.wikimedia.org` for cached images. Cache lives on-device in Hive
and is evicted after 30 days. Reference this when filling the data-safety
form in Play Console.
