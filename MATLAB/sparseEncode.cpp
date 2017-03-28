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
    double *I = mxGetPr(pi[1]),
           *D = mxGetPr(pi[0]);
    
    
    int N = mxGetN(pi[0]),
        M = mxGetN(pi[1]);
    
    // Copy input image
    double  *J = mxGetPr(mxCreateDoubleMatrix(64, 1, mxREAL)),
           *iD = mxGetPr(mxCreateDoubleMatrix(64, 1, mxREAL));
    
    // outputs
    po[0] = mxCreateDoubleMatrix(N, M, mxREAL);
    double *A = mxGetPr(po[0]);
    
    double e  = 1e10,
           ke = 1e10,
           je = 1e10,
           ie = 1e10,
           ix = -1,
           jx = -1;
    int ii = -1,
        count = 0,
        coeffs = 0;
    
    for (int o = 0; o < M; o++) { // Each neighborhood
        
        e = 1e10;
        
        // Copy 1 neighborhood
        for (int i = 0; i < 64; i++) J[i] = I[o*64+i];
        
        ii = -1; coeffs = 0;
        while (e > 1 && coeffs < 10) {

            // Get vector of smallest error
            ii = 0; ie = 1e10;
            for (int i = 0; i < N; i++) {
                if (A[o*N+i] == 0) {
                    // Get Basis of interest
                    jx = 0;
                    for (int j = 0; j < 64; j++) {
                        iD[j] = D[i*64+j];
                        if (J[j] != 0) jx += iD[j] / J[j] / 64;
                    }
                    // Error
                    je = 0;
                    for (int j = 0; j < 64; j++) je += fabs(J[j] - jx*iD[j]);
                    // Compare
                    if (je < ie) {
                        ii = i;
                        ix = jx;
                        ie = je;
                    }
                }
            }

            if (ie < e) {
                A[o*N+ii] = ix; e = 0;
                for (int i = 1; i < 64; i++) {
                    J[i] = J[i] - ix*D[ii*64+i];
                    e += fabs(J[i]);
                }
                coeffs++;
            } else {
                // printf("%d: %e >= %e\n",coeffs,ie,e);
                coeffs = 10;
            }
        }
    }
    return;
}