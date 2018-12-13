#include "entitytype.h"


#if 0
EntityType::t_TreeNodesTypeMap EntityType::createNodesTypesMap()
{
    t_TreeNodesTypeMap ret;
    return ret;
}
EntityType::_typesMap = EntityType::createNodesTypesMap();
#endif

EntityType::EntityType()
{

}


EntityType::t_TreeNodesTypeMap * EntityType::getMap()
{
   return &(EntityType::_typesMap);
}


void EntityType::generateTypes()
{
#ifdef VERIFY_ALL_ALERTS_IMPLEMENTED
    DISPLAY_ITEM_ID type;

    for(int type_itr = AlertTypes::ALERT_NONE; type_itr < AlertTypes::ALERT_END_OF_TYPE; type_itr++)
    {
        type =  (DISPLAY_ITEM_ID)type_itr;

        generateSingleType(type);
    }

    //TODO insert the JSON Enum Graphic Items:


#endif
}

void EntityType::generateSingleType(DISPLAY_ITEM_ID item_id)
{
#ifdef VERIFY_ALL_ALERTS_IMPLEMENTED
        RootedTreeNode * nodeToInsert = nullptr;  //new RootedTreeNode();

        if(0 == EntityType::_typesMap.count(item_id))
        {
            EntityType::_typesMap.insert(std::pair<DISPLAY_ITEM_ID, RootedTreeNode*>(item_id,nodeToInsert));
        }
#endif
}


#if 0
DISPLAY_ERRORS_t linkByEntityType(DISPLAY_ITEM_ID type, RootedTreeNode* node)
{
    if (_typesMap.find(type) != _typesMap.end())
    {
        return GENERAL_ERROR;
    }

    RootedTreeNode* nodeInMap = _typesMap.find(type)->second;
    if (nodeInMap != NULL)
    {
        return GENERAL_ERROR;  // RootedTreeNode is unique per type
    }
    else
    {
        _typesMap[type] = node;
    }
    return OK;
}


RootedTreeNode* EntityType::findEntityType(DISPLAY_ITEM_ID type)
{
    return EntityType::_typesMap.find(type)->second;
}


#endif
