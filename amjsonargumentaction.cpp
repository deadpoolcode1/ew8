#include "amjsonargumentaction.h"
#include "graphicitemsenummap.h"

AMJsonArgumentAction::AMJsonArgumentAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent): AMJsonAction(aJsonSignal, action, parent)
{
    itsGraphicItemID = GraphicItemsEnumMap::getId(action);
    itsIndex = 0;
}
