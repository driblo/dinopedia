# Audio assets

Drop the following SFX files here to enable quiz sound:

- `correct.mp3` — plays on correct answer
- `wrong.mp3` — plays on wrong answer
- `win.mp3` — plays when finishing all tiers
- `checkpoint.mp3` — plays when a checkpoint is reached

`SfxPlayer` (`lib/src/features/quiz/sfx.dart`) fails open: if a file is
missing, playback is a no-op and the quiz keeps running. This keeps the
build green until the audio assets land.
