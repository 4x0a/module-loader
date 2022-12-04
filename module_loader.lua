// Directory that we want to load from.
local baseRoot = "<gamemode_name>/gamemode/modules" // Dont leave a / after the folder you want to load from

local printConsole = false // Do we want the script to print what was loaded in the console

// Print function to see what was loaded
function ml_print(file)
	if printConsole then
		print( "[ML] Loaded: "..file )
	end
end 

function LoadModuleFolder(baseDir)
  // Check if folder specified is valid and exists.
  if not file.Exists(baseDir, "LUA") then 
	error("[Module Loader] Directory does not exist, cannot load!") // Kick error to console 
	return
  else
	baseDir = baseDir.."/"	 
  end
	// setup base root location
  local m_files, m_dirs = file.Find(baseDir.."*", "LUA")

	// loop through folders in specified location.
	for key, loadFile in pairs(m_dirs) do
		local newPath = baseDir .. loadFile
		local findModule = file.Find( newPath.."/*.lua", "LUA", "namedesc")

		// now find all the files within the folders to load.
		for key2, file in pairs(findModule) do
			local fullPath = newPath.."/"..file
			if string.Left(file, 3) == "sv_" then // for SERVER files
				if SERVER then 
					include(fullPath)
					ml_print(file)
				end
			elseif string.Left(file, 3 ) == "sh_" then // for SHARED files
				if SERVER then  
					AddCSLuaFile(fullPath)
					ml_print(file)
				end
				include(fullPath)
			elseif string.Left(file,3) == "cl_" then // for CLIENT files
				if SERVER then 
					AddCSLuaFile(fullPath)
					ml_print(file)
				else
					include(fullPath)
				end
			end
		end
	end
end

// Now we run the function to load whatever we need loaded
LoadModuleFolder(baseRoot) 
