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
local lastPos = Vector3.new(0,0,0)
local stuckTimer = 0

local IlegalKeywords = {"dinheirosujo", "dinheiro sujo", "glock", "g18", "ak47", "ak-47", "fuzil", "m4a1", "pistola", "revolver", "dmr", "desert", "deagle", "money", "saco", "maleta", "maconha", "coca", "droga", "tablete", "trouxa", "lsd", "crack", "meta", "algema", "lockpick", "colete", "munição", "pente"}
local BlacklistKeywords = {"arsenal", "equipar", "pegar", "policia", "pm", "civil", "prf", "guardar", "bancada", "abrir"}

-- // LÓGICA DE AUTO FARM (INFINITO E RESISTENTE) // --
runService.RenderStepped:Connect(function()
    if _G.AutoFarmLixo then
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hrp and hum then
            -- Verifica se o char travou
            if (hrp.Position - lastPos).Magnitude < 0.1 and not coletando then
                stuckTimer = stuckTimer + 1
                if stuckTimer > 60 then 
                    hum.Jump = true
                    stuckTimer = 0
                end
            else
                stuckTimer = 0
            end
            lastPos = hrp.Position

            -- Busca novo alvo
            if not targetLixo or not targetLixo.Parent or not targetLixo.Enabled then
                targetLixo = nil
                coletando = false
                local shortestDist = math.huge
                local encontrouLixo = false

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and not LixosColetados[v] and v.Enabled then
                        local name = (v.ObjectText .. v.ActionText .. v.Parent.Name):lower()
                        if name:find("lixo") or name:find("recicl") then
                            local pos = v.Parent:IsA("Model") and v.Parent:GetModelCFrame().p or v.Parent:IsA("BasePart") and v.Parent.Position
                            if pos then
                                encontrouLixo = true
                                local dist = (hrp.Position - pos).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    targetLixo = v
                                end
                            end
                        end
                    end
                end

                -- Se não achou nenhum lixo novo, limpa a lista para farmar os mesmos de novo (Infinito)
                if not encontrouLixo and next(LixosColetados) ~= nil then
                    LixosColetados = {}
                end
            end

            if targetLixo and not coletando then
                local targetPos = targetLixo.Parent:IsA("Model") and targetLixo.Parent:GetModelCFrame().p or targetLixo.Parent.Position
                local distance = (hrp.Position - targetPos).Magnitude

                if distance > 2.2 then
                    local direction = (targetPos - hrp.Position).Unit
                    hrp.CFrame = hrp.CFrame + (direction * (_G.LixoSpeed / 6.5))
                else
                    -- FICA PARADO ATÉ COLETAR
                    coletando = true
                    task.spawn(function()
                        while targetLixo and targetLixo.Enabled and targetLixo.Parent do
                            fireproximityprompt(targetLixo)
                            task.wait(0.1) -- Spam rápido para garantir a coleta
                            if (hrp.Position - targetPos).Magnitude > 3 then -- Caso seja empurrado
                                hrp.CFrame = CFrame.new(targetPos)
                            end
                        end
                        LixosColetados[targetLixo] = true
                        targetLixo = nil
                        coletando = false
                    end)
                end
            end
        end
    end
end)

-- // MOVIMENTAÇÃO (MANTIDA) // --
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

-- // AUTO LOOT (MANTIDA) // --
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoLoot and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local rawText = (v.ObjectText .. v.ActionText .. v.Parent.Name):lower()
                    local cleanText = rawText:gsub("%s+", "") 
                    local isIlegal = false
                    local isBanned = false
                    for _, key in pairs(IlegalKeywords) do
                        if cleanText:find(key:gsub("%s+", "")) or rawText:find(key) then
                            isIlegal = true 
                            break 
                        end
                    end
                    for _, bad in pairs(BlacklistKeywords) do
                        if rawText:find(bad) then
                            isBanned = true
                            break
                        end
                    end
                    if isIlegal and not isBanned then
                        local item = v.Parent
                        local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                        if targetPart and targetPart.Size.Magnitude < 10 then
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

-- // ESP E AIMBOT (MANTIDOS) // --
local function ApplyESP(target)
    local pgui = lp:WaitForChild("PlayerGui")
    runService.RenderStepped:Connect(function()
        if _G.BoxEsp and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local bgui = pgui:FindFirstChild("Tzzy_"..target.Name) or Instance.new("BillboardGui", pgui)
            bgui.Name = "Tzzy_"..target.Name
            bgui.Adornee = hrp
            bgui.AlwaysOnTop = true
            bgui.Size = UDim2.new(4, 0, 5.5, 0)
            bgui.MaxDistance = 100000 
            local frame = bgui:FindFirstChild("Main") or Instance.new("Frame", bgui)
            frame.Name = "Main"
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            local stroke = frame:FindFirstChild("Stroke") or Instance.new("UIStroke", frame)
            stroke.Thickness = 2.5
            stroke.Color = Color3.fromRGB(255, 0, 0)
            bgui.Enabled = true
        elseif pgui:FindFirstChild("Tzzy_"..target.Name) then
            pgui:FindFirstChild("Tzzy_"..target.Name).Enabled = false
        end
    end)
end

runService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = nil
        local dist = _G.FOVRadius
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, screen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if screen then
                    local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if mDist < dist then
                        dist = mDist
                        target = p
                    end
                end
            end
        end
        if target then
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position), 1/_G.AimbotSmoothing)
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
TabMov:CreateToggle({Name = "Fly Stealth", CurrentValue = false, Callback = function(v) _G.FlyEnabled = v end})
TabMov:CreateSlider({Name = "Velocidade Fly", Range = {1, 3.5}, Increment = 0.1, CurrentValue = 2.5, Callback = function(v) _G.FlySpeed = v end})

local TabVisual = Window:CreateTab("Visual & Combat")
TabVisual:CreateToggle({Name = "ESP Caixa (Global)", CurrentValue = false, Callback = function(v) 
    _G.BoxEsp = v 
    if v then for _, p in pairs(game.Players:GetPlayers()) do if p ~= lp then ApplyESP(p) end end end
end})
TabVisual:CreateToggle({Name = "Aimbot Suave", CurrentValue = false, Callback = function(v) _G.AimbotEnabled = v end})
TabVisual:CreateSlider({Name = "Suavização Aimbot", Range = {1, 15}, Increment = 1, CurrentValue = 5, Callback = function(v) _G.AimbotSmoothing = v end})

local TabRoubo = Window:CreateTab("Auto Loot")
TabRoubo:CreateToggle({Name = "VAI PEGA E KITA", Info = "Filtro Anti-Arsenal Ativado", CurrentValue = false, Callback = function(v) _G.AutoLoot = v end})

game.Players.PlayerAdded:Connect(function(p) if _G.BoxEsp then ApplyESP(p) end end)
