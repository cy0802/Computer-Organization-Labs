#include<iostream>
#include<fstream>
#include<string>
using namespace std;
int main(){
    string line;
    ifstream in("inst.txt");
    ofstream out("TEST_INSTRUCTIONS.txt");
    if(in.is_open()){
        while(getline(in, line)){
            // cout << line << endl;
            for(int pos = 0; pos < line.length(); pos += 8){
                out << line.substr(pos, 8) << endl;
            }
        }
        in.close();
    }
    else{
        cout<<"Unable to open file"<<endl;
    }
    return 0;
}