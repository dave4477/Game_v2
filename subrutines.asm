
;****************************
;* Subrutines
;****************************


#region Read Joystick
;****************************
;* Read Joystick
;****************************
ReadJoystick
        ldy #0                  ;load 0 in y register
        sty JoystickInput       ;store in joystick input zero page
        lda CIAPRA              ;read port 2
        and #JSMR               ;right
        beq go_right            ;branch if equal to 0
        lda CIAPRA              ;read port 2
        and #JSML               ;left
        beq go_left             ;branch if equal to 0
        lda CIAPRA              ;read port 2
        and #JSMU               ;up
        beq go_up               ;branch if equal to 0
        lda CIAPRA              ;read port 2
        and #JSMD               ;down
        beq go_down             ;branch if equal to 0
        lda CIAPRA              ;read port 2
        and #JSMB               ;button
        beq go_button           ;branch if equal to 0
        rts

go_right
        ldy PlayerMovedRight    ;load 4 in register y for right
        sty JoystickInput       ;store in joystick input zeropage
        rts
go_left
        ldy PlayerMovedLeft     ;load 16 in register y for left
        sty JoystickInput       ;store in joystick input zeropage
        rts
go_up
        ldy PlayerMovedUp       ;load 2 in register y for up
        sty JoystickInput       ;store in joystick input zeropage
        rts
go_down
        ldy PlayerMovedDown     ;load 8 in register y for down
        sty JoystickInput       ;store in joystick input zeropage
        rts
go_button
        ldy PlayerFire          ;load 1 in register y for button
        sty JoystickInput       ;store in joystick input zeropage
        rts
#endregion

#region initialize sprites
;****************************
;* Initialize sprites
;****************************
InitSprites
        EnableSprites #%00001111                        ;Enable sprite 0,1,2,3 (player, enemy explosion, portal)
        PointToSpriteData PlayerSprIndex,SSDP0          ;Point to sprite data for sprite 0 (player)

        ;set sprite colours
        lda LightBlueCol
        sta SP0COL                                      ;set sprite - colour to light blue
        lda RedCol                                      ;load red colour
        sta SP1COL                                      ;set sprite1 colour to red
        lda WhiteCol
        sta SP2COl
        lda GreenCol                                    ;load green colour
        sta SP3COL                                      ;sprite 3 colour to green

        ;set enemy 1 start Position 
        lda Enemy1XMaxPos                               ;get enemy 1 max x position 
        sta Enemy1XPosition                             ;set enemy 1 x position to max Position 
        jsr PositionEnemy1                              ;position enemy1 on screen
        
        ;set player position at the start position
        lda PlayerXPosStart                             ;load player start x position 
        sta PlayerXPosition                             ;store player start x position in player x position
        lda PlayerYPosStart                             ;load player y position
        sta PlayerYPosition                             ;store player start y position in player y position 

        jsr PositionPlayer                              ;Position sprite 0 (player) on screen

        ;Set explosion position to 0,0
        lda #0
        sta SP2X
        sta SP2Y
        jsr SetCurrentExplosionSprite

        ;set portal Position 
        lda PortalXPosition
        sta SP3X
        lda PortalYPosition
        sta SP3Y
        jsr SetCurrentPortalSprite

        ;reset score and lives
        lda #0
        sta Score
        sta Score+1
        sta Score+2
        lda #$35
        sta Lives

        rts
#endregion

#region Positon player sprite
;****************************
;* Position player sprite
;****************************
PositionPlayer
        ;Position player
        lda PlayerXPosition             ;load player x position 
        sta SP0X                        ;store in sprite 0 x position memory address
        lda PlayerYPosition             ;load player y position
        sta SP0Y                        ;store in sprite 0 y position memory address
        rts
#endregion

#region Position enemy1 sprite
;****************************
;* Position Enemy 1 sprite
;****************************
PositionEnemy1
        ;position enemy 1
        lda Enemy1XPosition     ;get enemy 1 max x position 
        sta SP1X                ;store in memory address
        lda Enemy1YPosition     ;load enemy y position 
        sta SP1Y                ;store in memory address
        rts
#endregion

#region Move player sprite
;****************************
;* Move Player Sprite
;****************************
MovePlayer
        lda JoystickInput               ;read joystick input
        cmp PlayerMovedUp               ;compare for joystick up
        bne @joyRight                   ;branch if not equal to joyRight
        ldy PlayerYPosition             ;load player y position 
        dey                             ;decrease player y position 
        sty PlayerYPosition             ;store y in player y position 
        ldx PlayerUp                    ;load player up
        stx PlayerSprIndex              ;store in player sprite index
        lda #0                          ;load value 0
        sta JoystickInput               ;store in joystick input variable
        rts
