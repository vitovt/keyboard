// SPDX-License-Identifier: BSD-3-Clause

#include "maliitkcm.h"

#include "keyboardsettings.h"

#include <KLocalizedString>
#include <KPluginFactory>

#include <QCollator>
#include <QDir>
#include <QFileInfo>
#include <QLocale>
#include <QSet>
#include <QStandardPaths>

#include <algorithm>

using MaliitKeyboard::KeyboardSettings;

K_PLUGIN_CLASS_WITH_JSON(MaliitKcm, "kcm_maliit.json")

namespace {

QString translatedVariantName(const QString &variant)
{
    if (variant.compare(QStringLiteral("dv"), Qt::CaseInsensitive) == 0) {
        return i18n("Dvorak");
    }

    return variant.toUpper();
}

QString displayNameForLanguageId(const QString &languageId)
{
    if (languageId == QStringLiteral("zh-hans")) {
        return i18n("Chinese (Pinyin)");
    }
    if (languageId == QStringLiteral("zh-hant")) {
        return i18n("Chinese (Chewing)");
    }

    QString normalized = languageId;
    QString variant;
    const int atIndex = normalized.indexOf(QLatin1Char('@'));
    if (atIndex >= 0) {
        variant = normalized.mid(atIndex + 1);
        normalized = normalized.left(atIndex);
    }

    QLocale locale(normalized.replace(QLatin1Char('-'), QLatin1Char('_')));
    QString name;

    if (locale.language() != QLocale::C) {
        name = QLocale::languageToString(locale.language());
        if (locale.territory() != QLocale::AnyTerritory) {
            name += i18nc("Language with region", " (%1)", QLocale::territoryToString(locale.territory()));
        }
    }

    if (name.isEmpty()) {
        name = languageId;
    }

    if (!variant.isEmpty()) {
        name += i18nc("Language with keyboard variant", " (%1)", translatedVariantName(variant));
    }

    return name;
}

QString displayNameForDeviceId(const QString &deviceId)
{
    if (deviceId == QStringLiteral("tablet")) {
        return i18n("Tablet");
    }

    return i18n("Default");
}

QStringList uniqueNonEmpty(const QStringList &values)
{
    QStringList result;
    QSet<QString> seen;

    for (const QString &value : values) {
        if (value.isEmpty() || seen.contains(value)) {
            continue;
        }
        seen.insert(value);
        result.append(value);
    }

    return result;
}

} // namespace

MaliitKcm::MaliitKcm(QObject *parent, const KPluginMetaData &metaData)
    : KQuickManagedConfigModule(parent, metaData)
    , m_settings(std::make_unique<KeyboardSettings>())
{
    load();
}

QVariantList MaliitKcm::availableLanguages() const
{
    return m_availableLanguages;
}

QStringList MaliitKcm::enabledLanguages() const
{
    return m_enabledLanguages;
}

QString MaliitKcm::activeLanguage() const
{
    return m_activeLanguage;
}

void MaliitKcm::setActiveLanguage(const QString &languageId)
{
    if (languageId == m_activeLanguage || !m_enabledLanguages.contains(languageId)) {
        return;
    }

    m_activeLanguage = languageId;
    Q_EMIT activeLanguageChanged();
    markChanged();
}

bool MaliitKcm::autoCapitalizationEnabled() const
{
    return m_autoCapitalizationEnabled;
}

void MaliitKcm::setAutoCapitalizationEnabled(bool enabled)
{
    if (enabled == m_autoCapitalizationEnabled) {
        return;
    }

    m_autoCapitalizationEnabled = enabled;
    Q_EMIT autoCapitalizationEnabledChanged();
    markChanged();
}

bool MaliitKcm::autoCompletionEnabled() const
{
    return m_autoCompletionEnabled;
}

void MaliitKcm::setAutoCompletionEnabled(bool enabled)
{
    if (enabled == m_autoCompletionEnabled) {
        return;
    }

    m_autoCompletionEnabled = enabled;
    Q_EMIT autoCompletionEnabledChanged();
    markChanged();
}

