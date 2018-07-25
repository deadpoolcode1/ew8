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

EntityType::EntityType(AlertTypes::EnAlert type)
{
    _type = type;
    _node = nullptr;
}

std::map<AlertTypes::EnAlert, RootedTreeNode*>* EntityType::getMap()
{
   return &(EntityType::_typesMap);
}


void EntityType::generateTypes()
{

    AlertTypes::EnAlert type;

    for(int type_itr = AlertTypes::ALERT_NONE; type_itr < AlertTypes::ALERT_END_OF_TYPE; type_itr++)
    {
        type =  (AlertTypes::EnAlert)type_itr;

        //EntityType* typeObj = new EntityType(type);

        RootedTreeNode * nodeToInsert = new RootedTreeNode();

        EntityType::_typesMap.insert(std::pair<AlertTypes::EnAlert, RootedTreeNode*>(type,nodeToInsert));
    }
}

#if 0
RootedTreeNode* EntityType::findEntityType(AlertTypes::EnAlert type)
{
    return EntityType::_typesMap.find(type)->second;
}
#endif