@joyRight
        lda JoystickInput               ;read joystick input
        cmp PlayerMovedRight            ;compare for joystick right
        bne @joyDown                    ;branch if not equal to joyDown
        ldx PlayerXPosition             ;load player x Position 
        inx                             ;increase player x position 
        stx PlayerXPosition             ;store x in player x Position 
        ldx PlayerRight                 ;load player right
        stx PlayerSprIndex              ;store in player sprite index 
        ;Check for extended
        ldx PlayerXPosition             ;load player x postion 
        cpx #$00                        ;compare with value 0
        bne @contRight                  ;brnach if not equal
        ;set extended sprite
        lda MSIGX                       ;load from extended sprite register        
        ora #%00000001                  ;Or value in bit 0
        sta MSIGX                       ;store in sprite extended memory address
        lda #$00        
        sta PlayerXPosition 
@contRight
        lda #0
        sta JoystickInput
        rts
@joyDown
        lda JoystickInput               ;read joystick input
        cmp PlayerMovedDown             ;compare for joystick down
        bne @joyLeft                    ;branch if not equal to joyLeft
        ldy PlayerYPosition            ;load player y position 
        iny                             ;increase player y position 
        sty PlayerYPosition             ;store y in player y postion 
        ldx PlayerDown                  ;load player down
        stx PlayerSprIndex              ;store in player sprite index
        lda #0
        sta JoystickInput
        rts
@joyLeft
        lda JoystickInput               ;read Joystick input
        cmp PlayerMovedLeft             ;compare for joystick left
        bne @joyButton                  ;branch if not equal to joyButton
        ldx PlayerXPosition             ;load player x position 
        dex                             ;decrease player x position 
        stx PlayerXPosition             ;store x in player x position 
        ldx PlayerLeft                  ;load player left
        stx PlayerSprIndex              ;store in player sprite index
        ;check for leave extended
        ldx PlayerXPosition             ;load player x position 
        cpx #$FF                        ;compare with value $FF
        bne @contLeft                   ;branch if not equal
        ;Clear extended sprite
        lda MSIGX
        and #%11111110
        sta MSIGX                       ;store in sprite extended memory address
        lda #$FF
        sta PlayerXPosition
@contLeft
        lda #0
        sta JoystickInput
        rts
@joyButton
        lda JoystickInput               ;read joystick input
        cmp PlayerShoot                 ;compare for joystick button
        bne @joyNothing                 ;branch if not equal to joyButton
        lda #0
        sta JoystickInput
        rts
@joyNothing
        ldx PlayerIdle                  ;Load player idle
        stx PlayerSprIndex              ;store in sprite index
        lda #0
        sta JoystickInput
        rts
#endregion

#region Move enemy 1 sprite
;****************************
;* Move Enemy 1 sprite
;****************************
MoveEnemy1
        ldx Enemy1Direction     ;load enemy direction
        cpx #0                  ;Is the enemy going left
        bne @goingRight         ;branch if not equal
        ldx Enemy1XPosition     ;load enemy 1 x position in x register
        dex                     ;decrement value in x register
        stx Enemy1XPosition     ;store x register value in enemy 1 x position 
        cpx Enemy1XMinPos       ;compare if x register is equal to enemy 1 min. position 
        bne @continue           ;branch if not equal
        ldx #@01                ;load 1
        stx Enemy1Direction     ;store in enemy direction
@goingRight
        ldx Enemy1XPosition     ;load enemy 1 x position in x register
        inx                     ;increment value in x register
        stx Enemy1XPosition     ;store x register value in enemy 1 x Position 
        cpx Enemy1XMaxPos       ;compare if x register value in enemy 1 x position is equal to Max x position 
        bne @continue           ;branch if not equal
        ldx #@00
        stx Enemy1Direction
@continue 
        rts
#endregion

#region set current player sprite
;****************************
;* Set current  Player Sprite
;****************************
SetCurrentPlayerSprite
        PointToSpriteData PlayerSprIndex, SSDP0 ;set current sprite
        rts
#endregion

