#ifndef CORE_H
#define CORE_H

#include <QJsonObject>
#include <QJsonArray>
#include <QObject>

class PluginLoader;

class Core: public QObject
{
    Q_OBJECT
public:
    Core(QObject *parent = nullptr);
    virtual ~Core();
    Q_INVOKABLE QJsonObject auth() const;
    Q_INVOKABLE QJsonArray contents() const;
    Q_INVOKABLE QJsonObject coreConfig() const;
    Q_INVOKABLE QJsonArray drawerPlugins() const;
    Q_INVOKABLE QString pluginsDir() const;
    Q_INVOKABLE QJsonArray swipeViewPlugins() const;
private:
    void loadCoreConfig();
    QJsonObject m_coreConfig;
    PluginLoader *m_pluginLoader;
};

#endif // CORE_H

