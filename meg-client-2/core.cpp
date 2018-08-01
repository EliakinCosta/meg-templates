#include "core.h"
#include "pluginloader.h"

#include <QDir>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QGuiApplication>

Core::Core(QObject *parent):QObject(parent)
{        
    loadCoreConfig();
    m_pluginLoader = new PluginLoader(this);    
}

Core::~Core()
{
    delete m_pluginLoader;
}

QJsonObject Core::auth() const
{
    foreach(QJsonValue jsonValue, m_pluginLoader->pluginsConfig())
    {
        QJsonObject jsonObject = jsonValue.toObject();
        if (jsonObject["type"].toString() == "auth")
        {
            return jsonObject;
        }
    }
    return QJsonObject();
}

QJsonArray Core::contents() const
{
    return m_pluginLoader->pluginsConfig();
}

QJsonObject Core::coreConfig() const
{
    return m_coreConfig;
}


QJsonArray Core::drawerPlugins() const
{
    QJsonArray jsonArray;
    foreach(QJsonValue jsonValue, m_pluginLoader->pluginsConfig())
    {
        QJsonObject jsonObject = jsonValue.toObject();
        if (jsonObject["showInDrawer"].toBool())
        {
            jsonArray.append(jsonObject);
        }
    }
    return jsonArray;
}

QString Core::pluginsDir() const
{
    return m_pluginLoader->pluginsDir();
}

QJsonArray Core::swipeViewPlugins() const
{
    QJsonArray jsonArray;
    foreach(QJsonValue jsonValue, m_pluginLoader->pluginsConfig())
    {
        QJsonObject jsonObject = jsonValue.toObject();
        if (jsonObject["showInSwipeView"].toBool())
        {
            jsonArray.append(jsonObject);
        }
    }
    return jsonArray;
}

void Core::loadCoreConfig()
{
    QDir dir(qApp->applicationDirPath());
    QFile jsonFile(dir.absoluteFilePath("core.json"));
    jsonFile.open(QIODevice::ReadOnly);
    m_coreConfig = QJsonDocument::fromJson(jsonFile.readAll()).object();
}
