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
    _node = null;
}

std::map<AlertTypes::EnAlert, RootedTreeNode*>* EntityType::getMap()
{
   return &(EntityType::_typesMap);
}


void EntityType::generateTypes()
{
    for(AlertTypes::EnAlert type = 0; type < enumTypeEnd; type++)
    {
        EntityType* typeObj = new EntityType(type);
        EntityType::_typesMap.insert(typeObj);
    }
}

#if 0
RootedTreeNode* EntityType::findEntityType(AlertTypes::EnAlert type)
{
    return EntityType::_typesMap.find(type)->second;
}
#endif