bool MaliitKcm::predictiveTextEnabled() const
{
    return m_predictiveTextEnabled;
}

void MaliitKcm::setPredictiveTextEnabled(bool enabled)
{
    if (enabled == m_predictiveTextEnabled) {
        return;
    }

    m_predictiveTextEnabled = enabled;
    Q_EMIT predictiveTextEnabledChanged();
    markChanged();
}

bool MaliitKcm::spellCheckingEnabled() const
{
    return m_spellCheckingEnabled;
}

void MaliitKcm::setSpellCheckingEnabled(bool enabled)
{
    if (enabled == m_spellCheckingEnabled) {
        return;
    }

    m_spellCheckingEnabled = enabled;
    Q_EMIT spellCheckingEnabledChanged();
    markChanged();
}

bool MaliitKcm::soundEnabled() const
{
    return m_soundEnabled;
}

void MaliitKcm::setSoundEnabled(bool enabled)
{
    if (enabled == m_soundEnabled) {
        return;
    }

    m_soundEnabled = enabled;
    Q_EMIT soundEnabledChanged();
    markChanged();
}

bool MaliitKcm::hapticFeedbackEnabled() const
{
    return m_hapticFeedbackEnabled;
}

void MaliitKcm::setHapticFeedbackEnabled(bool enabled)
{
    if (enabled == m_hapticFeedbackEnabled) {
        return;
    }

    m_hapticFeedbackEnabled = enabled;
    Q_EMIT hapticFeedbackEnabledChanged();
    markChanged();
}

bool MaliitKcm::magnifierEnabled() const
{
    return m_magnifierEnabled;
}

void MaliitKcm::setMagnifierEnabled(bool enabled)
{
    if (enabled == m_magnifierEnabled) {
        return;
    }

    m_magnifierEnabled = enabled;
    Q_EMIT magnifierEnabledChanged();
    markChanged();
}

bool MaliitKcm::doubleSpaceFullStopEnabled() const
{
    return m_doubleSpaceFullStopEnabled;
}

void MaliitKcm::setDoubleSpaceFullStopEnabled(bool enabled)
{
    if (enabled == m_doubleSpaceFullStopEnabled) {
        return;
    }

    m_doubleSpaceFullStopEnabled = enabled;
    Q_EMIT doubleSpaceFullStopEnabledChanged();
    markChanged();
}

bool MaliitKcm::stayHidden() const
{
    return m_stayHidden;
}

void MaliitKcm::setStayHidden(bool enabled)
{
    if (enabled == m_stayHidden) {
        return;
    }

    m_stayHidden = enabled;
    Q_EMIT stayHiddenChanged();
    markChanged();
}

bool MaliitKcm::disableHeightReporting() const
{
    return m_disableHeightReporting;
}

void MaliitKcm::setDisableHeightReporting(bool enabled)
{
    if (enabled == m_disableHeightReporting) {
        return;
    }

    m_disableHeightReporting = enabled;
    Q_EMIT disableHeightReportingChanged();
    markChanged();
}

int MaliitKcm::opacityPercent() const
{
    return m_opacityPercent;
}

void MaliitKcm::setOpacityPercent(int percent)
{
    percent = std::clamp(percent, 50, 100);
    if (percent == m_opacityPercent) {
        return;
    }

    m_opacityPercent = percent;
    Q_EMIT opacityPercentChanged();
    markChanged();
}

QString MaliitKcm::device() const
{
    return m_device;
}

void MaliitKcm::setDevice(const QString &deviceId)
{
    if (deviceId == m_device || !deviceOptions().contains(deviceId)) {
        return;
    }

    m_device = deviceId;
    Q_EMIT deviceChanged();
    markChanged();
}

QStringList MaliitKcm::deviceOptions() const
{
    return {QStringLiteral("default"), QStringLiteral("tablet")};
}

QString MaliitKcm::layoutOverridePath() const
{
    return defaultLayoutOverridePath();
}

bool MaliitKcm::isSaveNeeded() const
{
    return m_needsSave;
}

