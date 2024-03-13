#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vadd_sub_4bit.h"
#include <stdlib.h>
#include <iostream>
#include <bitset>
#include <time.h>
using namespace std;

Vadd_sub_4bit *top = new Vadd_sub_4bit;
vluint64_t sim_time = 0;
VerilatedVcdC *m_trace = new VerilatedVcdC;

typedef struct{
   unsigned int A : 4;
   unsigned int B : 4;
   unsigned int C : 4;
   unsigned int Y : 4;
}ABC;


void test(){
    ABC abc;
    for(int cnt=0; cnt<10; cnt++){
        abc.A = rand() % 16;
        abc.B = rand() % 16;
        top->Mode = rand() & 1;
        // generate golden answer
        switch(top->Mode) { 
            case 0:
                abc.C = abc.A + abc.B;
                break;
            case 1:
                abc.C = abc.A - abc.B;
                break;
        }
        int x = top->Mode;
        // cout << abc.A << " " << (x ? '-' : '+') << " " << abc.B;
        top->A = abc.A;
        top->B = abc.B;
        // for(int i = 0; i <= 3; i++){
        //     top->A[i] = abc.A % 2;
        //     top->B[i] = abc.B % 2;
        //     abc.A /= 2; abc.B /= 2;
        // }

        top->eval();
        m_trace->dump(sim_time);
        sim_time++;
        // abc.B = 0;
        // for(int i = 0; i < 4; i++){
        //     abc.B += top->S[i] << i;
        // }
        // abc.B = top->S[0] + 2 * top->S[1] + 4 * top->S[2] + 8 * top->S[3];
        abc.B = top->S;
        // cout << " = " << abc.B << " / " << abc.C << endl;
        assert(abc.C == abc.B);
    }
    cout<<endl;
    cout<<"============================"<<endl;
    cout<<"\e[32m\e[1mPASS\e[0m\n";
}

int main() {
    time_t start, end;
    srand(1111);
    Verilated::traceEverOn(true);
    top->trace(m_trace, 99);
    m_trace->open("waveform.vcd");
    start = clock();
    test();   
    end = clock();
    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    m_trace->close();
    cout<<"cpu_time_used : "<<cpu_time_used<<endl;
    cout<<"============================"<<endl;
    delete top;
    return 0;
}
