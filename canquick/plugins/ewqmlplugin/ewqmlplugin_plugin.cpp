#include "ewqmlplugin_plugin.h"
#include "qquickhalfcircletray.h"

#include <qqml.h>

void EwqmlpluginPlugin::registerTypes(const char *uri)
{
    // @uri com.mobileye
    qmlRegisterType<QQuickHalfCircleTray>(uri, 1, 0, "QQuickHalfCircleTray");
}

