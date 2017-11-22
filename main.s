	;INCLUDE C:\ti\TivaWare_C_Series-2.1.4.178\examples\boards\my_board\startup_TM4C123.s

	AREA |.text|, CODE, READONLY
	;THUMB
	EXPORT __main
	ENTRY
	
__main

	;defining addresses here for practice

	;general base addresses
SYS_CONTROL	EQU 0x400FE000
AHB_PORTB	EQU 0x40059000
	
	;offsets
GPIOHBCTL 	EQU 0x06C
RCGCGPIO	EQU	0X608
GPIODIR		EQU	0X400
GPIOAFSEL	EQU	0X420
GPIODR2R	EQU	0X500
GPIOPUR		EQU	0X510
GPIODEN		EQU	0X51C
GPIODATAPB5	EQU	0x3FC;0X080
	
	
	;power pin PB5 to light up external LED
	;select APB. GPIOHBCTL
	LDR r0, =SYS_CONTROL
	LDR r1,[r0, #GPIOHBCTL]
	ORR r1, r1, #(1<<1) ;Enable port B AHB instead. "Note that GPIO can only be accessed through the AHB aperture
	;BFC r1,#0,#6 ;use APB when 0
	;AND r1, r1, 0x0000.0000 ;use APB when 0
	STR r1,[r0, #GPIOHBCTL] 
	
	;Enable clock. RCGCGPIO
	LDR r0, =SYS_CONTROL 
	LDR r1,[r0,#RCGCGPIO]
	ORR r1, r1, #(1<<1) ;enable port B clock(bit 5)
	STR r1,[r0,#RCGCGPIO]
	
	;set to output. GPIODIR
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODIR]
	ORR r1, r1, #(1<<5);pin5
	STR r1,[r0,#GPIODIR]
	
	;set mode to GPIO (nor alternate function). GPIOAFSEL
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIOAFSEL]
	BFC r1,#0,#8 ;clears fields. 0 = GPIO
	;AND r1, r1, 0x0000.0000 ;0 = GPIO
	STR r1,[r0,#GPIOAFSEL]
	
	;to drive strength to 2mA. GPIODR2R
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODR2R]
	ORR r1, r1, #(1<<5);pin5
	STR r1,[r0,#GPIODR2R]
	
	;set to pull up. GPIOPUR
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIOPUR]
	ORR r1, r1, #(1<<5) ;pin5
	STR r1,[r0,#GPIOPUR]

	;enable digital output. GPIODEN
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODEN]
	ORR r1,r1, #(1<<5);pin 1 = digital output enable
	STR r1,[r0,#GPIODEN]
	
	;write "high" to data register for port F pin 1 to turn on red LED. GPIODATA
	LDR r0, =AHB_PORTB
	;LDR r1,[r0,#GPIODATAPB5]
	ORR r1, r1, #0xF0
	STR r1,[r0,#GPIODATAPB5]
	LDR r1,[r0,#GPIODATAPB5]
	
stop B stop	
	
	END