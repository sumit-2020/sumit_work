/*====================================================================

 This file defines the SKILL procedure for creating 
   LAYOUT of a N-bit inverter chain with AMI06 technology.

 Built for ECE432/632 Introduction to VLSI Design, Fall 2007.

=====================================================================*/

;; Load the file containing the basic layout procedures
load("./skill/Layout.il")


/*====================================================================
 Define the procedure for placing cells (N inverters)
====================================================================*/
procedure(invChainPlaceCells(cvid N)

  prog((xy instName bBox) ;;Define local variables
  
    printf("in invChainPlaceCells()\n")
  
    ;; The origin of the first inverter
    xy = 0:0
	
	;; Place N inverter instances
    for(i 1 N
      ;; Define the inverter instance name
	  sprintf(instName "IINV%L" i)
	  
	  ;; Create the inverter instance.
	  ;; You should have created the layout of the inverter cell.
	  ;; The return value 'bBox' stores the location info of the instance. 
      bBox = ece432LayoutCreateInst(
	            ;; Cell view id
	            cvid 
				
				;; Library name of the inverter
				"tutorial"
				
				;; Cell name of the inverter
				"bcInverter" 
				
				;; Layout view name, always be "layout"
				"layout" 
				
				;; Instance name for the inverter
				instName 
				
				;; Origin of the inveter instance 
	            xy
				
				;; Rotation of the inverter instance, "R0" means no rotation
				"R0"
				
			 );; end bBox=
									
	  ;; The origin of the next inverter, which will be put on the "lowerRight"
	  ;;   side of the current one.   
      xy = ece432GetBboxCorners(bBox "lowerRight")
    )
    
	return(t)

  ) ;; end prog  
  
) ;; end of Cell Placing Procedure


/*====================================================================
 Define the procedure for routing wires (connect the inverters)
====================================================================*/
procedure(invChainRouteSignals(cvid N)

  prog((labelSize fstInstName net lstInstName i curInstName nextInstName
        p1 p2 RAIL bBox) ;; Define local variables
    
	printf("in invChainRouteSignals()\n")
	
	;; Define the fontsize of the pin label
	labelSize = .05
	
    ;; Place input pin "IN" on the same place of pin "in" of the 1st inverter
	fstInstName = "IINV1"
    net = dbMakeNet(cvid "IN")
    ece432LayoutCreateNewInstPinSamePlace(cvid fstInstName "in" 1
         net "IN" labelSize)
    
    ;; Place output pin "OUT" on the same place of pin "out" of the last inverter
	lstInstName = sprintf(nil "IINV%L" N)
    net = dbMakeNet(cvid "OUT")
    ece432LayoutCreateNewInstPinSamePlace(cvid lstInstName "out" 1
         net "OUT" labelSize)
		
	;; Tie up the output of the ith inverter with the input of the (i+1)th inverter 	 
    for(i 1 N-1
	  ;; Instanace name of the current inverter
      curInstName = sprintf(nil "IINV%L" i)
	  
	  ;; Instance name of the next inverter
      nextInstName = sprintf(nil "IINV%L" i+1)
	  
      ;; Define the name of the net that connects both the two inverters
      net = dbMakeNet(cvid sprintf(nil "out%L" i))
	  
	  ;; Find the output pin of the current inverter
	  p1 = ece432LayoutFindInstPinCenter(cvid curInstName "out" 1)
	  
	  ;; Find the input pin of the next inverter
	  p2 = ece432LayoutFindInstPinCenter(cvid nextInstName "in" 1)
	  
	  ;; Connect the two inverters with a metal1 path 
      dbCreatePath(cvid list("metal1" "drawing") list(p1 p2) 0.08 
	             "extendExtend")~>net=net

    ) ;;end for i 1 N

  
    ;; Tie up VDD and VSS, and place VDD and VSS pin
    foreach(RAIL list("VDD" "VSS")
	  ;; Find the VDD/VSS pin location of the first inverter
	  bBox = ece432LayoutFindInstPinBbox(cvid fstInstName RAIL 1)
	  ;; Find the coordinate of the lower-left corner of that pin
	  p1 = ece432GetBboxCorners(bBox "lowerLeft")
	  
	  ;; Find the VDD/VSS pin location of the last inverter
	  bBox = ece432LayoutFindInstPinBbox(cvid lstInstName RAIL 1)
	  ;; Find the coordinate of the upper-right corner of that pin
	  p2 = ece432GetBboxCorners(bBox "upperRight")
	  
	  ;; Define the VDD/VSS net
	  net = dbMakeNet(cvid RAIL)
	  
	  ;; Define the location of the rectangle
	  bBox = list(p1 p2)
	  
	  ;; Draw a metal1 rectangle to connect all the VDDs/VSSs
	  dbCreateRect(cvid list("metal1" "drawing") bBox)
				 
	  ;; Add VDD/VSS pin
      ece432LayoutCreatePin(cvid "metal1" bBox net "input"
	                        labelSize)
    ) ;;end foreach(RAIL
	
    return(t)
 
  );; end prog

);; end of routing procedure


/*====================================================================
 Define the procedure for placing the new cell boundary
====================================================================*/
procedure(invChainPutBoundary(cvid N)
  prog((instName bBox upperR rect)

  printf("in invChainPutBoundary()\n")
  
  ;; The instance name of the last invereter
  instName = sprintf(nil "IINV%L" N)
  
  ;; Find the location of the last inverter boundary
  bBox = ece432LayoutFindInstBboxByName(cvid instName)
  
  ;; Find the coordinate of the upper-right corner of the last inverter
  upperR = ece432GetBboxCorners(bBox "upperRight")
  
  ;; Create the boundary of the whole inverter chain with "text" layer
  rect = dbCreateRect(cvid list("text" "drawing") list(0:0 upperR))

  return(t)
  
  ) ;; end prog
  
) ;; end of placing boundary procedure


/*====================================================================
 Define the procedure for creating layout of the N-bit inverter
   chain.
 This procedure has 3 parameter:
 - libName: the name of the library that you will put the cell layout in;
 - cellName: the name of the cell you will create;
 - N: the number of data bits of the inverter chain
=====================================================================*/
procedure(invChainLayout(libName cellName N)

  ;; Define the local variables
  prog((cvid)
  
    ;; Open the cell and its layout view
    cvid = dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
	
	;; Clean the layout view
	ece432DeleteObjectsLayout(cvid)
	
	;; Place N inverters
	invChainPlaceCells(cvid N)
    
	;; Route wires
	invChainRouteSignals(cvid N)
    
	;; Place boundary
	invChainPutBoundary(cvid N)
  
    ;; Check, save and close the cell view
	dbCheck(cvid)
    dbSave(cvid)
    dbClose(cvid)
    
	return(t);
	
  ); end prog
	
); end of the inverter chain layout procedure
	
	
/*====================================================================
 'let' is the main entrance of the skill program.
 We will build layout for a 6-bit inverter chain as an example.
====================================================================*/
let((libName cellName N)

  ;; The number of inverters
  N = 6
  
  ;; The name of the library we will put the new cell in
  libName="tutorial"
  
  ;; Define the cell name as 'invChain_6b'
  sprintf(cellName "invChain_%Lb" N)

  ;; Call the procedure to reate the inverter chain layout
  invChainLayout(libName cellName N)
  
  printf("=== Cell %L layout has been created! ===\n", cellName)

) ;;end let
 
