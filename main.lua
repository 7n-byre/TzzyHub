-- [[ Tzzy Hub | VERSÃO BLINDADA ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local Webhook_URL = "https://discord.com/api/webhooks/1498063422657400863/xW3OVmmfUooDLnXd-tPCr30eixgAvQB1qIRfxrc32JVaSHw3nHvMmfG1l9DsXedrOXJX"

-- // CONFIGURAÇÕES BLINDADAS // --
_G.GlideEnabled = false
_G.GlideSpeed = 2.2
_G.FlyEnabled = false
_G.FlySpeed = 2.5
_G.AutoLixo = false
_G.BoxEsp = false

local lixosColetados = {}

-- // BANCO DE KEYS // --
local KeysValidas = {
    ["TZZY-A1B2"] = {dia = 28, mes = 4}, ["TZZY-C3D4"] = {dia = 28, mes = 4},
    ["TZZY-E5F6"] = {dia = 28, mes = 4}, ["TZZY-G7H8"] = {dia = 28, mes = 4},
    ["TZZY-I9J0"] = {dia = 28, mes = 4}, ["TZZY-K1L2"] = {dia = 28, mes = 4},
    ["TZZY-M3N4"] = {dia = 28, mes = 4}, ["TZZY-O5P6"] = {dia = 28, mes = 4},
    ["TZZY-Q7R8"] = {dia = 28, mes = 4}, ["TZZY-S9T0"] = {dia = 28, mes = 4}
}

-- // LOGS COM CONTADOR // --
local function SendLog(status, key)
    local expira = "Permanente"
    if KeysValidas[key] then expira = string.format("%02d/%02d/2026", KeysValidas[key].dia, KeysValidas[key].mes) end
    pcall(function()
        local data = {
            ["embeds"] = {{
                ["title"] = "🚀 Log de Acesso | Tzzy Hub",
                ["color"] = status == "Acesso Permitido" and 65280 or 16711680,
                ["fields"] = {
                    {["name"] = "Jogador:", ["value"] = lp.Name, ["inline"] = true},
                    {["name"] = "Key:", ["value"] = key, ["inline"] = true},
                    {["name"] = "Status:", ["value"] = status, ["inline"] = false},
                    {["name"] = "Expira em:", ["value"] = expira, ["inline"] = false}
                }
            }}
        }
        request({Url = Webhook_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(data)})
    end)
end

-- // JANELA PRINCIPAL // --
local Window = Rayfield:CreateWindow({
   Name = "Tzzy Hub | Oficial 7n",
   LoadingTitle = "Carregando Funções Blindadas...",
   LoadingSubtitle = "By 7n / 7zada",
   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Key",
      Key = {"TZZY-ADMIN-7N", "TZZY-A1B2", "TZZY-C3D4", "TZZY-E5F6", "TZZY-G7H8", "TZZY-I9J0", "TZZY-K1L2", "TZZY-M3N4", "TZZY-O5P6", "TZZY-Q7R8", "TZZY-S9T0"},
      Actions = {
         OnEnter = function(v)
            local d = os.date("*t")
            if v == "TZZY-ADMIN-7N" then SendLog("Acesso Permitido", v)
            elseif KeysValidas[v] and (d.month < KeysValidas[v].mes or (d.month == KeysValidas[v].mes and d.day <= KeysValidas[v].dia)) then SendLog("Acesso Permitido", v)
            else SendLog("Acesso Negado/Expirado", v) lp:Kick("Key Inválida!") end
         end
      }
   }
})

-- // MOVIMENTAÇÃO (BLINDADA) // --
local TabMov = Window:CreateTab("Movimentação")
TabMov:CreateToggle({Name = "Speed Glide", CurrentValue = false, Callback = function(v) _G.GlideEnabled = v end})
TabMov:CreateSlider({Name = "Velocidade Glide", Range = {1, 15}, Increment = 0.5, CurrentValue = 2.2, Callback = function(v) _G.GlideSpeed = v end})
TabMov:CreateToggle({Name = "Fly Stealth", CurrentValue = false, Callback = function(v) _G.FlyEnabled = v end})

runService.RenderStepped:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if hrp and hum then
        if _G.GlideEnabled and not _G.FlyEnabled and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.GlideSpeed / 6))
        end
        if _G.FlyEnabled then
            hum:ChangeState(11)
            hrp.Velocity = hum.MoveDirection.Magnitude > 0 and camera.CFrame.LookVector * (_G.FlySpeed * 50) or Vector3.new(0, 1.5, 0)
        end
    end
end)

-- // AUTO FARM LIXO (V2.2 ANTI-STUCK) // --
local TabFarm = Window:CreateTab("Auto Farm")
TabFarm:CreateToggle({Name = "Auto Lixo 2.2", CurrentValue = false, Callback = function(v) _G.AutoLixo = v end})

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoLixo and lp.Character then
            for _, v in pairs(workspace:GetDescendants()) do
                if not _G.AutoLixo then break end
                if v:IsA("ProximityPrompt") and (v.ObjectText:lower():find("lixo") or v.ActionText:lower():find("lixo")) then
                    if not lixosColetados[v] then
                        local hrp = lp.Character.HumanoidRootPart
                        local target = v.Parent:IsA("BasePart") and v.Parent or v.Parent:FindFirstChildWhichIsA("BasePart")
                        if target then
                            local lastPos = hrp.Position
                            while _G.AutoLixo and (hrp.Position - target.Position).Magnitude > 4 do
                                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target.Position + Vector3.new(0, 2, 0)), 0.15)
                                task.wait(0.05)
                                -- Anti-Stuck: Se a posição não mudar, ele pula
                                if (hrp.Position - lastPos).Magnitude < 0.1 then lp.Character.Humanoid.Jump = true end
                                lastPos = hrp.Position
                            end
                            fireproximityprompt(v)
                            lixosColetados[v] = true
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end
end)

-- // VISUAL (ESP QUADRADO) // --
local TabVisual = Window:CreateTab("Visual")
TabVisual:CreateToggle({Name = "ESP Box (Quadrado)", CurrentValue = false, Callback = function(v) _G.BoxEsp = v end})

local function CreateEsp(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1
    box.Filled = false

    runService.RenderStepped:Connect(function()
        if _G.BoxEsp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= lp then
            local pos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local size = (camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)).Y)
                box.Size = Vector2.new(math.abs(size/2), math.abs(size))
                box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                box.Visible = true
            else box.Visible = false end
        else box.Visible = false end
    end)
end
for _, p in pairs(game.Players:GetPlayers()) do CreateEsp(p) end
game.Players.PlayerAdded:Connect(CreateEsp)

Rayfield:Notify({Title = "Tzzy Hub", Content = "Sistema 100% Operacional!", Duration = 5})
