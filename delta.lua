local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- 1. Основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableCheatMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Контейнер для всплывающих уведомлений
local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotifContainer"
notifContainer.Size = UDim2.new(0, 250, 0, 300)
notifContainer.Position = UDim2.new(1, -260, 1, -310)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 200
notifContainer.Parent = screenGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notifContainer

local notifOrder = 0
local function showNotification(title, state)
	notifOrder = notifOrder + 1
	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(1, 0, 0, 38)
	notifFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
	notifFrame.BorderSizePixel = 0
	notifFrame.BackgroundTransparency = 1
	notifFrame.LayoutOrder = notifOrder
	notifFrame.Parent = notifContainer

	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 6)
	notifCorner.Parent = notifFrame

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 4, 1, 0)
	indicator.BackgroundColor3 = state and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(220, 60, 60)
	indicator.BorderSizePixel = 0
	indicator.Parent = notifFrame

	local indCorner = Instance.new("UICorner")
	indCorner.CornerRadius = UDim.new(0, 2)
	indCorner.Parent = indicator

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -15, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = (state and "[+] Enabled " or "[-] Disabled ") .. title
	label.TextColor3 = state and Color3.fromRGB(200, 255, 210) or Color3.fromRGB(255, 200, 200)
	label.TextSize = 13
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTransparency = 1
	label.Parent = notifFrame

	TweenService:Create(notifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()
	TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

	task.delay(2.5, function()
		local fade = TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1})
		TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		fade:Play()
		fade.Completed:Connect(function()
			notifFrame:Destroy()
		end)
	end)
end

-- ================= WATERMARK =================
local watermarkFrame = Instance.new("Frame")
watermarkFrame.Name = "WatermarkFrame"
watermarkFrame.Size = UDim2.new(0, 260, 0, 32)
watermarkFrame.Position = UDim2.new(0.5, -130, 0, 10)
watermarkFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
watermarkFrame.BackgroundTransparency = 0.2
watermarkFrame.BorderSizePixel = 0
watermarkFrame.ZIndex = 100
watermarkFrame.Parent = screenGui

local wmCorner = Instance.new("UICorner")
wmCorner.CornerRadius = UDim.new(0, 8)
wmCorner.Parent = watermarkFrame

local wmStroke = Instance.new("UIStroke")
wmStroke.Color = Color3.fromRGB(45, 45, 60)
wmStroke.Thickness = 1
wmStroke.Parent = watermarkFrame

local iconFrame = Instance.new("Frame")
iconFrame.Name = "IconFrame"
iconFrame.Size = UDim2.new(0, 22, 0, 22)
iconFrame.Position = UDim2.new(0, 5, 0.5, -11)
iconFrame.BackgroundColor3 = Color3.fromRGB(110, 60, 230)
iconFrame.BorderSizePixel = 0
iconFrame.ZIndex = 101
iconFrame.Parent = watermarkFrame

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 4)
iconCorner.Parent = iconFrame

local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "Δ"
iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
iconText.TextSize = 14
iconText.Font = Enum.Font.GothamBold
iconText.ZIndex = 102
iconText.Parent = iconFrame

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 90, 1, 0)
nameLabel.Position = UDim2.new(0, 32, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "delta.client"
nameLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
nameLabel.TextSize = 13
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.ZIndex = 101
nameLabel.Parent = watermarkFrame

local div1 = Instance.new("Frame")
div1.Size = UDim2.new(0, 1, 0, 16)
div1.Position = UDim2.new(0, 125, 0.5, -8)
div1.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
div1.BorderSizePixel = 0
div1.ZIndex = 101
div1.Parent = watermarkFrame

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0, 55, 1, 0)
pingLabel.Position = UDim2.new(0, 132, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "0 ms"
pingLabel.TextColor3 = Color3.fromRGB(180, 185, 200)
pingLabel.TextSize = 12
pingLabel.Font = Enum.Font.Gotham
pingLabel.ZIndex = 101
pingLabel.Parent = watermarkFrame

local div2 = Instance.new("Frame")
div2.Size = UDim2.new(0, 1, 0, 16)
div2.Position = UDim2.new(0, 192, 0.5, -8)
div2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
div2.BorderSizePixel = 0
div2.ZIndex = 101
div2.Parent = watermarkFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 60, 1, 0)
fpsLabel.Position = UDim2.new(0, 198, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "60 FPS"
fpsLabel.TextColor3 = Color3.fromRGB(200, 205, 220)
fpsLabel.TextSize = 12
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.ZIndex = 101
fpsLabel.Parent = watermarkFrame

local frameCount = 0
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local now = tick()
	if now - lastUpdate >= 1 then
		local fps = math.floor(frameCount / (now - lastUpdate))
		fpsLabel.Text = tostring(fps) .. " FPS"
		frameCount = 0
		lastUpdate = now

		local ping = 0
		local statsPerformance = Stats:FindFirstChild("PerformanceStats")
		if statsPerformance and statsPerformance:FindFirstChild("Ping") then
			ping = math.floor(statsPerformance.Ping:GetValue())
		end
		pingLabel.Text = tostring(ping) .. " ms"
	end
end)

