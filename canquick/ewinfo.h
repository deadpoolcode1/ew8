#ifndef EWINFO_H
#define EWINFO_H

#include <QObject>
#include "core/types.h"


class EWInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString sn READ getEwsn CONSTANT)
    Q_PROPERTY(QString bin READ getEngineVer CONSTANT)
    Q_PROPERTY(QString cfg READ getConfigVer CONSTANT)
    Q_PROPERTY(QString mesn WRITE setMeSn)
    Q_PROPERTY(QString snv READ getSnv NOTIFY snvChanged)
    Q_PROPERTY(QString osbuild READ getOSBuildTimestamp CONSTANT)


public:

    EWInfo(QObject * parent = nullptr);

    //Single time fired
    static void declareQML();
    QString getEwsn(void);
    QString getEngineVer(void);
    QString getConfigVer(void);
    QString getOSBuildTimestamp(void);

    QString getSnv(void);
    void setMeSn(QString);

signals:
    void snvChanged(QString newSnv);

private:

    void readEWInfo(void);

#if !((defined WIN32) || (defined REMOVE_EW8_HW))

    void readOSBuildInfo(void);
    void readServiceNumber(void);
    void enableDisableSFC(uint32_t * wr_ptr, bool On);
    uint32_t readDataSFC(uint32_t * rd_ptr, uint32_t index);



    uint8_t ewsn_lsb[8];
    uint8_t ewsn_msb[8];
#endif

    QString ewsn_str;
    QString ewbin_str;
    QString ewcfg_str;
    QString ewosbuild_str;
    QString snv_str;
    bool is_snv_ready;
};

#endif // EWINFO_H
