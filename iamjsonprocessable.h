#ifndef IAMJSONPROCESSABLE_H
#define IAMJSONPROCESSABLE_H

class IAMJsonProcessable
{
public:
    virtual void process(QObject * sender, QVariant extractedCANsignal) = 0;
};

#endif // IAMJSONPROCESSABLE_H
