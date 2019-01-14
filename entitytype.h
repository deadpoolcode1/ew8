#ifndef ENTITYTYPE_H
#define ENTITYTYPE_H

#include "defs.h"
#include "rootedtreenode.h"
#include "alerttypes.h"



class EntityType
{


public:

    typedef std::multimap<DISPLAY_ITEM_ID, RootedTreeNode*> t_TreeNodesTypeMap;

    typedef std::pair<t_TreeNodesTypeMap::iterator,t_TreeNodesTypeMap::iterator> t_TreeNodesInterval;

    EntityType();

    static t_TreeNodesTypeMap * getMap();
    static void generateTypes();
    static void generateSingleType(DISPLAY_ITEM_ID item_id);

    static bool keyExist(DISPLAY_ITEM_ID type)
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

    static EntityType::t_TreeNodesInterval findByEntityType(DISPLAY_ITEM_ID type)
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


//    static DISPLAY_ERRORS_t linkByEntityType(DISPLAY_ITEM_ID type, RootedTreeNode* node);
    static DISPLAY_ERRORS_t linkByEntityType(DISPLAY_ITEM_ID type, RootedTreeNode* node)
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
//    DISPLAY_ITEM_ID _type;
};



#endif // ENTITYTYPE_H
