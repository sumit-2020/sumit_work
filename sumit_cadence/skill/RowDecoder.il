/*====================================================================

 This file defines the SKILL procedure for creating 
   SCHEMATIC of a N-bit Decoder with SCL180 technology.

=====================================================================*/

;; Load the file containing the basic schematic procedures
load("./skill/Schematic.il")


/*====================================================================
 Define the procedure for creating schematic of the N-bit Decoder
   chain.
 This procedure has 3 parameter:
 - libName: the name of the library that you will put the cell schematic in;
 - cellName: the name of the cell you will create;
 - N: the number of data bits of the Decoder
=====================================================================*/
procedure(DecoderSchematic(libName cellName WIDTH OUTPUTS)

  ;; Define the local variables
  prog((cvid x y pin pinName k h temp a b out inst)
  
    ;; Open the cell and its schematic view
    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
	
	;; Clean the schematic view
    ece432DeleteObjectsSchematic(cvid)
	
	;; The coordinate of the origin point for the schematic
    x=0
    y=0
	
    ;; Create top level pins
	
	;; Create input pins
	for(u 0 WIDTH-1
		a=sprintf(nil "A%L" u)
		pin=ece432SchematicCreatePin(cvid a "input" x:y "R0")
      	y=y+0.5
    );; end for(u

	;; Create output pins
	for(q 0 OUTPUTS-1
		out=sprintf(nil "WL%L" q)
		pin=ece432SchematicCreatePin(cvid out "output" x:y "R0")
      	y=y+0.5
    );; end for(q

	;; Create inout pins
    foreach(pinName list("vdd" "gnd")
      pin=ece432SchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y+0.5
    )






	;; The coordinate of the origin point for the schematic
    x=1
    y=0
	
	;; Create the decoder using tx-gates
	for(k 0 OUTPUTS-1

	  ;; Define the input and output net name of the first inverter
	  temp=k
	  if(mod(temp 2)==1 then
		add0="A0"
	  else
		add0="A0_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add1="A1"
	  else
		add1="A1_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add2="A2"
	  else
		add2="A2_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add3="A3"
	  else
		add3="A3_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add4="A4"
	  else
		add4="A4_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add5="A5"
	  else
		add5="A5_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add6="A6"
	  else
		add6="A6_"
      )

	  a=sprintf(nil "%s%s%s%s" add0 add1 add2 add3)
	  b=sprintf(nil "%s%s%s" add4 add5 add6)
	  out=sprintf(nil "WL%L" k)

	  ;; Instantiate the kth tx-gate with ece432SchematicCreateInst() procedure, 
	  ;; which is defined in the file 'ece432Schematic.il'. 
	  ;; This procedure needs 10 paramters
	  inst = ece432SchematicCreateInst(
		       ;; Cell view id
			   cvid 
			   
			   ;; Name of the library containing the inverter cell
			   libName
			   
		       ;; The tx-gate cell name  
	           "and_2"  
			   
			   ;; Cell view type, always be "symbol" here
			   "symbol" 
			   
			   ;; Instance name
		       sprintf(nil "AND_%L" k) 
			   
			   ;; The following list defines the connections of the left side pins 
			   ;; in the symbol view; For our inverter, 'in' is the only pin on the left.
			   ;; The inverter pin 'in' is connected with the net 'inName'.
			   ;; If there are multiple pins on the left side, you can use the below way to define.
			   ;;    list(list("in1" in1net)
			   ;;         list("in2" in2net))
			   ;; If there is no pin on the left side, this parameter should be 'nil'.
	  		   list(list("a" a) 
			   		list("b" b))
			   
			   ;; The following list defines the connections of the right side pins 
			   ;; in the symbol view; For our inverter, 'out' is the only pin on the right.
	  		   list(list("out" out)) 

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
	       
	  y=y-2
	  
	);; end for(k






	;; The coordinate of the origin point for the schematic
    x=-5
    y=0
	
	;; Create the decoder using tx-gates
	for(k 0 15

	  ;; Define the input and output net name of the first inverter
	  temp=k
	  if(mod(temp 2)==1 then
		add0="A0"
	  else
		add0="A0_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add1="A1"
	  else
		add1="A1_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add2="A2"
	  else
		add2="A2_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add3="A3"
	  else
		add3="A3_"
      )

	  a=sprintf(nil "%s" add0)
	  b=sprintf(nil "%s" add1)
	  c=sprintf(nil "%s" add2)
	  d=sprintf(nil "%s" add3)

	  out=sprintf(nil "%s%s%s%s" add0 add1 add2 add3)

	  ;; Instantiate the kth tx-gate with ece432SchematicCreateInst() procedure, 
	  ;; which is defined in the file 'ece432Schematic.il'. 
	  ;; This procedure needs 10 paramters
	  inst = ece432SchematicCreateInst(
		       ;; Cell view id
			   cvid 
			   
			   ;; Name of the library containing the inverter cell
			   libName
			   
		       ;; The tx-gate cell name  
	           "and_4"  
			   
			   ;; Cell view type, always be "symbol" here
			   "symbol" 
			   
			   ;; Instance name
		       sprintf(nil "AND4_%L" k) 
			   
			   ;; The following list defines the connections of the left side pins 
			   ;; in the symbol view; For our inverter, 'in' is the only pin on the left.
			   ;; The inverter pin 'in' is connected with the net 'inName'.
			   ;; If there are multiple pins on the left side, you can use the below way to define.
			   ;;    list(list("in1" in1net)
			   ;;         list("in2" in2net))
			   ;; If there is no pin on the left side, this parameter should be 'nil'.
	  		   list(list("a" a) 
			   		list("b" b)
			   		list("c" c)
			   		list("d" d))
			   
			   ;; The following list defines the connections of the right side pins 
			   ;; in the symbol view; For our inverter, 'out' is the only pin on the right.
	  		   list(list("out" out)) 

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
	       
	  y=y-2
	  
	);; end for(k







	;; The coordinate of the origin point for the schematic
    x=-8
    y=0
	
	;; Create the decoder using tx-gates
	for(k 0 7

	  ;; Define the input and output net name of the first inverter
	  temp=k
	  if(mod(temp 2)==1 then
		add0="A4"
	  else
		add0="A4_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add1="A5"
	  else
		add1="A5_"
      )
      temp=temp/2

	  if(mod(temp 2)==1 then
		add2="A6"
	  else
		add2="A6_"
      )

	  a=sprintf(nil "%s" add0)
	  b=sprintf(nil "%s" add1)
	  c=sprintf(nil "%s" add2)

	  out=sprintf(nil "%s%s%s" add0 add1 add2)

	  ;; Instantiate the kth tx-gate with ece432SchematicCreateInst() procedure, 
	  ;; which is defined in the file 'ece432Schematic.il'. 
	  ;; This procedure needs 10 paramters
	  inst = ece432SchematicCreateInst(
		       ;; Cell view id
			   cvid 
			   
			   ;; Name of the library containing the inverter cell
			   libName
			   
		       ;; The tx-gate cell name  
	           "and_3"  
			   
			   ;; Cell view type, always be "symbol" here
			   "symbol" 
			   
			   ;; Instance name
		       sprintf(nil "AND3_%L" k) 
			   
			   ;; The following list defines the connections of the left side pins 
			   ;; in the symbol view; For our inverter, 'in' is the only pin on the left.
			   ;; The inverter pin 'in' is connected with the net 'inName'.
			   ;; If there are multiple pins on the left side, you can use the below way to define.
			   ;;    list(list("in1" in1net)
			   ;;         list("in2" in2net))
			   ;; If there is no pin on the left side, this parameter should be 'nil'.
	  		   list(list("a" a) 
			   		list("b" b)
			   		list("c" c))
			   
			   ;; The following list defines the connections of the right side pins 
			   ;; in the symbol view; For our inverter, 'out' is the only pin on the right.
	  		   list(list("out" out)) 

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
	       
	  y=y-2
	  
	);; end for(k




;; ******************************Address inverters***************************
	;; The coordinate of the origin point for the schematic
    x=-12
    y=0
	
	;; Create the decoder using tx-gates
	for(k 0 6

	  in=sprintf(nil "A%L" k)
	  out=sprintf(nil "A%L_" k)

	  ;; Instantiate the kth tx-gate with ece432SchematicCreateInst() procedure, 
	  ;; which is defined in the file 'ece432Schematic.il'. 
	  ;; This procedure needs 10 paramters
	  inst = ece432SchematicCreateInst(
		       ;; Cell view id
			   cvid 
			   
			   ;; Name of the library containing the inverter cell
			   libName
			   
		       ;; The tx-gate cell name  
	           "inv"  
			   
			   ;; Cell view type, always be "symbol" here
			   "symbol" 
			   
			   ;; Instance name
		       sprintf(nil "INVERTER_%L" k) 
			   
			   ;; The following list defines the connections of the left side pins 
			   ;; in the symbol view; For our inverter, 'in' is the only pin on the left.
			   ;; The inverter pin 'in' is connected with the net 'inName'.
			   ;; If there are multiple pins on the left side, you can use the below way to define.
			   ;;    list(list("in1" in1net)
			   ;;         list("in2" in2net))
			   ;; If there is no pin on the left side, this parameter should be 'nil'.
	  		   list(list("in" in))
			   
			   ;; The following list defines the connections of the right side pins 
			   ;; in the symbol view; For our inverter, 'out' is the only pin on the right.
	  		   list(list("out" out)) 

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
	       
	  y=y-2
	  
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
let((WIDTH libName cellName)  ;; N, libName and cellName are variables

  ;; The number of inverters
  WIDTH = 7
  OUTPUTS = 74
  ;; The name of the library we will put the new cell in
  libName="sumitfpga"
  
  ;; Define the cell name as 'invChain_6b'
  sprintf(cellName "RowDecoder")

  ;; Call the procedure to create the inverter chain schematic
  DecoderSchematic(libName cellName WIDTH OUTPUTS)

  printf("=== Cell %L Schematic has been created! ===\n", cellName)

) ;;end let
 
