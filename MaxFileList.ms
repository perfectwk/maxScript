
global FileDir = ""
global FileList = #()
global FileName = #()
global RecentFile1 = #()
global RecentFileName = #()
Global max2010Plus
Fn LoadRecentFileListMax2010 =
(
    local recentfiles = (getdir #maxData) + "RecentDocuments.xml"
    if doesfileexist recentfiles then
    (
        XMLArray = #()
        xDoc = dotnetobject "system.xml.xmldocument"
        xDoc.Load recentfiles
        Rootelement = xDoc.documentelement

        XMLArray = for i = 0 to rootelement.childnodes.item[4].childnodes.itemof[0].childnodes.count-1 collect
            (
            #(rootelement.childnodes.item[4].childnodes.itemof[0].childnodes.itemof[i].childnodes.itemof[3].innertext, rootelement.childnodes.item[4].childnodes.itemof[0].childnodes.itemof[i].childnodes.itemof[0].innertext)
            )

        Return XMLArray
        LRXML = Undefined
        XDoc = Undefined
        XDoc = nothing
    )
)



rollout MaxFileList "Untitled" width:162 height:300
(
	listbox lbx1 "" pos:[4,35] width:153 height:9 enabled:true
	checkbutton btn1 "Recent" pos:[15,10] width:56 height:20
	Timer cust2 "" pos:[113,263] width:24 height:24
	checkbutton btn6 "Max" pos:[90,10] width:56 height:20
	on MaxFileList open do
	(
	   max2010Plus = (((maxversion())[1]) > 11999)

		--FileDir =  maxFilePath as string
		--for i in (getfiles (FileDir+"/*.max")) do append FileList i
		--for z=1 to FileList.count do append FileName (filenameFromPath FileList[z])
		-- lbx1.items = FileName

	)
------最近打开文件
	on btn1 changed state do
	(
                    RecentFileName = #()
                    RecentFile1 = #()
		if state == true then
		(
                            btn6.checked  =false

			if max2010Plus then
				(
					for i = 1 to 9 do
					(
							try (append RecentFile1  (LoadRecentFileListMax2010())[i]) catch (RecentFile1 = undefined)
							--if RecentFile1 != undefined then (if (doesfileexist RecentFile1[1]) /*and not (((getdir #autoback)+"\\")==(getfilenamepath RecentFile1[1])*/) then append ABFiles RecentFile1) else (exit)
					)
					try(for j=1 to RecentFile1.count do append RecentFileName (filenameFromPath RecentFile1[j][1]))catch()
				)
				else(
					for i =1 to 9 do
					(
						   try ( append RecentFile1  (getINISetting (getMAXIniFile()) "FileList" ("File"+i as string))) catch (RecentFile1 = undefined)
					)
					for j=1 to RecentFile1.count do append RecentFileName (filenameFromPath RecentFile1[j])
				)
		)
		else(RecentFileName = #())
	   lbx1.items = RecentFileName


    )
 ----MAX文件
	on btn6 changed state do
	(
		FileName = #()
		FileList = #()
	    if state == true then
		(
                    btn1.checked  =false
			FileDir =  maxFilePath as string
			for i in (getfiles (FileDir+"/*.max")) do append FileList i
			for z=1 to FileList.count do append FileName (filenameFromPath FileList[z])

		)else(FileName = #())
		lbx1.items = FileName
	)



	on lbx1 doubleClicked sel do
	(

		loadMaxFile FileList[sel]


	)

on cust2 tick do
    (
              -- if  btn1.checked  == true do btn6.checked  = false;
               -- if  btn6.checked  == true do btn1.checked  =false;

    )

)
createdialog MaxFileList