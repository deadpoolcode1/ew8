#include "amjsonargumentaction.h"
#include "graphicitemsenummap.h"

AMJsonArgumentAction::AMJsonArgumentAction(AMJsonProtocol * aJsonProtocol, action_type_e type, const String& action): AMJsonAction(aJsonProtocol, type, action)
{
    itsGraphicItemID = GraphicItemsEnumMap::getId(action);
    itsIndex = 0;
}
