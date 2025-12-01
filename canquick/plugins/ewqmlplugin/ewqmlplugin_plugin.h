#ifndef EWQMLPLUGIN_PLUGIN_H
#define EWQMLPLUGIN_PLUGIN_H

#include <QQmlExtensionPlugin>

class EwqmlpluginPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri) override;
};

#endif // EWQMLPLUGIN_PLUGIN_H
