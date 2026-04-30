Layout Overrides
================

This directory contains ready-to-copy user layout overrides for Maliit
Keyboard.

These files are not used automatically from the repository checkout. They are
stored here as presets that you can copy into your user override directory:

- `~/.config/maliit/layouts`

The structure inside each preset mirrors the structure expected by Maliit in
the user override directory. In practice, that means the whole inner language
directory, such as `en/` or `uk/`, should be copied into:

- `~/.config/maliit/layouts/<language>/`

Copy the complete language directory, not individual QML files. Once a
language directory exists under `~/.config/maliit/layouts`, Maliit resolves the
layout from that override directory first. If only some files are copied, other
input contexts such as URL, email, search, or the language plugin may be
missing and the keyboard can show an empty white layout.

Why this directory exists
-------------------------

The main source tree contains the built-in packaged layouts.

This `layout-overrides/` directory is for experimental or optional layouts that
are better kept as user-level overrides:

- terminal-oriented layouts
- layouts with additional language-specific characters
- personal workflow layouts
- layouts that still need runtime testing
- layouts you may want to enable only on one machine

That makes it possible to test and iterate on custom layouts without rebuilding
or reinstalling the package every time.

Available Presets
-----------------

### `terminal-en`

Path in this repository:

- `layout-overrides/terminal-en/en/`

This preset replaces the normal English layout with a terminal-oriented
variant.

Current terminal-oriented features:

- direct arrow keys on the main English layout
- language switching on the main layout
- local `Fn` toggle inside the layout
- one-shot `Ctrl` key on the main layout for terminal control-letter
  shortcuts such as `Ctrl+C`, `Ctrl+R`, and `Ctrl+D`
- `Fn` screen with `F1` through `F12` sent as xterm-style escape sequences
- `Esc`, `Tab`, `Home`, `End`, `PgUp`, and `PgDown`
- terminal-friendly `|` and `-` on the `Fn` screen

Current limitation:

- `Ctrl` is intentionally limited to one-shot letter combinations for
  terminal workflows
- `Alt` and universal graphical shortcut modifiers are intentionally omitted
  for now

How to activate `terminal-en`
-----------------------------

Copy the whole preset language directory:

```console
$ mkdir -p ~/.config/maliit/layouts
$ cp -a layout-overrides/terminal-en/en ~/.config/maliit/layouts/
```

Do not copy only `Keyboard_en.qml`. This preset also needs helper QML files and
the language plugin file from the same `en/` directory.

After copying the directory, restart Maliit Keyboard or switch away from
English and back again so the override path is re-evaluated.

### `ukr-cyrextended`

Path in this repository:

- `layout-overrides/ukr-cyrextended/uk/`

This preset replaces the normal Ukrainian layout with a Ukrainian layout that
adds extra Cyrillic characters inspired by the "Strange Ukrainian" Windows
layout.

Additional long-press characters:

- `е`: `ё`
- `ї`: `ъ`
- `і`: `ы`
- `є`: `э`

The existing Ukrainian long-press characters, such as `ґ`, `₴`, and `ʼ`, are
kept.

How to activate `ukr-cyrextended`
---------------------------------

Copy the whole preset language directory:

```console
$ mkdir -p ~/.config/maliit/layouts
$ cp -a layout-overrides/ukr-cyrextended/uk ~/.config/maliit/layouts/
```

Do not copy only `Keyboard_uk.qml`. The `uk/` directory must include all
context-specific layout files and the Ukrainian language plugin file.

After copying the directory, restart Maliit Keyboard or switch away from
Ukrainian and back again so the override path is re-evaluated.

How to disable it again
-----------------------

Remove the copied override directory for the language:

```console
$ rm -r ~/.config/maliit/layouts/en
$ rm -r ~/.config/maliit/layouts/uk
```

Remove only the language directory you want to disable. Then restart the
keyboard or switch languages again to return to the packaged layout.
