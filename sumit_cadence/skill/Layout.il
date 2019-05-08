;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This file defines the common SKILL procedures(functions) for 
;;   creating layout.
;;
;; Built for ECE432/632 Introduction to VLSI Design, Fall 2007
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load("./skill/Math.il")

procedure( ece432DeleteObjectsLayout(cvid)
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

procedure(  ece432LayoutFindInstBboxByName(cvid instName)
  prog((mstr inst origin rotation lppList bBoxMaster ur ll originR ur1 originRx originRy ur1x ur1y bBox)

    inst = dbFindAnyInstByName(cvid instName)
    mstr = inst~>master
    origin = inst~>xy
    rotation = inst~>orient

    lppList = mstr~>layerPurposePairs
    foreach(lpp lppList
	lppName = lpp~>layerName
	if( lppName == "text" then
	  bBoxMaster = car(lpp~>shapes)~>bBox
	)
      )
    ur = ece432GetBboxCorners( bBoxMaster "upperRight")
    ll = ece432GetBboxCorners( bBoxMaster "lowerLeft")

    if( rotation == "R0" then
      originR = xCoord(origin)+xCoord(ll):yCoord(origin)+yCoord(ll)
      ur1 = xCoord(origin)+xCoord(ur) : yCoord(origin)+yCoord(ur)
    )
    if( rotation == "R90" then
      originRx = xCoord(origin)-xCoord(ur)
      originRy = yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)
      ur1y = yCoord(ur) + yCoord(origin)
      ur1 = ur1x:ur1y
    )
    if( rotation == "R180" then
      originRx = xCoord(origin)-xCoord(ur)
      originRy = yCoord(origin)-yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)+xCoord(ll)
      ur1y = yCoord(origin)+yCoord(ll) 
      ur1 = ur1x:ur1y
    )
    if( rotation == "R270" then
      originRx = xCoord(origin)
      originRy = yCoord(origin)-yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)+xCoord(ur)
      ur1y = yCoord(origin)
      ur1 = ur1x:ur1y
    )
    if( rotation == "MX" then
      originRx = xCoord(origin)+xCoord(ll)
      originRy = yCoord(origin)-yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)+xCoord(ur)
      ur1y = yCoord(origin)-yCoord(ll)
      ur1 = ur1x:ur1y
    )
    if( rotation == "MY" then
      originRx = xCoord(origin)-xCoord(ur)
      originRy = yCoord(origin)+yCoord(ll)
      originR = originRx:originRy
      ur1x = xCoord(origin)-xCoord(ll)
      ur1y = yCoord(origin)+yCoord(ur)
      ur1 = ur1x:ur1y
    )

    bBox = list(originR ur1)      
    return(bBox)


  )
)


procedure( ece432LayoutCreateInst(cvid libName cellName cellType instName origin rotation)
  prog((mstr inst bBox bBoxMaster lppList lpp x0 y0 x1 y1 originR)
    mstr = dbOpenCellViewByType(libName cellName cellType)

    lppList = mstr~>layerPurposePairs

    foreach(lpp lppList
	lppName = lpp~>layerName
	if( lppName == "text" then
	  bBoxMaster = car(lpp~>shapes)~>bBox
	)
      )

    if(bBoxMaster==nil then
	printf("ERROR in ece432LayoutCreateInst:\n")
	printf("      Cell %L does not have a text bBox\n" cellName)
    )
    ur = ece432GetBboxCorners( bBoxMaster "upperRight")
    ll = ece432GetBboxCorners( bBoxMaster "lowerLeft")    
    lr = ece432GetBboxCorners( bBoxMaster "lowerRight")    

    if( rotation == "R0" then
      org = xCoord(origin)-xCoord(ll):yCoord(origin)-yCoord(ll)
      originR = org
      ur1 = xCoord(org)+xCoord(ur) : yCoord(org)+yCoord(ur)
    )
    if( rotation == "R90" then
      originRx = xCoord(origin)+yCoord(ur)
      originRy = yCoord(origin)
      originR = originRx:originRy
      ur1 = xCoord(origin)+yCoord(ur) : yCoord(origin)+xCoord(ur)
    )
    if( rotation == "R180" then
      originRx = xCoord(ur)+xCoord(origin)
      originRy = yCoord(ur)+yCoord(origin)
      originR = originRx:originRy
      ur1 = originR
    )
    if( rotation == "R270" then
      originRx = xCoord(origin)
      originRy = yCoord(origin)+xCoord(ur)
      originR = originRx:originRy
      ur1 = xCoord(origin)+yCoord(ur) : yCoord(origin)+xCoord(ur)
    )
    if( rotation == "MX" then
      originRx = xCoord(origin)-xCoord(ll)
      originRy = yCoord(origin)+yCoord(ur)
      originR = originRx:originRy
      ur1 = xCoord(origin)+xCoord(ur): yCoord(origin)+yCoord(ur)
    )
    if( rotation == "MY" then
      originRx = xCoord(origin)+xCoord(ur)
      originRy = yCoord(origin)-yCoord(lr)
      originR = originRx:originRy
      ur1 = originRx-xCoord(ll): originRy+yCoord(ur)
    )

    inst = dbCreateInst(cvid mstr instName originR rotation 1)

    bBox = list(origin ur1)      

    return(bBox)
  )
)