void MaliitKcm::setLanguageEnabled(const QString &languageId, bool enabled)
{
    const bool currentlyEnabled = m_enabledLanguages.contains(languageId);
    if (enabled == currentlyEnabled) {
        return;
    }

    if (enabled) {
        m_enabledLanguages.append(languageId);
    } else {
        if (m_enabledLanguages.size() == 1) {
            return;
        }
        m_enabledLanguages.removeAll(languageId);
        if (m_activeLanguage == languageId && !m_enabledLanguages.isEmpty()) {
            m_activeLanguage = m_enabledLanguages.front();
            Q_EMIT activeLanguageChanged();
        }
    }

    Q_EMIT enabledLanguagesChanged();
    markChanged();
}

QString MaliitKcm::languageDisplayName(const QString &languageId) const
{
    return displayNameForLanguageId(languageId);
}

QString MaliitKcm::deviceDisplayName(const QString &deviceId) const
{
    return displayNameForDeviceId(deviceId);
}

void MaliitKcm::load()
{
    const QStringList configuredLanguages = m_settings->enabledLanguages();
    const QString configuredActiveLanguage = m_settings->activeLanguage();

    reloadAvailableLanguages(uniqueNonEmpty(configuredLanguages + QStringList{configuredActiveLanguage}));

    const QSet<QString> availableIds = [this]() {
        QSet<QString> ids;
        for (const QVariant &entry : m_availableLanguages) {
            ids.insert(entry.toMap().value(QStringLiteral("id")).toString());
        }
        return ids;
    }();

    m_enabledLanguages.clear();
    for (const QString &languageId : configuredLanguages) {
        if (availableIds.contains(languageId) && !m_enabledLanguages.contains(languageId)) {
            m_enabledLanguages.append(languageId);
        }
    }
    if (m_enabledLanguages.isEmpty() && !m_availableLanguages.isEmpty()) {
        m_enabledLanguages.append(m_availableLanguages.constFirst().toMap().value(QStringLiteral("id")).toString());
    }

    if (m_enabledLanguages.contains(configuredActiveLanguage)) {
        m_activeLanguage = configuredActiveLanguage;
    } else if (!m_enabledLanguages.isEmpty()) {
        m_activeLanguage = m_enabledLanguages.constFirst();
    } else {
        m_activeLanguage.clear();
    }

    m_autoCapitalizationEnabled = m_settings->autoCapitalization();
    m_autoCompletionEnabled = m_settings->autoCompletion();
    m_predictiveTextEnabled = m_settings->predictiveText();
    m_spellCheckingEnabled = m_settings->spellchecking();
    m_soundEnabled = m_settings->keyPressAudioFeedback();
    m_hapticFeedbackEnabled = m_settings->keyPressHapticFeedback();
    m_magnifierEnabled = m_settings->enableMagnifier();
    m_doubleSpaceFullStopEnabled = m_settings->doubleSpaceFullStop();
    m_stayHidden = m_settings->stayHidden();
    m_disableHeightReporting = m_settings->disableHeight();
    m_opacityPercent = std::clamp(qRound(m_settings->opacity() * 100.0), 50, 100);
    m_device = m_settings->device();
    if (!deviceOptions().contains(m_device)) {
        m_device = QStringLiteral("default");
    }

    setNeedsSaveFlag(false);

    Q_EMIT availableLanguagesChanged();
    Q_EMIT enabledLanguagesChanged();
    Q_EMIT activeLanguageChanged();
    Q_EMIT autoCapitalizationEnabledChanged();
    Q_EMIT autoCompletionEnabledChanged();
    Q_EMIT predictiveTextEnabledChanged();
    Q_EMIT spellCheckingEnabledChanged();
    Q_EMIT soundEnabledChanged();
    Q_EMIT hapticFeedbackEnabledChanged();
    Q_EMIT magnifierEnabledChanged();
    Q_EMIT doubleSpaceFullStopEnabledChanged();
    Q_EMIT stayHiddenChanged();
    Q_EMIT disableHeightReportingChanged();
    Q_EMIT opacityPercentChanged();
    Q_EMIT deviceChanged();
}

