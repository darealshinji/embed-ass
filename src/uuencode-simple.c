/*
Project: UUEncode-simple
File: main.c

Copyright (c) 2014, Christoph "Youka" Spanknebel

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
    Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
    This notice may not be removed or altered from any source distribution.
*/

#include <stdio.h>
#include <string.h>
#define MIN(a,b) ((a) < (b) ? (a) : (b))

// "UNIX to UNIX copy protocol" decoding
void ass_uudecode(FILE* in, FILE* out){
    unsigned char lf_buf[2], read, src[4], dst[3];
    while((read = fread(src, 1, sizeof(src), in)) != 0){
        memset(src+read, 33, sizeof(src)-read);
        dst[0] = ((src[0] - 33) << 2) | ((src[1] - 33) >> 4);
        dst[1] = ((src[1] - 33) << 4) | ((src[2] - 33) >> 2);
        dst[2] = ((src[2] - 33) << 6) | (src[3] - 33);
        fwrite(dst, 1, MIN(read-1,sizeof(dst)), out);
        if((read = fread(lf_buf, 1, 2, in)) != 2 || lf_buf[0] != '\r' || lf_buf[1] != '\n')
            fseek(in, -read, SEEK_CUR);
    }
}

// "UNIX to UNIX copy protocol" encoding
void ass_uuencode(FILE* in, FILE* out){
    unsigned char wrote_line = 0, read, src[3], dst[4];
    while((read = fread(src, 1, sizeof(src), in)) != 0){
        memset(src+read, 0, sizeof(src)-read);
        dst[0] = (src[0] >> 2) + 33;
        dst[1] = (((src[0] & 0x3) << 4) | (src[1] >> 4)) + 33;
        dst[2] = (((src[1] & 0xf) << 2) | (src[2] >> 6)) + 33;
        dst[3] = (src[2] & 0x3f) + 33;
        wrote_line += fwrite(dst, 1, MIN(read+1,sizeof(dst)), out);
        if(wrote_line == 80 && !feof(in)){
            fwrite("\n", 1, 1, out);
            wrote_line = 0;
        }
    }
}

// Program entry
int main(int argc, const char** argv){
    // Data
    enum {DECODE, ENCODE, NONE} mode = NONE;
    char output = 0;
    const char* fin = NULL, *fout = NULL;
    FILE* fpin = stdin, *fpout = stdout;
    int i;
    // Command line info
    if(argc < 2){
        puts(
"Command line arguments:\n"
"-d\tDecode mode\n"
"-e\tEncode mode\n"
"-i <FILENAME>\tInput file\n"
"-o <FILENAME>\tOutput file"
        );
        return 0;
    }
    // Read command line
    for(i = 1; i < argc; ++i)
        if(strcmp(argv[i], "-d") == 0)
            mode = DECODE;
        else if(strcmp(argv[i], "-e") == 0)
            mode = ENCODE;
        else if(strcmp(argv[i], "-i") == 0)
            output = 0;
        else if(strcmp(argv[i], "-o") == 0)
            output = 1;
        else if(output)
            fout = argv[i];
        else
            fin = argv[i];
    // Decode / encode
    if(mode == NONE){
        puts("No mode selected!");
        return 1;
    }
    if(fin && strcmp(fin, "-") != 0 && !(fpin = fopen(fin, "rb"))){
        printf("Couldn't read file '%s'", fin);
        return 1;
    }
    if(fout && strcmp(fout, "-") != 0 && !(fpout = fopen(fout, "wb"))){
        if(fpin != stdin)
            fclose(fpin);
        printf("Couldn't write to file '%s'", fout);
        return 1;
    }
    if(mode == DECODE)
        ass_uudecode(fpin, fpout);
    else
        ass_uuencode(fpin, fpout);
    // Clean
    if(fpin != stdin)
        fclose(fpin);
    if(fpout != stdout)
        fclose(fpout);
    // Success
    return 0;
}
