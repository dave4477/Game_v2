;****************************
;* Memory addresses
;****************************

; sprite addresses
SPENA = $D015;          ;sprite enable register
SP0X = $D000            ;sprite 0 horizontal position
SP0Y = $D001            ;sprite 0 vertical position
SP1X = $D002            ;sprite 1 horizontal position
SP1Y = $D003            ;sprite 1 vertical position  
SP2X = $D004            ;sprite 2 horizontal position
SP2Y = $D005            ;sprite 2 vertical position
SP3X = $D006            ;sprite 3 horizontal position
SP3Y = $D007            ;sprite 3 vertical position

SP0COL = $D027          ;sprite 0 colour
SP1COL = $D028          ;sprite 1 colour
SP2COL = $D029          ;sprite 2 colour
SP3COL = $D02A          ;sprite 3 colour

SPSPCL = $D01E          ;sprite to sprite collision register
SPBGCL = $D01F          ;sprite to foreground collision register
MSIGX = $D010           ;sprite extended register
SSDP0 = $07F8           ;sprite 0 shape data pointer
SSDP1 = $07F9           ;sprite 1 shape data pointer
SSDP2 = $07FA           ;sprite 2 shape data pointer
SSDP3 = $07FB           ;sprite 3 shape data pointer

; joystick addresses
CIAPRA = $DC00          ;joystick port 2
CIAPRB = $DC01          ;joystick port 1

;joystick masks
JSMR = %00001000        ;joystick mask right
JSML = %00000100        ;joystick mask left
JSMU = %00000001        ;joystick mask up
JSMD = %00000010        ;joystick mask down
JSMB = %00010000        ;joyst mask button

; screen
EXTCOL = $D020          ;border colour
BGCOL0 = $D021          ;background colour 0
BGCOL1 = $D022          ;background colour 1
BGCOL2 = $D023          ;background colour 2
BGCOL3 = $D024          ;background colour 3

; character set
VSCMB = $D018           ;VIC chip memory control register
SCROLLX = $D016         ;fine scrolling and control register

; raster
RASTER = $D012          ;read current raster line

; program start
PrgStart = $0810

; sprite memory location
SpritesMemory = $2000

; Character set memory location
CharacterSetMemory = $3800      ;set custom character address to $3800

; Map memory locations
MapMemory = $4000               ;map memory address
MapMemoryBlock1 = $4000         ;map memory address
MapMemoryBlock2 = $40FF         ;map memory address + 255
MapMemoryBlock3 = $41FE         ;map memory address + 2 * 255
MapMemoryBlock4 = $42FD         ;map memory address + 3 * 255

;Game over memory location
MapGameOverMemory = $5000       ;location of game over map
MapGameOverMemory1 = $5000      ;location of game over map 
MapGameOverMemory2 = $50FF      ;location of game over map 
MapGameOverMemory3 = $51FE      ;location of game over map 
MapGameOverMemory4 = $52FD      ;location of game over map 

;Start menu memory location
MapStartMenuMemory = $6000      ;location of start menu map 
MapStartMenuMemory1 = $6000     ;location of start menu map 
MapStartMenuMemory2 = $60FF     ;location of start menu map 
MapStartMenuMemory3 = $61FE     ;location of start menu map 
MapStartMenuMemory4 = $62FD     ;location of start meny map 


;Screen memory locations
ScreenBlock1 = $0400            ;screen memory address
ScreenBlock2 = $04FF            ;screen memory address ScreenBlock2 = $04FF            ;screen memory address + 255
ScreenBlock3 = $05FE            ;screen memory address + 2 * 255
ScreenBlock4 = $06FD            ;screen memory address + 3 * 255

;This is to display the score
Screen_Score = $07C7            ;location of score on screen
Lives_Score = $07D5             ;location of lives on screen

;Sound memory
FRELO1 = $D400                  ;frequency control lo byte for voice 1
FREHI1 = $D401                  ;frequency control hi byte for voice 1
PWLO1 = $D402                   ;pulse waveform width lo byte for voice 1
PWHI1 = $D403                   ;pulse waveform width hi byte for voice 1
VCREG1 = $D404                  ;control register for voice 1
ATDCY1 = $D405                  ;attack/decay register for voice 1
SURELI = $D406                  ;Sustain/release register for voice 1
SIGVOL = $D418                  ;volume and filter select register