void MaliitKcm::save()
{
    m_settings->setEnabledLanguages(m_enabledLanguages);
    if (!m_activeLanguage.isEmpty()) {
        m_settings->setActiveLanguage(m_activeLanguage);
    }
    m_settings->setAutoCapitalization(m_autoCapitalizationEnabled);
    m_settings->setAutoCompletion(m_autoCompletionEnabled);
    m_settings->setPredictiveText(m_predictiveTextEnabled);
    m_settings->setSpellchecking(m_spellCheckingEnabled);
    m_settings->setKeyPressAudioFeedback(m_soundEnabled);
    m_settings->setKeyPressHapticFeedback(m_hapticFeedbackEnabled);
    m_settings->setEnableMagnifier(m_magnifierEnabled);
    m_settings->setDoubleSpaceFullStop(m_doubleSpaceFullStopEnabled);
    m_settings->setStayHidden(m_stayHidden);
    m_settings->setDisableHeight(m_disableHeightReporting);
    m_settings->setOpacity(m_opacityPercent / 100.0);
    m_settings->setDevice(m_device);

    setNeedsSaveFlag(false);
}

void MaliitKcm::markChanged()
{
    setNeedsSaveFlag(true);
}

void MaliitKcm::setNeedsSaveFlag(bool needsSave)
{
    m_needsSave = needsSave;
    setNeedsSave(needsSave);
}

QStringList MaliitKcm::languageSearchPaths() const
{
    QStringList paths;
    const QByteArray envOverride = qgetenv("MALIIT_KEYBOARD_LANGUAGES_PATH");
    if (!envOverride.isEmpty()) {
        paths.append(QString::fromLocal8Bit(envOverride));
    }

    paths.append(defaultLayoutOverridePath());
    paths.append(QStringLiteral(MALIIT_KEYBOARD_LANGUAGES_DIR));
    paths.append(m_settings->pluginPaths());

    return uniqueNonEmpty(paths);
}

QVariantList MaliitKcm::buildAvailableLanguages(const QStringList &extraLanguages) const
{
    QSet<QString> ids;

    for (const QString &path : languageSearchPaths()) {
        const QDir dir(path);
        if (!dir.exists()) {
            continue;
        }

        const QFileInfoList languageDirs = dir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
        for (const QFileInfo &languageDir : languageDirs) {
            const QString languageId = languageDir.fileName();
            const QString qmlFile = QDir(languageDir.absoluteFilePath()).filePath(QStringLiteral("Keyboard_%1.qml").arg(languageId));
            const QString pluginFile = QDir(languageDir.absoluteFilePath()).filePath(QStringLiteral("lib%1plugin.so").arg(languageId));
            if (QFileInfo::exists(qmlFile) || QFileInfo::exists(pluginFile)) {
                ids.insert(languageId);
            }
        }
    }

    for (const QString &languageId : extraLanguages) {
        if (!languageId.isEmpty()) {
            ids.insert(languageId);
        }
    }

    QList<QVariantMap> entries;
    entries.reserve(ids.size());
    for (const QString &languageId : ids) {
        QVariantMap entry;
        entry.insert(QStringLiteral("id"), languageId);
        entry.insert(QStringLiteral("name"), displayNameForLanguageId(languageId));
        entries.append(entry);
    }

    QCollator collator;
    collator.setNumericMode(true);
    std::sort(entries.begin(), entries.end(), [&collator](const QVariantMap &left, const QVariantMap &right) {
        return collator.compare(left.value(QStringLiteral("name")).toString(),
                                right.value(QStringLiteral("name")).toString()) < 0;
    });

    QVariantList result;
    result.reserve(entries.size());
    for (const QVariantMap &entry : entries) {
        result.append(entry);
    }
    return result;
}

QString MaliitKcm::defaultLayoutOverridePath() const
{
    const QString configLocation = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
    if (configLocation.isEmpty()) {
        return QString();
    }

    return QDir(configLocation).filePath(QStringLiteral("maliit/layouts"));
}

void MaliitKcm::reloadAvailableLanguages(const QStringList &extraLanguages)
{
    m_availableLanguages = buildAvailableLanguages(extraLanguages);
}
