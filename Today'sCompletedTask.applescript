
(*

Write Today's Completed Tasks In OmniFocus to a Text File
Version 1.1
March 28, 2012
Author: lqik2004(刘潮)
*)


(* 
======================================
// MAIN PROGRAM 
======================================
*)

--GET TODAY'S DATE
set dteToday to date (short date string of (current date))

--CHOOSE FILE NAME / SAVE LOCATION
set theFilePath to choose file name default name "Today_Task.rst"

--GET OMNIFOCUS INFORMATION
set today_Tasks to my do_OmniFocus()

--WRITE THE TEXT FILE
my write_File(theFilePath, today_Tasks)

(* 
======================================
// MAIN HANDLER SUBROUTINES 
======================================
*)

--GET OMNIFOCUS INFORMATION
on do_OmniFocus()
	set dteToday to date (short date string of (current date))
	tell application id "com.omnigroup.OmniFocus"
		tell default document
			set refDoneToday to a reference to (flattened tasks where (completion date ≥ dteToday))
			set {lstName, lstContext, lstProject} to {name, name of its context, name of its containing project} of refDoneToday
			set strText to "=======================" & return
			set strText to strText & "Today's Completed Task" & return & "=======================" & return
			set strText to strText & return & ".. scv-table:: " & return
			set strText to strText & "   :header: \"任务\", \"项目\", \"上下文\"" & return & return
			repeat with iTask from 1 to count of lstName
				set {strName, varContext, varProject} to {item iTask of lstName, item iTask of lstContext, item iTask of lstProject}
				set strText to strText & "\"" & strName & "\""
				if varContext is not missing value then set strText to strText & ",\"" & varContext & "\""
				if varProject is not missing value then set strText to strText & ",\"" & varProject & "\""
				set strText to strText & return
			end repeat
		end tell
	end tell
	strText
end do_OmniFocus


(* 
======================================
// UTILITY SUBROUTINES 
======================================
*)

--EXPORT TO TXT FILE 
on write_File(theFilePath, today_Tasks)
	set theText to today_Tasks
	set theFileReference to open for access theFilePath with write permission
	write theText to theFileReference
	close access theFileReference
end write_File
