/*
 * Terminal-oriented insert key for user override layouts.
 */

import QtQuick 2.4

import MaliitKeyboard 2.0

import keys 1.0

ActionKey {
    property real widthUnits: 1.0
    property string submitText: label

    width: panel.keyWidth * widthUnits
    shifted: label
    valueToSubmit: submitText

    noMagnifier: true
    skipAutoCaps: true
    textCenterOffset: 0
}