#region Set current enemy 1 sprite
;****************************
;* Position Enemy 1 sprite
;****************************
SetCurrentEnemy1Sprite
        PointToSpriteData Enemy1SprIndex, SSDP1 ;set current enemy 1 sprite
        rts
#endregion

#region Set player sprite animation
;****************************
;* Set Player Sprite animation
;****************************
SetPlayerAnimation
        lda JoystickInput               ;load joystick input
        cmp PlayerMovedUp               ;check for up
        bne @joyRight                   ;branch if not equal to joyRight

        ;check if animation up 1 is active
        ldx PlayerUp                    ;load player up animation
        cpx PlayerUpAnim2               ;compare if its player up anim 2
        bne @contUp                     ;branch if not equal to contUp
        ldx PlayerUpAnim1               ;load player up anim 1
        stx PlayerUp                    ;store x in player up
        lda #0
        sta JoystickInput
        rts
@contUp
        inx                             ;increment x
        stx PlayerUp                    ;store x in player up
        lda#0
        sta JoystickInput
        rts
@joyRight
        lda JoystickInput               ;read joystick input
        cmp PlayerMovedRight            ;compare for joystick right
        bne @joyDown                    ;branch if not equal to joyDown

        ;check if animation right 1 is active
        ldx PlayerRight                 ;load player right animation
        cpx PlayerRightAnim2            ;compare with player right anim 2
        bne @contRight                  ;branch if not equal
        ldx PlayerRightAnim1            ;Load player right anim 1
        stx PlayerRIght                 ;store in player right
        lda #0
        sta JoystickInput
        rts
@contRight
        inx                             ;increment x
        stx PlayerRight                 ;store in player right
        rts
@joyDown
        lda JoystickInput               ;read joystick input
        cmp PlayerMovedDown             ;compare for joystick down
        bne @joyLeft                    ;branch if not equal to joyLeft

        ;check if animation down1 is active
        ; BROKEN?
        ldx PlayerDown                  ;load player down animation
        cpx PlayerDOwnAnim2             ;compare to player down anim 2
        bne @contDown                   ;branch if not equal
        ldx PlayerDownAnim1             ;load player down anim 1
        stx PlayerDOwn                  ;store in player down
        lda #0
        sta JoystickInput
        rts
@contDown
        inx                             ;increment x
        stx PlayerDown                  ;store in player down
        lda #0
        sta JoystickInput
        rts
@joyLeft
        lda JoystickInput               ;read joystick input
        cmp PlayerMovedLeft             ;compare for joystick left
        bne @joyNothing                 ;branch if not equal to joyNothing

        ;check if animation left is active
        ldx PlayerLeft                  ;load player left animation
        cpx PlayerLeftAnim2             ;compare to player left anim2
        bne @contLeft                   ;branch if not equal
        ldx PlayerLeftAnim1             ;load player left anim1
        stx PlayerLeft                  ;store in player left
        lda #0
        sta JoystickInput
        rts
@contLeft
        inx                             ;increment x
        stx PlayerLeft                  ;store in player left
        lda #0
        sta JoystickInput
        rts
@joyNothing
        lda #0
        sta JoystickInput
        rts
#endregion

#region check for player collision
;****************************
;* check for collision
;****************************
CheckForPlayerCollision
        ; first check for sprite to sprite collision
        lda SPSPCL              ;load sprite to sprite collision register
        cmp #%00000011          ;check if player (spr0, bit 0) collides with enemy (spr1, bit 1)
        bne @noSprCollision     ;branch if not equal

        ldx #$00                ;load 0
        stx PlayerVisible

        jsr DisablePlayer       ;call disable player
        jmp @noSprCollision2
@noSprCollision        
        cmp #%00001001
        bne @noSprCollision2
        lda #1
        sta GameOver
        rts
@noSprCollision2
        lda SPBGCL              ;load player to background collision register
        cmp #%00000001          ;check if player collided with the background
        bne @noBgCollision      ;branch if not equal

        ;Call the methods that find the character under the sprite
        jsr CCCUL
        lda SprBgColChar
        cmp #$3C
        beq @pickedUp

        jsr CCCUR
        lda SprBgColChar
        cmp #$3C
        beq @pickedUp

        jsr CCCLL
        lda SprBgColChar
        cmp #$3C
        beq @pickedUp

        jsr CCCLR
        lda SprBgColChar
        cmp #$3C
        beq @pickedUp

        ldx #$00                ;load 0
        stx PlayerVisible

        jsr DisablePlayer       ;disable player


