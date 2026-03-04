#ifndef ALERTCONTROLLER_H
#define ALERTCONTROLLER_H

#include "ialertdisplay.h"
#include "alerttypes_core.h"
#include "core/types.h"

#include <functional>
#include <string>
#include <cstdint>

class AlertController : public IAlertDisplay
{
public:
    AlertController();

    // IAlertDisplay interface
    void activate(DISPLAY_ITEM_ID at, uint8_t valueInt = 0, uint8_t valueFrac = 0, uint8_t unit = 0) override;
    void activate(DISPLAY_ITEM_ID at, const std::string& stringArg) override;
    void deactivate(DISPLAY_ITEM_ID at) override;
    void forceUpdate(void) override;
    void message(const std::string& stringMessage) override;

    // Called when tree changes externally (e.g. QML self-deactivation)
    void setTreeChanged();

    // State for frontend polling
    bool needsDisplayUpdate() const;
    void markUpdateComplete();

    // Frontend sets callbacks
    using MessageCallback = std::function<void(const std::string&)>;
    using ProcessCallback = std::function<void()>;
    void setMessageCallback(MessageCallback cb);
    void setProcessCallback(ProcessCallback cb);

private:
    void activateInternal(DISPLAY_ITEM_ID at, bool isStrArg, const String& strArg, uint8_t valueInt, uint8_t valueFrac, uint8_t unit);

    bool isDataComplete;
    bool flag_tree_changed;
    MessageCallback messageCallback;
    ProcessCallback processCallback;
};

#endif // ALERTCONTROLLER_H
