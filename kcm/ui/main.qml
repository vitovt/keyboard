// SPDX-License-Identifier: BSD-3-Clause

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.ScrollViewKCM {
    id: root

    ColumnLayout {
        width: parent ? parent.width : implicitWidth
        spacing: Kirigami.Units.largeSpacing

        Kirigami.InlineMessage {
            Layout.fillWidth: true
            type: Kirigami.MessageType.Information
            showCloseButton: false
            text: i18n("Layouts in %1 override the packaged Maliit layouts automatically.", kcm.layoutOverridePath)
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            level: 2
            text: i18n("Layouts")
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Repeater {
                model: kcm.availableLanguages

                delegate: QQC2.CheckDelegate {
                    Layout.fillWidth: true
                    text: modelData.name
                    checked: kcm.enabledLanguages.indexOf(modelData.id) !== -1
                    enabled: checked || kcm.enabledLanguages.length > 1
                    onClicked: kcm.setLanguageEnabled(modelData.id, checked)
                }
            }
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            level: 3
            text: i18n("Active layout")
            visible: kcm.enabledLanguages.length > 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            visible: kcm.enabledLanguages.length > 0

            Repeater {
                model: kcm.enabledLanguages

                delegate: QQC2.RadioDelegate {
                    Layout.fillWidth: true
                    text: kcm.languageDisplayName(modelData)
                    checked: modelData === kcm.activeLanguage
                    onClicked: kcm.activeLanguage = modelData
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            level: 2
            text: i18n("Typing")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.CheckBox {
                Kirigami.FormData.label: i18n("General:")
                text: i18n("Auto-capitalization")
                checked: kcm.autoCapitalizationEnabled
                onToggled: kcm.autoCapitalizationEnabled = checked
            }

            QQC2.CheckBox {
                text: i18n("Auto-completion")
                checked: kcm.autoCompletionEnabled
                onToggled: kcm.autoCompletionEnabled = checked
            }

            QQC2.CheckBox {
                text: i18n("Predictive text")
                checked: kcm.predictiveTextEnabled
                onToggled: kcm.predictiveTextEnabled = checked
            }

            QQC2.CheckBox {
                text: i18n("Spell checking")
                checked: kcm.spellCheckingEnabled
                onToggled: kcm.spellCheckingEnabled = checked
            }

            QQC2.CheckBox {
                text: i18n("Double-space full stop")
                checked: kcm.doubleSpaceFullStopEnabled
                onToggled: kcm.doubleSpaceFullStopEnabled = checked
            }
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            level: 2
            text: i18n("Feedback")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.CheckBox {
                Kirigami.FormData.label: i18n("On key press:")
                text: i18n("Sound")
                checked: kcm.soundEnabled
                onToggled: kcm.soundEnabled = checked
            }

            QQC2.CheckBox {
                text: i18n("Haptic feedback")
                checked: kcm.hapticFeedbackEnabled
                onToggled: kcm.hapticFeedbackEnabled = checked
            }

            QQC2.CheckBox {
                text: i18n("Key magnifier")
                checked: kcm.magnifierEnabled
                onToggled: kcm.magnifierEnabled = checked
            }
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            level: 2
            text: i18n("Appearance")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.SpinBox {
                id: opacitySpinBox
                Kirigami.FormData.label: i18n("Opacity:")
                from: 50
                to: 100
                stepSize: 5
                value: kcm.opacityPercent
                textFromValue: function(value) {
                    return value + "%"
                }
                valueFromText: function(text) {
                    return parseInt(text)
                }
                onValueChanged: kcm.opacityPercent = value
            }
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            level: 3
            text: i18n("Device profile")
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Repeater {
                model: kcm.deviceOptions

                delegate: QQC2.RadioDelegate {
                    Layout.fillWidth: true
                    text: kcm.deviceDisplayName(modelData)
                    checked: modelData === kcm.device
                    onClicked: kcm.device = modelData
                }
            }
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            level: 2
            text: i18n("Advanced")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.CheckBox {
                Kirigami.FormData.label: i18n("Runtime:")
                text: i18n("Stay hidden")
                checked: kcm.stayHidden
                onToggled: kcm.stayHidden = checked
            }

            QQC2.CheckBox {
                text: i18n("Disable height reporting")
                checked: kcm.disableHeightReporting
                onToggled: kcm.disableHeightReporting = checked
            }
        }
    }
}
