// usage: ./program <outfile> <size-in-bytes>
#include <stdio.h>
void main(int argc, char** argv){
    long long i, s;
    FILE* f = fopen(*(argv+1), "w");
    srand(time(NULL));
    sscanf(*(argv+2), "%lld", &s);  
    for(i=0;i<s;i++){
        fputc(rand()%255,f);
    }
    fclose(f);
}
