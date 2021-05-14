
;****************************
;* Basic start
;****************************
; 10 sys (2064)

*=$0801
        BYTE $0E, $08, $0A, $00
        BYTE $9E, $20, $28, $32
        BYTE $30, $36, $34, $29
        BYTE $00, $00, $00

;****************************
;* Include memory addresses
;****************************
incasm "memory.asm"                     ;Memory addresses


;****************************
;* Include bin files
;****************************
*=SpritesMemory                         ;Point to player sprite in memory
incbin "sprites2.bin"                   ;Load sprites from bin file


*=CharacterSetMemory
incbin "cslevel1.bin"                   ;loads custom character set from bin file

*=MapMemory
incbin "mlevel1.bin"

*=MapGameOverMemory
incbin "gameover.bin"

*=MapStartMenuMemory
incbin "startmenu.bin"

;****************************
;* Include other asm files
;****************************
incasm "macros.asm"  
incasm "data.asm"           

;****************************
;* Program start
;****************************
*=PrgStart
        ldx BlackCol                    ;load 0
        stx BGCOL0
        ldx BlackCol
        stx EXTCOL
        
        jsr InitCharacterSet            ;initialize character set

NewGame
        jsr DisplayStartMenu
        jsr InitSprites                 ;initialize sprites
        jsr ClearScreen                 ;Clears the screen
        jsr DrawMap
GameLoop
        WaitForRaster #255              ;Wait for Raster line 255

        ldx PlayerVisible               ;load player visible byte 
        cpx #$01                        ;check if player is visible
        bne @PlayerNotVisible           ;branch if not visible

        jsr ReadJoystick                ;read joystick
        jsr MovePlayer                  ;move player
        jsr PositionPlayer              ;position player
        jsr SetCurrentPlayerSprite      ;set current player sprite
        jsr SetPlayerAnimation          ;set player animation
        jsr CheckForPlayerCollision

@PlayerNotVisible
        jsr MoveEnemy1
        jsr PositionEnemy1              ;position enemy 1
        jsr SetCurrentEnemy1Sprite

        ;Check if we must play explosion animation
        ldx ExplosionPlaying
        cpx #$01
        bne @noExplosion
        jsr PlayExplosionAnimation
        jsr WaitForExplosion

@noExplosion
        ldx PlayerVisible               ;load the visible byte 
        cpx #$00                        ;check if player is visible
        bne @NoCounting
        jsr incPlayerVisibleCounter     ;increment player visible counter
@NoCounting

        jsr DisplayScore
        jsr DisplayLives
        jsr CheckGateActive
        jsr CheckLives

        lda GameOver
        cmp #1
        beq @gameOver

        jmp GameLoop
@gameOver
        jsr DisplayGameOver
        jmp NewGame
        rts

;****************************
;* Include subrutines
;****************************
incasm "subrutines.asm"
