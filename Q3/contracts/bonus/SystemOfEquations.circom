pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom"; // hint: you can use more than one templates in circomlib-matrix to help you

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component mul = matMul(n,n,1);
    for(var i = 0;i<n;i++){
        for(var j =0;j<n;j++){
            mul.a[i][j] <== A[i][j];
        }
    }
    for(var i =0;i<n;i++){
        mul.b[i][0] <== x[i];
    }

    component eq [n];
    var ch = n;
    for(var  i =0;i<n;i++){
        eq[i] = IsEqual();
        eq[i].in[0] <== b[i];
        eq[i].in[1] <== mul.out[i][0];
        ch -= eq[i].out;
    }
    
    component check = IsEqual();
    check.in[0] <== ch;
    check.in[1] <== 0;
    out<== check.out;
}

component main {public [A, b]} = SystemOfEquations(3);