procedure( ece432LayoutListAllPins(cvid instName)
  prog( (inst rects pN bBox layerName att)

  inst = dbFindAnyInstByName(cvid instName)

  foreach(rects inst~>master~>lpps
      if(rects~>purpose == "pin" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
	bBox = shapes~>bBox
	layerName = shapes~>layerName
        att = list(pN bBox layerName)
	println(att)
        )
      )
    )

))

procedure( ece432LayoutFindInstPinCenter(cvid instName pinName pinNumber) 
  prog( (inst rects shapes bBoxX bBoxY xy0 xy1 xy origin rotation deltax deltay bBoxorig)
  
  inst = dbFindAnyInstByName(cvid instName)

  index = 1
  bBoxOrig = nil
  foreach(rects inst~>master~>lpps

    if(rects~>purpose == "drawing" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
	;;if(pN==nil then pN=shapes~>theLabel)
        if( pN == pinName then
          if( index == pinNumber then      
          bBoxOrig = shapes~>bBox
          )
          index = index + 1
	))))
  if(bBoxOrig==nil then
    printf("ERROR in ece432LayoutFindInstPinCenter:\n")
    printf("  Cannot find pin %L in cell %L\n" pinName instName)
  )
  ; Get the origin
  xy0 = ece432GetBboxCorners( bBoxOrig "lowerLeft")
  xy1 = ece432GetBboxCorners( bBoxOrig "upperRight")
  deltax = (xCoord(xy1)-xCoord(xy0))/2
  deltay = (yCoord(xy1)-yCoord(xy0))/2
  origin = inst~>xy
  rotation = inst~>orient  

    if( rotation == "R0" then
      bBoxX = xCoord(xy0)+deltax+xCoord(origin)
      bBoxY = yCoord(xy0)+deltay+yCoord(origin)
    )
    if( rotation == "R180" then
      bBoxX = xCoord(origin)-xCoord(xy0)-deltax
      bBoxY = yCoord(origin)-yCoord(xy0)-deltay
    )
    if( rotation == "MX" then
      bBoxX = xCoord(origin)+xCoord(xy0)+deltax
      bBoxY = yCoord(origin)-yCoord(xy0)-deltay
    )
    if( rotation == "MY" then
      bBoxX = xCoord(origin)-xCoord(xy0)-deltax
      bBoxY = yCoord(origin)+yCoord(xy0)+deltay
    )
    if( rotation == "R270" then
      bBoxX = xCoord(origin)+yCoord(xy0)+deltay
      bBoxY = yCoord(origin)-xCoord(xy0)-deltax
    )
    if( rotation == "R90" then  ;; ADDED 2-25-05 BHC
      bBoxX = xCoord(origin)-yCoord(xy1)+deltay
      bBoxY = yCoord(origin)+xCoord(xy0)+deltax
    )

  xy = bBoxX:bBoxY
  return(xy)
  )
)

