;; Author  : Cadence Design Systems
;; FileName: JayChangeLabel.il
;; Tested  : IC442 IC443
;;
;; This procedure may be used to traverse through the hierarchy of a library.
;; If cellList is specified then the operation will be performed only on cellList.
;; default is all cells in the library. 
;; viewName = layout or schematic
;;
;; Usage In CIW:
;; JayChangeLabel("library_name" "schematic" "old_label" "new_label")
;; SKILL LINT SCORE 100 (BEST MAXIMUM IS 100)

procedure(JayChangeLabel(libName viewName oldLabel newLabel @optional listOfCells)

 let((cv libId cellId cellList)

   libId = ddGetObj(libName)
   if(!listOfCells then
     cellList = libId~>cells
   else 
     cellList = nil
     foreach(cellName listOfCells
       cellId = ddGetObj(libName cellName)
       cellList = append(list(cellId) cellList)
	   );end foreach
     );end if

   foreach(cell cellList 
     foreach(view cell~>views
;; using views matching viewName variable. 
       if(view~>name == viewName && (cv = dbOpenCellViewByType(libName cell->name
       view~>name "" "a")) then
	  printf("\nOpened view %L from cell %L of library %L for edit.\n" 
		 cv~>viewName cv~>cellName cv~>libName)
      ;; Operate on the desired objects, Here it's shape with the property
      ;; theLabel = oldLabel
	foreach(shape cv~>shapes 
	   if(shape~>theLabel && (shape~>theLabel == oldLabel) then
	   printf("\n Changing the label %L with %L. " shape~>theLabel newLabel )
		   shape~>theLabel = newLabel
	   );end if
	);end foreach

	  dbSave(cv)
	  dbClose(cv)
     );end if
   );end foreach view
 );end foreach cell
   
   ddReleaseObj(libId)
 );let
);proc JayChangeLabel
;; End of JayChangeLabel.il
