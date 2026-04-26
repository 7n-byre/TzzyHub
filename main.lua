-- [[ Tzzy Hub | VERSÃO 7ZADA COMPLETA ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local Webhook_URL = "https://discord.com/api/webhooks/1498063422657400863/xW3OVmmfUooDLnXd-tPCr30eixgAvQB1qIRfxrc32JVaSHw3nHvMmfG1l9DsXedrOXJX"

-- // INICIALIZAÇÃO DE VARIÁVEIS // --
_G.GlideEnabled = false
_G.GlideSpeed = 2.2
_G.FlyEnabled = false
_G.FlySpeed = 2.5
_G.AutoLoot = false
_G.BoxEsp = false
_G.AimbotEnabled = false
_G.AimbotSmoothing = 5
_G.FOVRadius = 150
_G.AutoLixo = false

local lixosColetados = {}
local IlegalKeywords = {"dinheirosujo", "dinheiro sujo", "glock", "g18", "ak47", "ak-47", "fuzil", "m4a1", "pistola", "revolver", "dmr", "desert", "deagle", "money", "saco", "maleta", "maconha", "coca", "droga", "tablete", "trouxa", "lsd", "crack", "meta", "algema", "lockpick", "colete", "munição", "pente"}
local BlacklistKeywords = {"arsenal", "equipar", "pegar", "policia", "pm", "civil", "prf", "guardar", "bancada", "abrir"}

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
                },
                ["footer"] = {["text"] = os.date("%H:%M:%S")}
            }}
        }
        request({Url = Webhook_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(data)})
    end)
end

-- // CRIAÇÃO DA JANELA // --
local Window = Rayfield:CreateWindow({
   Name = "Tzzy Hub | Sintonia Rp",
   LoadingTitle = "Iniciando Protocolo Tzzy...",
   LoadingSubtitle = "By 7n / 7zada",
   KeySystem = true,
   KeySettings = {
      Title = "Autenticação",
      Key = {"TZZY-ADMIN-7N", "TZZY-A1B2", "TZZY-C3D4", "TZZY-E5F6", "TZZY-G7H8", "TZZY-I9J0", "TZZY-K1L2", "TZZY-M3N4", "TZZY-O5P6", "TZZY-Q7R8", "TZZY-S9T0"},
      Actions = {
         OnEnter = function(v)
            local d = os.date("*t")
            if v == "TZZY-ADMIN-7N" then SendLog("Acesso Permitido", v)
            elseif KeysValidas[v] and (d.month < KeysValidas[v].mes or (d.month == KeysValidas[v].mes and d.day <= KeysValidas[v].dia)) then SendLog("Acesso Permitido", v)
            else SendLog("Negado/Expirado", v) lp:Kick("Key Inválida!") end
         end
      }
   }
})

--- // ABA MOVIMENTAÇÃO // ---
local TabMov = Window:CreateTab("Movimentação")
TabMov:CreateToggle({Name = "Speed Glide", CurrentValue = false, Callback = function(v) _G.GlideEnabled = v end})
TabMov:CreateSlider({Name = "Velocidade Glide", Range = {1, 15}, Increment = 0.5, CurrentValue = 2.2, Callback = function(v) _G.GlideSpeed = v end})
TabMov:CreateToggle({Name = "Fly Stealth", CurrentValue = false, Callback = function(v) _G.FlyEnabled = v end})
TabMov:CreateSlider({Name = "Velocidade Fly", Range = {1, 10}, Increment = 0.5, CurrentValue = 2.5, Callback = function(v) _G.FlySpeed = v end})

--- // ABA AUTO FARM // ---
local TabFarm = Window:CreateTab("Auto Farm")
TabFarm:CreateToggle({Name = "Auto Lixo 2.2", Info = "Anti-Stuck Ativado", CurrentValue = false, Callback = function(v) _G.AutoLixo = v end})

--- // ABA VISUAL & COMBAT // ---
local TabVisual = Window:CreateTab("Visual & Combat")
TabVisual:CreateToggle({Name = "Aimbot Suave", CurrentValue = false, Callback = function(v) _G.AimbotEnabled = v end})
TabVisual:CreateSlider({Name = "Suavização", Range = {1, 15}, Increment = 1, CurrentValue = 5, Callback = function(v) _G.AimbotSmoothing = v end})
TabVisual:CreateToggle({Name = "ESP Box (Global)", CurrentValue = false, Callback = function(v) _G.BoxEsp = v end})

--- // ABA AUTO LOOT // ---
local TabLoot = Window:CreateTab("Auto Loot")
TabLoot:CreateToggle({Name = "VAI PEGA E KITA", Info = "Filtro Ilegal Ativo", CurrentValue = false, Callback = function(v) _G.AutoLoot = v end})

-- // LOOP DE MOVIMENTAÇÃO // --
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

-- // LOOP AUTO LIXO // --
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

-- // LOOP AUTO LOOT (PEGA E KITA) // --
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoLoot and lp.Character then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local txt = (v.ObjectText .. v.ActionText .. v.Parent.Name):lower()
                    local clean = txt:gsub("%s+", "")
                    local ileg = false
                    local ban = false
                    for _, k in pairs(IlegalKeywords) do if clean:find(k:gsub("%s+", "")) or txt:find(k) then ileg = true break end end
                    for _, b in pairs(BlacklistKeywords) do if txt:find(b) then ban = true break end end
                    if ileg and not ban then
                        local target = v.Parent:IsA("BasePart") and v.Parent or v.Parent:FindFirstChildWhichIsA("BasePart")
                        if target and target.Size.Magnitude < 15 then
                            lp.Character.HumanoidRootPart.CFrame = target.CFrame
                            task.wait(0.1)
                            fireproximityprompt(v)
                            lp:Kick("Tzzy Hub | Item Coletado! 🍀")
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- // LOOP AIMBOT // --
runService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = nil
        local dist = _G.FOVRadius
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, screen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if screen then
                    local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if mDist < dist then dist = mDist target = p end
                end
            end
        end
        if target then camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position), 1/_G.AimbotSmoothing) end
    end
end)

Rayfield:Notify({Title = "Tzzy Hub", Content = "SISTEMA COMPLETO OPERACIONAL!", Duration = 5})
