/*
 * Terminal-oriented arrow key with one-shot modifier dispatch.
 */

import QtQuick 2.4

import keys 1.0

ArrowKey {
    property var terminalHandler

    allowPreeditHandler: true
    preeditHandler: Item {
        function onKeyReleased(keyString, action) {
            var sequenceToken = "Left"
            switch (direction) {
            case "up":
                sequenceToken = "Up"
                break
            case "down":
                sequenceToken = "Down"
                break
            case "right":
                sequenceToken = "Right"
                break
            default:
                break
            }

            terminalHandler.onTerminalKeyReleased("", action, sequenceToken)
        }
    }
}