@noBgCollision
        rts
@pickedUp
        ;play pick up sound
        jsr PlayPickupSound

        ;remove found character
        ldy SavedYCol
        ldx SavedXCol

        lda ScreenReaderTableLo,x
        sta SprBgCollisionLo
        lda ScreenReaderTableHi,x
        sta SprBgCollisionHi
        lda #$20
        sta (SprBgCollisionLo),y

        jsr IncrementScore
        rts
#endregion

#region set player to start position
;****************************
;* spawn player start position
;****************************
SpawnPlayerAtStartPosition
        ;set player position at the start position 
        lda PlayerXPosStart     ;load player start x position 
        sta PlayerXPosition     ;store player start x position in player x position
        lda PlayerYPosStart     ;load player start y position 
        sta PlayerYposition     ;store player start y position in player y position 
        lda #%00000000          ;reset sprite extended x position 
        sta MSIGX               ;store in memory address 
        jsr PositionPlayer
        rts
#endregion

#region Disable player
;****************************
;* Disable player
;****************************
DisablePlayer
        ;set explosion where player is located
        jsr PlayExplosionSound

        ldx PlayerXPosition
        stx SP2X
        ldy PlayerYPosition
        sty SP2Y
        lda #$01
        sta ExplosionPlaying

        EnableSprites #%00001110        ;disable player sprite
        jsr DecrementLives
        rts
#endregion

#region increment player visible counter
;****************************
;* increment player visible counter
;****************************
IncPlayerVisibleCounter
        ldx PlayerWaitCount     ;load player wait count
        dex                     ;decrement x
        stx PlayerWaitCount     ;store in payer wait count
        cpx #$00                ;compare to 00
        bne @PlayerCountNotFinished     ;branch if not equal
        ;player count is finished
        ldx #$01                ;load 1
        stx PlayerVisible       ;store in player visible
        ldx #$AF                ;load $AF
        stx PlayerWaitCount     ;store in player wait count

        EnableSprites #%00001111;enable player sprite
        jsr SpawnPlayerAtStartPosition ;spawn player at start position 
@PlayerCountNotFinished
        rts
#endregion

#region Clear screen
;****************************
;* Clear screen
;****************************
ClearScreen
        lda #147                        ;load 147
        jsr $FFD2                       ;call kernel address
        rts
#endregion

#region initialize character set
;****************************
;* Initialize character set
;****************************
; This code initialize our custom character set.
; The #$0E value points to address $3800
InitCharacterSet
        lda VSCMB               ;load from VIC address
        ora #$0E                ;set char's location to $3800 for displaying the custom font
        sta VSCMB               ;store in VIC address
        lda #$18                ;load multicolour register
        sta SCROLLX             ;store in multicolour register
        ;Set colours for multicolour
        lda OrangeCol           ;load orange colour
        sta BGCOL1              ;Store in background colour 1
        lda BrownCol            ;load brown colour
        sta BGCOL2              ;store in background colour 2
        lda DarkGreyCol         ;load dark grey colour
        sta BGCOL3              ;store in background colour
        rts
#endregion

#region Draw map to screen
;****************************
;* Draw map to screen
;****************************
DrawMap
        ;load first map block
        ldx #0                  ;load 0
@mapLoop1
        lda MapMemoryBlock1,x   ;load map memory + x
        tay                     ;move a to y
        sta ScreenBlock1,x      ;store in screen memory + x
        inx                     ;increment x
        cpx #255                ;compare to 255
        bne @mapLoop1           ;branch if not equal
        ;load second map block
        ldx #0                  ;load 0
@mapLoop2
        lda MapMemoryBlock2,x   ;load map memory 2 + x
        tay                     ;move a to y
        sta ScreenBlock2,x      ;store in screen memory 2 + x
        inx                     ;increment x
        cpx #255                ;compare to 255
        bne @mapLoop2           ;branch if not equal
        ;load third map block
        ldx #0                  ;load 0
@mapLoop3
        lda MapMemoryBlock3,x   ;load map memory 3 + x
        tay                     ;move a to y
        sta ScreenBlock3,x      ;store in screen memory 3 + x
        inx                     ;increment x
        cpx #255                ;compare to 255
        bne @mapLoop3           ;branch if not equal
        ;load fourth map block
        ldx #0                  ;load 0
