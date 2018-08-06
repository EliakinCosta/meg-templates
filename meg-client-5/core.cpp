#include "core.h"
#include "pluginloader.h"
#include "authpluginmanager.h"
#include "drawerpluginmanager.h"
#include "swipeviewpluginmanager.h"
#include "filterproxymodel.h"
#include "meglistmodel.h"

#include <QDir>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QGuiApplication>
#include <QQmlEngine>

Core::Core(QObject *parent):QObject(parent)
{        
    loadCoreConfig();
    m_pluginLoader = new PluginLoader(this);
    m_authPluginManager = new AuthPluginManager(this);
    m_drawerPluginManager = new DrawerPluginManager(this);
    m_swipeViewPluginManager = new SwipeViewPluginManager(this);
}

Core::~Core()
{
    delete m_pluginLoader;
    delete m_authPluginManager;
    delete m_drawerPluginManager;
    delete m_swipeViewPluginManager;
}

void Core::initialize()
{
    m_authPluginManager->loadConfig();
    m_drawerPluginManager->loadConfig();
    m_swipeViewPluginManager->loadConfig();

    qmlRegisterType<FilterProxyModel>("com.meg.filterproxymodel", 1, 0, "FilterProxyModel");
    qmlRegisterType<MegListModel>("com.meg.meglistmodel", 1, 0, "MegListModel");
}

QJsonArray Core::pluginsConfig() const
{
    return m_pluginLoader->pluginsConfig();
}

QJsonObject Core::authPlugin() const
{    
    for(QJsonValue jsonValue : m_authPluginManager->config())
    {
        QJsonObject jsonObject = jsonValue.toObject();
        if (jsonObject["name"].toString() == m_coreConfig.value("activeAuthPlugin").toString())
        {
            return jsonObject;
        }
    }
    return QJsonObject();
}

QJsonObject Core::coreConfig() const
{
    return m_coreConfig;
}

QJsonObject Core::homePlugin() const
{
    for(QJsonValue jsonValue : pluginsConfig())
    {
        QJsonObject jsonObject = jsonValue.toObject();
        if (jsonObject.contains("homePlugin") && jsonObject["homePlugin"].toBool() == true)
        {
            return jsonObject;
        }
    }
    return QJsonObject();
}


QJsonArray Core::drawerPlugins() const
{
    return m_drawerPluginManager->config();
}

QString Core::pluginsDir() const
{
    return m_pluginLoader->pluginsDir();
}

QJsonArray Core::swipeViewPlugins() const
{
    return m_swipeViewPluginManager->config();
}

void Core::loadCoreConfig()
{    
    QFile jsonFile(":/core.json");
    jsonFile.open(QIODevice::ReadOnly);
    m_coreConfig = QJsonDocument::fromJson(jsonFile.readAll()).object();
}
