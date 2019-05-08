;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This file defines the common SKILL procedures(functions) for 
;;   creating schematics.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load("./skill/Math.il")

procedure( ece432DeleteObjectsSchematic(cvid)
  prog((propName inst)
    dbDeleteAllNet(cvid)
    foreach(inst cvid~>instances
      dbDeleteObject(inst)
    )
    foreach(inst cvid~>shapes
      dbDeleteObject(inst)
    )
  return(t)

  )
)

procedure( ece432SymbolCreatePin(cvid pinName pinType origin rotation)
  prog((pin net term xy0 xy1 labelPlace rect Label)
    
   /* First create a net, then a terminal, then the pin shape */
   xy0 = xCoord(origin)-.025:yCoord(origin)-.025
   xy1 = xCoord(origin)+.025:yCoord(origin)+.025
   if( pinType == "output" then
     labelPlace = xCoord(origin)-.1:yCoord(origin)
     labelOrient = "centerRight"
   else
     labelPlace = xCoord(origin)+.1:yCoord(origin)
     labelOrient = "centerLeft")
  
   Label = dbCreateLabel(cvid list(229 237) labelPlace pinName 
     labelOrient "R0" "stick" 6.250000e-02)
   rect = dbCreateRect(cvid list(229 252) list(xy0 xy1))
   net = dbCreateNet(cvid pinName nil)
   term = dbCreateTerm(net pinName pinType)
   pin = dbCreatePin(net rect nil)

   Label~>parent = rect

  return(pin)
  )
)

procedure( ece432SchematicCreatePin(cvid pinName pinType origin rotation)
  prog((pin net term inst mstr pinCV xy newxy x y stretchxy xyoffset)
    
   /* First create a net, then a terminal, then the pin shape */

   pinCV = case( pinType
      ("input" "ipin")
      ("output" "opin")
      ("inputOutput" "iopin"))
   mstr = dbOpenCellViewByType("basic" pinCV "symbol")
   inst = dbCreateInst(cvid mstr nil origin rotation 1)
   inst~>purpose = "pin"

   net = dbCreateNet(cvid pinName nil)
if(net==nil then net=dbMakeNet(cvid pinName))
     term = dbCreateTerm(net pinName pinType)
   pin = dbCreatePin(net inst)
   xy = ece432GetPinCenter(inst)
   xyoffset = case( pinType
      ("input" .125:0.0625)
      ("output" -.125:0.0625)
      ("inputOutput" -0.0625:-0.095))
   xy=ece432AddCoords(xy xyoffset)
   x = xCoord(xy)
   y = yCoord(xy)
   stretchxy = case(rotation
	 ("R0" (x-.2):y)
	 ("R180" (x+.2):y)
	 ("R90" x:(y+.2))
	 ("R270" x:(y-.2))
   )
   line = dbCreateLine(cvid list(228 252) list(xy stretchxy))~>net=net
   return(pin)
  )
)

procedure( ece432SchematicCreateInst(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation)
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)
inst2=inst
   /* Now add the connectivity */

    ece432AddLabelsToInstPins(cvid inst origin mstr leftPins "left")        
    ece432AddLabelsToInstPins(cvid inst origin mstr  rightPins "right")        
    ece432AddLabelsToInstPins(cvid inst origin mstr  topPins "top")        
    ece432AddLabelsToInstPins(cvid inst origin mstr   botPins "bottom")        


  return(inst)
  )
)

procedure( ece432AddLabelsToInstPins(cvid inst origin mstr pinList side)
  prog( (pinPair shape instPinName pinLabel x y newxy stretchxy rotation label line)

      rotation = case(side
        ("left" "R0")
        ("right" "R0")
        ("top" "R90")
        ("bottom" "R270")
      )

    foreach(pinPair pinList
      instPinName = car(pinPair)
      pinLabel = car(last(pinPair))

      net = dbMakeNet(cvid pinLabel nil)
      dbCreateConnByName(net inst instPinName)
      xy = ece432GetPinCenterByName(mstr instPinName)
      newxy = ece432AddCoords(xy origin)

      x = xCoord(newxy)
      y = yCoord(newxy)
      stretchxy = case(side
        ("left" (x-.2):y)
        ("right" (x+.2):y)
        ("top" x:(y+.2))
        ("bottom" x:(y-.2))
      )

      line = dbCreateLine(cvid list(228 252) list(newxy stretchxy))~>net=net

      label = dbCreateLabel(cvid list(228 237) stretchxy pinLabel "lowerCenter" rotation "stick" 6.250000e-02)
      label~>isDrafted = t
      label~>isOverbar = nil
      label~>isVisible = t
      label~>labelType = "normalLabel"
    )
        

  return(t)
  )
)

