local drive = require("googleDrive")
local json = require("json")
local canMakeRequest = false
--drive.onlyAppAccess(true) --configure at will
drive.init("clientId", "clientSecret", "redirectUrl")

local signOutButton
local requestButton

local loginButton = display.newGroup()
loginButton.box = display.newRoundedRect( loginButton,0, 0, 100, 50, 10 )
loginButton.myText = display.newText( loginButton, "Login", 0, 0 , native.systemFont , 15 )
loginButton.myText:setFillColor( 0 )
loginButton.x, loginButton.y =  display.contentCenterX, display.contentCenterY
loginButton.alpha = 1
loginButton.box:addEventListener( "tap", function ( event )
	local function driveLis( e )
		print(e.error)
		if (not e.error) then
			canMakeRequest = true
			signOutButton.alpha = 1
			requestButton.alpha = 1
			loginButton.alpha = 0
		end
	end

	drive.login(driveLis)
end)

requestButton = display.newGroup()
requestButton.box = display.newRoundedRect( requestButton,0, 0, 100, 50, 10 )
requestButton.myText = display.newText( requestButton, "Request", 0, 0 , native.systemFont , 15 )
requestButton.myText:setFillColor( 0 )
requestButton.x, requestButton.y =  display.contentCenterX, display.contentCenterY-100
requestButton.alpha = 0
requestButton.box:addEventListener( "tap", function ( e )
	--upload image
	--[[
	local fileName = "arrow.png"
	drive.request("https://www.googleapis.com/upload/drive/v3/files/", "POST", function ( e )
		print(e.response)
	end, {uploadType= "multipart"}, {name = fileName}, fileName, system.ResourceDirectory, "image/png", fileName )
	--]]
	--delete file
	--[[
	local fileId = "0B5swSg-cH4L6cjdTWU94RTNDR0E"
	drive.request("https://www.googleapis.com/upload/drive/v3/files/"..fileId, "DELETE", function ( e )
		print(e.response)
	end, {fileId= fileId} )
	]]--
	--update file
	--[[
	local fileId = "0B5swSg-cH4L6cjdTWU94RTNDR0E"
	local fileName = "arrow.png"
	drive.request("https://www.googleapis.com/upload/drive/v3/files/"..fileId, "PATCH", function ( e )
		print(e.response)
	end, {fileId= fileId, uploadType= "multipart"}, {name = fileName}, fileName, system.ResourceDirectory, "image/png", fileName )
	]]--
	--list file(s)
	--[[
	drive.request("https://www.googleapis.com/drive/v3/files/", "GET", function ( e )
		print(e.response)
	end, {orderBy ="modifiedTime"} )
	]]--
	--download file
	--[[
	local fileId = ""
	drive.download(fileId, nil, function ( e )
		print(e.response)
	end ,"arrow.png", system.TemporaryDirectory)
	--]]
	-------------
	----app folder requests
	--please note on format I recommend the ones google likes (https://developers.google.com/drive/v3/web/manage-downloads#downloading_google_documents)
	---upload file to app data
	--drive.createFileInAppData("arrow.png", nil--[[ default is system.ResourceDirectory ]], "image/png", function ( e )
	--	print( e.response )
	--end )
	--list files in app data
	--drive.listFilesInAppData(function ( e )
	--	print( e.response )
	--end)
	--update files in app data
	--local fileId = ""
	--drive.updateFileInAppData(fileId,"arrow.png", nil--[[ default is system.ResourceDirectory ]], "application/vnd.google-apps.script+json", function ( e )
	--	print( e.response )
	--end )
	--what about deleting and downloading? they are the same request above
	--download file
	--local fileId = ""
	--drive.download(fileId, nil, function ( e )
	--	print(json.encode(e))
	--end ,"arrow.png", system.TemporaryDirectory)
end )

signOutButton = display.newGroup()
signOutButton.box = display.newRoundedRect( signOutButton,0, 0, 100, 50, 10 )
signOutButton.myText = display.newText( signOutButton, "Sign Out", 0, 0 , native.systemFont , 15 )
signOutButton.myText:setFillColor( 0 )
signOutButton.x, signOutButton.y =  display.contentCenterX, display.contentCenterY+100
signOutButton.alpha = 0
signOutButton.box:addEventListener( "tap", function ( e )
	drive.signOut(function ( event )
		if not event.error then
			signOutButton.alpha = 0
			requestButton.alpha = 0
			loginButton.alpha = 1
			canMakeRequest = false
		end
	end)
end )