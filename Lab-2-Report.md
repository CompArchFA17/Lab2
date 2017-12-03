# Lab 2 Report
Jonah Spear, David Papp


# Note:

We never finished this lab and at this point we’re submitting for partial credit.


# Input Conditioning

Our waveform illustrates the three desired characteristics:

![](https://d2mxuefqeaa7sj.cloudfront.net/s_B9532690B10F570C9A4A02C57E09079770E739AAA391501DF085C097B989418B_1508953194069_input_fixed.png)


**Input synchronisation:** The conditioned input is synchronised with the noisy input with the clock. This part was already done for us.

**Input debouncing:** We create a noisy signal with several bounces prior to stabilisation in both the positive and negative directions. It is evident from the waveform image that the conditioned input only changes if the input pin is stable for at least three cycles. Because of this, there is a three cycle delay between when the noisy signal changes to when conditioned registers this change.

**Edge detection:** It is evident from the waveform image that rising rises for exactly one clock cycle when conditioned switches from 0 to 1. Conversely, falling rises for exactly one clock cycle when conditioned switches from 1 to 0. Rising and falling flip at the exact time that condition flips.





**Circuit diagram:**
<insert here>


**Question:** If the main system clock is running at 50MHz, what is the maximum length input glitch that will be suppressed by this design for a `waittime` of 10? Include the analysis in your report.

With a *waittime* of 10, the noisy signal needs to be steady for 10 cycles before the conditioned input changes. With a 50MHz clock, each cycle takes 2e-8 seconds. Ten cycles will thus take 2e-7 seconds.


----------
# Shift Register

**Test bench for shiftregister.v:** We tested three properties of our shift register. First, we tested that parallel load was working properly. We confirmed that parallelDataOut was the same as the parallelDataIn when parallel load was enabled.
Next, we confirmed that the shift register advances one position and appends the correct serialDataIn value. We did this by manually setting the peripheralClkEdge and adding ones and zeros in manual clock cycles and verifying parallelDataOut in each iteration.
Finally, we made sure that serialDataOut was correct. This was simple to test, since we essentially just needed to make sure that we were reading the right value.



----------
# Midpoint


Pressing and releasing the button will reset the LEDs to the binary representation of hA5, which is b10101001.

Switch 0 will provide the serialBitIn. It will update when switch 1 is toggled from 0 to 1.

Switching switch 1 to from 0 to 1 will trigger a Clk Edge in the shift register, which will cause the register to shift.


We will confirm that our FPGA works by first initialising our LEDs to 0. We will then toggle switch 0 to ON, and proceeded to toggle switch 1 off and on several times. This will push a few 1s into our LED queue. We will then toggle switch 0 to OFF. Now, when we toggle switch 1 off and on, it will push 0s into our LED queue.
Finally, we will check that parallel load works as expected. When we press the button, the LEDs are set to the sequence 10101001.



----------



