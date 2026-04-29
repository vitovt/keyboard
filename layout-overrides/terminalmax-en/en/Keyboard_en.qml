/*
 * Terminal-oriented English user override layout with one-shot modifiers.
 *
 * This preset is intended for terminal use and keeps the extra service keys
 * behind a local Fn layer. Ctrl, Alt, and Shift can be latched on the Fn page
 * and are applied to the next terminal-aware key press.
 */

import QtQuick 2.4

import MaliitKeyboard 2.0

import keys 1.0
import "." as Terminal

KeyPad {
    id: terminalKeypad

    anchors.fill: parent

    content: contentRoot
    symbols: "languages/Keyboard_symbols.qml"

    property bool terminalFnEnabled: false
    property bool ctrlLatched: false
    property bool altLatched: false
    property bool shiftLatched: false
    property string activeModifierIndicator: {
        var indicators = []
        if (ctrlLatched) {
            indicators.push("C")
        }
        if (altLatched) {
            indicators.push("A")
        }
        if (shiftLatched) {
            indicators.push("S")
        }
        return indicators.join("")
    }

    function currentModifiers() {
        var modifiers = []
        if (ctrlLatched) {
            modifiers.push("Ctrl")
        }
        if (altLatched) {
            modifiers.push("Alt")
        }
        if (shiftLatched) {
            modifiers.push("Shift")
        }
        return modifiers
    }

    function hasLatchedModifiers() {
        return ctrlLatched || altLatched || shiftLatched
    }

    function syncVisualShift() {
        if (panel.state !== "CHARACTERS") {
            return
        }

        if (shiftLatched) {
            panel.activeKeypadState = "SHIFTED"
        } else if (panel.activeKeypadState === "SHIFTED") {
            panel.activeKeypadState = "NORMAL"
        }
    }

    function clearLatchedModifiers() {
        ctrlLatched = false
        altLatched = false
        shiftLatched = false
        syncVisualShift()
    }

    function resetTerminalState() {
        terminalFnEnabled = false
        clearLatchedModifiers()
    }

    function toggleModifier(modifierName) {
        switch (modifierName) {
        case "Ctrl":
            ctrlLatched = !ctrlLatched
            break
        case "Alt":
            altLatched = !altLatched
            break
        case "Shift":
            shiftLatched = !shiftLatched
            break
        default:
            break
        }

        syncVisualShift()
    }

    function onTerminalKeyReleased(value, action, sequenceToken) {
        var token = sequenceToken || value

        if (hasLatchedModifiers() && token !== "") {
            event_handler.onKeyReleased(currentModifiers().join("+") + "+" + token, "keysequence")
            clearLatchedModifiers()
            return
        }

        if (action === "" || action === "terminal-insert") {
            event_handler.onKeyReleased(value, "")
            return
        }

        event_handler.onKeyReleased(value, action)
    }

    onTerminalFnEnabledChanged: {
        if (terminalFnEnabled) {
            panel.activeKeypadState = "NORMAL"
        } else {
            syncVisualShift()
        }
    }

    onShiftLatchedChanged: syncVisualShift()

    Connections {
        target: MaliitGeometry

        function onShownChanged() {
            if (!MaliitGeometry.shown) {
                terminalKeypad.resetTerminalState()
            }
        }
    }

    Item {
        id: contentRoot

        anchors.fill: parent

        property int numberOfRows: 4
        property int maxNrOfKeys: 10

        Column {
            id: mainColumn

            anchors.fill: parent
            spacing: 0
            visible: !terminalKeypad.terminalFnEnabled

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "q"; shifted: "Q"; extended: ["1"]; extendedShifted: ["1"]; leftSide: true }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "w"; shifted: "W"; extended: ["2"]; extendedShifted: ["2"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "e"; shifted: "E"; extended: ["3", "è", "é", "ê", "ë", "€"]; extendedShifted: ["3", "È", "É", "Ê", "Ë", "€"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "r"; shifted: "R"; extended: ["4"]; extendedShifted: ["4"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "t"; shifted: "T"; extended: ["5", "þ"]; extendedShifted: ["5", "Þ"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "y"; shifted: "Y"; extended: ["6", "ý", "¥"]; extendedShifted: ["6", "Ý", "¥"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "u"; shifted: "U"; extended: ["7", "û", "ù", "ú", "ü"]; extendedShifted: ["7", "Û", "Ù", "Ú", "Ü"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "i"; shifted: "I"; extended: ["8", "î", "ï", "ì", "í"]; extendedShifted: ["8", "Î", "Ï", "Ì", "Í"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "o"; shifted: "O"; extended: ["9", "ö", "ô", "ò", "ó"]; extendedShifted: ["9", "Ö", "Ô", "Ò", "Ó"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "p"; shifted: "P"; extended: ["0"]; extendedShifted: ["0"]; rightSide: true }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "a"; shifted: "A"; extended: ["ä", "à", "â", "ª", "á", "å", "æ"]; extendedShifted: ["Ä", "À", "Â", "ª", "Á", "Å", "Æ"]; leftSide: true }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "s"; shifted: "S"; extended: ["ß", "$"]; extendedShifted: ["$"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "d"; shifted: "D"; extended: ["ð"]; extendedShifted: ["Ð"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "f"; shifted: "F" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "g"; shifted: "G" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "h"; shifted: "H" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "j"; shifted: "J" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "k"; shifted: "K" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "l"; shifted: "L"; rightSide: true }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                ShiftKey {}
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "z"; shifted: "Z" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "x"; shifted: "X" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "c"; shifted: "C"; extended: ["ç"]; extendedShifted: ["Ç"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "v"; shifted: "V" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "b"; shifted: "B" }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "n"; shifted: "N"; extended: ["ñ"]; extendedShifted: ["Ñ"] }
                Terminal.TerminalManagedCharKey { terminalHandler: terminalKeypad; label: "m"; shifted: "M" }
                Terminal.TerminalManagedArrowKey { terminalHandler: terminalKeypad; direction: "up" }
                Terminal.TerminalManagedBackspaceKey { terminalHandler: terminalKeypad; widthUnits: 1.15 }
            }

            Item {
                anchors.left: parent.left
                anchors.right: parent.right

                height: panel.keyHeight + Device.row_margin

                SymbolShiftKey {
                    id: symbolsKey

                    anchors.left: parent.left
                    height: parent.height
                    width: panel.keyWidth * 1.15
                }

                LanguageKey {
                    id: languageKey

                    anchors.left: symbolsKey.right
                    height: parent.height
                }

                Terminal.TerminalManagedSpaceKey {
                    id: spaceKey

                    terminalHandler: terminalKeypad
                    anchors.left: languageKey.right
                    anchors.right: fnKey.left
                    height: parent.height
                }

                ActionKey {
                    id: fnKey

                    anchors.right: leftArrowKey.left
                    height: parent.height
                    width: panel.keyWidth * 0.85

                    label: "Fn"
                    shifted: label
                    annotation: terminalKeypad.activeModifierIndicator
                    noMagnifier: true
                    skipAutoCaps: true
                    overridePressArea: true
                    textCenterOffset: 0

                    onPressed: {
                        Feedback.keyPressed()
                        terminalKeypad.terminalFnEnabled = true
                    }
                }

                Terminal.TerminalManagedArrowKey {
                    id: leftArrowKey

                    terminalHandler: terminalKeypad
                    direction: "left"
                    anchors.right: downArrowKey.left
                    height: parent.height
                }

                Terminal.TerminalManagedArrowKey {
                    id: downArrowKey

                    terminalHandler: terminalKeypad
                    direction: "down"
                    anchors.right: rightArrowKey.left
                    height: parent.height
                }

                Terminal.TerminalManagedArrowKey {
                    id: rightArrowKey

                    terminalHandler: terminalKeypad
                    direction: "right"
                    anchors.right: enterKey.left
                    height: parent.height
                }

                Terminal.TerminalManagedReturnKey {
                    id: enterKey

                    terminalHandler: terminalKeypad
                    anchors.right: parent.right
                    height: parent.height
                    widthUnits: 1.3
                }
            }
        }

        Column {
            id: fnColumn

            anchors.fill: parent
            spacing: 0
            visible: terminalKeypad.terminalFnEnabled

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F1"; terminalAction: "terminal-insert"; terminalValue: "\u001bOP"; terminalSequenceToken: "F1" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F2"; terminalAction: "terminal-insert"; terminalValue: "\u001bOQ"; terminalSequenceToken: "F2" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F3"; terminalAction: "terminal-insert"; terminalValue: "\u001bOR"; terminalSequenceToken: "F3" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F4"; terminalAction: "terminal-insert"; terminalValue: "\u001bOS"; terminalSequenceToken: "F4" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F5"; terminalAction: "terminal-insert"; terminalValue: "\u001b[15~"; terminalSequenceToken: "F5" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F6"; terminalAction: "terminal-insert"; terminalValue: "\u001b[17~"; terminalSequenceToken: "F6" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F7"; terminalAction: "terminal-insert"; terminalValue: "\u001b[18~"; terminalSequenceToken: "F7" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F8"; terminalAction: "terminal-insert"; terminalValue: "\u001b[19~"; terminalSequenceToken: "F8" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F9"; terminalAction: "terminal-insert"; terminalValue: "\u001b[20~"; terminalSequenceToken: "F9" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F10"; terminalAction: "terminal-insert"; terminalValue: "\u001b[21~"; terminalSequenceToken: "F10" }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalModifierKey { terminalHandler: terminalKeypad; modifierName: "Ctrl"; active: terminalKeypad.ctrlLatched }
                Terminal.TerminalModifierKey { terminalHandler: terminalKeypad; modifierName: "Alt"; active: terminalKeypad.altLatched }
                Terminal.TerminalModifierKey { terminalHandler: terminalKeypad; modifierName: "Shift"; active: terminalKeypad.shiftLatched }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "Esc"; terminalAction: "keysequence"; terminalValue: "Esc"; terminalSequenceToken: "Esc" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "Tab"; terminalAction: "keysequence"; terminalValue: "Tab"; terminalSequenceToken: "Tab" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "|"; terminalAction: "keysequence"; terminalValue: "|"; terminalSequenceToken: "|" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "-"; terminalAction: "keysequence"; terminalValue: "-"; terminalSequenceToken: "-" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F11"; terminalAction: "terminal-insert"; terminalValue: "\u001b[23~"; terminalSequenceToken: "F11" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "F12"; terminalAction: "terminal-insert"; terminalValue: "\u001b[24~"; terminalSequenceToken: "F12" }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalManagedArrowKey { terminalHandler: terminalKeypad; direction: "left" }
                Terminal.TerminalManagedArrowKey { terminalHandler: terminalKeypad; direction: "right" }
                Terminal.TerminalManagedArrowKey { terminalHandler: terminalKeypad; direction: "up" }
                Terminal.TerminalManagedArrowKey { terminalHandler: terminalKeypad; direction: "down" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "Home"; terminalAction: "keysequence"; terminalValue: "Home"; terminalSequenceToken: "Home" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "End"; terminalAction: "keysequence"; terminalValue: "End"; terminalSequenceToken: "End" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "PgUp"; terminalAction: "keysequence"; terminalValue: "PgUp"; terminalSequenceToken: "PgUp" }
                Terminal.TerminalManagedKey { terminalHandler: terminalKeypad; label: "PgDn"; terminalAction: "keysequence"; terminalValue: "PgDown"; terminalSequenceToken: "PgDown" }
                Terminal.TerminalManagedBackspaceKey { terminalHandler: terminalKeypad }
                Terminal.TerminalManagedReturnKey { terminalHandler: terminalKeypad }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Spacer {}
                Spacer {}
                Spacer {}
                ActionKey {
                    height: panel.keyHeight
                    width: panel.keyWidth * 2

                    label: "ABC"
                    shifted: label
                    annotation: terminalKeypad.activeModifierIndicator
                    noMagnifier: true
                    skipAutoCaps: true
                    overridePressArea: true
                    textCenterOffset: 0

                    onPressed: {
                        Feedback.keyPressed()
                        terminalKeypad.terminalFnEnabled = false
                    }
                }
                Spacer {}
                Spacer {}
                Spacer {}
                Spacer {}
                Spacer {}
            }
        }
    }
}
