; SwitchTestMain.asm
; Runs on MSP432P401r

; built-in LED1 connected to P1.0
; negative logic built-in Button 1 connected to P1.1
; negative logic built-in Button 2 connected to P1.4
; positive logic switch connected to P1.5
; built-in red LED connected to P2.0
; built-in green LED connected to P2.1
; built-in blue LED connected to P2.2
       .thumb

       .text
       .align  2

P1IN    .field 0x40004C00,32  ; Port 1 Input
P2IN    .field 0x40004C01,32  ; Port 2 Input
P2OUT   .field 0x40004C03,32  ; Port 2 Output
P1OUT   .field 0x40004C02,32  ; Port 1 Output
P1DIR   .field 0x40004C04,32  ; Port 1 Direction
P2DIR   .field 0x40004C05,32  ; Port 2 Direction
P1REN   .field 0x40004C06,32  ; Port 1 Resistor Enable
P2REN   .field 0x40004C07,32  ; Port 2 Resistor Enable
P1DS    .field 0x40004C08,32  ; Port 1 Drive Strength
P2DS    .field 0x40004C09,32  ; Port 2 Drive Strength
P1SEL0  .field 0x40004C0A,32  ; Port 1 Select 0
P2SEL0  .field 0x40004C0B,32  ; Port 2 Select 0
P1SEL1  .field 0x40004C0C,32  ; Port 1 Select 1
P2SEL1  .field 0x40004C0D,32  ; Port 2 Select 1

SW1      .equ 0x02                 ; on the left side of the LaunchPad board
SW2      .equ 0x10                 ; on the right side of the LaunchPad board
SWEXT    .equ 0x20                 ; external switch
RED      .equ 0x01
GREEN    .equ 0x02
BLUE     .equ 0x04
LED1     .equ 0x01

      .global main
      .global   Switch_Init
      .global   Switch_Input
      .global   Board_Init
      .global   Board_Input
      .thumbfunc main
main: .asmfunc
    BL   Switch_Init                ; P1.5 is input
    BL   Board_Init                 ; initialize P1.1 and P1.4 and make them inputs (P1.1 and P1.4 built-in buttons)

    ; initialize P1.0 and make it output (P1.0 built-in LED1)
    ; configure built-in LED1 as GPIO
    LDR  R1, P1SEL0
    LDRB R0, [R1]
    BIC  R0, R0, #LED1              ; configure built-in LED1 as GPIO
    STRB R0, [R1]
    LDR  R1, P1SEL1
    LDRB R0, [R1]
    BIC  R0, R0, #LED1              ; configure built-in LED1 as GPIO
    STRB R0, [R1]
    ; make built-in LED1 out
    LDR  R1, P1DIR
    LDRB R0, [R1]
    ORR  R0, R0, #LED1              ; output direction
    STRB R0, [R1]
    LDR  R4, P1OUT                  ; R4 = &P1OUT (pointer)

loop
    LDRB R6, [R4]
    BIC  R6, R6, #LED1
    BL   Board_Input
    CMP  R0, #0x10                  ; R0 == 0x10?
    BEQ  sw1pressed                 ; if so, switch 1 pressed
    CMP  R0, #0x02                  ; R0 == 0x02?
    BEQ  sw2pressed                 ; if so, switch 2 pressed
    CMP  R0, #0x00                  ; R0 == 0x00?
    BEQ  bothpressed                ; if so, both switches pressed
    CMP  R0, #0x12                  ; R0 == 0x12?
    BEQ  nopressed                  ; if so, neither switch pressed
                                    ; if none of the above, unexpected return value
    ORR  R6, R6, #LED1
    B    continue
sw1pressed
    B    continue

sw2pressed
    B    continue

bothpressed
    B    continue

nopressed
    ORR  R6, R6, #LED1
    B    continue

continue
    STRB R6, [R4]
    BL   Switch_Input               ; status = R0 = 0x00 or 0x20
    B   loop
    .endasmfunc

    .end