@mapLoop4
        lda MapMemoryBlock4,x   ;load map memory 4 + x
        tay                     ;move a to y
        sta ScreenBlock4,x      ;store in screen memory 4 + x
        inx                     ;increment x
        cpx #232                ;compare to 255
        bne @mapLoop4           ;branch if not equal
        
        rts
#endregion

#region Calculate player position upper left
CalculatePlayerPositionUL
        ;y Position
        clc
        lda PlayerYPosition
        adc SprBgColOffsetY1
        sbc #50
        sta PlayerYPosCal

        ;Divide playerYposCal by 8 
        lda PlayerYPosCal
        lsr
        lsr
        lsr
        sta PlayerYPosCal

        ;Check for extended sprite
        lda MSIGX
        cmp #%00000001
        beq @spriteIsExtended

        ;x position
        clc
        lda PlayerXPosition
        adc SprBgColOffsetX1
        sbc #24
        sta PlayerXPosCal

        ;Divide playerXPosCal by 8
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXposCal

        rts
@spriteIsExtended
        ;X Position 
        clc
        lda PlayerXPosition
        sta PlayerXPosCal
        
        ;Divide playerXPosCal by 8
        ldy #0
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXPosCal
        lda PlayerXPosCal
        adc #29
        sta PlayerXPosCal

        rts
#endregion
        
#region Calculate player position upper right
CalculatePlayerPositionUR
        ;Y position 
        clc
        lda PlayerYPosition
        adc SprBgColOffsetY2
        sbc #50
        sta PlayerYPosCal

        ;Divide PlayerYPosCal by 8
        lda PlayerYPosCal
        lsr
        lsr
        lsr
        sta PlayerYPosCal

        ;Check for extended sprite
        lda MSIGX
        cmp #%00000001
        beq @spriteIsExtended

        ;X position 
        clc
        lda PlayerXPosition
        adc SprBgColOffsetX2
        sbc #24
        sta PlayerXPosCal

        ;Divide playerXPosCal by 8
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXPosCal

        rts
@spriteIsExtended
        ;X Position 
        clc
        lda PlayerXPosition
        adc SprBgColOffsetX2
        sta PlayerXPosCal

        ;Divide PlayerXPosCal by 8
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXPosCal 
        lda PlayerXPosCal
        adc #29
        sta PlayerXPosCal

        rts
#endregion

#region Calculate player position lower left
CalculatePlayerPositionLL
        ;Y Position
        clc
        lda PlayerYPosition
        adc SprBgColOffsetY3
        sbc #50
        sta PlayerYPosCal

        ;Divide playerYPosCal by 8
        lda PlayerYPosCal
        lsr
        lsr
        lsr
        sta PlayerYPosCal

        ;Check for extended sprite
        lda MSIGX
        cmp #%00000001
        beq @spriteIsExtended

        ;X Position
        clc
        lda PlayerXPosition
        adc SprBgColOffsetX3
        sbc #24
        sta PlayerXPosCal

        ;Divide PlayerXPosCal by 8
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXPosCal

        rts
@spriteIsExtended
        ;X Position
        clc
        lda PlayerXPosition
        adc SprBgColOffsetX3
        sta PlayerXPosCal
        
        ;Divide PlayerXPosCal by 8
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXPosCal
        lda PlayerXPosCal
        adc #29
        sta PlayerXPosCal
        rts
#endregion

#region Calculate player position lower right
CalculatePlayerPositionLR
        ;y position
        clc
        lda PlayerYPosition
        adc SprBgColOffsetY4
        sbc #50
        sta PlayerYposCal

        ;Divide playerYPosCal by 8
        lda PlayerYPosCal
        lsr
        lsr
        lsr
        sta PlayerYPosCal

        ;check for extended sprite
        lda MSIGX
        cmp #%00000001
        beq @spriteIsExtended
        
        ;x position 
        clc
        lda PlayerXPosition
        adc SprBgColOffsetX4
        sbc #24
        sta PlayerXPosCal

        ;Divide PlayerXPosCal by 8
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXPosCal
        
        rts
@spriteIsExtended
        ;x position 
        clc
        lda PlayerXPosition
        adc SprBgColOffsetX4
        sta PlayerXPosCal

        ;divide playerXposCal by 8
        lda PlayerXPosCal
        lsr
        lsr
        lsr
        sta PlayerXPosCal
        lda PlayerXPosCal 
        adc #29
        sta PlayerXPosCal
        rts
#endregion

