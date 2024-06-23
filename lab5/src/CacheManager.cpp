#include "CacheManager.h"
#include <math.h>

CacheManager::CacheManager(Memory *memory, Cache *cache){
    // TODO: implement your constructor here
    // TODO: set tag_bits accord to your design.
    // Hint: you can access cache size by cache->get_size();
    // Hint: you need to call cache->set_block_size();
    this->memory = memory;
    this->cache = cache;
    cache->set_block_size(4);
    size = cache->get_size();  
    cache_line_num = size / 4 / way;
    block_index_bits = log2(cache_line_num);
    tag_bits = cache->get_machine_address_bit() - block_index_bits - 2;
    dirty.resize(cache->get_len(), 0);
    valid.resize(cache->get_len(), 0);
    least_used.resize(cache->get_len(), 0);
};

CacheManager::~CacheManager(){
};

unsigned int* CacheManager::find(unsigned int addr){
    // TODO:: implement function determined addr is in cache or not
    // if addr is in cache, return target pointer, otherwise return nullptr.
    // you shouldn't access memory in this function.
    unsigned int cache_line_index = addr >> (tag_bits + 2);
    unsigned int tag = (addr << (block_index_bits)) >> (block_index_bits + 2);
    for (unsigned int block_index = way * cache_line_index; block_index < way * (cache_line_index + 1); block_index++){
        if((*cache)[block_index].tag == tag && valid[block_index]){
            least_used[block_index] = counter++;
            return &(*cache)[block_index][0];
        }
    }
    return nullptr;
}

unsigned int CacheManager::read(unsigned int addr){
    // TODO:: implement replacement policy and return value 
    unsigned int* value_ptr = find(addr);
    unsigned int cache_line_index = addr >> (tag_bits + 2);
    unsigned int tag = (addr << (block_index_bits)) >> (block_index_bits + 2);
    if(value_ptr != nullptr) {
        // in cache
        return *value_ptr;
    } else {
        // not in cache
        unsigned int least_used_index = way * cache_line_index;
        int least_used_time = least_used[way * cache_line_index];
        for (unsigned int block_index = way * cache_line_index; block_index < way * (cache_line_index + 1); block_index++){
            if (least_used[block_index] < least_used_time){
                least_used_time = least_used[block_index];
                least_used_index = block_index;
            }
            if(!valid[block_index]){
                // find empty slot
                valid[block_index] = 1;
                dirty[block_index] = 0;
                least_used[block_index] = counter++;
                (*cache)[block_index].tag = tag;
                return (*cache)[block_index][0] = memory->read(addr);
            }
        }
        // replace least recently used
        if(dirty[least_used_index]){
            unsigned int dirty_addr = ((*cache)[least_used_index].tag << (2)) + (cache_line_index << (tag_bits + 2));
            memory->write(dirty_addr, (*cache)[least_used_index][0]);
        }
        valid[least_used_index] = 1;
        dirty[least_used_index] = 0;
        least_used[least_used_index] = counter++;
        (*cache)[least_used_index].tag = tag;
        return (*cache)[least_used_index][0] = memory->read(addr);
    }
}

void CacheManager::write(unsigned int addr, unsigned value){
    // TODO:: write value to addr
    unsigned int cache_line_index = addr >> (tag_bits + 2);
    unsigned int tag = (addr << (block_index_bits)) >> (block_index_bits + 2);
    for (unsigned int block_index = way * cache_line_index; block_index < way * (cache_line_index + 1); block_index++){
        if((*cache)[block_index].tag == tag){
            if (dirty[block_index]){
                unsigned int dirty_addr = ((*cache)[block_index].tag << (2)) + (cache_line_index << (tag_bits + 2));
                memory->write(dirty_addr, value);
                dirty[block_index] = 0;
            } else {
                dirty[block_index] = 1;
            }
            least_used[block_index] = counter++;
            (*cache)[block_index][0] = value;
            return;
        }
    }
    // write miss: write around
    read(addr);
    write(addr, value);
    return;
};