procedure( ece432LayoutFindInstPinBbox(cvid instName pinName pinNumber) 
  prog( (inst index bBoxOrig rects shapes pN xy xy0 xy1 x y bBox rotation)
  
  ; ASSUMES NO ROTATION

  inst = dbFindAnyInstByName(cvid instName)

  index = 1
  bBoxOrig = nil
  foreach(rects inst~>master~>lpps

    if(rects~>purpose == "drawing" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
	;;if(pN==nil then pN=shapes~>theLabel)
        if( pN == pinName then
          if( index == pinNumber then 
          bBoxOrig = shapes~>bBox
          )
          index = index + 1
	))))

  if(bBoxOrig==nil then 
    printf("ERROR - Cannot find pin %s in instance %s.\n" pinName instName)
  )

  xy = inst~>xy
  rotation=inst~>orient
  ; default (R0)  
   xy0 = ece432AddCoords(xy car(bBoxOrig))
   xy1 = ece432AddCoords(xy cadr(bBoxOrig))

  if( rotation == "MY" then 
   bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = yCoord(xy)+cadr(car(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = yCoord(xy)+cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "MX" then 
   ;;bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = xCoord(xy)+car(car(bBoxOrig))
   y = yCoord(xy)-cadr(car(bBoxOrig))
   xy0 = x:y
   x = xCoord(xy)+car(cadr(bBoxOrig))
   y = yCoord(xy)-cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R180" then 
   bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(cadr(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(car(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R270" then  
   x = car(xy)+cadr(car(bBoxOrig))
   y = cadr(xy)-car(car(bBoxOrig))
   xy0 = x:y
   x = car(xy)+cadr(cadr(bBoxOrig))
   y = cadr(xy)-car(cadr(bBoxOrig))
   xy1 = x:y   
  )

  bBox = list(xy0 xy1)    

  return(bBox)
))


procedure( ece432LayoutFindInstPinCenter(cvid instName pinName pinNumber)
  prog( (inst rects shapes bBoxX bBoxY xy0 xy1 xy origin rotation deltax deltay
bBoxorig)

  inst = dbFindAnyInstByName(cvid instName)

  index = 1
  bBoxOrig = nil

  foreach(rects inst~>master~>lpps
    if(rects~>purpose == "drawing" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
        ;;if(pN==nil then pN=shapes~>theLabel)
        if( pN == pinName then
          if( index == pinNumber then
          bBoxOrig = shapes~>bBox
          )
          index = index + 1
        );;end of if(pN
      );;end of foreach(shapes
    );;end of if(rects
  );;end of foreach(rects

  if(bBoxOrig==nil then
    printf("ERROR in ece432LayoutFindInstPinCenter:\n")
    printf("  Cannot find pin %L in cell %L\n" pinName instName)
  )

  ; Get the origin
  xy0 = ece432GetBboxCorners( bBoxOrig "lowerLeft")
  xy1 = ece432GetBboxCorners( bBoxOrig "upperRight")
  deltax = (xCoord(xy1)-xCoord(xy0))/2
  deltay = (yCoord(xy1)-yCoord(xy0))/2
  origin = inst~>xy
  rotation = inst~>orient

    if( rotation == "R0" then
      bBoxX = xCoord(xy0)+deltax+xCoord(origin)
      bBoxY = yCoord(xy0)+deltay+yCoord(origin)
    )
    if( rotation == "R180" then
      bBoxX = xCoord(origin)-xCoord(xy0)-deltax
      bBoxY = yCoord(origin)-yCoord(xy0)-deltay
    )
    if( rotation == "MX" then
      bBoxX = xCoord(origin)+xCoord(xy0)+deltax
      bBoxY = yCoord(origin)-yCoord(xy0)-deltay
    )
    if( rotation == "MY" then
      bBoxX = xCoord(origin)-xCoord(xy0)-deltax
      bBoxY = yCoord(origin)+yCoord(xy0)+deltay
    )
    if( rotation == "R270" then
      bBoxX = xCoord(origin)+yCoord(xy0)+deltay
      bBoxY = yCoord(origin)-xCoord(xy0)-deltax
    )
    if( rotation == "R90" then  ;; ADDED 2-25-05 BHC
      bBoxX = xCoord(origin)-yCoord(xy1)+deltay
      bBoxY = yCoord(origin)+xCoord(xy0)+deltax
    )

  xy = bBoxX:bBoxY
  return(xy)
  )
)

procedure( ece432LayoutFindInstPinBbox(cvid instName pinName pinNumber)
  prog( (inst index bBoxOrig rects shapes pN xy xy0 xy1 x y bBox rotation)
 
  ; ASSUMES NO ROTATION

  inst = dbFindAnyInstByName(cvid instName)

  index = 1
  bBoxOrig = nil

  foreach(rects inst~>master~>lpps
    if(rects~>purpose == "drawing" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
        ;;if(pN==nil then pN=shapes~>theLabel)
        if( pN == pinName then
          if( index == pinNumber then
          bBoxOrig = shapes~>bBox
          )
          index = index + 1
        );;end of if(pN
      );;end of foreach(shapes
    );;end of if(rects
  );;end of foreach(rects

  if(bBoxOrig==nil then
    printf("ERROR - Cannot find pin %s in instance %s.\n" pinName instName)
  )

  xy = inst~>xy
  rotation=inst~>orient
  ; default (R0)
   xy0 = ece432AddCoords(xy car(bBoxOrig))
   xy1 = ece432AddCoords(xy cadr(bBoxOrig))

  if( rotation == "MY" then
   bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = yCoord(xy)+cadr(car(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = yCoord(xy)+cadr(cadr(bBoxOrig))
   xy1 = x:y
  )

  if( rotation == "MX" then
   ;;bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = xCoord(xy)+car(car(bBoxOrig))
   y = yCoord(xy)-cadr(car(bBoxOrig))
   xy0 = x:y
   x = xCoord(xy)+car(cadr(bBoxOrig))
   y = yCoord(xy)-cadr(cadr(bBoxOrig))
   xy1 = x:y
  )

  if( rotation == "R180" then
   bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(cadr(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(car(bBoxOrig))
   xy1 = x:y
  )

  if( rotation == "R270" then
   x = car(xy)+cadr(car(bBoxOrig))
   y = cadr(xy)-car(car(bBoxOrig))
   xy0 = x:y
   x = car(xy)+cadr(cadr(bBoxOrig))
   y = cadr(xy)-car(cadr(bBoxOrig))
   xy1 = x:y
  )

  bBox = list(xy0 xy1)

  return(bBox)
))

procedure( ece432LayoutCreateNewInstPinSamePlace(cvid instName pinName pinNumber
 net label fontsize)
  prog( (inst index bBoxOrig ioType rects shapes pN xy xy0 xy1 x y bBox rotatio
n layer pinLabel rectPin term)
 
  inst = dbFindAnyInstByName(cvid instName)

  index = 1
  bBoxOrig = nil
  ioType = "input"

  ;; Find the Pin origion location
  foreach(rects inst~>master~>lpps
    if(rects~>purpose == "drawing" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
        ;;if(pN==nil then pN=shapes~>theLabel)
        if( pN == pinName then
          if( index == pinNumber then 
	    layer = car(shapes~>lpp)
            bBoxOrig = shapes~>bBox
            ioType = shapes~>net~>term~>direction
          )
          index = index + 1
	);;end of if(pN
      );;end of foreach(shapes
    );;end of if(rects
  );;end of foreach(rects

  xy = inst~>xy
  rotation=inst~>orient
  ; default (R0)  
   xy0 = ece432AddCoords(xy car(bBoxOrig))
   xy1 = ece432AddCoords(xy cadr(bBoxOrig))

  if( rotation == "MY" then 
   bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = yCoord(xy)+cadr(car(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = yCoord(xy)+cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "MX" then 
   ;;bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = xCoord(xy)+car(car(bBoxOrig))
   y = yCoord(xy)-cadr(car(bBoxOrig))
   xy0 = x:y
   x = xCoord(xy)+car(cadr(bBoxOrig))
   y = yCoord(xy)-cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R180" then 
   bBox = ece432LayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(cadr(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(car(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R270" then  
   x = car(xy)+cadr(car(bBoxOrig))
   y = cadr(xy)-car(car(bBoxOrig))
   xy0 = x:y
   x = car(xy)+cadr(cadr(bBoxOrig))
   y = cadr(xy)-car(cadr(bBoxOrig))
   xy1 = x:y   
  )

  ;; Create pin
  bBox = list(xy0 xy1)    
  rectPin = dbCreateRect(cvid list(layer "drawing") bBox)
  term = dbCreateTerm(net nil ioType)
  pinInst = dbCreatePin(net rectPin nil)
  pinInst~>accessDir = list("left" "right" "top" "bottom")

  ;; Create pin label
;  x = xCoord(ece432GetBboxDimensions(cvid bBox))/2.0
;  y = yCoord(ece432GetBboxDimensions(cvid bBox))/2.0
  x = xCoord(ece432GetBboxDimensions(bBox))/2.0
  y = yCoord(ece432GetBboxDimensions(bBox))/2.0
  p1 = ece432AddCoords(car(bBox) x:y)
  p1 = ece432SnapToGrid(p1)
  pinLabel = dbCreateLabel(cvid list(layer "pin") p1 label "centerCenter" "R0" "roman" fontsize)

  return(pinInst)
))

procedure( ece432LayoutCreatePin(cvid layerName bBox netInst ioType fontSize)
  prog((rectPin term pinInst x y p1 pinLabel)
 
    ;; Create pin
    rectPin = dbCreateRect(cvid list(layerName "drawing") bBox)
    term = dbCreateTerm(netInst nil ioType)
    pinInst = dbCreatePin(netInst rectPin netInst~>name)
    pinInst~>accessDir = list("left" "right" "top" "bottom")

    ;; Add pin label
    x = xCoord(ece432GetBboxDimensions(bBox))/2.0
    y = yCoord(ece432GetBboxDimensions(bBox))/2.0
    p1 = ece432AddCoords(car(bBox) x:y)
    p1 = ece432SnapToGrid(p1)
    pinLabel = dbCreateLabel(cvid list(layerName "pin") p1 netInst~>name "centerCenter" "R0" "roman" fontSize)

    return(pinInst)
  )
)


procedure( ece432BoxDimensions(cvid instName)
  prog((bBox ul lr h w)
    bBox = ece432LayoutFindInstBboxByName(cvid instName)
    ul = ece432GetBboxCorners(bBox "upperLeft")
    lr = ece432GetBboxCorners(bBox "lowerRight")
    h = yCoord(ul)-yCoord(lr)
    w = xCoord(lr)-xCoord(ul)
    return(list(w h))
))

;; Changed to exclude cvid on 10-20-04
;;procedure( ece432GetBboxDimensions(cvid bBox)
procedure( ece432GetBboxDimensions(bBox)
  prog((ul lr h w)
    ul = ece432GetBboxCorners(bBox "upperLeft")
    lr = ece432GetBboxCorners(bBox "lowerRight")
    h = yCoord(ul)-yCoord(lr)
    w = xCoord(lr)-xCoord(ul)
    return(list(w h))
))

;; Added 11-23-04
procedure( ece432GetBboxCenter(bBox)
  prog((ul lr h w x y)
    ul = ece432GetBboxCorners(bBox "upperLeft")
    lr = ece432GetBboxCorners(bBox "lowerRight")
    h = yCoord(ul)-yCoord(lr)
    w = xCoord(lr)-xCoord(ul)
    x = w/2.0
    y = h/2.0
    return(list(x y))
))

procedure( ece432MoveInstByName(cvid instName newxy)
  prog((inst)
    inst=dbFindAnyInstByName(cvid instName)
    inst~>xy=newxy         
    return(t)
))

procedure( ece432MoveInstRelativeByName(cvid instName xyrel)
  prog((inst xy)
    inst=dbFindAnyInstByName(cvid instName)
    xy=inst~>xy
    xy=xCoord(xy)+xCoord(xyrel):yCoord(xy)+yCoord(xyrel)
    inst~>xy=xy         
    return(t)
))

procedure( ece432AlignInstTopWithBox(cvid instName bBox)
  prog((wh xy)
    wh = ece432BoxDimensions(cvid instName)
    xy = ece432GetBboxCorners(bBox "upperRight")
    xy = xCoord(xy):yCoord(xy)-yCoord(wh)
    ece432MoveInstByName(cvid instName xy)
    return(t)
))
  
procedure( ece432SnapToGrid(pt)
  prog((x y newpt)
    x=xCoord(pt)
    y=yCoord(pt)
    x=round(100.0*x)/100.0
    y=round(100.0*y)/100.0
    newpt=x:y
    return(newpt)
))

procedure( ece432LayoutCreateViaArray(cvid libname cellname location center_LLbar rows cols xpitch ypitch width net)
  prog((inst xy bBox)
    inst = dbCreateInstByMasterName(cvid libname cellname "symbolic" nil location "R0")
    if(inst != nil then
	if(rows > 1 then
	   dbCreateProp(inst "row" "int" rows))
	if(cols > 1 then
	   dbCreateProp(inst "column" "int" cols))
	if(xpitch != nil then
	   dbCreateProp(inst "xPitch" "float" xpitch))
	if(ypitch != nil then
	   dbCreateProp(inst "yPitch" "float" ypitch))
	if(width != nil then
	   dbCreateProp(inst "w" "float" width)
	   dbCreateProp(inst "l" "float" width))
	if(net != nil then 
	   inst~>net = net)
	if(center_LLbar == 0 then
	   xy=location
	   bBox=inst~>bBox
	   xyrel=(caadr(bBox)-caar(bBox))/2:(yCoord(cadr(bBox))-yCoord(car(bBox)))/2
	   xy=xCoord(xy)+xCoord(xyrel):yCoord(xy)+yCoord(xyrel)
           inst~>xy=xy         
	)
    ) 
    return(inst)
))
