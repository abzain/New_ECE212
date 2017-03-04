/* 
 * File:   Lab4_t1_main.c
 * Author: Zainab Hussein
 *
 * HYPNOTIZER
 * Created on February 28, 2017, 8:23 AM
 */

#include "ece212.h"
/*
 * 
*/
int main() {
    ece212_setup();
    
    int mask = 0x1;
    int wrap_left = 0x1;
    int wrap_right = 0x8;
    int dir = 0; 
    
    writeLEDs(mask);
    
    while(1) {
       
 
        //for right direction
        if( dir == 1){
            delayms(500);
            mask >>= 1;
            if( mask < 0x1)
                mask = wrap_right;
                
            writeLEDs(mask);    
            
        }
        //for left direction
        if( dir == 0){
            delayms(500);
            mask = mask << 1;
            if(mask > 0x8)
                mask = wrap_left;
 
            writeLEDs(mask);
        }
        
        if(SW3){
            dir = 1;    //right
        }
        if(SW4){
            dir = 0;    //left
        }
    }
    return(EXIT_SUCCESS);  
}


