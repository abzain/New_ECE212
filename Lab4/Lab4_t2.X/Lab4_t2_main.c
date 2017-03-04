/* 
 * File:   Lab4_t2_main.c
 * Author: Zainab Hussein
 *
 * Lab 1 in software
 * Created on March 1, 2017, 8:47 PM
 */

#include "ece212.h"
/*
 * currently general function works but need to
 * fix button ignoring press, either for dir or 
 * blink mode
 * 
 * Debouncing implementation probably!
 */
int main() {
    ece212_setup();
    
    int mask = 0x1;
    int wrap_left = 0x1;
    int wrap_right = 0x8;
    int dir = 0; 
    int blink_rate = 0;
    
    writeLEDs(mask);
    
    while(1) { 
        
               
        if(SW3){
            dir = 1;    //right
            delayms(300);
            mask >>= 1;
            if( mask < 0x1)
                mask = wrap_right;
                
            writeLEDs(mask);    
        }
        if(SW4){
            dir = 0;    //left
            delayms(300);
            mask = mask << 1;
            if(mask > 0x8)
                mask = wrap_left;
 
            writeLEDs(mask);
        }
        if(SW5){      //blink rate
            delayms(300);
            if (blink_rate == 0) 
                blink_rate = 300;   // 1 Hz blink
            
            else if (blink_rate == 300) 
                blink_rate = 600;  // 2 Hz blink
            
            else if (blink_rate == 600) 
                blink_rate = 0; //solid led
        }
        
        //blink routine
        delayms(blink_rate);    //wait specified time
        writeLEDs(mask);    //led on
        delayms(blink_rate);    //wait specified time
        writeLEDs(0x0);   //led off
    }
    return (EXIT_SUCCESS);
}