#region Check char collision upper left
CCCUL
        ;Calculate player position upper left
        jsr CalculatePlayerPositionUL
        ldy PlayerXPosCal
        ldx PlayerYPosCal

        sty SavedYCol
        stx SavedXCol

        lda ScreenReaderTableLo,x
        sta SprBgCollisionLo
        lda ScreenReaderTableHi,x
        sta SprBgCollisionHi
        lda (SprBgCollisionLo),y
        sta PlayerYPosCal
        sta SprBgColChar

        rts
#endregion

#region Check char collision upper right
CCCUR
        jsr CalculatePlayerPositionUR
        ldy PlayerXPosCal
        ldx PlayerYPosCal

        sty SavedYCol
        stx SavedXCol

        lda ScreenReaderTableLo,x
        sta SprBgCollisionLo
        lda ScreenReaderTableHi,x
        sta SprBgCollisionHi
        lda (SprBgCollisionLo),y
        sta PlayerYPosCal
        sta SprBgColChar

        rts
#endregion

#region Check char collision lower left
CCCLL
        jsr CalculatePlayerPositionLL
        ldy PlayerXPosCal
        ldx PlayerYPosCal

        sty SavedYCol
        stx SavedXCol

        lda ScreenReaderTableLo,x
        sta SprBgCollisionLo
        lda ScreenReaderTableHi,x
        sta SprBgCollisionHi
        lda (SprBgCollisionLo),y
        sta PlayerYPosCal
        sta SprBgColChar

        rts
#endregion

#region Check char collision lower right
CCCLR
        jsr CalculatePlayerPositionLR
        ldy PlayerXPosCal
        ldx PlayerYPosCal

        sty SavedYCol
        stx SavedXCol

        lda ScreenReaderTableLo,x
        sta SprBgCollisionLo
        lda ScreenReaderTableHi,x
        sta SprBgCollisionHi
        lda (SprBgCollisionLo),y
        sta PlayerYPosCal
        sta SprBgColChar

        rts
#endregion

#region Display score
;****************************
;* Display score
;****************************
DisplayScore
        ldy #5
        ldx #0
sloop
        lda Score,x
        pha
        and #$0F
        jsr PlotDigit
        pla
        lsr a
        lsr a
        lsr a
        lsr a
        jsr PlotDigit
        inx
        cpx #3
        bne Sloop
        rts
#endregion

#region Plot digit
;****************************
;* Plot digit
;****************************
PlotDigit
        clc
        adc #48
        sta Screen_Score,y
        dey
        rts
#endregion

#region increment score
;****************************
;* Increment score
;****************************
IncrementScore
        sed
        clc
        lda Score
        adc #1
        sta Score
        lda Score+1
        adc #0
        sta Score+1
        lda Score+2
        adc #0
        sta Score+2
        cld
        rts
#endregion

#region Display lives
;****************************
;* Display lives
;****************************
DisplayLives
        lda Lives
        sta Lives_score
        rts
#endregion

#region Decrement lives
;****************************
;* Decrement lives
;****************************
DecrementLives
        ldx Lives
        dex
        stx Lives
        rts
#endregion

#region Play explosion animation
;************************************
; Play explosion animation
;************************************
PlayExplosionAnimation
        ldx ExplosionIndex
        inx
        stx ExplosionIndex
        cpx #$8F
        bne @continueExplosion

        ldx #0
        stx ExplosionPlaying
        stx SP2X
        stx SP2Y
        ldx #$8A
        stx ExplosionIndex
@continueExplosion
        jsr SetCurrentExplosionSprite
        rts
#endregion

#region Set Current exposion sprite
;************************************
; Set current explosion sprite
;************************************
SetCurrentExplosionSprite
        PointToSpriteData ExplosionIndex,SSDP2          ;Set current explosion sprite
        rts
#endregion

#region Set current portal sprite
;************************************
; Set current portal sprite
;************************************
SetCurrentPortalSprite
        PointToSpriteData PortalIndex,SSDP3
        rts
#endregion

#region Wait for explosion
;************************************
; Wait for explosion
;************************************
WaitForExplosion
        ldx #25
@waitExplosion1
        ldy #255
@waitExplosion2
        dey
        cpy #0
        bne @waitExplosion2
        dex
        cpx #0
        bne @waitExplosion1

        rts
#endregion

#region Play explosion sound
;************************************
; Play explosion sound
;************************************
PlayExplosionSound

        lda #15
        sta SIGVOL
        lda #0
        sta FRELO1
        lda #30
        sta FREHI1
        lda #12
        sta ATDCY1
        lda #5
        sta SURELI
        lda #0
        sta VCREG1
        lda #129
        sta VCREG1

        rts
