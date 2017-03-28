/* 
 * File:   LafBot.c
 * Author: Zainab Hussein
 *
 * Bot used: SN 2
 * Created on March 23, 2017, 9:01 PM
 */

#include "ece212.h"
int main() {
    ece212_lafbot_setup();
    int minSpeed = 0x000F;      //min speed of robot
    int maxSpeed = 0xFFF0;      //max speed of robot on big track
    int outOfBounds = 0x1FF;    //the ADC threshold for determining
                                // whether the robot is on the line
        while (1){
            if(SW3)
                maxSpeed = 0xF000;      //max speed of robot on small track
            
            /**when the right sensor detects a value out of bounds, the left wheel
            * will spin forward at its maxspeed and the right wheel will spin
            * forward at its minSpeed */           
            while (analogRead(RIGHT_SENSOR) > outOfBounds) {
            LFORWARD = maxSpeed;
            RFORWARD = minSpeed;
            }
            
            /**when the left sensor detects a value out of bounds, the left wheel
            * will spin forward at its minSpeed and the right wheel will spin
            * forward at its maxSpeed */
            while (analogRead(LEFT_SENSOR) > outOfBounds) {
            RFORWARD = maxSpeed;
            LFORWARD = minSpeed;
            }
            
            /**when the left sensor and right sensor both detect a value within
            * bound, the left and right wheel will spin forward at their
            * maxSpeeds */
            while (analogRead(LEFT_SENSOR) < outOfBounds
            && analogRead(RIGHT_SENSOR) < outOfBounds) {
            RFORWARD = maxSpeed;
            LFORWARD = maxSpeed;
            }
        }
}