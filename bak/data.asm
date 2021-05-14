;****************************
;* Sprite data
;****************************
PlayerXPosition byte $22                ;player x position
PlayerYPosition byte $3A                ;player y position
PlayerSprIndex byte $80                 ;current player sprite in memory
PlayerXPosStart byte $22
PlayerYPosStart byte $3A
PlayerVisible byte $01                  ;player visible
PlayerWaitCount byte $AF                ;player wait counter

;****************************
;* Enemy
;****************************
Enemy1XPosition byte $65                ;enemy 1 x position
Enemy1YPosition byte $3A                ;enemy 1 y position
Enemy1XMinPos byte $43                  ;enemy 1 min. x position
Enemy1XMaxPos byte $FD                  ;enemy 1 max. x position
Enemy1SprIndex byte $89                 ;current enemy1 sprite in memory
Enemy1Direction byte $00                ;Direction: 00 = left, 01 = right

PlayerIdle byte $80                     ;player idle
PlayerRight byte $81                    ;player right
PlayerLeft byte $83                     ;player left
PlayerUp byte $85                       ;player up
PlayerDown byte $87                     ;player down

PortalXPosition byte $9A
PortalYPosition byte $92

;****************************
;* Zero page
;****************************
PlayerRightAnim1 = #$81                 ;player right anim 1
PlayerRightAnim2 = #$82                 ;player right anim 2
PlayerLeftAnim1 = #$83                  ;player left anim 1
PlayerLeftAnim2 = #$84                  ;player left anim 2
PlayerUpAnim1 = #$85                    ;player up anim 1
PlayerUpAnim2 = #$86                    ;player up anim 2
PlayerDownAnim1 = #$87                  ;player down anim 1
PlayerDownAnim2 = #$88                  ;player down anim 2

Enemy1 = #$89                           ;enemy sprite index

Explosion1 = $8A
Explosion2 = $8B
Explosion3 = $8C
Explosion4 = $8D
Explosion5 = $8E
Explosion6 = $8F
ExplosionPlaying byte $00
ExplosionIndex byte $8A

Portal = $90
PortalIndex byte $90
PortalActive byte $01

GameOver byte $00

;****************************
;* Collision
;****************************
;** This is for sprite to background collision
SprBgCollisionLo = $73                  ;Lo byte for sprite to background collision
SprBgCollisionHi = $74                  ;Hi byte for sprite to background collision
SprBgColOffsetX1 byte $00               ;sprite x offset upper left
SprBgColOffsetY1 byte $00               ;sprite y offset upper left
SprBgColOffsetX2 byte $07               ;sprite x offset upper right
SprBgColOffsetY2 byte $00               ;sprite y offset upper right
SprBgColOffsetX3 byte $00               ;sprite x offset lower left
SprBgColOffsetY3 byte $08               ;sprite y offset lower left
SprBgColOffsetX4 byte $07               ;sprite x offset lower right
SprBgColOffsetY4 byte $08               ;sprite y offset lower right
SprBgColChar = $75                      ;character under sprite
SavedXCol = $76                         ;saved x
SavedYCol = $77                         ;saved y
PlayerXPosCal byte $00                  ;player calculated x position 2 bytes
PlayerYPosCal byte $00                  ;player calculated y position

PlayerShoot = #1                        ;player shoot
PlayerMovedUp = #2                      ;player moved up
PlayerMovedRight = #4                   ;player moved right
PlayerMovedDown = #8                    ;player moved down
PlayerMovedLeft = #16                   ;player moved left
PlayerFire = #32

Score byte $0,$0,$0
Lives byte $35

;****************************
;* This is for sprite to character collision
;****************************
ScreenReaderTableLo byte $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B9,$E0,$08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0
ScreenReaderTableHi byte $04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07

;This is for sounds
soundExplosion byte $00,$80,$01,$44,$02,$A8,$03,$15,$04,$1F,$00,$81,$07,$14,$00,$80,$08

soundExplosionHigh byte >soundExplosion 
spimdExplosionLow byte <soundExplosion 
soundVoiceActive byte $0,$0,$0
soundVoiceCmdPtrLow byte $0,$0,$0
soundVoiceCmdIndex byte $0,$0,$0

;****************************
;* Colours
;****************************
BlackCol = #0                           ;Colour black
WhiteCol = #1                           ;Colour white
RedCol = #2                             ;Colour red
CyanCol = #3                            ;Colour cyan
PurpleCol = #4                          ;Colour purple
GreenCol = #5                           ;Colour green
BlueCol = #6                            ;Colour blue
YellowCol = #7                          ;Colour yellow
OrangeCol = #8                          ;Colour orange
BrownCol = #9                           ;Colour brown
LightRedCol = #10                       ;Colour RedCol
DarkGreyCol = #11                       ;Colour dark grey
GreyCol = #12                           ;Colour GreyCol
LightGreenCol = #13                     ;Colour light green
LightBlueCol = #14                      ;Colour light blue 
LightGreyCol = #15                      ;Colour light grey 

;****************************
;* zero page variables
;****************************
JoystickInput = $02                     ; 0=nothing, 1=fire, 2=up, 4=right,8=down,16=left
