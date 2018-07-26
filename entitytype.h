#ifndef ENTITYTYPE_H
#define ENTITYTYPE_H

#include <map>
#include "defs.h"
#include "rootedtreenode.h"
#include "alerttypes.h"



class EntityType
{
typedef std::map<AlertTypes::EnAlert, RootedTreeNode*> t_TreeNodesTypeMap;

public:
    EntityType();
//    EntityType(AlertTypes::EnAlert type);

    static std::map<AlertTypes::EnAlert, RootedTreeNode*>* getMap();
    static void generateTypes();

    static RootedTreeNode* findByEntityType(AlertTypes::EnAlert type)
    {
       if (EntityType::_typesMap.find(type) != _typesMap.end())
       {
        return   EntityType::_typesMap.find(type)->second;
       }
       else
       {
        return NULL;
       }
    }


//    static DISPLAY_ERRORS_t linkByEntityType(AlertTypes::EnAlert type, RootedTreeNode* node);
    static DISPLAY_ERRORS_t linkByEntityType(AlertTypes::EnAlert type, RootedTreeNode* node)
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

    //    RootedTreeNode* getNode();

private:

    static t_TreeNodesTypeMap _typesMap;


//    RootedTreeNode* _node;
//    AlertTypes::EnAlert _type;
};



#endif // ENTITYTYPE_H
