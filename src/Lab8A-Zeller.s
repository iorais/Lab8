        .syntax     unified
        .cpu        cortex-m4
        .text

/*
uint32_t Zeller(uint32_t k, uint32_t m, uint32_t D, uint32_t C)
    {
    int32_t f, r ;

    f = (int32_t) (k + (13*m-1)/5 + D +D/4 + C/4 - 2*C) ;
    r = f % 7 ;
    if (r < 0) r += 7 ;
    return r ;
    }
*/
        .global     Zeller1 // Baseline using divide and multiply
        .thumb_func
        .align

Zeller1:    // R0=k, R1=m, R2=D, R3=C
        //Your code here...
		//Your code here...
		//Your code here...
        BX          LR

        .global     Zeller2 // No multiply instructions
        .thumb_func
        .align

Zeller2:    // R0=k, R1=m, R2=D, R3=C
        //Your code here...
		//Your code here...
		//Your code here...
        BX          LR

        .global     Zeller3 // No multiply or divide instructions
        .thumb_func
        .align

Zeller3:    // R0=k, R1=m, R2=D, R3=C
        //Your code here...
		//Your code here...
		//Your code here...
        BX          LR

        .end


