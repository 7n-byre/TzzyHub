-- Copia o link do Discord automaticamente ao executar
setclipboard("https://discord.gg/Mge64THGmc")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Função para enviar Logs ao Webhook
local function SendWebhookLog(keyUsed)
    local player = game.Players.LocalPlayer
    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 Novo Acesso ao Script!",
            ["color"] = 65280,
            ["fields"] = {
                {["name"] = "Jogador", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
                {["name"] = "Perfil", ["value"] = "https://www.roblox.com/users/"..player.UserId.."/profile"},
                {["name"] = "Key Utilizada", ["value"] = keyUsed, ["inline"] = false}
            },
            ["footer"] = {["text"] = "Tzzy Hub | Log de Acesso"}
        }}
    }
    local jsonData = game:GetService("HttpService"):JSONEncode(data)
    local request = (syn and syn.request) or (http and http.request) or http_request or request
    if request then
        request({
            Url = "https://discord.com/api/webhooks/1498087867329675305/Bw9zMvv7W-lBV1D_sj5siUyRO1Uc-DX3VKQwa8miQCl53F3tP-Y2KpHLPf-5kuJZouH3",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = jsonData
        })
    end
end

local Window = Rayfield:CreateWindow({
   Name = "Tzzy Hub | Sintonia Rp",
   LoadingTitle = "Filtro de Arsenal Ativado",
   LoadingSubtitle = "By 7n / 7zada",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Chaves",
      Subtitle = "Acesso Restrito",
      Note = "Compre Key No Nosso Discord: https://discord.gg/Mge64THGmc",
      FileName = "TzzyKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"TZZY-ADMIN-7N", "TZZY-777-X1", "TZZY-888-Y2", "TZZY-999-Z3", "TZZY-111-A4", "TZZY-222-B5", "TZZY-333-C6", "TZZY-444-D7", "TZZY-555-E8", "TZZY-666-F9", "TZZY-000-G0"}
   }
})

-- Log de acesso
SendWebhookLog("Key Validada")

-- // CONFIGURAÇÕES GLOBAIS // --
local _G = {
    GlideEnabled = false,
    GlideSpeed = 2,
    FlyEnabled = false,
    FlySpeed = 2.5,
    AutoLoot = false,
    BoxEsp = false,
    AimbotEnabled = false,
    AimbotSmoothing = 5,
    FOVRadius = 150,
    AutoFarmLixo = false,
    LixoSpeed = 7
}

local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local LixosColetados = {}
local targetLixo = nil
local coletando = false

-- Limpeza periódica da lista de ignorados para garantir o farm infinito
task.spawn(function()
    while true do
        task.wait(60) -- Limpa a lista a cada 1 minuto para poder re-coletar lixos que deram respawn
        LixosColetados = {}
    end
end)

-- // LÓGICA DE AUTO FARM MELHORADA // --
runService.RenderStepped:Connect(function()
    if _G.AutoFarmLixo then
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hrp and hum then
            -- Busca novo alvo se não tiver um ou se o atual sumiu
            if not targetLixo or not targetLixo.Parent or not targetLixo.Enabled then
                targetLixo = nil
                coletando = false
                local shortestDist = math.huge
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled and not LixosColetados[v] then
                        local name = (v.ObjectText .. v.ActionText .. v.Parent.Name):lower()
                        if name:find("lixo") or name:find("recicl") then
                            local pos = v.Parent:IsA("Model") and v.Parent:GetModelCFrame().p or v.Parent:IsA("BasePart") and v.Parent.Position
                            if pos then
                                local dist = (hrp.Position - pos).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    targetLixo = v
                                end
                            end
                        end
                    end
                end
            end

            if targetLixo and not coletando then
                local targetPos = targetLixo.Parent:IsA("Model") and targetLixo.Parent:GetModelCFrame().p or targetLixo.Parent.Position
                local distance = (hrp.Position - targetPos).Magnitude

                if distance > 2.2 then
                    -- Movimentação em direção ao lixo
                    local direction = (targetPos - hrp.Position).Unit
                    hrp.CFrame = hrp.CFrame + (direction * (_G.LixoSpeed / 7))
                    
                    if hrp.Velocity.Magnitude < 0.1 then
                        hum.Jump = true
                    end
                else
                    -- Chegou: Coleta e marca como coletado
                    coletando = true
                    fireproximityprompt(targetLixo)
                    
                    task.spawn(function()
                        task.wait(0.5) -- Tempo de espera para o script reconhecer a coleta
                        LixosColetados[targetLixo] = true
                        targetLixo = nil
                        coletando = false
                    end)
                end
            end
        end
    end
end)

-- // MOVIMENTAÇÃO ORIGINAL // --
runService.RenderStepped:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if hrp and hum then
        if _G.GlideEnabled and not _G.FlyEnabled and not _G.AutoFarmLixo then
            if hum.MoveDirection.Magnitude > 0 then
                local alpha = _G.GlideSpeed > 8 and 8 or 6
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.GlideSpeed / alpha))
            end
        end
        if _G.FlyEnabled then
            hum:ChangeState(11)
            if hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = camera.CFrame.LookVector * (_G.FlySpeed * 48)
            else
                hrp.Velocity = Vector3.new(0, 1.5, 0)
            end
        end
    end
end)

-- // AUTO LOOT ORIGINAL // --
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoLoot and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local rawText = (v.ObjectText .. v.ActionText .. v.Parent.Name):lower()
                    local cleanText = rawText:gsub("%s+", "") 
                    local isIlegal = false
                    for _, key in pairs({"dinheirosujo", "glock", "ak47", "fuzil", "pistola", "maconha", "coca", "droga", "algema", "lockpick", "colete"}) do
                        if cleanText:find(key) then isIlegal = true break end
                    end
                    if isIlegal then
                        local item = v.Parent
                        local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                        if targetPart then
                            root.CFrame = targetPart.CFrame 
                            fireproximityprompt(v)
                            lp:Kick("Você Coletou Um Item 🍀")
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- // ABAS // --
local TabFarm = Window:CreateTab("Auto Farm")
TabFarm:CreateToggle({Name = "Auto Farm Lixo", CurrentValue = false, Callback = function(v) _G.AutoFarmLixo = v end})
TabFarm:CreateSlider({Name = "Velocidade Farm", Range = {1, 15}, Increment = 0.5, CurrentValue = 7, Callback = function(v) _G.LixoSpeed = v end})

local TabMov = Window:CreateTab("Movimentação")
TabMov:CreateToggle({Name = "Speed Glide", CurrentValue = false, Callback = function(v) _G.GlideEnabled = v end})
TabMov:CreateSlider({Name = "Velocidade Speed", Range = {1, 15}, Increment = 0.5, CurrentValue = 2, Callback = function(v) _G.GlideSpeed = v end})

local TabVisual = Window:CreateTab("Visual & Combat")
TabVisual:CreateToggle({Name = "Aimbot Suave", CurrentValue = false, Callback = function(v) _G.AimbotEnabled = v end})

local TabRoubo = Window:CreateTab("Auto Loot")
TabRoubo:CreateToggle({Name = "VAI PEGA E KITA", CurrentValue = false, Callback = function(v) _G.AutoLoot = v end})
