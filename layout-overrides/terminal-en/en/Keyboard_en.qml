/*
 * Terminal-oriented English user override layout.
 *
 * This is the current working preset for terminal use:
 * - normal symbols still use the standard symbols page
 * - Fn is a local in-layout toggle, not a new content type
 * - Ctrl/Alt are intentionally omitted until backend modifier support exists
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

    onTerminalFnEnabledChanged: panel.activeKeypadState = "NORMAL"

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

                CharKey { label: "q"; shifted: "Q"; extended: ["1"]; extendedShifted: ["1"]; leftSide: true; }
                CharKey { label: "w"; shifted: "W"; extended: ["2"]; extendedShifted: ["2"] }
                CharKey { label: "e"; shifted: "E"; extended: ["3", "è", "é", "ê", "ë", "€"]; extendedShifted: ["3", "È", "É", "Ê", "Ë", "€"] }
                CharKey { label: "r"; shifted: "R"; extended: ["4"]; extendedShifted: ["4"] }
                CharKey { label: "t"; shifted: "T"; extended: ["5", "þ"]; extendedShifted: ["5", "Þ"] }
                CharKey { label: "y"; shifted: "Y"; extended: ["6", "ý", "¥"]; extendedShifted: ["6", "Ý", "¥"] }
                CharKey { label: "u"; shifted: "U"; extended: ["7", "û", "ù", "ú", "ü"]; extendedShifted: ["7", "Û", "Ù", "Ú", "Ü"] }
                CharKey { label: "i"; shifted: "I"; extended: ["8", "î", "ï", "ì", "í"]; extendedShifted: ["8", "Î", "Ï", "Ì", "Í"] }
                CharKey { label: "o"; shifted: "O"; extended: ["9", "ö", "ô", "ò", "ó"]; extendedShifted: ["9", "Ö", "Ô", "Ò", "Ó"] }
                CharKey { label: "p"; shifted: "P"; extended: ["0"]; extendedShifted: ["0"]; rightSide: true; }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                CharKey { label: "a"; shifted: "A"; extended: ["ä", "à", "â", "ª", "á", "å", "æ"]; extendedShifted: ["Ä", "À", "Â", "ª", "Á", "Å", "Æ"]; leftSide: true; }
                CharKey { label: "s"; shifted: "S"; extended: ["ß", "$"]; extendedShifted: ["$"] }
                CharKey { label: "d"; shifted: "D"; extended: ["ð"]; extendedShifted: ["Ð"] }
                CharKey { label: "f"; shifted: "F"; }
                CharKey { label: "g"; shifted: "G"; }
                CharKey { label: "h"; shifted: "H"; }
                CharKey { label: "j"; shifted: "J"; }
                CharKey { label: "k"; shifted: "K"; }
                CharKey { label: "l"; shifted: "L"; rightSide: true; }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                ShiftKey {}
                CharKey { label: "z"; shifted: "Z"; }
                CharKey { label: "x"; shifted: "X"; }
                CharKey { label: "c"; shifted: "C"; extended: ["ç"]; extendedShifted: ["Ç"] }
                CharKey { label: "v"; shifted: "V"; }
                CharKey { label: "b"; shifted: "B"; }
                CharKey { label: "n"; shifted: "N"; extended: ["ñ"]; extendedShifted: ["Ñ"] }
                CharKey { label: "m"; shifted: "M"; }
                ArrowKey { direction: "up"; }
                BackspaceKey {}
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
