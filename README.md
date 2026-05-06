Maliit Keyboard Community Fork
==============================

This repository is still **Maliit Keyboard**: the original virtual keyboard for
Linux systems with Wayland and X11, implemented as a plug-in for the Maliit
Framework.

The purpose of this fork is not to replace Maliit with a different project
identity, but to keep `maliit/keyboard` usable by collecting compatible fixes
and improvements that were previously scattered across multiple community forks.

Maliit Keyboard evolved from the
[reference keyboard plug-in](https://github.com/maliit/plugins),
[Ubuntu Keyboard](https://launchpad.net/ubuntu-keyboard) and
[Lomiri Keyboard](https://github.com/maliit/keyboard/pull/60). Ubuntu Keyboard
was a fork of the reference plugin which was taking into account the special
UI/UX needs of Ubuntu Phone.

Why This Fork Exists
--------------------

The upstream project has useful fixes spread across several abandoned or
special-purpose forks, but no single fork contains all of them. This fork
aggregates the parts that are practical to keep together in one tree.

Changes Relative to Original `maliit/keyboard`
----------------------------------------------

Compared with upstream `maliit/keyboard`, this fork currently adds:

- crash fixes for keyboard hide/show re-entrancy
- a fix for the regression where the keyboard does not reappear after hiding
- reduced VRAM usage while the keyboard is hidden
- follow-up stability fixes for the hidden-keyboard VRAM work
- more robust surrounding-text handling
- tests for surrounding-text overflow protection
- a small `UpdateNotifier` refactor related to surrounding-text robustness
- a null check in the `visibleRectChanged` path
- a fix for the `visibleRectChanged` lambda capture compilation issue
- a fix for a typo that caused missing backspace and enter icons
- a fallback so the emoji keyboard still works when QML `LocalStorage` fails
- key hover highlighting
- a Plasma 6 system settings URL fix
- the missing `de-ch` keyboard layout variant
- English layout navigation arrows
- long-press arrow extensions for `Home`, `End`, `PgUp`, and `PgDown`
- per-user layout overrides from `~/.config/maliit/layouts`

Community Sources Incorporated
------------------------------

The current fork includes work adapted from these community repositories:

- `cwt/maliit-keyboard-robust`
  - crash, stability, VRAM, surrounding-text, emoji, and icon fixes
- `DanielMcInnes/keyboard`
  - hover feedback for keys
- `vojtapl/keyboard`
  - Plasma 6 settings integration fix
- `mbgevers/keyboard`
  - missing `de-ch` layout files
- `snetsplit/keyboard`
  - navigation-arrow idea, selectively adapted for the English layout

This fork intentionally does not import every change from those repositories.
Only the parts that fit this tree and are useful here are kept.

User Layout Overrides
---------------------

This fork also looks for per-user layout overrides in:

- `~/.config/maliit/layouts`

That directory is checked before the built-in system layout directory, so a user
layout can override an existing layout without rebuilding or reinstalling the
package.

Expected directory structure:

```text
~/.config/maliit/layouts/
└── en/
    ├── Keyboard_en.qml
    ├── Keyboard_en_email.qml
    ├── Keyboard_en_url.qml
    └── Keyboard_en_url_search.qml
```

Only the QML layout files need to be overridden there. The compiled language
plugin can still come from the system installation.

Important: layout overrides are currently resolved per language directory, not
per individual file. If `~/.config/maliit/layouts/en` exists, Maliit will use
that directory as the active English layout directory. Content-specific layouts
such as email and URL fields are then loaded from the same directory:

```text
~/.config/maliit/layouts/en/Keyboard_en.qml
~/.config/maliit/layouts/en/Keyboard_en_email.qml
~/.config/maliit/layouts/en/Keyboard_en_url_search.qml
```

There is no fallback to the packaged English email or URL layout when one of
those files is missing from the override directory. In that case the keyboard
may show a blank white area for that content type. Phone and number fields are
different: they use the shared built-in `Keyboard_telephone.qml` and
`Keyboard_numbers.qml`, so they can continue to work even when the English
override directory is incomplete.

Example: override the normal English layout from the source tree:

```console
$ mkdir -p ~/.config/maliit/layouts/en
$ cp plugins/en/qml/Keyboard_en*.qml ~/.config/maliit/layouts/en/
```

Then edit only the copied files you want to customize.

If you are working from an installed package instead of this source tree, copy
the original files from your installed Maliit layouts directory, typically:

```text
<libdir>/maliit/keyboard2/languages/<lang>/
```

After adding or changing override files, restart the keyboard or switch away
from the language and back again so the layout path is re-evaluated.

Debug Logging
-------------

Runtime debug logging follows the standard Qt/KDE logging-category mechanism.
Warnings and errors remain visible by default, while Maliit Keyboard debug
categories are quiet unless explicitly enabled.

The standalone `maliit-keyboard` executable also disables the noisy
`maliit.connection.wayland.debug` framework category by default when
`QT_LOGGING_RULES` is not already set.

To enable all Maliit Keyboard debug logs for one run:

```console
$ QT_LOGGING_RULES='maliit.keyboard.*.debug=true;maliit.pinyin.debug=true;maliit.connection.wayland.debug=true' maliit-keyboard
```

To enable one category:

```console
$ QT_LOGGING_RULES='maliit.keyboard.inputmethod.debug=true' maliit-keyboard
```

Installed packages also provide a `maliit-keyboard.categories` file for KDE
debug tooling such as `kdebugsettings`.

Ubuntu Build Script
-------------------

For Ubuntu-based systems such as Ubuntu, Kubuntu, and KDE neon, you do not
need to clone the whole repository just to build a package.

Download the standalone `build4ubuntu.sh` script from this repository, make it
executable, and run it. The script downloads the current Debian source package,
pulls the selected fork branch, builds a `.deb`, and places the resulting
artifacts in its output directory.

Typical usage:

```console
$ chmod +x build4ubuntu.sh
$ ./build4ubuntu.sh --install-build-deps
$ sudo apt install ./path/to/output/*.deb
```

License
-------

The license of the combined work is LGPL-3.0-only.

The majority of individual files in `src` are under a BSD license as written in
`COPYING.BSD`.

The majority of individual files in `qml` are under LGPL-3.0-only. New
contributions in that directory should be licensed under LGPL-3.0-or-later or
aforementioned BSD license.

All new code outside the `qml` directory should be licensed as defined in
`COPYING.BSD`.
