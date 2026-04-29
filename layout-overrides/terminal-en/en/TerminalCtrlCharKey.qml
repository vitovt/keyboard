/*
 * Terminal-oriented character key with one-shot Ctrl support.
 */

import QtQuick 2.4

import MaliitKeyboard 2.0

import keys 1.0

CharKey {
    property var terminalHandler

    allowPreeditHandler: terminalHandler && terminalHandler.ctrlLatched
    preeditHandler: terminalHandler
}
