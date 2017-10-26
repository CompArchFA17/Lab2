Midpoint

Since there are 4 leds on FPGA board, I put a MUX to control led by Switch 2. If Switch 2 is off, 0~3 bits are shown on LED. Otherwise, 4~7 bits are shown on LED.

I tested the followings.
1. Check the initial value(xA5 = 10100101). When Switch 2 is off, LED 0 and 2 are on and LED 1 and 3 are off.(x5 = 0101) When Switch 2 is on, LED 1 and 3 are on and LED 0 and 2 are off.(xA = 1010)
2. When I turn Switch 1 on, if Switch 0 is off the bits shift up by one and 0 is loaded to the LSB(Least Significant Bit).
3. Otherwise, if Switch 1 is on, then 1 is loaded to the LSB. 
4. If I click Button 0, the value is reseted to the initial value.

The test video is [here](https://drive.google.com/open?id=0BwRWdLa3OOtLSDFaXzFhN1FGZ2s)