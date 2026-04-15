// SPDX-License-Identifier: BSD-3-Clause

#pragma once

#include <KQuickManagedConfigModule>

#include <QStringList>
#include <QVariantList>

#include <memory>

namespace MaliitKeyboard {
class KeyboardSettings;
}

class MaliitKcm : public KQuickManagedConfigModule
{
    Q_OBJECT
    Q_PROPERTY(QVariantList availableLanguages READ availableLanguages NOTIFY availableLanguagesChanged)
    Q_PROPERTY(QStringList enabledLanguages READ enabledLanguages NOTIFY enabledLanguagesChanged)
    Q_PROPERTY(QString activeLanguage READ activeLanguage WRITE setActiveLanguage NOTIFY activeLanguageChanged)
    Q_PROPERTY(bool autoCapitalizationEnabled READ autoCapitalizationEnabled WRITE setAutoCapitalizationEnabled NOTIFY autoCapitalizationEnabledChanged)
    Q_PROPERTY(bool autoCompletionEnabled READ autoCompletionEnabled WRITE setAutoCompletionEnabled NOTIFY autoCompletionEnabledChanged)
    Q_PROPERTY(bool predictiveTextEnabled READ predictiveTextEnabled WRITE setPredictiveTextEnabled NOTIFY predictiveTextEnabledChanged)
    Q_PROPERTY(bool spellCheckingEnabled READ spellCheckingEnabled WRITE setSpellCheckingEnabled NOTIFY spellCheckingEnabledChanged)
    Q_PROPERTY(bool soundEnabled READ soundEnabled WRITE setSoundEnabled NOTIFY soundEnabledChanged)
    Q_PROPERTY(bool hapticFeedbackEnabled READ hapticFeedbackEnabled WRITE setHapticFeedbackEnabled NOTIFY hapticFeedbackEnabledChanged)
    Q_PROPERTY(bool magnifierEnabled READ magnifierEnabled WRITE setMagnifierEnabled NOTIFY magnifierEnabledChanged)
    Q_PROPERTY(bool doubleSpaceFullStopEnabled READ doubleSpaceFullStopEnabled WRITE setDoubleSpaceFullStopEnabled NOTIFY doubleSpaceFullStopEnabledChanged)
    Q_PROPERTY(bool stayHidden READ stayHidden WRITE setStayHidden NOTIFY stayHiddenChanged)
    Q_PROPERTY(bool disableHeightReporting READ disableHeightReporting WRITE setDisableHeightReporting NOTIFY disableHeightReportingChanged)
    Q_PROPERTY(int opacityPercent READ opacityPercent WRITE setOpacityPercent NOTIFY opacityPercentChanged)
    Q_PROPERTY(QString device READ device WRITE setDevice NOTIFY deviceChanged)
    Q_PROPERTY(QStringList deviceOptions READ deviceOptions CONSTANT)
    Q_PROPERTY(QString layoutOverridePath READ layoutOverridePath CONSTANT)

public:
    MaliitKcm(QObject *parent, const KPluginMetaData &metaData);

    QVariantList availableLanguages() const;
    QStringList enabledLanguages() const;
    QString activeLanguage() const;
    void setActiveLanguage(const QString &languageId);

    bool autoCapitalizationEnabled() const;
    void setAutoCapitalizationEnabled(bool enabled);

    bool autoCompletionEnabled() const;
    void setAutoCompletionEnabled(bool enabled);

    bool predictiveTextEnabled() const;
    void setPredictiveTextEnabled(bool enabled);

    bool spellCheckingEnabled() const;
    void setSpellCheckingEnabled(bool enabled);

    bool soundEnabled() const;
    void setSoundEnabled(bool enabled);

    bool hapticFeedbackEnabled() const;
    void setHapticFeedbackEnabled(bool enabled);

    bool magnifierEnabled() const;
    void setMagnifierEnabled(bool enabled);

    bool doubleSpaceFullStopEnabled() const;
    void setDoubleSpaceFullStopEnabled(bool enabled);

    bool stayHidden() const;
    void setStayHidden(bool enabled);

    bool disableHeightReporting() const;
    void setDisableHeightReporting(bool enabled);

    int opacityPercent() const;
    void setOpacityPercent(int percent);

    QString device() const;
    void setDevice(const QString &deviceId);

    QStringList deviceOptions() const;
    QString layoutOverridePath() const;

    bool isSaveNeeded() const override;

    Q_INVOKABLE void setLanguageEnabled(const QString &languageId, bool enabled);
    Q_INVOKABLE QString languageDisplayName(const QString &languageId) const;
    Q_INVOKABLE QString deviceDisplayName(const QString &deviceId) const;

public Q_SLOTS:
    void load() override;
    void save() override;

Q_SIGNALS:
    void availableLanguagesChanged();
    void enabledLanguagesChanged();
    void activeLanguageChanged();
    void autoCapitalizationEnabledChanged();
    void autoCompletionEnabledChanged();
    void predictiveTextEnabledChanged();
    void spellCheckingEnabledChanged();
    void soundEnabledChanged();
    void hapticFeedbackEnabledChanged();
    void magnifierEnabledChanged();
    void doubleSpaceFullStopEnabledChanged();
    void stayHiddenChanged();
    void disableHeightReportingChanged();
    void opacityPercentChanged();
    void deviceChanged();

private:
    void markChanged();
    void setNeedsSaveFlag(bool needsSave);
    QStringList languageSearchPaths() const;
    QVariantList buildAvailableLanguages(const QStringList &extraLanguages = {}) const;
    QString defaultLayoutOverridePath() const;
    void reloadAvailableLanguages(const QStringList &extraLanguages = {});

    std::unique_ptr<MaliitKeyboard::KeyboardSettings> m_settings;

    QVariantList m_availableLanguages;
    QStringList m_enabledLanguages;
    QString m_activeLanguage;
    bool m_autoCapitalizationEnabled = true;
    bool m_autoCompletionEnabled = true;
    bool m_predictiveTextEnabled = true;
    bool m_spellCheckingEnabled = true;
    bool m_soundEnabled = false;
    bool m_hapticFeedbackEnabled = true;
    bool m_magnifierEnabled = true;
    bool m_doubleSpaceFullStopEnabled = true;
    bool m_stayHidden = false;
    bool m_disableHeightReporting = false;
    int m_opacityPercent = 100;
    QString m_device = QStringLiteral("default");
    bool m_needsSave = false;
};
