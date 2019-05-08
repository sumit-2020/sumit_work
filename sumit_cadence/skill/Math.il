;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This file defines the common SKILL procedures(functions) for
;;   mathematical calculations. 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

procedure( ece432GetBboxCorners( bBox cornerName)
  prog( (xy x y uR lL)
  
   if(bBox==nil then
	printf("ERROR in ece432GetBboxCorners - bBox is nil\n")
   )
   uR = car(last(bBox))
   lL = car(bBox)

    xy = case(cornerName
      ("upperRight" uR) 
      ("lowerLeft"  lL)
      ("upperLeft"  xCoord(lL):yCoord(uR))
      ("lowerRight" xCoord(uR):yCoord(lL))
    )
    return(xy)              
  )
)

procedure( ece432AddCoords(xy1 xy2)
  prog((xy3 x y)

    x = xCoord(xy1) + xCoord(xy2)
    y = yCoord(xy1) + yCoord(xy2)
    xy3 = x:y

  return(xy3)
  )
)
