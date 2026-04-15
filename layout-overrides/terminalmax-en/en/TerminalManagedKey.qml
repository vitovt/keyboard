/*
 * Terminal-oriented action key with explicit dispatch metadata.
 */

import QtQuick 2.4

import keys 1.0

ActionKey {
    property var terminalHandler
    property real widthUnits: 1.0
    property string terminalAction: action
    property string terminalValue: label
    property string terminalSequenceToken: terminalValue

    width: panel.keyWidth * widthUnits
    shifted: label
    valueToSubmit: terminalValue
    action: terminalAction

    noMagnifier: true
    skipAutoCaps: true
    textCenterOffset: 0

    allowPreeditHandler: true
    preeditHandler: Item {
        function onKeyReleased(keyString, action) {
            terminalHandler.onTerminalKeyReleased(terminalValue, terminalAction, terminalSequenceToken)
        }
    }
}
