-- [[ Tzzy Hub | Oficial ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local Webhook_URL = "https://discord.com/api/webhooks/1498063422657400863/xW3OVmmfUooDLnXd-tPCr30eixgAvQB1qIRfxrc32JVaSHw3nHvMmfG1l9DsXedrOXJX"

-- // BANCO DE KEYS (VÁLIDAS ATÉ 28/04/2026) // --
local KeysValidas = {
    ["TZZY-A1B2"] = {dia = 28, mes = 4}, ["TZZY-C3D4"] = {dia = 28, mes = 4},
    ["TZZY-E5F6"] = {dia = 28, mes = 4}, ["TZZY-G7H8"] = {dia = 28, mes = 4},
    ["TZZY-I9J0"] = {dia = 28, mes = 4}, ["TZZY-K1L2"] = {dia = 28, mes = 4},
    ["TZZY-M3N4"] = {dia = 28, mes = 4}, ["TZZY-O5P6"] = {dia = 28, mes = 4},
    ["TZZY-Q7R8"] = {dia = 28, mes = 4}, ["TZZY-S9T0"] = {dia = 28, mes = 4}
}

-- // Função de Logs com Contador // --
local function SendLog(status, key)
    local tempoRestante = "Permanente"
    local dataAtual = os.date("*t")
    
    if KeysValidas[key] then
        local k = KeysValidas[key]
        tempoRestante = string.format("%02d/%02d/2026", k.dia, k.mes)
    end

    pcall(function()
        local data = {
            ["embeds"] = {{
                ["title"] = "🚀 Log de Acesso | Tzzy Hub",
                ["color"] = status == "Acesso Permitido" and 65280 or 16711680,
                ["fields"] = {
                    {["name"] = "Jogador:", ["value"] = lp.Name, ["inline"] = true},
                    {["name"] = "Key:", ["value"] = key, ["inline"] = true},
                    {["name"] = "Status:", ["value"] = status, ["inline"] = false},
                    {["name"] = "Expira em:", ["value"] = tempoRestante, ["inline"] = false}
                },
                ["footer"] = {["text"] = "Enviado em: "..os.date("%H:%M:%S")}
            }}
        }
        request({
            Url = Webhook_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
end

-- // CONFIGURAÇÕES GLOBAIS // --
local _G = {
    GlideEnabled = false, GlideSpeed = 2.2,
    FlyEnabled = false, FlySpeed = 2.5,
    AutoLoot = false, BoxEsp = false,
    AimbotEnabled = false, AimbotSmoothing = 5,
    FOVRadius = 150, AutoLixo = false
}

local lixosColetados = {}
local IlegalKeywords = {"dinheirosujo", "glock", "ak47", "fuzil", "pistola", "maconha", "coca", "droga"}
local BlacklistKeywords = {"arsenal", "policia", "pm", "prf"}

-- // JANELA PRINCIPAL // --
local Window = Rayfield:CreateWindow({
   Name = "Tzzy Hub | Sintonia Rp",
   LoadingTitle = "Carregando tudo...",
   LoadingSubtitle = "By 7n / 7zada",
   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Key",
      Key = {"TZZY-ADMIN-7N", "TZZY-A1B2", "TZZY-C3D4", "TZZY-E5F6", "TZZY-G7H8", "TZZY-I9J0", "TZZY-K1L2", "TZZY-M3N4", "TZZY-O5P6", "TZZY-Q7R8", "TZZY-S9T0"},
      Actions = {
         OnEnter = function(v)
            local dataAt = os.date("*t")
            if v == "TZZY-ADMIN-7N" then 
                SendLog("Acesso Permitido", v)
            elseif KeysValidas[v] then
                local k = KeysValidas[v]
                if (dataAt.month < k.mes) or (dataAt.month == k.mes and dataAt.day <= k.dia) then
                    SendLog("Acesso Permitido", v)
                else
                    SendLog("Key EXPIRADA", v)
                    lp:Kick("Sua Key expirou!")
                end
            else
                SendLog("Tentativa de Key Inválida", v)
                lp:Kick("Key Incorreta!")
            end
         end
      }
   }
})

-- // ABA MOVIMENTAÇÃO // --
local TabMov = Window:CreateTab("Movimentação")
TabMov:CreateToggle({Name = "Speed Glide", CurrentValue = false, Callback = function(v) _G.GlideEnabled = v end})
TabMov:CreateSlider({Name = "Velocidade", Range = {1, 15}, Increment = 0.5, CurrentValue = 2.2, Callback = function(v) _G.GlideSpeed = v end})
TabMov:CreateToggle({Name = "Fly Stealth", CurrentValue = false, Callback = function(v) _G.FlyEnabled = v end})

runService.RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        local hum = lp.Character.Humanoid
        if _G.GlideEnabled and not _G.FlyEnabled and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.GlideSpeed / 6))
        end
        if _G.FlyEnabled then
            hum:ChangeState(11)
            hrp.Velocity = hum.MoveDirection.Magnitude > 0 and camera.CFrame.LookVector * (_G.FlySpeed * 50) or Vector3.new(0, 1.5, 0)
        end
    end
end)

-- // ABA AUTO FARM // --
local TabFarm = Window:CreateTab("Auto Farm")
TabFarm:CreateToggle({Name = "Auto Coletar Lixo", Info = "V2.2 | Anti-Stuck", CurrentValue = false, Callback = function(v) _G.AutoLixo = v end})

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoLixo and lp.Character then
            for _, v in pairs(workspace:GetDescendants()) do
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

-- // ABA VISUAL & COMBAT // --
local TabVisual = Window:CreateTab("Visual & Combat")
TabVisual:CreateToggle({Name = "ESP Caixa (Global)", CurrentValue = false, Callback = function(v) _G.BoxEsp = v end})
TabVisual:CreateToggle({Name = "Aimbot Suave", CurrentValue = false, Callback = function(v) _G.AimbotEnabled = v end})

-- // ABA AUTO LOOT // --
local TabLoot = Window:CreateTab("Auto Loot")
TabLoot:CreateToggle({Name = "VAI PEGA E KITA", CurrentValue = false, Callback = function(v) _G.AutoLoot = v end})

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoLoot and lp.Character then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local txt = (v.ObjectText .. v.ActionText .. v.Parent.Name):lower()
                    local ileg = false
                    local ban = false
                    for _, k in pairs(IlegalKeywords) do if txt:find(k) then ileg = true break end end
                    for _, b in pairs(BlacklistKeywords) do if txt:find(b) then ban = true break end end
                    if ileg and not ban then
                        lp.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                        fireproximityprompt(v)
                        lp:Kick("Item Coletado! 🍀")
                        break
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "Tzzy Hub", Content = "Script Completo Carregado!", Duration = 5})
