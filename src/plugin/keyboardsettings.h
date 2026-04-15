/*
 * This file is part of Maliit Plugins
 *
 * Copyright (C) 2013 Canonical, Ltd.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Nokia Corporation nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#ifndef KEYBOARDSETTINGS_H
#define KEYBOARDSETTINGS_H

#include <QObject>
#include <QStringList>

class QGSettings;

namespace MaliitKeyboard {

class KeyboardSettings : public QObject
{
    Q_OBJECT
public:
    explicit KeyboardSettings(QObject *parent = nullptr);
    
    QString activeLanguage() const;
    void setActiveLanguage(const QString& id);
    void resetActiveLanguage();
    QStringList enabledLanguages() const;
    void setEnabledLanguages(const QStringList& ids);
    void resetEnabledLanguages();
    bool autoCapitalization() const;
    void setAutoCapitalization(bool enabled);
    bool autoCompletion() const;
    void setAutoCompletion(bool enabled);
    bool predictiveText() const;
    void setPredictiveText(bool enabled);
    bool spellchecking() const;
    void setSpellchecking(bool enabled);
    bool keyPressAudioFeedback() const;
    void setKeyPressAudioFeedback(bool enabled);
    QString keyPressAudioFeedbackSound() const;
    void setKeyPressAudioFeedbackSound(const QString& sound);
    bool keyPressHapticFeedback() const;
    void setKeyPressHapticFeedback(bool enabled);
    bool enableMagnifier() const;
    void setEnableMagnifier(bool enabled);
    bool doubleSpaceFullStop() const;
    void setDoubleSpaceFullStop(bool enabled);
    bool stayHidden() const;
    void setStayHidden(bool enabled);
    bool disableHeight() const;
    void setDisableHeight(bool enabled);
    QStringList pluginPaths() const;
    void setPluginPaths(const QStringList& paths);
    double opacity() const;
    void setOpacity(double value);
    QString theme() const;
    void setTheme(const QString& themeName);
    QString device() const;
    void setDevice(const QString& deviceName);

Q_SIGNALS:
    void activeLanguageChanged(QString);
    void enabledLanguagesChanged(QStringList);
    void autoCapitalizationChanged(bool);
    void autoCompletionChanged(bool);
    void predictiveTextChanged(bool);
    void spellCheckingChanged(bool);
    void keyPressAudioFeedbackChanged(bool);
    void keyPressAudioFeedbackSoundChanged(QString);
    void keyPressHapticFeedbackChanged(bool);
    void enableMagnifierChanged(bool);
    void doubleSpaceFullStopChanged(bool);
    void stayHiddenChanged(bool);
    void disableHeightChanged(bool);
    void pluginPathsChanged(QStringList);
    void opacityChanged(double);
    void themeChanged(const QString&);
    void deviceChanged(const QString&);

private:
    Q_SLOT void settingUpdated(const QString &key);

    QGSettings *m_settings;

    friend class TestKeyboardSettings;
};

} // namespace

#endif // KEYBOARDSETTINGS_H
