
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	self:test()
end

function MainScene:test()
	local RichLabel = require("app.scenes.RichLabel")

	local strArr = {}
	strArr[1] = "[image=wsk1.png][/image][fontColor=f75d85 fontSize=20]hello world[/fontColor][fontColor=fefefe]这是测试代码[/fontColor][fontColor=ff7f00 fontName=ArialRoundedMTBold]看看效果如何[/fontColor][fontColor=3232cd]碉堡了吧!!![/fontColor][fontColor=42426f]哈哈哈哈哈哈!![/fontColor][image=wsk1.png scale=1.3][/image]" --图片
	strArr[2] = "[image=wsk1.png][/image][image=wsk1.png][/image][image=wsk1.png][/image][image=wsk1.png][/image][image=wsk1.png][/image]"
	strArr[3] = "[fontColor=f75d85 fontSize=20]hello world!!!!!![/fontColor]"
	strArr[4] = "[fontColor=7f00ff fontSize=20]hello world[/fontColor][fontColor=fefefe]这是测试代码[/fontColor][fontColor=ff7f00 fontName=ArialRoundedMTBold]看看效果如何[/fontColor]"

	local curWidth = 200
	local curHeight = 200

	local params = {
						text = strArr[1],
						dimensions = cc.size(curWidth, curHeight)
					}
	local testLabel = RichLabel:create(params)
	self:addChild(testLabel)
	testLabel:setPosition(display.cx - 100, display.cy)

	--提示信息
	local infoLabel = cc.LabelTTF:create("", "Arial", 30)
	self:addChild(infoLabel)
	infoLabel:setPosition(display.cx, display.bottom + 50)

	local function addLog(text)
		print(text)
		infoLabel:setString(text)
	end
		
	do --大小测试
		local contentBg
		local textBg

		local function setBgSprite(contentSize, textSize)

			if contentBg then
				self:removeChild(contentBg, true)
				self:removeChild(textBg, true)
				contentBg = nil
				textBg = nil
			end

			contentBg = cc.Sprite:createWithTexture(nil, cc.rect(0, 0, contentSize.width, contentSize.height))
			textBg = cc.Sprite:createWithTexture(nil, cc.rect(0, 0, textSize.width, textSize.height))

			contentBg:setColor(cc.c3b(200, 200, 200))
			textBg:setColor(cc.c3b(100, 100, 100))

			contentBg:setAnchorPoint(cc.p(0, 1))
			textBg:setAnchorPoint(cc.p(0, 1))

			contentBg:setPosition(display.cx - 100, display.cy)
			textBg:setPosition(display.cx - 100, display.cy)

			self:addChild(contentBg, -1)
			self:addChild(textBg, -1)

			self:stopAllActions()
			self:performWithDelay(function ()
				self:removeChild(contentBg, true)
				self:removeChild(textBg, true)
				contentBg = nil
				textBg = nil
			end, 2)
		end

		local label = self:addTestLabel("大小测试", function ()
			local contentSize = cc.size(math.random(10, 30) * 10 + 50, curHeight)
			testLabel:setDimensions(contentSize)
			local textSize = testLabel:getLabelSize()
			local logStr = "TextSize:"..textSize.width.." "..textSize.height.." setSize:"..contentSize.width.." "..contentSize.height
			addLog(logStr)
			setBgSprite(contentSize, textSize)

		end)
		label:setPosition(display.right - 100, display.top - 50)
	end

	do --设置文字测试
		local label = self:addTestLabel("设置文字测试", function ()
			testLabel:setLabelString(strArr[math.random(1,#strArr)])
		
			local size = testLabel:getLabelSize()
			addLog("设置文字测试: TextSize:"..size.width.." "..size.height)
		end)
		label:setPosition(display.right - 100, display.top - 100)
	end

	do --动画测试
		local label = self:addTestLabel("动画测试", function ()
			local wordPerSec = 15 --每秒15个字
			testLabel:playFadeInAnim(wordPerSec)
		end)
		label:setPosition(display.right - 100, display.top - 150)
	end
end

--简单的触摸回调
function MainScene:addTestLabel(text, callback)
	local labelBtn = cc.LabelTTF:create(text, "Arial", 30)
	self:addChild(labelBtn)
	labelBtn:setTouchEnabled(true)

    labelBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(eventDic)
    	local event = eventDic.name
    	local x = eventDic.x
    	local y = eventDic.y
        if event == "began" then
            labelBtn:setScale(labelBtn:getScale() * 0.9)
            return true -- catch touch event, stop event dispatching
        end

        local touchInSprite = labelBtn:getCascadeBoundingBox():containsPoint(cc.p(x, y))
        if event == "ended" then
            labelBtn:setScale(labelBtn:getScale() / 0.9)
            if touchInSprite then 
                callback()
            end
        end
    end)
    return labelBtn
end

function MainScene:onEnter()

end

function MainScene:onExit()
end

return MainScene
