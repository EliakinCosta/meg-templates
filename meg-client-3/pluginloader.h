#ifndef PLUGINLOADER_H
#define PLUGINLOADER_H

#include <QJsonArray>
#include <QJsonObject>

class QString;
class Core;

class PluginLoader
{
public:    
    PluginLoader(Core *core);
    QJsonArray pluginsConfig() const;
    QString pluginsDir() const;
private:
    QString findPluginsDirectory();
    void loadPlugins();
    QJsonObject m_authConfig;
    Core *m_core;
    QString m_pluginsAbsolutePath;
    QJsonArray m_pluginsConfig;
    QString m_pluginsDir;
};

#endif // PLUGINLOADER_H
