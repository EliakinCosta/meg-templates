#include "pluginloader.h"
#include "core.h"

#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QJsonObject>
#include <QJsonDocument>
#include <QGuiApplication>

PluginLoader::PluginLoader(Core *core):
    m_core(core),
    m_pluginsDir(findPluginsDirectory())
{    
    loadPlugins();
}

QJsonArray PluginLoader::pluginsConfig() const
{
    return m_pluginsConfig;
}

QString PluginLoader::pluginsDir() const
{
    return m_pluginsDir;
}

QString PluginLoader::findPluginsDirectory()
{
    QString pluginsAbsolutePath;
#ifdef Q_OS_ANDROID
    QDir dir("assets:/plugins");
#else
    QDir dir(qApp->applicationDirPath());
    if (!QDir(dir.absolutePath() + "/plugins").exists()){
        dir.cdUp();
        dir.cd("/fullApp");
    }
    dir.cd("plugins");
    pluginsAbsolutePath = "file://";
#endif
    pluginsAbsolutePath += dir.absolutePath();
    m_pluginsAbsolutePath = dir.absolutePath();
    return pluginsAbsolutePath;
}

void PluginLoader::loadPlugins()
{    
    QDir dir(m_pluginsAbsolutePath);
    foreach(const QString &fileName, dir.entryList(QStringList() << "*.json"))
    {
        QFile dfile(dir.absoluteFilePath(fileName));
        dfile.open(QIODevice::ReadOnly);
        QJsonObject jsonObject = QJsonDocument::fromJson(dfile.readAll()).object();
        QDir pluginDir(m_pluginsAbsolutePath);
        pluginDir.cd(fileName.split('.').first());
#ifdef Q_OS_ANDROID
        jsonObject["pluginName"] = fileName.split('.').first();
#else
        jsonObject["pluginName"] = pluginDir.absolutePath();
#endif
        if (jsonObject.contains("position"))
            m_pluginsConfig.insert(jsonObject["position"].toInt(), jsonObject);
        else
            m_pluginsConfig.append(jsonObject);
        dfile.close();
    }
}
