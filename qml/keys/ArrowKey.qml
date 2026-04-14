/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4

ActionKey {
    property string direction: "left"

    width: panel.keyWidth * 0.6

    label: {
        switch (direction) {
        case "up":
            return "\u2191"
        case "down":
            return "\u2193"
        case "right":
            return "\u2192"
        default:
            return "\u2190"
        }
    }
    shifted: label

    action: direction
}
