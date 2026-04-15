/*
 * Terminal-oriented return key with one-shot modifier dispatch.
 */

import QtQuick 2.4

import keys 1.0

ReturnKey {
    property var terminalHandler
    property real widthUnits: 1.0

    width: panel.keyWidth * widthUnits

    allowPreeditHandler: true
    preeditHandler: Item {
        function onKeyReleased(keyString, action) {
            terminalHandler.onTerminalKeyReleased("", "return", "Return")
        }
    }
}
