Layout Overrides
================

This directory contains ready-to-copy user layout overrides for Maliit
Keyboard.

These files are not used automatically from the repository checkout. They are
stored here as presets that you can copy into your user override directory:

- `~/.config/maliit/layouts`

The structure inside each preset mirrors the structure expected by Maliit in
the user override directory. In practice, that means the inner language
directories such as `en/` should be copied into:

- `~/.config/maliit/layouts/<language>/`

Why this directory exists
-------------------------

The main source tree contains the built-in packaged layouts.

This `layout-overrides/` directory is for experimental or optional layouts that
are better kept as user-level overrides:

- terminal-oriented layouts
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
- `Fn` screen with `F1` through `F12` sent as xterm-style escape sequences
- `Esc`, `Tab`, `Home`, `End`, `PgUp`, and `PgDown`
- terminal-friendly `|` and `-` on the `Fn` screen

Current limitation:

- `Ctrl` and `Alt` are intentionally omitted for now
- the current backend still needs extra work for universal modifier support

How to activate `terminal-en`
-----------------------------

Create the destination directory:

```console
$ mkdir -p ~/.config/maliit/layouts/en
```

Copy all files from this preset:

```console
$ cp layout-overrides/terminal-en/en/Keyboard_en.qml ~/.config/maliit/layouts/en/
$ cp layout-overrides/terminal-en/en/TerminalSequenceKey.qml ~/.config/maliit/layouts/en/
$ cp layout-overrides/terminal-en/en/TerminalInsertKey.qml ~/.config/maliit/layouts/en/
```

Why all three files are needed:

- `Keyboard_en.qml` is the actual override layout
- `TerminalSequenceKey.qml` is used for working special keys such as `Esc`
- `TerminalInsertKey.qml` is used for terminal text/control sequences such as `Tab` and `F1`...`F12`

After copying the files, restart Maliit Keyboard or switch away from English
and back again so the override path is re-evaluated.

How to disable it again
-----------------------

Remove the copied override files:

```console
$ rm ~/.config/maliit/layouts/en/Keyboard_en.qml
$ rm ~/.config/maliit/layouts/en/TerminalSequenceKey.qml
$ rm ~/.config/maliit/layouts/en/TerminalInsertKey.qml
```

Then restart the keyboard or switch languages again to return to the packaged
English layout.

### `terminalmax-en`

Path in this repository:

- `layout-overrides/terminalmax-en/en/`

This preset is an experimental terminal-oriented English layout with a larger
Fn screen and one-shot modifier support.

Current terminalmax features:

- everything from `terminal-en`
- `Ctrl`, `Alt`, and `Shift` buttons on the `Fn` screen
- one-shot modifier latching
- modifiers stay active when you leave the `Fn` screen
- the latched modifier is applied to the next terminal-aware key and then cleared
- `Esc`, `Tab`, `Home`, `End`, `PgUp`, and `PgDown` are sent as real key events
- `F1`...`F12` use terminal escape sequences unless a modifier is latched
- intended workflows such as `Ctrl+C`, `Ctrl+R`, `Alt+Left`, `Shift+Tab`

Current behavior notes:

- modifier keys stay latched until the next terminal-aware key is sent
- this preset depends on the backend support present in this branch
- this preset is still more experimental than `terminal-en`

How to activate `terminalmax-en`
--------------------------------

Create the destination directory:

```console
$ mkdir -p ~/.config/maliit/layouts/en
```

Copy all files from this preset:

```console
$ cp layout-overrides/terminalmax-en/en/* ~/.config/maliit/layouts/en/
```

After copying the files, restart Maliit Keyboard or switch away from English
and back again so the override path is re-evaluated.
