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
