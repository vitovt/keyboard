/*
 * Terminal-oriented backspace key with one-shot modifier dispatch.
 */

import QtQuick 2.4

import MaliitKeyboard 2.0

import keys 1.0

ActionKey {
    property var terminalHandler
    property real widthUnits: 1.0

    width: panel.keyWidth * widthUnits

    iconNormal: "edit-clear-symbolic"
    iconShifted: iconNormal
    iconCapsLock: iconNormal

    action: "backspace"
    noMagnifier: true
    skipAutoCaps: true
    overridePressArea: true

    onPressed: {
        Feedback.keyPressed()
    }

    onReleased: {
        terminalHandler.onTerminalKeyReleased("", "backspace", "Backspace")
    }
}
