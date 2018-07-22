#include "qmltreeparser.h"

#if 0
QmlTreeParser::QmlTreeParser(QObject *aComponentObject)// : QObject()
{

    componentObject = aComponentObject;

}

DISPLAY_ERRORS_t QmlTreeParser::constructTree(QObject * componentObject, RootedTree* tree)
{ 
 //       QObject * current = componentObject->findChild<QObject*>("main_panel_root");
    //componentObject->children();
    if (componentObject->children() == null)
    {
        return EMPTY_TREE_QML;
    }

    const QObjectList& children = componentObject->children();
// root of mirror tree
    RootedTreeNode* rootNode = tree->current;
    if (!rootNode)
    {
        return GENERAL_ERROR;
    }
// recursive function
    expandChildren(rootNode, children);

//            current->dumpObjectTree();
}



void QmlTreeParser::expandChildren(QObjectList*& currentChildrenLevel)
{
    if (!currentChildrenLevel)
    {
        return;
    }
    QObjectList*& nextChildrenLevel = new QObjectList();

    if (!currentChildrenLevel->isEmpty())
    {
        for (int i = 0; i < currentChildrenLevel->size(); i++) {
// collect childran onthe current entity to the children list of level
            const QObjectList& children = currentChildrenLevel->at(i)->children();
            nextChildrenLevel->append(children);

// build "mirrow" object in C++
            QVariant vlayer = currentChildrenLevel->at(i)->property("layer");
            int layer = int(vlayer);

        }
    }

    if (currentChildrenLevel)
    {
        delete(currentChildrenLevel);
    }
    currentChildrenLevel = nextChildrenLevel;
    return;
}
#endif
