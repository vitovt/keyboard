/*
 * Terminal-oriented space key with one-shot modifier dispatch.
 */

import QtQuick 2.4

import MaliitKeyboard 2.0

import keys 1.0

ActionKey {
    property var terminalHandler
    property real widthUnits: 1.0

    width: panel.keyWidth * widthUnits

    label: " "
    shifted: " "

    action: "space"
    switchBackFromSymbols: true
    noMagnifier: true
    overridePressArea: true

    Rectangle {
        anchors.margins: 8
        anchors.fill: parent
        color: "#888888"
        radius: 8
        opacity: parent.currentlyPressed ? 0.0 : 0.25
    }

    onPressed: {
        Feedback.keyPressed()
    }

    onReleased: {
        terminalHandler.onTerminalKeyReleased("", "space", "Space")
        if (switchBackFromSymbols && panel.state === "SYMBOLS") {
            panel.state = "CHARACTERS"
        }
    }
}
