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
        ADD             R0, R2          //R0 -> k + D

        ADD             R0, R2, LSR 2   //R0 -> k + D + D/4

        ADD             R0, R3, LSR 2   //R0 -> k + D + D/4 + C/4

        SUB             R0, R3, LSL 1   //R0 -> k + D + D/4 + C/4 - 2C

        //R3 -> (13m - 1)/5
        MOV             R2, 13          
        MUL             R3, R1, R2      //R3 -> 13*R1
        SUB             R3, 1
        MOV             R2, 5
        UDIV            R3, R3, R2      //R3 -> R3/32

        ADD             R0, R3          //R0 -> f = k + (13*m - 1)/5 + D + D/4 + C/4 - 2C

        //R0 -> f % 7
        MOV             R1, 7
        SDIV            R2, R0, R1              //R2 -> (int)R0/7
        MLS             R0, R1, R2, R0          //R0 -> R0 - 7*R2

        CMP             R0, 0                   
        IT              LT              //if R0 is negative
        ADDLT           R0, 7           //then add 7

        BX              LR

        .global     Zeller2 // No multiply instructions
        .thumb_func
        .align

Zeller2:    // R0=k, R1=m, R2=D, R3=C
        ADD             R0, R2                  //R0 -> k + D

        ADD             R0, R2, LSR 2           //R0 -> k + D + D/4

        ADD             R0, R3, LSR 2           //R0 -> k + D + D/4 + C/4

        SUB             R0, R3, LSL 1           //R0 -> k + D + D/4 + C/4 - 2C

        //R3 -> (13m - 1)/5 
        ADD             R3, R1, R1, LSL 3       //R3 -> R1 + 8*R1 = 9*R1
        ADD             R3, R1, LSL 2           //R3 -> 9*R1 + 4*R1 = 13*R1 = 13*m
        SUB             R3, 1                   //R3 -> 13*m - 1
        MOV             R2, 5
        UDIV            R3, R3, R2

        ADD             R0, R3                  //R0 -> f = k + (13*m - 1)/5 + D + D/4 + C/4 - 2C

        //R0 -> f % 7
        MOV             R1, 7
        SDIV            R2, R0, R1              //R2 -> (int)R0/7
        RSB             R1, R2, R2, LSL 3       //R2 -> 8*R2 - R2 = 7*R2
        SUB             R0, R1                  //R0 -> R0 - R1

        CMP             R0, 0                   
        IT              LT              //if R0 is negative
        ADDLT           R0, 7           //then add 7

        BX              LR

        .global     Zeller3 // No multiply or divide instructions
        .thumb_func
        .align

Zeller3:    // R0=k, R1=m, R2=D, R3=C
        ADD             R0, R2                  //R0 -> k + D

        ADD             R0, R2, LSR 2           //R0 -> k + D + D/4

        ADD             R0, R3, LSR 2           //R0 -> k + D + D/4 + C/4

        SUB             R0, R3, LSL 1           //R0 -> k + D + D/4 + C/4 - 2C

        //R3 -> (13m - 1)/5 
        ADD             R3, R1, R1, LSL 3       //R3 -> R1 + 8*R1 = 9*R1
        ADD             R3, R1, LSL 2           //R3 -> 9*R1 + 4*R1 = 13*R1 = 13m
        SUB             R3, 1                   //R3 -> 13*m - 1
        MOV             R2, 5

        UDIV            R3, R3, R2              //{REPLACE THIS}

        ADD             R0, R3                  //R0 -> f = k + (13m - 1)/5 + D + D/4 + C/4 - 2C

        //R0 -> f % 7
        MOV             R1, 7

        SDIV            R2, R0, R1              //{REPLACE THIS}

        RSB             R1, R2, R2, LSL 3       //R2 -> 8*R2 - R2 = 7*R2
        SUB             R0, R1                  //R0 -> R0 - R1

        CMP             R0, 0                   
        IT              LT              //if R0 is negative
        ADDLT           R0, 7           //then add 7

        BX              LR

        .end


