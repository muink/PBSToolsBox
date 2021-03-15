Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = oWS.ExpandEnvironmentStrings("%shortcut%")
Set oLink = oWS.CreateShortcut(sLinkFile)
oLink.TargetPath = oWS.ExpandEnvironmentStrings("%symlnk%")
oLink.Arguments = oWS.ExpandEnvironmentStrings("%args%")
oLink.WorkingDirectory = oWS.ExpandEnvironmentStrings("%workdir%")
oLink.HotKey = ""
oLink.Description = ""
oLink.IconLocation = oWS.ExpandEnvironmentStrings("%icon%")
oLink.Save