procedure( ece432GetPinCenterByName(inst instPinName)
  prog( (x y shape xy bBox x1 x2 y1 y2)
    foreach(shape inst~>shapes
      if( shape~>layerName=="pin" then
;;printf("%L \n" shape~>children~>theLabel)
        if( car(shape~>children~>theLabel)==instPinName then
          bBox = shape~>bBox
        )
        if( car(cdr(shape~>children~>theLabel))==instPinName then
          bBox = shape~>bBox
        )
      )
    )
  if(bBox==nil then
     printf("ERROR - pin %L not found in instance type %L\n" instPinName inst~>cellName)
     return(0)
  )
  x1 = xCoord(car(bBox))
  x2 = xCoord(car(last(bBox)))
  x  = (x1 + x2)/2
  
  y1 = yCoord(car(bBox))
  y2 = yCoord(car(last(bBox)))
  y  = (y1 + y2)/2
  xy = x:y

  return(xy)
  )
)

procedure( ece432GetPinCenter(inst)
  prog((bBox x1 x2 x y1 y2 xy)
 	bBox = inst~>bBox	
        x1 = xCoord(car(bBox))
        x2 = xCoord(car(last(bBox)))
        x  = (x1 + x2)/2
        
        y1 = yCoord(car(bBox))
        y2 = yCoord(car(last(bBox)))
        y  = (y1 + y2)/2
        xy = x:y
        return(xy)
  )
)
procedure( ece432SchematicCreateFETInstDefault(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation)
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)

   /* Now add the connectivity */

    ece432FETAddLabelsToInstPins(cvid inst origin mstr leftPins "left")        
    ece432FETAddLabelsToInstPins(cvid inst origin mstr  rightPins "right")        
    ece432FETAddLabelsToInstPins(cvid inst origin mstr  topPins "top")        
    ece432FETAddLabelsToInstPins(cvid inst origin mstr   botPins "bottom")        

  return(inst)
  )
)
procedure( ece432SchematicCreateFETInst(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation wFinger Length Bconn mi miX @optional (SUBPmos "VSS"))
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)

   /* Now add the connectivity */

    ece432FETAddLabelsToInstPins(cvid inst origin mstr leftPins "left")        
    ece432FETAddLabelsToInstPins(cvid inst origin mstr  rightPins "right")        
    ece432FETAddLabelsToInstPins(cvid inst origin mstr  topPins "top")        
    ece432FETAddLabelsToInstPins(cvid inst origin mstr   botPins "bottom")        

  /* now add the properties */
    dbCreateProp(inst "miX" "string" miX)
    dbCreateProp(inst "mpCell" "string" miX)
    dbCreateProp(inst "wFinger" "string" wFinger)
    dbCreateProp(inst "l" "string" Length)
    dbCreateProp(inst "mi" "string" mi)
    dbCreateProp(inst "B" "string" Bconn)
    if( strcmp(substring(cellName,1,1), "P")==0 then 
	dbCreateProp(inst "SUB" "string" SUBPmos)
	net = dbMakeNet(cvid SUBPmos nil)
        dbCreateConnByName(net inst "SUB")
    );

  return(inst)
  )
)

procedure( ece432FETAddLabelsToInstPins(cvid inst origin mstr pinList side)
  prog( (pinPair shape instPinName pinLabel x y newxy stretchxy rotation label line)

      rotation = case(side
        ("left" "R0")
        ("right" "R0")
        ("top" "R90")
        ("bottom" "R270")
      )

    foreach(pinPair pinList
      instPinName = car(pinPair)
      pinLabel = car(last(pinPair))

      net = dbMakeNet(cvid pinLabel nil)
      dbCreateConnByName(net inst instPinName)
      xy = ece432GetFETPinCenter(mstr instPinName)
      newxy = ece432AddCoords(xy origin)

      x = xCoord(newxy)
      y = yCoord(newxy)
      stretchxy = case(side
        ("left" (x-.2):y)
        ("right" (x+.2):y)
        ("top" x:(y+.2))
        ("bottom" x:(y-.2))
      )

      line = dbCreateLine(cvid list(228 252) list(newxy stretchxy))~>net=net

      label = dbCreateLabel(cvid list(228 237) stretchxy pinLabel "lowerCenter" rotation "stick" 6.250000e-02)
      label~>isDrafted = t
      label~>isOverbar = nil
      label~>isVisible = t
      label~>labelType = "normalLabel"
    )
        

  return(t)
  )
)

procedure( ece432GetFETPinCenter(inst instPinName)
  prog( (x y shape xy bBox x1 x2 y1 y2)
    foreach(shape inst~>shapes
      if( shape~>layerName=="pin" then
        if( car(shape~>net~>sigNames)==instPinName then
          bBox = shape~>bBox
        )
        if( car(cdr(shape~>net~>sigNames))==instPinName then
          bBox = shape~>bBox
        )
      )
    )
  x1 = xCoord(car(bBox))
  x2 = xCoord(car(last(bBox)))
  x  = (x1 + x2)/2
  
  y1 = yCoord(car(bBox))
  y2 = yCoord(car(last(bBox)))
  y  = (y1 + y2)/2
  xy = x:y

  return(xy)
  )
)

