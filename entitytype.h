#ifndef ENTITYTYPE_H
#define ENTITYTYPE_H

#include <map>
#include "defs.h"
#include "rootedtreenode.h"
#include "alerttypes.h"



class EntityType
{


public:

    typedef std::multimap<AlertTypes::EnAlert, RootedTreeNode*> t_TreeNodesTypeMap;

    typedef std::pair<t_TreeNodesTypeMap::iterator,t_TreeNodesTypeMap::iterator> t_TreeNodesInterval;

    EntityType();

    static t_TreeNodesTypeMap * getMap();
    static void generateTypes();

    static bool keyExist(AlertTypes::EnAlert type)
    {
       if (EntityType::_typesMap.find(type) != _typesMap.end())
       {
        return  true;
       }
       else
       {
        return false;
       }
    }

    static EntityType::t_TreeNodesInterval findByEntityType(AlertTypes::EnAlert type)
    {
       EntityType::t_TreeNodesInterval  ret;

       if (EntityType::_typesMap.find(type) != _typesMap.end())
       {
          ret =  EntityType::_typesMap.equal_range(type);
       }
       else
       {
           throw std::exception(/*"Alert type does not have implementation"*/);
       }

       return ret;
    }


//    static DISPLAY_ERRORS_t linkByEntityType(AlertTypes::EnAlert type, RootedTreeNode* node);
    static DISPLAY_ERRORS_t linkByEntityType(AlertTypes::EnAlert type, RootedTreeNode* node)
    {
#ifdef VERIFY_ALL_ALERTS_IMPLEMENTED
        if (_typesMap.find(type) == _typesMap.end())
        {
            return GENERAL_ERROR;
        }

        EntityType::t_TreeNodesTypeMap::iterator it = _typesMap.find(type);

        RootedTreeNode * nodeInMap = it->second;

        if (nodeInMap == nullptr)
        {
            //remove nullptr pair:
            _typesMap.erase(it);
        }
#endif

        _typesMap.insert(std::make_pair(type, node));

        return OK;
    }

    //    RootedTreeNode* getNode();

private:

    static t_TreeNodesTypeMap _typesMap;


//    RootedTreeNode* _node;
//    AlertTypes::EnAlert _type;
};



#endif // ENTITYTYPE_H
