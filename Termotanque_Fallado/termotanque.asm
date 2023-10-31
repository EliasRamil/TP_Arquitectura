; Configuración del PIC16F628A
	list    p=16F628A        ; Lista de instrucciones del PIC16F628A
	#include <P16F628A.INC>  ; Archivo de inclusión específico del PIC16F628A

; Definición de bits trisb
BA      equ 0    ; Bit asociado al LED azul (Bomba encendida)
TR      equ 1    ; Bit asociado al LED rojo (Resistencia encendida)
CA      equ 3    ; Bit asociado al LED verde (Canilla abierta)
CE      equ 4    ; Bit asociado al LED blanco (Canilla cerrada)
Ta      equ 5    ; Bit asociado para la temperatura del agua (Ta)
Ca      equ 6    ; Bit asociado para la cantidad del agua (Ca)

; Definición de constantes
CAPACIDAD_TERMOTANQUE    equ d'110'     ; Capacidad del termotanque en litros
Tm			             equ d'20'      ; Temperatura mínima de trabajo en °C
TM			             equ d'45'      ; Temperatura máxima donde debe dejar de calentar en °C
CANTIDAD_AGUA            equ d'50'      ; Cantidad de agua para cerrar la canilla en litros
	CBLOCK 0x20
	COUNT1
	COUNT2
	ENDC

; Inicio del programa
	org 0x00
    goto inicio

; Rutina de interrupción
    ORG 0x04
    RETFIE

; Subrutina para verificar si hay agua suficiente en el termotanque
verificar_agua:
    ; Verificar si el termotanque tiene suficiente agua (si es menor de 110 litros)
    ; Si es menor, se enciende la bomba (BA) y se espera a que la cantidad de agua alcance el nivel necesario.

loop_agua
    movlw CAPACIDAD_TERMOTANQUE
    subwf Ca, w
    btfss STATUS, Z			; Si Ca - w es 0 se hace salto de 1 instruccion
    goto agua_insuficiente

    ; Apagar la bomba (BA)
    bcf PORTB, BA

    return

agua_insuficiente:
	; Encender la bomba (BA)
    bsf PORTB, BA
    
    call delay_espera
    call delay_espera
    call delay_espera
    call delay_espera
    call delay_espera

	goto loop_agua
	
    return

; Subrutina para verificar la temperatura del agua
verificar_temperatura:
    ; Verificar la temperatura del agua y encender la resistencia (TR) si es necesario
    ; Mostrar el estado de la temperatura en el led amarillo (TA)

loop_temp
    ; Leer la temperatura max (TM)
    movf TM, w

    ; Comparar con la temperatura del agua (Ta)
    subwf Ta, w
    btfss STATUS, Z			; Si Ta - w es 0 se hace salto de 1 instruccion
    goto temperatura_baja

    ; Apagar la resistencia y mostrar el estado en el led rojo (TR)
    bcf PORTB, TR

    return

temperatura_baja:
    ; Encender la resistencia y mostrar el estado en el led rojo (TR)
    bsf PORTB, TR

    call delay_espera
    call delay_espera
    call delay_espera
    call delay_espera
    call delay_espera

	goto loop_temp

    return

; Subrutina para verificar si la canilla debe abrirse o cerrarse
verificar_canilla:
    ; Verificar la apertura y cierre de la canilla. Cuando la cantidad de agua alcanza los 50 litros,
    ; se cierra la canilla (CE) y se espera un tiempo antes de activar la bomba (BA) y la resistencia (TR).

    ; Verificar si la canilla está cerrada (CE)
    btfss PORTB, CE
    goto canilla_abierta

    ; Verificar si la cantidad de agua alcanzó el límite
    movlw CANTIDAD_AGUA
    subwf Ca, w
    btfsc STATUS, Z					; Si Ca - w es 0 no se hace salto de 1 instruccion
    goto cantidad_agua_alcanzada

    ; Abrir la canilla (CA)
    bsf PORTB, CA

    return

cantidad_agua_alcanzada:
    ; Cerrar la canilla (CE)
    bcf PORTB, CA

    ; Esperar un tiempo antes de encender la bomba (BA) y la resistencia (TR)
    call delay_espera
    call delay_espera

    ; Encender la bomba (BA)
    bsf PORTB, BA

    ; Encender la resistencia (TR)
    bsf PORTB, TR

    return

canilla_abierta:
    ; Verificar si la cantidad de agua es suficiente para cerrar la canilla
    movlw CANTIDAD_AGUA
    subwf Ca, w
    btfsc STATUS, Z					; Si Ca - w es 0 no se hace salto de 1 instruccion
    goto cantidad_agua_suficiente

    ; Abrir la canilla (CA)
    bsf PORTB, CA

    return

cantidad_agua_suficiente:
    ; Cerrar la canilla (CE)
    bcf PORTB, CA

    return

; Subrutina de espera (delay)
delay_espera:
    ; Implementar delay para esperar un tiempo antes de encender la bomba (BA) y la resistencia (TR)

    movlw 0xFF
    movwf COUNT1
delay_loop1:
    movlw 0xFF
    movwf COUNT2
delay_loop2:
    decfsz COUNT2, f
    goto delay_loop2
    decfsz COUNT1, f
    goto delay_loop1

    return
    
    
; Inicio del programa
inicio:
    ; Configuración de puertos y registros
    bsf STATUS, RP0        ; Seleccionar el banco 1 de registros
    movlw b'01100000'      ; Config TRISB
    movwf TRISB;

     ; Apagar Watchdog Timer
    MOVLW 0x7
    MOVWF OPTION_REG
    ; Deseleccionar el banco de registros 1 (volver al banco 0)
    BCF STATUS, RP0

	bcf PORTB, BA
	bcf PORTB, TR
	bcf PORTB, CA
	bcf PORTB, CE
	
bucle_principal:
    call verificar_agua			; Verificar si hay agua suficiente en el termotanque
    call verificar_temperatura  ; Verificar la temperatura del agua
    call verificar_canilla		; Verificar si la canilla debe abrirse o cerrarse
    goto bucle_principal
    end