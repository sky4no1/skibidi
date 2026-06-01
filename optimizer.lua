local self = {}

function self.Optimizer()
	local UserGameSettings = UserSettings():FindService("UserGameSettings") or UserSettings():GetService("UserGameSettings")
    local Lighting = cloneref(game:GetService('Lighting'))
    local Workspace = cloneref(game:GetService('Workspace'))
	local StarterGui = cloneref(game:GetService("StarterGui"))
	local Terrain = Workspace.Terrain
    local Optimizer = {}

    local disableEffects = function()
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
		Terrain:Clear()

		Lighting.Brightness = 0
		Lighting.GlobalShadows = false
		Lighting.PrioritizeLightingQuality = false
		Lighting.LightingStyle = Enum.LightingStyle.Soft
    	Lighting.FogEnd = 9e9

		if #Lighting:GetChildren() > 0 then
			for i, v in Lighting:GetChildren() do
				v:Destroy()
			end
		end
	end

	local disableSettings = function()
		-- Render Settings
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		settings().Rendering.ShowBoundingBoxes = false
		settings().Rendering.RenderCSGTrianglesDebug = false
		settings().Rendering.MeshCacheSize = 0
		settings().Rendering.GraphicsMode = Enum.GraphicsMode.NoGraphics
		settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
		settings().Rendering.EagerBulkExecution = false
		settings().Rendering.EnableFRM = true
		settings().Rendering.AutoFRMLevel = 0
		settings().Rendering.ExportMergeByMaterial = false
		settings().Rendering.ReloadAssets = false 
		settings().Rendering.MeshPartDetailLevel = "Level00"
		settings().Rendering.QualityLevel = "Level01"
		settings().Rendering.EditQualityLevel = "Level01"

		-- User Game Settings
		UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
		UserGameSettings.HasEverUsedVR = false 
		UserGameSettings.ChatVisible = false
		UserGameSettings.AllTutorialsDisabled = false
		UserGameSettings.Fullscreen = false
		UserGameSettings.GraphicsQualityLevel = 0
		UserGameSettings.SavedQualityLevel = 0 
		UserGameSettings.MasterVolume = 0

		--Physics Settings 
		settings()['Physics'].AllowSleep = true 
		settings()['Physics'].AreAnchorsShown = false 
		settings()['Physics'].AreAssembliesShown = false 
		settings()['Physics'].AreAssemblyCentersOfMassShown = false 
		settings()['Physics'].AreAwakePartsHighlighted = false 
		settings()['Physics'].AreBodyTypesShown = false 
		settings()['Physics'].AreCollisionCostsShown = false 
		settings()['Physics'].AreConstraintForcesShownForSelectedOrHoveredInstances = false 
		settings()['Physics'].AreContactForcesShownForSelectedOrHoveredAssemblies = false 
		settings()['Physics'].AreContactIslandsShown = false 
		settings()['Physics'].AreContactPointsShown = false 
		settings()['Physics'].AreJointCoordinatesShown = false 
		settings()['Physics'].AreMagnitudesShownForDrawnForcesAndTorques = false 
		settings()['Physics'].AreMechanismsShown = false 
		settings()['Physics'].AreModelCoordsShown = false 
		settings()['Physics'].AreOwnersShown = false 
		settings()['Physics'].ArePartCoordsShown = false 
		settings()['Physics'].AreRegionsShown = false 
		settings()['Physics'].AreSolverIslandsShown = false 
		settings()['Physics'].AreTerrainReplicationRegionsShown = false 
		settings()['Physics'].AreTimestepsShown = false 
		settings()['Physics'].AreUnalignedPartsShown = false 
		settings()['Physics'].AreWorldCoordsShown = false 
		settings()['Physics'].DisableCSGv2 = true 
		settings()['Physics'].ForceDrawScale = 0 
		settings()['Physics'].IsInterpolationThrottleShown = false 
		settings()['Physics'].IsReceiveAgeShown = false 
		settings()['Physics'].IsTreeShown = false 
		settings()['Physics'].PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
		settings()['Physics'].ShowDecompositionGeometry = false 
		settings()['Physics'].ThrottleAdjustTime = 1

		-- Network Settings
		settings().Network.PrintPhysicsErrors = false
		settings().Network.PrintJoinSizeBreakdown = false
		settings().Network.PrintStreamInstanceQuota = false
		settings().Network.RandomizeJoinInstanceOrder = false
		settings().Network.RenderStreamedRegions = false
		settings().Network.ShowActiveAnimationAsset = false

		-- Other shit
		StarterGui:SetCore("TopbarEnabled", false)
    	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    	local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
    	if sethidden then
			sethidden(Lighting, "Technology", 2)
    		sethidden(Terrain, "Decoration", false)
		end
	end

	local disableInstances = function()
		local function disable(v)
			if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("SpotLight") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
				v.Enabled = false
			elseif v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") or v:IsA("BasePart") then 
				v.Material = "Plastic"
				v.Reflectance = 0
			elseif v:IsA("Decal") or v:IsA("Texture") then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0,0)
			elseif v:IsA("MeshPart") then
				v.RenderFidelity = Enum.RenderFidelity.Performance
				v.Material = "Plastic"
				v.Reflectance = 0
				v.TextureID = "rbxassetid://10385902758728957"
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			end
		end

		for _, v in pairs(game:GetDescendants()) do
			disable(v)
		end

		Workspace.DescendantAdded:Connect(function(v)
            disable(v)
        end)
	end

    function Optimizer.startOptimize()
        disableSettings()
        disableEffects()
        disableInstances()
    end

    return Optimizer
end

return self
