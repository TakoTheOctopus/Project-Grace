local Quake = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/quake/src"))()

local Window = Quake:Window({
    Title = "🐾 Pet Catchers! [🤝TRADING]",
    isMobile = true
})

local PetsTab = Window:Tab({
    Name = "Pets",
    tabColor = Color3.new(1, 1, 1),
    Image = "rbxassetid://13266029052"
})

local Label = PetsTab:Label("Capture")
Label:SetText("Capture")

local selectedStars = 0
local selectedCube 

local Dropdown = PetsTab:Dropdown({
    Name = "Star Count",
    Items = {1, 2, 3, 4},
    Multiselect = false,
    Default = "",
    Callback = function(value)
        selectedStars = value
    end
})

local Dropdown = PetsTab:Dropdown({
    Name = "Select Cube",
    Items = {"Common", "Rare", "Epic", "Legendary"},
    Multiselect = false,
    Default = "",
    Callback = function(value)
        selectedCube = value
    end
})

local enabled = false

local Toggle = PetsTab:Toggle({
    Name = "Auto Capture",
    Default = false,
    Callback = function(value)
        enabled = value
        while enabled do
            local pet = nil
            if game:GetService("Workspace").Rendered.Pets.World then
                local closestDistance = math.huge
                for _, child in ipairs(game:GetService("Workspace").Rendered.Pets.World:GetChildren()) do
                    local hitbox = child:FindFirstChild("Hitbox")
                    if hitbox then
                        local hitboxPosition = hitbox.Position
                        local visibleCount = 0
                        local petGui = hitbox:FindFirstChild("WorldPetGui")
                        if petGui then
                            local stars = petGui:FindFirstChild("Stars")
                            if stars then
                                for _, label in ipairs(stars:GetChildren()) do
                                    if label:IsA("ImageLabel") and label.Visible == true then
                                        visibleCount = visibleCount + 1
                                    end
                                end
                            end
                        end
                        if visibleCount == selectedStars then
                            local distance = (hitboxPosition - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                pet = child
                            end
                        end
                    end
                end
            end
            if pet then
                local cube = nil
                if selectedCube == "Common" then
                    cube = "Common"
                elseif selectedCube == "Rare" then
                    cube = "Rare"
                elseif selectedCube == "Epic" then
                    cube = "Epic"
                elseif selectedCube == "Legendary" then
                    cube = "Legendary"
                end
                if cube then
                    local args = {
                        [1] = "CapturePet",
                        [2] = pet.Name,
                        [3] = cube
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function"):InvokeServer(unpack(args))
                end
            end
            wait(0.1)
        end
    end
})

local enabled = false

local Toggle = PetsTab:Toggle({
    Name = "Search For Legendary",
    Default = false,
    Callback = function(value)
        enabled = value
        while enabled do
            task.wait(1)
            if game:GetService("Workspace").Rendered.Pets.World then
                local closestDistance = math.huge
                local closestPet = nil
                
                for _, child in ipairs(game:GetService("Workspace").Rendered.Pets.World:GetChildren()) do
                    local hitbox = child:FindFirstChild("Hitbox")
                    if hitbox then
                        local petGui = hitbox:FindFirstChild("WorldPetGui")
                        local stars = petGui and petGui:FindFirstChild("Stars")
                        if stars then
                            local visibleCount = 0
                            for _, label in ipairs(stars:GetChildren()) do
                                if label:IsA("ImageLabel") and label.Visible == true then
                                    visibleCount = visibleCount + 1
                                end
                            end
                            if visibleCount == 4 then
                                local hitboxPosition = hitbox.Position
                                local distance = (hitboxPosition - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestPet = hitbox
                                end
                            end
                        end
                    end
                end
                
                if closestPet then
                    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(closestPet.Position))
                end
            end
        end            
    end
})

local Label = PetsTab:Label("Delete")
Label:SetText("Delete")

local selectedDeleteValue
local enabled = false

local Dropdown = PetsTab:Dropdown({
    Name = "Delete Maximum Star Count",
    Multiselect = false,
    Items = {1, 2, 3},
    Default = "",
    Callback = function(value)
        selectedDeleteValue = value
    end
})

local Toggle = PetsTab:Toggle({
    Name = "Auto Delete",
    Default = false,
    Callback = function(value)
        enabled = value
        if enabled then
            while enabled do
                wait(1) 
                local player = game:GetService("Players").LocalPlayer
                local playerGui = player.PlayerGui
                local inventory = playerGui.ScreenGui.Inventory.Frame.Main.Content.Pets.Grid.Content

                if inventory then
                    for _, frame in ipairs(inventory:GetChildren()) do
                        if frame:IsA("Frame") then
                            for _, child in ipairs(frame:GetChildren()) do
                                if child:IsA("ImageButton") and child.Name == "Button" then
                                    local stars = child:FindFirstChild("Stars")
                                    if stars then
                                        local starCount = 0
                                        for _, star in ipairs(stars:GetChildren()) do
                                            if star:IsA("ImageLabel") and star.Visible then
                                                starCount = starCount + 1
                                            end
                                        end
                                        if starCount <= selectedDeleteValue then
                                            local args = {
                                                [1] = "MultiDelete",
                                                [2] = {
                                                    [1] = child.Parent.Name
                                                }
                                            }

                                            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
})

local CraftTab = Window:Tab({
    Name = "Crafting",
    tabColor = Color3.new(1, 1, 1),
    Image = "rbxassetid://13266029052"
})

local Label = CraftTab:Label("Craft")
Label:SetText("Craft")

local slot = 0
local selectedItem = nil
local amount = 0
local enabled = false

local textbox = CraftTab:TextBox({
    Name = "Crafting Slot",
    Default = "0",
    Callback = function(value)
        slot = tonumber(value)
    end
})

local Dropdown = CraftTab:Dropdown({
    Name = "Select Item",
    Items = {"Rare Cube", "Epic Cube", "Legendary Cube", "Mystery Egg", "Elite Mystery Egg", "Coin Elixer", "XP Elixer", "Sea Elixer"},
    Multiselect = false,
    Default = "",
    Callback = function(value)
        selectedItem = value
        if selectedItem == "Rare Cube" then
            item = "rare-cube"
        elseif selectedItem == "Epic Cube" then
            item = "epic-cube"
        elseif selectedItem == "Legendary Cube" then
            item = "legendary-cube"
        elseif selectedItem == "Mystery Egg" then
            item = "mystery-egg"
        elseif selectedItem == "Elite Mystery Egg" then
            item = "elite-mystery-egg"
        elseif selectedItem == "Coin Elixer" then
            item = "coin-elixer"
        elseif selectedItem == "XP Elixer" then
            item = "xp-elixer"
        elseif selectedItem == "Sea Elixer" then
            item = "sea-elixer"
        end
    end
})

local textbox = CraftTab:TextBox({
    Name = "Amount To Craft",
    Default = "0",
    Callback = function(value)
        amount = tonumber(value)
    end
})

local Toggle = CraftTab:Toggle({
    Name = "Auto Craft",
    Default = false,
    Callback = function(value)
        enabled = value
        if enabled then
            AutoCraft()
            wait(0.1)
        end
    end
})

function AutoCraft()
    if enabled and selectedItem then
        local args = {
            [1] = "StartCrafting",
            [2] = slot,
            [3] = item,
            [4] = amount
        }
    
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))
    end
end
