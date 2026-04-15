/*
 * Terminal-oriented action key for user override layouts.
 */

import QtQuick 2.4

import MaliitKeyboard 2.0

import keys 1.0

ActionKey {
    property real widthUnits: 1.0
    property string sequence: label

    width: panel.keyWidth * widthUnits
    shifted: label
    valueToSubmit: sequence
    action: "keysequence"

    noMagnifier: true
    skipAutoCaps: true
    textCenterOffset: 0
}
