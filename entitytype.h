#ifndef ENTITYTYPE_H
#define ENTITYTYPE_H

#include <map>
#include "rootedtreenode.h"
#include "alerttypes.h"



class EntityType
{
typedef std::map<AlertTypes::EnAlert, RootedTreeNode*> t_TreeNodesTypeMap;

public:
    EntityType();
    EntityType(AlertTypes::EnAlert type);

    static std::map<AlertTypes::EnAlert, RootedTreeNode*>* getMap();
    static void generateTypes();

    static RootedTreeNode* findEntityType(AlertTypes::EnAlert type)
    {
       return EntityType::_typesMap.find(type)->second;
    }


    RootedTreeNode* getNode();

private:

    static t_TreeNodesTypeMap _typesMap;


    RootedTreeNode* _node;
    AlertTypes::EnAlert _type;
};



#endif // ENTITYTYPE_H
