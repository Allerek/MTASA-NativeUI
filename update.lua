local check
if fileExists("update.cfg") then
	check = fileOpen("update.cfg")
else
	check = fileCreate("update.cfg")
end
local allstr = fileRead(check,fileGetSize(check))
setElementData(resourceRoot,"Version",allstr)
fileClose(check)

Version = tonumber(allstr) or 0
RemoteVersion = 0
ManualUpdate = false
updateTimer = false
updatePeriodTimer = false
function checkUpdate()
	outputDebugString("[NativeUI]Connecting to github...")
	fetchRemote("https://raw.githubusercontent.com/Allerek/MTASA-NativeUI/master/update.cfg",function(data,err)
		if err == 0 then
			RemoteVersion = tonumber(data)
            if not ManualUpdate then
				if RemoteVersion > Version then
					outputDebugString("[NativeUI]Remote Version Got [Remote:"..data.." Current:"..allstr.."].")
					outputDebugString("[NativeUI]Update? Command: updatenative")
					if isTimer(updateTimer) then killTimer(updateTimer) end
					updateTimer = setTimer(function()
						if RemoteVersion > Version then
							outputDebugString("[NativeUI]Remote Version Got [Remote:"..RemoteVersion.." Current:"..allstr.."].")
							outputDebugString("[NativeUI]Update? Command: updatenative")
						else
							killTimer(updateTimer)
						end
					end,120*60000,0)
				else
					outputDebugString("[NativeUI]Current Version("..allstr..") is the latest!")
				end
			else
				startUpdate()
			end
		else
			outputDebugString("[NativeUI]Can't Get Remote Version ("..err..")")
		end
	end)
end


function startUpdate()
	ManualUpdate = false
	setTimer(function()
		outputDebugString("[NativeUI]Requesting Update Data (From github)...")
		fetchRemote("https://raw.githubusercontent.com/Allerek/MTASA-NativeUI/master/meta.xml",function(data,err)
			if err == 0 then
				outputDebugString("[DGS]Update Data Acquired")
				if fileExists("updated/meta.xml") then
					fileDelete("updated/meta.xml")
				end
				local meta = fileCreate("updated/meta.xml")
				fileWrite(meta,data)
				fileClose(meta)
				outputDebugString("[NativeUI]Requesting Verification Data...")
				getGitHubTree()
			else
				outputDebugString("[NativeUI]!Can't Get Remote Update Data (ERROR:"..err..")",2)
			end
		end)
	end,50,1)
end

addCommandHandler("updatenative",function(player)
	local account = getPlayerAccount(player)
	local accName = getAccountName(account)
	local isAdmin = isObjectInACLGroup("user."..accName,aclGetGroup("Admin")) or isObjectInACLGroup("user."..accName,aclGetGroup("Console"))
	if isAdmin then
		outputDebugString("[NativeUI]Player "..getPlayerName(player).." attempt to update native (Allowed)")
		outputDebugString("[NativeUI]Preparing for updating native")
		outputChatBox("[NativeUI]Preparing for updating native",root,0,255,0)
		if RemoteVersion > Version then
			startUpdate()
		else
			ManualUpdate = true
			checkUpdate()
		end
	else
		outputChatBox("[NativeUI]Access Denined!",player,255,0,0)
		outputDebugString("[NativeUI]Player "..getPlayerName(player).." attempt to update native (Denied)!",2)
	end
end)


addEventHandler("onResourceStart",resourceRoot,function()
    checkUpdate()
end)


preUpdate = {}
fileHash = {}
preUpdateCount = 0
UpdateCount = 0
FetchCount = 0
preFetch = 0
folderGetting = {}
function getGitHubTree(path,nextPath)
	nextPath = nextPath or ""
	fetchRemote(path or "https://api.github.com/repos/Allerek/MTASA-NativeUI/git/trees/master",function(data,err)
		if err == 0 then
			local theTable = fromJSON(data)
			folderGetting[theTable.sha] = nil
			for k,v in pairs(theTable.tree) do
				if v.path ~= "meta.xml" then
				local thePath = nextPath..(v.path)
					if v.mode == "040000" then
						folderGetting[v.sha] = true
						getGitHubTree(v.url,thePath.."/")
					else
						fileHash[thePath] = v.sha
					end
				end
			end
			if not next(folderGetting) then
				checkFiles()
			end
		else
			outputDebugString("[NativeUI]Failed To Get Verification Data, Please Try Again Later (API Cool Down 60 mins)!",2)
		end
	end)
end

function checkFiles()
	local xml = xmlLoadFile("updated/meta.xml")
	for k,v in pairs(xmlNodeGetChildren(xml)) do
		if xmlNodeGetName(v) == "script" or xmlNodeGetName(v) == "file" then
			local path = xmlNodeGetAttribute(v,"src")
			if path ~= "meta.xml" then
				local sha = ""
				if fileExists(path) then
					local file = fileOpen(path)
					local size = fileGetSize(file)
					local text = fileRead(file,size)
					fileClose(file)
					sha = hash("sha1","blob " .. size .. "\0" ..text)
				end
				if sha ~= fileHash[path] then
					outputDebugString("[NativeUI]Update Required: ("..path..")")
					table.insert(preUpdate,path)
				end
			end
		end
	end
	DownloadFiles()
end

function DownloadFiles()
	UpdateCount = UpdateCount + 1
	if not preUpdate[UpdateCount] then
		DownloadFinish()
		return
	end
	outputDebugString("[NativeUI]Requesting ("..UpdateCount.."/"..(#preUpdate or "Unknown").."): "..tostring(preUpdate[UpdateCount]).."")
	fetchRemote("https://raw.githubusercontent.com/Allerek/MTASA-NativeUI/master/"..preUpdate[UpdateCount],function(data,err,path)
		if err == 0 then
			local size = 0
			if fileExists(path) then
				local file = fileOpen(path)
				size = fileGetSize(file)
				fileClose(file)
				fileDelete(path)
			end
			local file = fileCreate(path)
			fileWrite(file,data)
			local newsize = fileGetSize(file)
			fileClose(file)
			outputDebugString("[DGS]File Got ("..UpdateCount.."/"..#preUpdate.."): "..path.." [ "..size.."B -> "..newsize.."B ]")
		else
			outputDebugString("[DGS]Download Failed: "..path.." ("..err..")!",2)
		end
		if preUpdate[UpdateCount+1] then
			DownloadFiles()
		else
			DownloadFinish()
		end
	end,"",false,preUpdate[UpdateCount])
end

function DownloadFinish()
	outputDebugString("[NativeUI]Changing Config File")
	if fileExists("update.cfg") then
		fileDelete("update.cfg")
	end
	local file = fileCreate("update.cfg")
	fileWrite(file,tostring(RemoteVersion))
	fileClose(file)
	if fileExists("meta.xml") then
		fileDelete("meta.xml")
	end
	outputDebugString("[NativeUI]Update Complete (Updated "..#preUpdate.." Files)")
	outputDebugString("[NativeUI]Please Restart NativeUI")
	outputChatBox("[NativeUI]Update Complete (Updated "..#preUpdate.." Files)",root,0,255,0)
	preUpdate = {}
	preUpdateCount = 0
	UpdateCount = 0
	FetchCount = 0
	preFetch = 0
end
