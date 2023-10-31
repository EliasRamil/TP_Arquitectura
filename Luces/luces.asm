; Configuración del PIC16F628A
	list    p=16F628A        ; Lista de instrucciones del PIC16F628A
	#include <P16F628A.INC>  ; Archivo de inclusión específico del PIC16F628A

	__CONFIG 3F10

; Definición de constantes, bloque de control
    CBLOCK 0x20
    COUNT1
    COUNT2
    ENDC

    ORG 0x00
    GOTO Inicio

; Rutina de interrupción
    ORG 0x04
    RETFIE

; Rutina para esperar 1 microsegundo
Esperar1ms:
	movlw d'250'
	movwf COUNT1
loop
	nop
	decfsz COUNT1, 1
	goto loop
	
	return

; Rutina para esperar 250 microsegundos
Esperar250ms:
	movlw d'250'
	movwf COUNT2
loop2
	call Esperar1ms
	decfsz COUNT2, 1
	goto loop2
	
	return

; Programa principal
Inicio:
    ; Configurar puertos
	BSF STATUS, RP0			; Seleccionar el banco de registros 1
    MOVLW 0x00
    MOVWF TRISB
	BCF STATUS, RP0			; Deseleccionar el banco de registros 1 (volver al banco 0)

LOOP

    ; Punto 1: Encender todos los leds (RB0, RB1, RB2, RB3)
    MOVLW 0x0F
    MOVWF PORTB

    ; Esperar un segundo
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms

    ; Punto 2: Encender y apagar todos los leds cada un segundo
    MOVLW 0x00
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x0F
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x00
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms

    ; Punto 3: Encender los leds durante un segundo y apagarlos leds durante medio segundo, repetir 4 veces
    MOVLW 0x0F
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x00
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x0F
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x00
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x0F
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x00
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x0F
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    CALL Esperar250ms
    MOVLW 0x00
    MOVWF PORTB
    CALL Esperar250ms
    CALL Esperar250ms

	; Punto 4: Encender los LEDs de RB0 a RB3 con una demora de 500ms entre ellos
	MOVLW 0x01
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms
	MOVLW 0x03
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms
	MOVLW 0x07
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms
	MOVLW 0x0F
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms

	; Punto 5: Apagar los LEDs de RB3 a RB0 con una demora de 500ms entre ellos
	MOVLW 0x07
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms
	MOVLW 0x03
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms
	MOVLW 0x01
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms
	MOVLW 0x00
	MOVWF PORTB
	CALL Esperar250ms
    CALL Esperar250ms

    GOTO LOOP
	END