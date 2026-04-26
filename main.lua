-- [[ Tzzy Hub | Sintonia RP ]] --
-- Carregando Interface
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // CONFIGURAÇÕES DE SEGURANÇA E LOGS // --
local Webhook_URL = "https://discord.com/api/webhooks/1498063422657400863/xW3OVmmfUooDLnXd-tPCr30eixgAvQB1qIRfxrc32JVaSHw3nHvMmfG1l9DsXedrOXJX"
local lp = game.Players.LocalPlayer

local function SendLog(msg)
    local data = {
        ["embeds"] = {{
            ["title"] = "LOG DE ACESSO | Tzzy Hub",
            ["description"] = msg,
            ["color"] = 0x00ff00,
            ["fields"] = {
                {["name"] = "Jogador", ["value"] = lp.Name, ["inline"] = true},
                {["name"] = "UserId", ["value"] = tostring(lp.UserId), ["inline"] = true}
            },
            ["footer"] = {["text"] = os.date("%d/%m/%Y às %H:%M:%S")}
        }}
    }
    pcall(function()
        request({
            Url = Webhook_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
end

-- // BANCO DE KEYS (VÁLIDAS ATÉ 27/04/2026) // --
local KeysValidas = {
    ["TZZY-A1B2"] = {dia = 27, mes = 4},
    ["TZZY-C3D4"] = {dia = 27, mes = 4},
    ["TZZY-E5F6"] = {dia = 27, mes = 4},
    ["TZZY-G7H8"] = {dia = 27, mes = 4},
    ["TZZY-I9J0"] = {dia = 27, mes = 4},
    ["TZZY-K1L2"] = {dia = 27, mes = 4},
    ["TZZY-M3N4"] = {dia = 27, mes = 4},
    ["TZZY-O5P6"] = {dia = 27, mes = 4},
    ["TZZY-Q7R8"] = {dia = 27, mes = 4},
    ["TZZY-S9T0"] = {dia = 27, mes = 4}
}

local function ValidarAcesso(input)
    local dataAtual = os.date("*t")
    local infoKey = KeysValidas[input]
    if infoKey then
        if (dataAtual.month < infoKey.mes) or (dataAtual.month == infoKey.mes and dataAtual.day <= infoKey.dia) then
            SendLog("Acesso Permitido com Key: " .. input)
            return true
        else
            SendLog("Tentativa com Key Expirada: " .. input)
            return false, "Esta Key já expirou!"
        end
    end
    return false, "Key Inválida!"
end

local Window = Rayfield:CreateWindow({
   Name = "Tzzy Hub | Sintonia Rp",
   LoadingTitle = "Verificando...",
   LoadingSubtitle = "By 7n / 7zada",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Key",
      Subtitle = "Keys de 1 dia",
      Note = "As keys expiram em 24h.",
      FileName = "TzzyKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"TZZY-ADMIN-7N"},
      Actions = {
         OnEnter = function(v)
            local ok, err = ValidarAcesso(v)
            if not ok and v ~= "TZZY-ADMIN-7N" then lp:Kick(err) end
         end
      }
   }
})

-- // CONFIGURAÇÕES GLOBAIS // --
local _G = {
    GlideEnabled = false, GlideSpeed = 2.2,
    FlyEnabled = false, FlySpeed = 2.5,
    AutoLoot = false, BoxEsp = false,
    AimbotEnabled = false, AimbotSmoothing = 5,
    FOVRadius = 150, AutoLixo = false
}

local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local lixosColetados = {}

-- // SISTEMA AUTO LIXO // --
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoLixo and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lp.Character.HumanoidRootPart
            local hum = lp.Character.Humanoid
            for _, v in pairs(workspace:GetDescendants()) do
                if not _G.AutoLixo then break end
                if v:IsA("ProximityPrompt") and (v.ObjectText:lower():find("lixo") or v.ActionText:lower():find("lixo")) then
                    if not lixosColetados[v] then
                        local target = v.Parent:IsA("BasePart") and v.Parent or v.Parent:FindFirstChildWhichIsA("BasePart")
                        if target then
                            local lastPos = hrp.Position
                            while _G.AutoLixo and (hrp.Position - target.Position).Magnitude > 4 do
                                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target.Position + Vector3.new(0, 2, 0)), 0.15)
                                task.wait(0.05)
                                if (hrp.Position - lastPos).Magnitude < 0.1 then hum.Jump = true end
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

-- // ABAS // --
local TabFarm = Window:CreateTab("Auto Farm")
TabFarm:CreateToggle({Name = "Auto Coletar Lixo", Info = "Velocidade 2.2 | Pula se travar", CurrentValue = false, Callback = function(v) _G.AutoLixo = v end})

local TabMov = Window:CreateTab("Movimentação")
TabMov:CreateToggle({Name = "Speed Glide", CurrentValue = false, Callback = function(v) _G.GlideEnabled = v end})
TabMov:CreateSlider({Name = "Velocidade", Range = {1, 15}, Increment = 0.5, CurrentValue = 2.2, Callback = function(v) _G.GlideSpeed = v end})

local TabVisual = Window:CreateTab("Visual")
TabVisual:CreateToggle({Name = "ESP Caixa", CurrentValue = false, Callback = function(v) _G.BoxEsp = v end})

Rayfield:Notify({Title = "Tzzy Hub", Content = "Script pronto, 7n!", Duration = 5})
