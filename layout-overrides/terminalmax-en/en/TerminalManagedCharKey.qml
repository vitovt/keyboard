/*
 * Terminal-oriented character key with one-shot modifier dispatch.
 */

import QtQuick 2.4

import keys 1.0

CharKey {
    property var terminalHandler

    allowPreeditHandler: true
    preeditHandler: Item {
        function onKeyReleased(keyString, action) {
            terminalHandler.onTerminalKeyReleased(keyString, action, keyString)
        }
    }
}