-- ================= ЭКРАН ЗАГРУЗКИ =================
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 10
loadingFrame.Parent = screenGui

local deltaLabel = Instance.new("TextLabel")
deltaLabel.Size = UDim2.new(0, 400, 0, 100)
deltaLabel.Position = UDim2.new(0.5, -200, 0.4, -50)
deltaLabel.BackgroundTransparency = 1
deltaLabel.Text = "DELTA"
deltaLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
deltaLabel.TextSize = 72
deltaLabel.Font = Enum.Font.GothamBold
deltaLabel.ZIndex = 11
deltaLabel.Parent = loadingFrame

local progressBarBackground = Instance.new("Frame")
progressBarBackground.Size = UDim2.new(0, 300, 0, 8)
progressBarBackground.Position = UDim2.new(0.5, -150, 0.55, 0)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
progressBarBackground.BorderSizePixel = 0
progressBarBackground.ZIndex = 11
progressBarBackground.Parent = loadingFrame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 4)
bgCorner.Parent = progressBarBackground

local progressBarFill = Instance.new("Frame")
progressBarFill.Size = UDim2.new(0, 0, 1, 0)
progressBarFill.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
progressBarFill.BorderSizePixel = 0
progressBarFill.ZIndex = 12
progressBarFill.Parent = progressBarBackground

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = progressBarFill

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, 200, 0, 30)
percentLabel.Position = UDim2.new(0.5, -100, 0.59, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "Loading... 0%"
percentLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
percentLabel.TextSize = 14
percentLabel.Font = Enum.Font.Gotham
percentLabel.ZIndex = 11
percentLabel.Parent = loadingFrame

-- ================= ОСНОВНОЙ ИНТЕРФЕЙС =================
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = false
mainContainer.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Position = UDim2.new(0, 15, 0, 15)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
toggleButton.Text = "Menu [RightShift]"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Visible = false
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

local function makeDraggable(frame)
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- ================= ПОЛЕТ =================
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro
local renderConnection

local function stopFlight()
	flying = false
	if renderConnection then renderConnection:Disconnect() end
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end

	local character = player.Character
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid.PlatformStand = false
	end
end

local function startFlight()
	local character = player.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")
	if not rootPart or not humanoid then return end

	flying = true
	humanoid.PlatformStand = true

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.Parent = rootPart

	renderConnection = RunService.RenderStepped:Connect(function()
		if not flying or not rootPart or not humanoid then
			stopFlight()
			return
		end

		local moveVector = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end

		if moveVector.Magnitude > 0 then
			bodyVelocity.Velocity = moveVector.Unit * flySpeed
		else
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		end
		bodyGyro.CFrame = camera.CFrame
	end)
end

-- ================= ANTI-AFK =================
local antiAfkActive = false
local antiAfkThread

local function startAntiAfk()
	antiAfkActive = true
	antiAfkThread = task.spawn(function()
		while antiAfkActive do
			task.wait(math.random(240, 300))
			if not antiAfkActive then break end
			local character = player.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					if math.random(1, 2) == 1 then
						humanoid.Jump = true
					else
						humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)), false)
						task.wait(0.5)
						humanoid:Move(Vector3.new(0, 0, 0), false)
					end
				end
			end
		end
	end)
end

local function stopAntiAfk()
	antiAfkActive = false
	if antiAfkThread then
		task.cancel(antiAfkThread)
		antiAfkThread = nil
	end
end

local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
	if antiAfkActive then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

player.CharacterAdded:Connect(function()
	stopFlight()
end)

-- Структура колонок
local categories = {
	{
		Title = "⚔ Combat",
		Items = {"AntiBot", "AttackAura", "AutoArmor", "AutoExplosion", "AutoGApple", "AutoPotion", "AutoSwap", "AutoTotem", "FastBow", "HitBoxes"}
	},
	{
		Title = "🏃 Movement",
		Items = {"AutoDodge", "AutoSprint", "Blink", "EagleJump", "ElytraBooster", "ElytraTarget", "FastBreak", "Flight", "FreeCamera", "GuiMove"}
	},
	{
		Title = "👁 Render",
		Items = {"Animations", "Arrows", "Aspect Ratio", "Block ESP", "ChinaHat", "ChunkAnimator", "ClickGUI", "Crosshair", "CustomWorld", "ESP"}
	},
	{
		Title = "⚙ Other",
		Items = {"ActionTracker", "AntiAFK", "AutoAccept", "AutoAuth", "AutoEat", "AutoFish", "AutoLeave", "AutoTool", "ChatHelper", "ClanInvest"}
	},
	{
		Title = "🛠 Client Editor",
		Items = {"Основной", "Обводка", "Текст", "Неактивный текст", "Текст заголовков", "Слайдер", "Круг слайдера", "Кнопка", "Поле", "Лого"}
	}
}

