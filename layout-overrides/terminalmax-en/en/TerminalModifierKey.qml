/*
 * Terminal-oriented modifier latch key.
 */

import QtQuick 2.4

import MaliitKeyboard 2.0

import keys 1.0

ActionKey {
    id: modifierKey

    property var terminalHandler
    property string modifierName: "Ctrl"
    property bool active: false
    property real widthUnits: 1.0

    width: panel.keyWidth * widthUnits
    label: modifierName
    shifted: label
    annotation: active ? "\u25cf" : ""

    noMagnifier: true
    skipAutoCaps: true
    overridePressArea: true
    textCenterOffset: 0

    Rectangle {
        anchors.fill: parent
        anchors.margins: Device.gu(0.15)
        color: "#5a99c8"
        opacity: active ? 0.18 : 0.0
        radius: Device.gu(0.5)
    }

    onPressed: {
        Feedback.keyPressed()
    }

    onReleased: {
        terminalHandler.toggleModifier(modifierName)
    }
}
