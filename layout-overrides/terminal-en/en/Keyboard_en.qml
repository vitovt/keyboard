/*
 * Terminal-oriented English user override layout.
 *
 * This is the current working preset for terminal use:
 * - normal symbols still use the standard symbols page
 * - Fn is a local in-layout toggle, not a new content type
 * - Ctrl is a one-shot terminal control key for letters
 * - Tab and F1-F12 are sent as terminal-friendly text/control sequences
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

    onTerminalFnEnabledChanged: {
        panel.activeKeypadState = "NORMAL";
        ctrlLatched = false;
    }

    function controlTextForLetter(letter) {
        var code = letter.toLowerCase().charCodeAt(0);
        if (code < 97 || code > 122)
            return "";

        return String.fromCharCode(code - 96);
    }

    function onKeyReleased(keyToSend, action) {
        if (ctrlLatched) {
            var controlText = controlTextForLetter(keyToSend);
            ctrlLatched = false;
            if (controlText.length > 0) {
                event_handler.onKeyReleased(controlText, "");
                return;
            }
        }

        event_handler.onKeyReleased(keyToSend, action);
    }

    Item {
        id: contentRoot

        anchors.fill: parent

        property int numberOfRows: 4
        // Keep key geometry stable when toggling the local Fn layer.
        property int maxNrOfKeys: 10

        Column {
            id: mainColumn

            anchors.fill: parent
            spacing: 0
            visible: !terminalKeypad.terminalFnEnabled

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "q"; shifted: "Q"; extended: ["1"]; extendedShifted: ["1"]; leftSide: true; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "w"; shifted: "W"; extended: ["2"]; extendedShifted: ["2"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "e"; shifted: "E"; extended: ["3", "è", "é", "ê", "ë", "€"]; extendedShifted: ["3", "È", "É", "Ê", "Ë", "€"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "r"; shifted: "R"; extended: ["4"]; extendedShifted: ["4"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "t"; shifted: "T"; extended: ["5", "þ"]; extendedShifted: ["5", "Þ"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "y"; shifted: "Y"; extended: ["6", "ý", "¥"]; extendedShifted: ["6", "Ý", "¥"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "u"; shifted: "U"; extended: ["7", "û", "ù", "ú", "ü"]; extendedShifted: ["7", "Û", "Ù", "Ú", "Ü"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "i"; shifted: "I"; extended: ["8", "î", "ï", "ì", "í"]; extendedShifted: ["8", "Î", "Ï", "Ì", "Í"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "o"; shifted: "O"; extended: ["9", "ö", "ô", "ò", "ó"]; extendedShifted: ["9", "Ö", "Ô", "Ò", "Ó"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "p"; shifted: "P"; extended: ["0"]; extendedShifted: ["0"]; rightSide: true; }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "a"; shifted: "A"; extended: ["ä", "à", "â", "ª", "á", "å", "æ"]; extendedShifted: ["Ä", "À", "Â", "ª", "Á", "Å", "Æ"]; leftSide: true; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "s"; shifted: "S"; extended: ["ß", "$"]; extendedShifted: ["$"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "d"; shifted: "D"; extended: ["ð"]; extendedShifted: ["Ð"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "f"; shifted: "F"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "g"; shifted: "G"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "h"; shifted: "H"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "j"; shifted: "J"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "k"; shifted: "K"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "l"; shifted: "L"; rightSide: true; }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                ShiftKey { width: panel.keyWidth * 0.85 }
                ActionKey {
                    label: terminalKeypad.ctrlLatched ? "Ctrl*" : "Ctrl"
                    shifted: label
                    width: panel.keyWidth * 0.9
                    noMagnifier: true
                    skipAutoCaps: true
                    overridePressArea: true
                    textCenterOffset: 0

                    onPressed: {
                        Feedback.keyPressed();
                        terminalKeypad.ctrlLatched = !terminalKeypad.ctrlLatched;
                    }
                }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "z"; shifted: "Z"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "x"; shifted: "X"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "c"; shifted: "C"; extended: ["ç"]; extendedShifted: ["Ç"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "v"; shifted: "V"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "b"; shifted: "B"; }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "n"; shifted: "N"; extended: ["ñ"]; extendedShifted: ["Ñ"] }
                Terminal.TerminalCtrlCharKey { terminalHandler: terminalKeypad; label: "m"; shifted: "M"; }
                ArrowKey { direction: "up"; }
                BackspaceKey { width: panel.keyWidth * 0.9 }
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

                SpaceKey {
                    id: spaceKey

                    anchors.left: languageKey.right
                    anchors.right: fnKey.left
                    height: parent.height
                    noMagnifier: true
                }

                ActionKey {
                    id: fnKey

                    anchors.right: leftArrowKey.left
                    height: parent.height
                    width: panel.keyWidth * 0.85

                    label: "Fn"
                    shifted: label
                    noMagnifier: true
                    skipAutoCaps: true
                    overridePressArea: true
                    textCenterOffset: 0

                    onPressed: {
                        Feedback.keyPressed();
                        terminalKeypad.terminalFnEnabled = true;
                    }
                }

                ArrowKey {
                    id: leftArrowKey

                    direction: "left"
                    anchors.right: downArrowKey.left
                    height: parent.height
                }

                ArrowKey {
                    id: downArrowKey

                    direction: "down"
                    anchors.right: rightArrowKey.left
                    height: parent.height
                }

                ArrowKey {
                    id: rightArrowKey

                    direction: "right"
                    anchors.right: enterKey.left
                    height: parent.height
                }

                ReturnKey {
                    id: enterKey

                    anchors.right: parent.right
                    height: parent.height
                    width: panel.keyWidth * 1.3
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

                Terminal.TerminalInsertKey { label: "F1";  submitText: "\u001bOP" }
                Terminal.TerminalInsertKey { label: "F2";  submitText: "\u001bOQ" }
                Terminal.TerminalInsertKey { label: "F3";  submitText: "\u001bOR" }
                Terminal.TerminalInsertKey { label: "F4";  submitText: "\u001bOS" }
                Terminal.TerminalInsertKey { label: "F5";  submitText: "\u001b[15~" }
                Terminal.TerminalInsertKey { label: "F6";  submitText: "\u001b[17~" }
                Terminal.TerminalInsertKey { label: "F7";  submitText: "\u001b[18~" }
                Terminal.TerminalInsertKey { label: "F8";  submitText: "\u001b[19~" }
                Terminal.TerminalInsertKey { label: "F9";  submitText: "\u001b[20~" }
                Terminal.TerminalInsertKey { label: "F10"; submitText: "\u001b[21~" }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalSequenceKey { label: "Esc"; sequence: "Esc" }
                Terminal.TerminalInsertKey { label: "Tab"; submitText: "\t" }
                Terminal.TerminalInsertKey { label: "|";   submitText: "|" }
                Terminal.TerminalInsertKey { label: "-";   submitText: "-" }
                Terminal.TerminalInsertKey { label: "F11"; submitText: "\u001b[23~" }
                Terminal.TerminalInsertKey { label: "F12"; submitText: "\u001b[24~" }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                ArrowKey { direction: "left" }
                ArrowKey { direction: "right" }
                ArrowKey { direction: "up" }
                ArrowKey { direction: "down" }
                ReturnKey {}
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Terminal.TerminalSequenceKey { label: "Home"; sequence: "Home" }
                Terminal.TerminalSequenceKey { label: "End";  sequence: "End" }
                Terminal.TerminalSequenceKey { label: "PgUp"; sequence: "PgUp" }
                Terminal.TerminalSequenceKey { label: "PgDn"; sequence: "PgDown" }
                ActionKey { label: "Paste"; shifted: label; action: "paste"; noMagnifier: true; skipAutoCaps: true; textCenterOffset: 0 }
                Terminal.TerminalInsertKey { label: "Ctrl+C"; submitText: "\u0003" }

                ActionKey {
                    height: panel.keyHeight
                    width: panel.keyWidth

                    label: "ABC"
                    shifted: label
                    noMagnifier: true
                    skipAutoCaps: true
                    overridePressArea: true
                    textCenterOffset: 0

                    onPressed: {
                        Feedback.keyPressed();
                        terminalKeypad.terminalFnEnabled = false;
                    }
                }
            }
        }
    }
}
