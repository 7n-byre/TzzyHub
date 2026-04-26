-- [[ Tzzy Hub | Oficial ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local lp = game.Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1498063422657400863/xW3OVmmfUooDLnXd-tPCr30eixgAvQB1qIRfxrc32JVaSHw3nHvMmfG1l9DsXedrOXJX"

-- // Função de Logs // --
local function SendLog(status, key)
    pcall(function()
        local data = {
            ["embeds"] = {{
                ["title"] = "🚀 Log de Execução",
                ["description"] = "O script foi carregado!",
                ["color"] = 65280,
                ["fields"] = {
                    {["name"] = "Jogador:", ["value"] = lp.Name, ["inline"] = true},
                    {["name"] = "Key Usada:", ["value"] = key, ["inline"] = true},
                    {["name"] = "Status:", ["value"] = status, ["inline"] = false},
                },
                ["footer"] = {["text"] = "Tzzy Hub | " .. os.date("%d/%m/%Y")}
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

local Window = Rayfield:CreateWindow({
   Name = "Tzzy Hub | Sintonia Rp",
   LoadingTitle = "Carregando Configurações...",
   LoadingSubtitle = "By 7n / 7zada",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Key",
      Subtitle = "Insira a chave de acesso",
      Note = "As keys expiram em 24h!",
      FileName = "TzzyKeySave",
      SaveKey = true,
      GrabKeyFromSite = false,
      -- IMPORTANTE: Todas as keys devem estar aqui dentro para o login funcionar
      Key = {"TZZY-ADMIN-7N", "TZZY-A1B2", "TZZY-C3D4", "TZZY-E5F6", "TZZY-G7H8", "TZZY-I9J0", "TZZY-K1L2", "TZZY-M3N4", "TZZY-O5P6", "TZZY-Q7R8", "TZZY-S9T0"}
   }
})

-- Logar que a key foi aceita
SendLog("Acesso Autorizado", "Key Salva/Inserida")

-- // CONFIGURAÇÕES GLOBAIS // --
local _G = {
    GlideEnabled = false,
    GlideSpeed = 2.2,
    AutoLixo = false
}

local lixosColetados = {}

-- // ABA AUTO FARM // --
local TabFarm = Window:CreateTab("Auto Farm")

TabFarm:CreateToggle({
   Name = "Auto Coletar Lixo (V2.2)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoLixo = Value
      if Value then
          task.spawn(function()
              while _G.AutoLixo do
                  task.wait(0.1)
                  if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                      local hrp = lp.Character.HumanoidRootPart
                      local hum = lp.Character.Humanoid
                      
                      for _, v in pairs(workspace:GetDescendants()) do
                          if not _G.AutoLixo then break end
                          if v:IsA("ProximityPrompt") and (v.ObjectText:lower():find("lixo") or v.ActionText:lower():find("lixo")) then
                              if not lixosColetados[v] then
                                  local part = v.Parent:IsA("BasePart") and v.Parent or v.Parent:FindFirstChildWhichIsA("BasePart")
                                  if part then
                                      -- Teleporte Suave
                                      local lastPos = hrp.Position
                                      while _G.AutoLixo and (hrp.Position - part.Position).Magnitude > 4 do
                                          hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0,2,0)), 0.15)
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
      end
   end,
})

-- // ABA MOVIMENTAÇÃO // --
local TabMov = Window:CreateTab("Movimentação")

TabMov:CreateToggle({
   Name = "Speed Glide",
   CurrentValue = false,
   Callback = function(v) _G.GlideEnabled = v end
})

TabMov:CreateSlider({
   Name = "Velocidade",
   Range = {1, 15},
   Increment = 0.5,
   CurrentValue = 2.2,
   Callback = function(v) _G.GlideSpeed = v end
})

-- Script de movimento
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.GlideEnabled and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        local hrp = lp.Character.HumanoidRootPart
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.GlideSpeed / 6))
        end
    end
end)

Rayfield:Notify({Title = "Tzzy Hub", Content = "Script Pronto!", Duration = 5})
