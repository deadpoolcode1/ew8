#include "alertcontroller.h"
#include "entitytype.h"
#include "idisplaynode.h"
#include "alerttypes_core.h"
#include "core/core.h"
#include "core/elapsed_timer.h"

AlertController::AlertController()
    : isDataComplete(false)
    , flag_tree_changed(false)
{
}

void AlertController::activate(DISPLAY_ITEM_ID alert, uint8_t valueInt, uint8_t valueFrac, uint8_t unit)
{
    activateInternal(alert, false, "", valueInt, valueFrac, unit);
}

void AlertController::activate(DISPLAY_ITEM_ID alert, const std::string& stringArg)
{
    activateInternal(alert, true, stringArg, 0, 0, 0);
}

void AlertController::activateInternal(DISPLAY_ITEM_ID alert, bool isStrArg, const String& strArg, uint8_t valueInt, uint8_t valueFrac, uint8_t unit)
{
    if (AlertTypes::ALERT_NONE == alert)
    {
        return;
    }

    coreDebug() << "function:" << __func__ << "alert:" << alert;
    coreDebug() << " activated at:" << core::ElapsedTimer::currentMSecsSinceEpoch();

    IDisplayNode* nodeCGRT = nullptr;

    EntityType::t_TreeNodesInterval itRange = EntityType::findByEntityType(alert);

    for (EntityType::t_TreeNodesTypeMap::iterator it = itRange.first; it != itRange.second; it++)
    {
        nodeCGRT = it->second;

        if (nodeCGRT == nullptr)
        {
            //TODO add exception
        }
        else if (nodeCGRT->getActivSem() > 0)
        {
            //skip: activated - no need for re-activation
        }
        else
        {
            if (isStrArg)
            {
                nodeCGRT->setCanEntityArg(strArg);
            }
            else
            {
                nodeCGRT->setCanEntityArgs(valueInt, valueFrac, unit);
            }
            nodeCGRT->activate();
            flag_tree_changed = true;
        }
    }
}

void AlertController::deactivate(DISPLAY_ITEM_ID alert)
{
    if (AlertTypes::ALERT_NONE == alert)
    {
        return;
    }

    coreDebug() << "function:" << __func__ << "alert:" << alert;
    coreDebug() << "deactivated at:" << core::ElapsedTimer::currentMSecsSinceEpoch();

    IDisplayNode* nodeCGRT = nullptr;

    EntityType::t_TreeNodesInterval itRange = EntityType::findByEntityType(alert);

    for (EntityType::t_TreeNodesTypeMap::iterator it = itRange.first; it != itRange.second; it++)
    {
        nodeCGRT = it->second;

        if (nodeCGRT == nullptr)
        {
            //TODO add exception
        }

        if (!(nodeCGRT->getActivSem()))
        {
            //skip: deactivated - no need for deactivation
        }
        else
        {
            nodeCGRT->deactivate();
            flag_tree_changed = true;
        }
    }
}

void AlertController::forceUpdate(void)
{
    isDataComplete = true;
    if (flag_tree_changed && processCallback)
    {
        processCallback();
    }
}

void AlertController::setTreeChanged()
{
    flag_tree_changed = true;
}

void AlertController::message(const std::string& stringMessage)
{
    if (messageCallback)
    {
        messageCallback(stringMessage);
    }
}

bool AlertController::needsDisplayUpdate() const
{
    return isDataComplete && flag_tree_changed;
}

void AlertController::markUpdateComplete()
{
    flag_tree_changed = false;
    isDataComplete = false;
}

void AlertController::setMessageCallback(MessageCallback cb)
{
    messageCallback = std::move(cb);
}

void AlertController::setProcessCallback(ProcessCallback cb)
{
    processCallback = std::move(cb);
}
