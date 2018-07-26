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


std::map<AlertTypes::EnAlert, RootedTreeNode*> * EntityType::getMap()
{
   return &(EntityType::_typesMap);
}


void EntityType::generateTypes()
{

    AlertTypes::EnAlert type;

    for(int type_itr = AlertTypes::ALERT_NONE; type_itr < AlertTypes::ALERT_END_OF_TYPE; type_itr++)
    {
        type =  (AlertTypes::EnAlert)type_itr;

        RootedTreeNode * nodeToInsert = nullptr;  //new RootedTreeNode();

        EntityType::_typesMap.insert(std::pair<AlertTypes::EnAlert, RootedTreeNode*>(type,nodeToInsert));
    }
}


#if 0
DISPLAY_ERRORS_t linkByEntityType(AlertTypes::EnAlert type, RootedTreeNode* node)
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


RootedTreeNode* EntityType::findEntityType(AlertTypes::EnAlert type)
{
    return EntityType::_typesMap.find(type)->second;
}


#endif
