#include <utility>
#pragma once

class Memory {
private:
    struct Impl;
    Impl* impl;
public:
    Memory();
    Memory(const Memory &b) = delete;


    Memory* operator=(const Memory &b) = delete;
    ~Memory();
    // return value at addr
    unsigned int read(unsigned int addr) const;
    // write data into addr
    void write(unsigned int addr, unsigned int data);
    std::pair<unsigned, unsigned> getUsage() const;
};
