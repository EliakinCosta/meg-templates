#ifndef CORE_H
#define CORE_H

#include <QJsonObject>
#include <QJsonArray>
#include <QObject>

class PluginLoader;
class AuthPluginManager;
class DrawerPluginManager;
class SwipeViewPluginManager;

class Core: public QObject
{
    Q_OBJECT
public:
    Core(QObject *parent = nullptr);
    virtual ~Core();
    void initialize();
    QJsonArray pluginsConfig() const;
    Q_INVOKABLE QJsonObject authPlugin() const;
    Q_INVOKABLE QJsonObject coreConfig() const;
    Q_INVOKABLE QJsonObject homePlugin() const;
    Q_INVOKABLE QJsonArray drawerPlugins() const;
    Q_INVOKABLE QString pluginsDir() const;
    Q_INVOKABLE QJsonArray swipeViewPlugins() const;
private:
    void loadCoreConfig();
    QJsonObject m_coreConfig;
    PluginLoader *m_pluginLoader;
    AuthPluginManager *m_authPluginManager;
    DrawerPluginManager *m_drawerPluginManager;
    SwipeViewPluginManager *m_swipeViewPluginManager;

};

#endif // CORE_H

