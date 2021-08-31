#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 1000
#define SUM_LEN 1000
#define MAX_FNAME 200

void fun(FILE * instream, FILE * outstream, int len) {
    int ch, count = 0;
    char * line = NULL;
    char isws = 1;
    size_t sz = MAX_LINE;
    getline(&line, &sz, instream);
    for (int i = 0; i < strlen(line); ++i) {
        ch = line[i];
        if (ch == '<') {
            count += 1;
            continue;
        }
        if (ch == '>') {
            count -= 1;
            continue;
        }
        if (count) 
            continue;
        if (isspace(ch) && isws) {
            continue;
        }
        isws = isspace(ch);

        fputc(ch, outstream);
    }
    free(line);
    fflush(outstream);


    count = 0;
    isws = 1;
    while ( len >= 0 && (ch = fgetc(instream)) != EOF ) {
        if (ch == '<') {
            count += 1;
            continue;
        }
        if (ch == '>') {
            count -= 1;
            continue;
        }
        if (count) 
            continue;

        if (isspace(ch) && isws) {
            continue;
        }
        isws = isspace(ch);
        ch = ( isws && ch != ' ') ? '\t' : ch;

        fputc(ch, outstream);
        len -= 1;
    }
    fputc('\n',outstream);
}

int main(int argc, char ** argv) {
    if (argc == 1) {
        fun(stdin, stdout, SUM_LEN);
        return 0;
    }
    char * fname;
    int l;
    char fnameout[MAX_FNAME];
    for (int i = 1; i < argc; ++i) {
        fname = argv[i];
        l = strlen(fname);
        if (strcmp(fname+l-4, "html")) continue;
        if (l >= MAX_FNAME){
            fprintf(stderr, "Too long file name\n");
            exit(1);
        }
        strcpy(fnameout, fname);
        strcpy(fnameout + l-4, "txt");
        FILE * fh = fopen(fname, "r");
        FILE * fhout = fopen(fnameout, "w");
        printf("%s  \t%s\n",fname, fnameout);
        fun(fh, fhout, SUM_LEN);
        fclose(fh);
        fclose(fhout);
    }
    return 0;
}