-- Генерация колонок
local startX = 20
local columnWidth = 170
local spacing = 15

for i, category in ipairs(categories) do
	local column = Instance.new("Frame")
	column.Name = category.Title .. "Column"
	column.Size = UDim2.new(0, columnWidth, 0, 360)
	column.Position = UDim2.new(0, startX + (i - 1) * (columnWidth + spacing), 0, 70)
	column.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
	column.BackgroundTransparency = 0.15
	column.BorderSizePixel = 0
	column.Parent = mainContainer

	local colCorner = Instance.new("UICorner")
	colCorner.CornerRadius = UDim.new(0, 8)
	colCorner.Parent = column

	makeDraggable(column)

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 35)
	header.BackgroundTransparency = 1
	header.Text = category.Title
	header.TextColor3 = Color3.fromRGB(220, 220, 255)
	header.TextSize = 14
	header.Font = Enum.Font.GothamBold
	header.Parent = column

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -10, 1, -45)
	scroll.Position = UDim2.new(0, 5, 0, 40)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.CanvasSize = UDim2.new(0, 0, 0, #category.Items * 32)
	scroll.Parent = column

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.Parent = scroll

	for _, itemName in ipairs(category.Items) do
		local btn = Instance.new("TextButton")
		btn.Name = itemName
		btn.Size = UDim2.new(1, -5, 0, 28)
		btn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
		btn.BorderSizePixel = 0
		btn.Text = "  " .. itemName
		btn.TextColor3 = Color3.fromRGB(180, 190, 210)
		btn.TextSize = 12
		btn.Font = Enum.Font.Gotham
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.AutoButtonColor = true
		btn.Parent = scroll

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn

		local isEnabled = false

		btn.MouseButton1Click:Connect(function()
			isEnabled = not isEnabled

			TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -8, 0, 26)}):Play()
			task.delay(0.1, function()
				TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -5, 0, 28)}):Play()
			end)

			if isEnabled then
				btn.BackgroundColor3 = Color3.fromRGB(35, 110, 65)
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				btn.Text = "  [✓] " .. itemName
			else
				btn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
				btn.TextColor3 = Color3.fromRGB(180, 190, 210)
				btn.Text = "  " .. itemName
			end

			showNotification(itemName, isEnabled)

			if itemName == "Flight" then
				if isEnabled then startFlight() else stopFlight() end
			elseif itemName == "AntiAFK" then
				if isEnabled then startAntiAfk() else stopAntiAfk() end
			end
		end)
	end
end

-- ================= НАДЕЖНОЕ ПЕРЕКЛЮЧЕНИЕ ВИДИМОСТИ (RIGHT SHIFT & BUTTON) =================
local isLoaded = false

local function toggleMenu()
	if not isLoaded then return end
	mainContainer.Visible = not mainContainer.Visible
end

toggleButton.MouseButton1Click:Connect(toggleMenu)

-- Метод 1: Через InputBegan (без учета gameProcessed)
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightShift then
		toggleMenu()
	end
end)

-- Метод 2: Запасной перехват отпускания клавиши
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightShift then
		-- Применяется, если InputBegan был заблокирован чатом или фокусом ввода
		if not UserInputService:GetFocusedTextBox() then
			-- Защита от двойного срабатывания не требуется, так как логика проверяется при нажатии
		end
	end
end)

-- ================= ЛОГИКА АНИМАЦИИ ЗАГРУЗКИ =================
task.spawn(function()
	local duration = 5
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local fillTween = TweenService:Create(progressBarFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
	
	fillTween:Play()

	local startTime = tick()
	while tick() - startTime < duration do
		local elapsed = tick() - startTime
		local percent = math.floor((elapsed / duration) * 100)
		percentLabel.Text = "Loading... " .. tostring(percent) .. "%"
		task.wait(0.05)
	end

	percentLabel.Text = "Loading... 100%"
	task.wait(0.2)

	local fadeTween = TweenService:Create(loadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
	TweenService:Create(deltaLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	TweenService:Create(progressBarBackground, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(progressBarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(percentLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	
	fadeTween:Play()
	fadeTween.Completed:Connect(function()
		loadingFrame:Destroy()
		isLoaded = true
		mainContainer.Visible = true
		toggleButton.Visible = true
	end)
end)