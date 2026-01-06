#ifndef EWINFO_H
#define EWINFO_H

#include <QObject>
#include "core/types.h"


class EWInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(String sn READ getEwsn CONSTANT)
    Q_PROPERTY(String bin READ getEngineVer CONSTANT)
    Q_PROPERTY(String cfg READ getConfigVer CONSTANT)
    Q_PROPERTY(String mesn WRITE setMeSn)
    Q_PROPERTY(String snv READ getSnv NOTIFY snvChanged)
    Q_PROPERTY(String osbuild READ getOSBuildTimestamp CONSTANT)


public:

    EWInfo(QObject * parent = nullptr);

    //Single time fired
    static void declareQML();
    String getEwsn(void);
    String getEngineVer(void);
    String getConfigVer(void);
    String getOSBuildTimestamp(void);

    String getSnv(void);
    void setMeSn(const String&);

signals:
    void snvChanged(const String& newSnv);

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

    String ewsn_str;
    String ewbin_str;
    String ewcfg_str;
    String ewosbuild_str;
    String snv_str;
    bool is_snv_ready;
};

#endif // EWINFO_H
