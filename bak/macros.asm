
;****************************
;* Macros
;****************************

;****************************
;* Enable sprites
;****************************
defm EnableSprites
        lda /1          ;number for the sprite to enable
        sta SPENA       ;enable that sprite
endm

;****************************
;* Point to sprite data
;****************************
defm PointToSpriteData
        lda /1          ;load position for the sprite
        sta /2          ;store in sprite shape data pointer
endm

;****************************
;* Wait for raster
;****************************
defm WaitForRaster
RasterLoop
        lda /1          ;load raster line value
        cmp Raster      ;compare with raster memory address
        bne RasterLoop  ;Branch if not equal to RasterLoop
endm

;****************************
;* Place char on screen
;****************************
defm PlaceCharOnScreen
        ldy /1
        ldx /2

        lda ScreenReaderTableLo,x
        sta $91
        lda ScreenReaderTableHi,x
        sta $92
        lda /3
        sta ($91),y
endm
