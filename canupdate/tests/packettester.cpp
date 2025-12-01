#include "packettester.h"

PacketTester::PacketTester()
    {
        m_readCounter = 0;
        m_crcError = 0;
        m_errorCounter = 0;
    }

int PacketTester::TestFrame(unsigned char* _data)
    {
        // test the got frame
        uint8_t crc;
        crc = crc8buf(_data, 8-1);
        if (crc != _data[8-1])
        {
            m_crcError++;
        }

        uint32_t _counter = *((uint32_t*)_data);
        if (0 == _counter)
        {
            m_crcError = m_errorCounter = 0;
        }
        if (_counter != m_readCounter+1)
        {
            m_errorCounter++;
        }

        if ((m_readCounter % 10000) == 0)
            LOG("LOAD TEST: %u packets (%u MB), %u drops, %u CRC errors\n", (unsigned)m_readCounter, (8*m_readCounter)/(1024*1024), m_errorCounter-1, m_crcError);

        m_readCounter = _counter;
        return _counter;
    }

int PacketTester::CANPacketReceptor(unsigned char *_data, uint32_t _size)
    {
        (void)_size;
        TestFrame(_data);
        return 0;
    }

PacketTester::~PacketTester()
{

}
