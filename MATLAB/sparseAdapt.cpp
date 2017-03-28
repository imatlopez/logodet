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
    double *A = mxGetPr(pi[2]),
           *I = mxGetPr(pi[1]),
           *C = mxGetPr(pi[0]);
    
    
    int N = mxGetN(pi[0]),
        M = mxGetN(pi[2]),
        O = 0, P = 0, Q = 0;
    
    // outputs
    po[0] = mxCreateDoubleMatrix(64, 256, mxREAL);
    double *D = mxGetPr(po[0]);
    
    for (int i = 0; i < 64; i++) {
        for (int j = 0; j < 256; j++) {
            O = 64*j + i;
            C[O] += D[O];
        }
    }
    
    // sums
    double *S1 = mxGetPr(mxCreateDoubleMatrix(1, M, mxREAL)),
           *S2 = mxGetPr(mxCreateDoubleMatrix(256, 1, mxREAL));
    
    for (int i = 0; i < 256; i++) {
        for (int j = 0; j < M; j++) {
            O = 256*j + i;
            S1[j] += A[O];
            S2[i] += A[O];
        }
    }
    
    // weights
    double *W1 = mxGetPr(mxCreateDoubleMatrix(256, M, mxREAL)),
           *W2 = mxGetPr(mxCreateDoubleMatrix(256, M, mxREAL)),
           *W3 = mxGetPr(mxCreateDoubleMatrix(256, M, mxREAL));
    
    for (int i = 0; i < 256; i++) {
        for (int j = 0; j < M; j++) {
            O = 256*j + i;
            if (S1[j] != 0) W1[O] = A[O] / S1[j];
            if (S2[i] != 0) W2[O] = A[O] / S2[i];
            W3[O] = W1[O] * W2[O];
        }
    }
    for (int i = 0; i < 256; i++) {
        for (int j = 0; j < M; j++) {
            O = 256*j + i;
            S1[j] += W1[O];
            S2[i] += W2[O];
        }
    }
    
    // adapt
    double E = 0;
    for (int i = 0; i < 256; i++) {
        for (int j = 0; j < M; j++) {
            O = 256*j + i; // Index of A
            for (int k = 0; k < 64; k++) {
                P = 64*j + k; // Index of I
                Q = 64*i + k; // Index of D
                if (A[O] != 0) E = (I[P] - A[O]*D[Q]) / A[O];
                if (A[O] != 0 && S1[j] != 0 && S2[i] != 0) D[Q] += E*(W3[O]/S1[j]/S2[i]);
            }
        }
    }
    
    return;
}