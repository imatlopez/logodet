#include <stdio.h>
#include <stdlib.h>
#include "mex.h"
#include "matrix.h"
#include <string.h>
#include <math.h>
#include <time.h>
#include <iostream>

/*
 * no - Number of expected output mxArrays
 * po - Array of pointers to the expected output mxArrays
 * ni - Number of input mxArrays
 * pi - Array of pointers to the input mxArrays.
 */
void mexFunction( int no, mxArray *po[], int ni, const mxArray *pi[] ) {
    
    // inputs
    double *F = mxGetPr(pi[3]),
           *A = mxGetPr(pi[2]),
           *I = mxGetPr(pi[1]),
           *C = mxGetPr(pi[0]);
    
    
    int N = mxGetN(pi[0]),
        M = mxGetN(pi[2]),
        O = 0, P = 0, Q = 0;
    
    // outputs
    po[0] = mxCreateDoubleMatrix(256, 256, mxREAL);
    double *D = mxGetPr(po[0]);
    
    for (int i = 0; i < 256; i++) {
        for (int j = 0; j < 256; j++) {
            O = 256*j + i;
            D[O] = C[O];
        }
    }
    
    // weights
    double *W = mxGetPr(mxCreateDoubleMatrix(1, 256, mxREAL));
    for (int i = 0; i < M; i++) W[(int)F[i]]++;
    
    // adapt
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < 256; j++) {
            O = 256*(int)F[i] + j;    // Index of D
            P = 256*i    + j;    // Index of I
            Q = 256*i    + (int)F[i]; // Index of A
            D[O] += (I[P]-A[Q]*C[O]) / W[(int)F[i]];
        }
    }
    
    return;
}