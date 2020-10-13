#include <stdio.h>

#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/address_map_arm.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/PBs.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/LEDs.h"




#define TIMERINT
int main(){
#ifdef LED
    while(1){
        write_LEDs_ASM(read_slider_switches_ASM());
        }
#endif

#ifdef SWITCHES
    while(1){
        write_LEDs_ASM(read_slider_switches_ASM());
        if(read_slider_switches_ASM() & 0x200){ // looking at the 10th switch
            HEX_clear_ASM(HEX0); //clear the displays
            HEX_clear_ASM(HEX1);
            HEX_clear_ASM(HEX2);
            HEX_clear_ASM(HEX3);
            HEX_clear_ASM(HEX4);
            HEX_clear_ASM(HEX5);
        }
        else{
            HEX_flood_ASM(HEX4);
            HEX_flood_ASM(HEX5);
            char hex_val = (0xF & read_slider_switches_ASM()); //We only care about first 4 switches, 0xF to clear upper bits
            int PB = (0xF & read_PB_data_ASM()); // 4 Switches
            hex_val = hex_val + 48; //for ASCII usage
            HEX_write_ASM(PB, hex_val);//write the value on specified location
        }
    }
#endif

#ifdef TIMER                          //initializing timer parameters
    HPS_TIM_config_t hps_tim;
    hps_tim.tim = TIM0;
    hps_tim.timeout = 10000;  //timer 1 timeout
    hps_tim.LD_en = 1;
    hps_tim.INT_en = 1;
    hps_tim.enable = 1;
    HPS_TIM_config_ASM(&hps_tim); //Configuring timer 1

    //This timer is for the PB polling, 2nd timer parameters
    HPS_TIM_config_t hps_tim_pb;
    hps_tim_pb.tim = TIM1;
    hps_tim_pb.timeout = 5000;
    hps_tim_pb.LD_en = 1;
    hps_tim_pb.INT_en = 1;
    hps_tim_pb.enable = 1;
    HPS_TIM_config_ASM(&hps_tim_pb); //configuring timer 2

    //Declare our ints
    int micros = 0;
    int seconds = 0;
    int minutes = 0;
    int timerstart = 0; //Bit holding whether time is running or not
    while (1) {
        //when timer for the timer seconds flags
        if (HPS_TIM_read_INT_ASM(TIM0) && timerstart) {
            HPS_TIM_clear_INT_ASM(TIM0);
            micros += 10; //Timer is for 10 milliseconds
            //When microseconds reach 1000, we increment seconds and then microseconds reset
            if (micros >= 1000) {
                micros -= 1000;
                seconds++;
                //when seconds reach 60, we reset and increment minutes
                if (seconds >= 60) {
                    seconds -= 60;
                    minutes++;
                    //we do not use hours
                    if (minutes >= 60) {
                        minutes = 0;
                    }
                }
            }
            //Display every value and convert the count to ASCII values
            HEX_write_ASM(HEX0, ((micros % 100) / 10) + 48);
            HEX_write_ASM(HEX1, (micros / 100) + 48);
            HEX_write_ASM(HEX2, (seconds % 10) + 48);
            HEX_write_ASM(HEX3, (seconds / 10) + 48);
            HEX_write_ASM(HEX4, (minutes % 10) + 48);
            HEX_write_ASM(HEX5, (minutes / 10) + 48);
        }
        //for the PBs polling
        if (HPS_TIM_read_INT_ASM(TIM1)) {
            HPS_TIM_clear_INT_ASM(TIM1); //reset
            int PB = 0xF & read_PB_data_ASM(); // read_PB_edgecap_ASM()
            //Start timer
            if ((PB & 1) && (!timerstart)) {
                timerstart = 1;
            }
            //Stop timer
            else if ((PB & 2) && (timerstart)) {
                timerstart = 0;
            }
            //Reset timer
            else if (PB & 4) {
                micros = 0;
                seconds = 0;
                minutes = 0;
                timerstart = 0;
                //set everything to 0
                HEX_write_ASM(HEX0, 48);
                HEX_write_ASM(HEX1, 48);
                HEX_write_ASM(HEX2, 48);
                HEX_write_ASM(HEX3, 48);
                HEX_write_ASM(HEX4, 48);
                HEX_write_ASM(HEX5, 48);
            }
        }
    }
#endif

#ifdef INTERRUPT
    int_setup(2, (int[]) {73, 199 });
    enable_PB_INT_ASM(PB0 | PB1 | PB2);

    int count = 0;
    HPS_TIM_config_t hps_tim;
    // we only need one timer
    hps_tim.tim = TIM0;
    hps_tim.timeout = 10000;
    hps_tim.LD_en = 1;
    hps_tim.INT_en = 1;
    hps_tim.enable = 1;

    HPS_TIM_config_ASM(&hps_tim);
    int timerstart=0;
    int micros = 0;
    int seconds = 0;
    int minutes = 0;

    while (1) {
        //each 10 ms, we increment, we only go when the subroutine flag is active
        if (hps_tim0_int_flag && timerstart) {
            hps_tim0_int_flag = 0;
            micros += 10;

            //increment ms until we reach 1000, then +1 second then reset
            if (micros >= 1000) {
                micros -= 1000;
                seconds++;
                //increment seconds, until we reach 60, then +1 minute then reset
                if (seconds >= 60) {
                    seconds -= 60;
                    minutes++;
                    //reset minutes since we have no hours
                    if (minutes >= 60) {
                        minutes = 0;
                    }
                }
            }

            //write on the proper hex display
            HEX_write_ASM(HEX0, ((micros % 100) / 10) + 48);
            HEX_write_ASM(HEX1, (micros / 100) + 48);
            HEX_write_ASM(HEX2, (seconds % 10) + 48);
            HEX_write_ASM(HEX3, (seconds / 10) + 48);
            HEX_write_ASM(HEX4, (minutes % 10) + 48);
            HEX_write_ASM(HEX5, (minutes / 10) + 48);
        }
        //if PB flag active, the ISR is active, we do something depending on which button is pressed
        if (pb_int_flag != 0){
            if(pb_int_flag == 1) //start
                timerstart=1;
            else if(pb_int_flag == 2) //pause
                timerstart = 0;
            else if(pb_int_flag == 4){ // reset timer
                micros = 0;
                seconds = 0;
                minutes = 0;
                HEX_write_ASM(HEX0, 48);
                HEX_write_ASM(HEX1, 48);
                HEX_write_ASM(HEX2, 48);
                HEX_write_ASM(HEX3, 48);
                HEX_write_ASM(HEX4, 48);
                HEX_write_ASM(HEX5, 48);
            }
            pb_int_flag = 0;
        }
    }
#endif
return 0;

}

