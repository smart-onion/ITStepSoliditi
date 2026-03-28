// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 < 0.9.0;

import "hardhat/console.sol";

library ArrayLibrary {
    function find(address[] calldata arr, address elementTofind) public pure returns(bool, int){
        for (uint i; i < arr.length; i++){
            if(arr[i] == elementTofind){
                return (true, int(i));
            }
        }
        return (false, -1);
    }

    // quick sort
    function sort(uint[] memory data)public pure returns(uint[] memory) {
        
        // uint i = 0;
        // uint total = 0;

        // while(total <= arr.length - 1){
        //     if (i == arr.length - 1){
        //         i = 0;
        //     }
        //     if (arr[i] >= arr[i + 1]){
        //         uint temp = arr[i + 1];
        //         arr[i + 1] = arr[i];
        //         arr[i] = temp;
        //         i++;
        //         total=0;
        //     }else{
        //         i=0;
        //     }
        //     total++;
        // }
        // return arr;

                uint n = data.length;
        uint[] memory arr = new uint[](n);
        uint i;

        for(i=0; i<n; i++) {
        arr[i] = data[i];
        }

        uint[] memory stack = new uint[](n+2);

        //Push initial lower and higher bound
        uint top = 1;
        stack[top] = 0;
        top = top + 1;
        stack[top] = n-1;

        //Keep popping from stack while is not empty
        while (top > 0) {

        uint h = stack[top];
        top = top - 1;
        uint l = stack[top];
        top = top - 1;

        i = l;
        uint x = arr[h];

        for(uint j=l; j<h; j++){
            if  (arr[j] <= x) {
            //Move smaller element
            (arr[i], arr[j]) = (arr[j],arr[i]);
            i = i + 1;
            }
        }
        (arr[i], arr[h]) = (arr[h],arr[i]);
        uint p = i;

        //Push left side to stack
        if (p > l + 1) {
            top = top + 1;
            stack[top] = l;
            top = top + 1;
            stack[top] = p - 1;
        }

        //Push right side to stack
        if (p+1 < h) {
            top = top + 1;
            stack[top] = p + 1;
            top = top + 1;
            stack[top] = h;
        }
        }

        for(i=0; i<n; i++) {
        data[i] = arr[i];
        }
        return data;
            
    }

    function remove(uint[] storage data, uint index) internal {
            require(index >= 0 && index < data.length, "Out of range");
            for(uint i = index; i < data.length - 1;i++){
                    data[i] = data[i + 1];
            }
            data.pop();
    }
}