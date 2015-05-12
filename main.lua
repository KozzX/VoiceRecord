-- Recording App
-- Developed by Carlos Yanez

-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Graphics

-- [Background]

local bg = display.newImage('bg.png')
bg.anchorX = 0
bg.anchorY = 0
-- [Buttons]

local stopBtn
local recBtn

-- Variables

local play
local playAgain
local recording
local recPath
local recorded

-- Functions

local Main = {}
local addListeners = {}
local startRec = {}
local stopRec = {}
local soundComplete = {}
local replay = {}

-- Main Function

function Main()
	stopBtn = display.newImage('stopBtn.png', 170, 380)
	stopBtn.anchorX = 0
	stopBtn.anchorY = 0
	recBtn = display.newImage('recBtn.png', 70, 380)
	recBtn.anchorX = 0
	recBtn.anchorY = 0
	play = display.newImage('play.png', 116, 369)
	play.anchorX = 0
	play.anchorY = 0
	play.isVisible = false
	playAgain = display.newImage('playAgain.png', 130, 450)
	playAgain.anchorX = 0
	playAgain.anchorY = 0
	playAgain.isVisible = false
	
	addListeners()
end

function addListeners()
	recBtn:addEventListener('tap', startRec)
	playAgain:addEventListener('tap', replay)
end

function startRec(e)
	stopBtn:addEventListener('tap', stopRec)
	recPath = system.pathForFile('myRecording.aif', system.DocumentsDirectory)
	recording = media.newRecording(recPath)
	recording:startTuner()
	recording:startRecording()
	recBtn.isVisible = false
	
	transition.to(stopBtn, {time = 200, x = display.contentWidth * 0.5})
end

function stopRec(e)
	stopBtn:removeEventListener('tap', stopRec)
	recording:stopRecording()
	recording:stopTuner()
	
	stopBtn.isVisible = false
	play.isVisible = true
	
	-- Play recorded file
	
	recorded = audio.loadStream('myRecording.aif', system.DocumentsDirectory)
	local mychannel, mysource = audio.play(recorded, {onComplete = soundComplete})
	al.Source(mysource, al.PITCH, 1.5)
	al.Source(mysource, al.POSITION,  -5.0, 0.0, 0.0)
end

function soundComplete()
	--audio.dispose(recorded)
	
	recBtn.isVisible = true
	stopBtn.isVisible = true
	stopBtn.x = 217
	play.isVisible = false
	playAgain.isVisible = true
end

function replay()
	recBtn.isVisible = false
	stopBtn.isVisible = false
	local mychannel, mysource = audio.play(recorded, {onComplete = soundComplete})
	al.Source(mysource, al.PITCH, 1.5)
	al.Source(mysource, al.POSITION,  -5.0, 0.0, 0.0)
end

Main()