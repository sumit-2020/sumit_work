/*====================================================================

 This file defines the SKILL procedure for creating 
   SCHEMATIC of a N-bit inverter chain with AMI06 technology.

 Built for ECE432/632 Introduction to VLSI Design, Fall 2007.

=====================================================================*/

;; Load the file containing the basic schematic procedures
load("./skill/Schematic.il")


/*====================================================================
 Define the procedure for creating schematic of the N-bit inverter
   chain.
 This procedure has 3 parameter:
 - libName: the name of the library that you will put the cell schematic in;
 - cellName: the name of the cell you will create;
 - N: the number of data bits of the inverter chain
=====================================================================*/
procedure(invChainSchematic(libName cellName N)

  ;; Define the local variables
  prog((cvid x y pin pinName k inName outName inst)
  
    ;; Open the cell and its schematic view
    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
	
	;; Clean the schematic view
    ece432DeleteObjectsSchematic(cvid)
	
	;; The coordinate of the origin point for the schematic
    x=0
    y=0
	
    ;; Create top level pins
	;; Create input pins
    foreach(pinName list("vdd" "gnd" "IN")
      pin=ece432SchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y+0.5
    )
	;; Create output pins
    foreach(pinName list("OUT")
      pin=ece432SchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y+0.5
    )
	
	;; The coordinate of the origin point for the schematic
    x=1
    y=0
	
	;; Create the chain of N inverters, each of which is the inverter cell
	;;   you have created in the previous tutorial.
    for(k 1 N
	
	  ;; Define the input and output net name of the first inverter
      if(k==1 then
	    inName="IN"
	    outName="out1"
      else 
	  
	  ;; Define the input and output net name of the last inverter
	    if(k==N then
		  inName=sprintf(nil "out%L" k-1)
	      outName="OUT"
		  
	  ;; Define the input and output net name of the kth inverter 
	  ;; eg. 2nd inverter, its input should be 'out1' and output should be 'out2'	  
	    else
	      inName=sprintf(nil "out%L" k-1)
	      outName=sprintf(nil "out%L" k)
		);; end if(k==N
		
      );; end if(k==1
	  
	  ;; Instantiate the kth inverter with ece432SchematicCreateInst() procedure, 
	  ;; which is defined in the file 'ece432Schematic.il'. 
	  ;; This procedure needs 10 paramters
      inst = ece432SchematicCreateInst(
	           ;; Cell view id
			   cvid 
			   
			   ;; Name of the library containing the inverter cell
			   libName
			   
	           ;; The inverter cell name  
               "inv"  
			   
			   ;; Cell view type, always be "symbol" here
			   "symbol" 
			   
			   ;; Instance name
	           sprintf(nil "IINV%L" k) 
			   
			   ;; The following list defines the connections of the left side pins 
			   ;; in the symbol view; For our inverter, 'in' is the only pin on the left.
			   ;; The inverter pin 'in' is connected with the net 'inName'.
			   ;; If there are multiple pins on the left side, you can use the below way to define.
			   ;;    list(list("in1" in1net)
			   ;;         list("in2" in2net))
			   ;; If there is no pin on the left side, this parameter should be 'nil'.
	           list(list("in" inName))   
			   
			   ;; The following list defines the connections of the right side pins 
			   ;; in the symbol view; For our inverter, 'out' is the only pin on the right.
	  		   list(list("out" outName))  
			   
			   ;; The following list defines the connections of the top side pins 
			   ;; in the symbol view; For our inverter, 'VDD' is the only pin on the top.
      		   list(list("vdd"  "vdd"))
			   
			   ;; The following list defines the connections of the bottom side pins 
			   ;; in the symbol view; For our inverter, 'VSS' is the only pin on the bottom.
	           list(list("gnd"  "gnd"))
			   
			   ;; Location of the instance
               x:y 
			   
			   ;; Rotation of the instance, such as "R0", "R90", "R180", "R270", "MX", "MY", ...
			   "R0"
			 );; end inst =
        
	  ;; The next inverter will be put at the right side of the current one.   
	  x=x+2
	  
    );; end for(k
	
	;; Check, save and close the cell view
	schCheck(cvid)  ;; check the schematic connectivity
    dbSave(cvid)
    dbClose(cvid)
	
    return(t)
	
  );; end prog
  
);; end procedure



/*====================================================================
 'let' is the main entrance of the skill program.
 We will build schematic for a 6-bit inverter chain as an example.
====================================================================*/
let((N libName cellName)  ;; N, libName and cellName are variables

  ;; The number of inverters
  N = 6 
  
  ;; The name of the library we will put the new cell in
  libName="sumitfpga"
  
  ;; Define the cell name as 'invChain_6b'
  sprintf(cellName "invChain_%Lb" N)

  ;; Call the procedure to create the inverter chain schematic
  invChainSchematic(libName cellName N)

  printf("=== Cell %L Schematic has been created! ===\n", cellName)

) ;;end let
 