#endregion

#region Play pick up sound
;************************************
; Play pick up sound
;************************************
PlayPickupSound
        lda #25
        sta SIGVOL
        lda #0
        sta FRELO1
        lda #40
        sta FREHI1
        lda #22
        sta ATDCY1
        lda #7
        sta SURELI
        lda #0
        sta VCREG1
        lda #129
        sta VCREG1

        rts
#endregion

#region Check if gate is active
;************************************
; Check if gate is active
;************************************
CheckGateActive
        ;Check score
        ldy PortalActive
        cpy #1
        bne @noRemovePortal
        ldx Score
        cpx #7
        bne @noRemovePortal
        jsr ReplacePortalCharacters
        lda #0
        sta PortalActive
@noRemovePortal
        rts
#endregion

#region Replace
;************************************
; Replace portal characters
;************************************
ReplacePortalCharacters
        PlaceCharOnScreen #19,#11,#$1C
        PlaceCharOnScreen #20,#12,#$20
        PlaceCharOnScreen #20,#13,#$22

        ;Clear zero pages
        lda #0
        sta $91
        sta $92

        rts
#endregion

#region Draw game over map to screen
;************************************
; Draw game over map to screen
;************************************
DrawGameOverMap
        ;load first map block
        ldx #0
@mapLoop1
        lda MapGameOverMemory1,x
        tay
        sta ScreenBlock1,x
        inx
        cpx #255
        bne @mapLoop1
        ;Load second map block
        ldx #0
@mapLoop2
        lda MapGameOverMemory2,x
        tay
        sta ScreenBlock2,x
        inx
        cpx #255
        bne @mapLoop2
        ;Load third map block
        ldx #0
@mapLoop3
        lda MapGameOverMemory3,x
        tay
        sta ScreenBlock3,x
        inx
        cpx #255
        bne @mapLoop3
        ;Load fourth map block
        ldx #0
@mapLoop4
        lda MapGameOverMemory4,x
        tay
        sta ScreenBlock4,x
        inx
        cpx #232
        bne @mapLoop4
        rts
#endregion

#region Display game over
;************************************
; Display Game over
;************************************
DisplayGameOver
        jsr ClearScreen
        jsr DisableAllSprites
        jsr DrawGameOverMap
@ReadJoystick
        jsr ReadJoystick
        lda JoystickInput
        cmp PlayerFire
        bne @readJoystick 
        
        lda #0
        sta GameOver
        lda #0
        sta JoystickInput

        rts
#endregion

#region Disable all sprites
;************************************
; Disable all sprites
;************************************
DisableAllSprites
        EnableSprites #%00000000
        rts
#endregion

#region Check lives
;************************************
; Check Lives
;************************************
CheckLives
        lda Lives
        cmp #$30
        bne @stillAlive
        lda #1
        sta GameOver
@stillAlive
        rts
#endregion

#region Draw start menu map to screen
;************************************
; Draw start menu map to screen
;************************************
DrawStartMenuMap
        ;load first map block
        ldx #0
@mapLoop1
        lda MapStartMenuMemory1,x
        tay
        sta ScreenBlock1,x
        inx
        cpx #255
        bne @mapLoop1
        ldx #0
@mapLoop2
        lda MapStartMenuMemory2,x
        tay
        sta ScreenBlock2,x
        inx
        cpx #255
        bne @mapLoop2
        ldx #0
@mapLoop3
        lda MapStartMenuMemory3,x
        tay
        sta ScreenBlock3,x
        inx
        cpx #255
        bne @mapLoop3
        ldx #0
@mapLoop4
        lda MapStartMenuMemory4,x
        tay
        sta ScreenBlock4,x
        inx
        cpx #232
        bne @mapLoop4
        rts
#endregion

#region Display start menu
;************************************
; Display start menu
;************************************
DisplayStartMenu
        ldx #255
@loop1
        ldy #255
@loop2
        dey
        bne @loop2
        dex
        bne @loop1

        jsr ClearScreen
        jsr DisableAllSprites
        jsr DrawStartMenuMap

@readJoystick 
        jsr ReadJoystick
        lda JoystickInput
        cmp PlayerFire
        bne @ReadJoystick
        lda #0
        sta GameOver 
        rts
#endregion

;EOF