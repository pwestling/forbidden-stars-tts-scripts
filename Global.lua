
loaded = false

-- fixed data

commandTokenRotation = {x=0,y=180,z=0 }
diceRotations = {
  Red = {
    gun = {x=270.0, y=0.0, z=0.0},
    shield = {x=0.0,y=0.0, z=0.0},
    morale = {x=0.0, y=360.0, z=270.0}
  },
  Green = {
    gun = {x=270.00, y=180.00, z=0.00},
    shield = {x=0.00, y=180.00, z=0.00},
    morale = {x=0.00, y=180.00, z=270.00}
  },
  Blue = {
    gun = {x=270.00, y=180.00, z=0.00},
    shield = {x=0.00, y=180.00, z=0.00},
    morale = {x=0.00, y=180.00, z=270.00}
  },
  Yellow = {
    gun = {x=270.0, y=0.0, z=0.0},
    shield = {x=0.0,y=0.0, z=0.0},
    morale = {x=0.0, y=360.0, z=270.0}
  }
}

dicePositions = {
  Red = {
    gun ={x=-42.22, y=1.91, z=-10.24},
    shield = {x=-42.24, y=1.91, z=-12.19},
    morale ={x=-42.26, y=1.91, z=-14.21},
    combatCard={x=-40.26, y=1.1, z=-20.21},
    dir=1
  },
  Green = {
    gun = {x=-31.55, y=1.91, z=10.12},
    shield = {x=-31.55, y=1.91, z=12.15},
    morale = {x=-31.55, y=1.91, z=14.15},
    combatCard={x=-29.55, y=1.1, z=20.12},
    dir=-1
  },
  Blue = {
    gun = {x=42.00, y=1.91, z=10.12},
    shield = {x=42.00, y=1.91, z=12.12},
    morale = {x=42.00, y=1.91, z=14.12},
    combatCard={x=40.00, y=1.1, z=20.12},
    dir=-1
  },
  Yellow = {
    gun ={x=31.29, y=1.91, z=-10.24},
    shield = {x=31.29, y=1.91, z=-12.19},
    morale ={x=31.29, y=1.91, z=-14.21},
    combatCard={x=33.29, y=1.1, z=-20.21},
    dir=1
  }
}
diceTrayZones = {
  ["a683b5"] = {player = "Red", side = "gun", dir=1},
  ["4ad533"] = {player = "Red", side = "shield", dir=1},
  ["c50b56"] = {player = "Red", side = "morale", dir=1},
  ["f3b87d"] = {player = "Green", side = "gun", dir=-1},
  ["28da53"] = {player = "Green", side = "shield", dir=-1},
  ["1ac1b8"] = {player = "Green", side = "morale", dir=-1},
  ["1c39c8"] = {player = "Blue", side = "gun", dir=-1},
  ["eff97e"] = {player = "Blue", side = "shield", dir=-1},
  ["1581fb"] = {player = "Blue", side = "morale", dir=-1},
  ["666cb1"] = {player = "Yellow", side = "gun", dir=1},
  ["61409a"] = {player = "Yellow", side = "shield", dir=1},
  ["7f86d5"] = {player = "Yellow", side = "morale", dir=1}

}
sideTableZones = {
  ["a53bc5"] = {player = "Blue"},
  ["7a2f2b"] = {player = "Yellow"},
  ["56ae34"] = {player = "Red"},
  ["ffaf4b"] = {player = "Green"}
}
diceSideMap = {"gun","gun","gun","shield","shield","morale"}

dieXWidth = 1.56

playerHighlights = {
  ["Red"]={r=1,b=0.0,g=0.0},
  ["Yellow"]={r=1,b=0.0,g=1},
  ["Blue"]={r=0.0,b=1,g=0.0},
  ["Green"]={r=0.0,b=0.0,g=1} }

tileRadius = 4.75
MAIN_BOARD_ZONE = "288d26"


--mutable state

reinforceTokensToPlayer = {}
combatTokensToPlayer = {}
combatDecks = {}
combatDeckPositions = {}
plannedUpgrades = {}
floatingCards = {}
combatDice = {}
combatEndDecks = {}
playedCombatCards = {Red={},Green={},Yellow={},Blue={}}
playerCombatStartButtons = {}
combatDeckContents = {}
playerCombatDomino = {}

combatLock = {
  Red=false,
  Yellow=false,
  Blue=false,
  Green=false
}
commandTokenObjects = {}

function onLoad(state)

  setOnCollisionEnter(findAllLike('order token'),'commandTokenCollision')
  setOnCollisionEnter(findAllWithTag('Bag'), 'bagCollision')
  --setOnCollisionEnter(findAllLike('Combat Pawn'), 'combatPawnCollision')
  --clearLua(findAllWithTag('Infinite'))

  --Chaos
  tokenResetButton(
    getObjectFromGUID('0e761d'),
    findAll('Chaos order token'))
  combatStartButton(
    getObjectFromGUID('713059'),
    find('Chaos Combat Cards'),
    "Red")
  combatEndButton(
    getObjectFromGUID('e0982e'),
    find('Chaos Combat Cards'),
    findAll('Chaos combat die'))
 --Eldar
  tokenResetButton(
    getObjectFromGUID('f39151'),
    findAll('Eldar order token'))
  combatStartButton(
    getObjectFromGUID('6e8dbf'),
    find('Eldar Combat Cards'),
    "Yellow")
  combatEndButton(
    getObjectFromGUID('53d047'),
    find('Eldar Combat Cards'),
    findAll('Eldar combat die'))
--SMs
  tokenResetButton(
    getObjectFromGUID('c2f4c8'),
    findAll('Space Marine order token'))
  combatStartButton(
    getObjectFromGUID('b06168'),
    find('Space Marine Combat Cards'),
    "Blue")
  combatEndButton(
    getObjectFromGUID('75dde9'),
    find('Space Marine Combat Cards'),
    findAll('Space Marine combat die'))
  --Orks
   tokenResetButton(
    getObjectFromGUID('a2d0c5'),
    findAll('Ork order token'))
  combatStartButton(
    getObjectFromGUID('dc2e41'),
    find('Ork Combat Cards'),
    "Green")
  combatEndButton(
    getObjectFromGUID('a91d0c'),
    find('Ork Combat Cards'),
    findAll('Ork combat die'))
    Global.setVar("loaded", true)

  for k,v in pairs(findAllLike('Combat upgrades')) do
    upgradeButton(getObjectFromGUID(v), nil)
  end
end

function upgradeButton(deck)
  cardbutton(deck, "UP", "upgradeCards")
end

function upgradeCards(deck, playerColor)
  if(not combatLock[playerColor]) then
    combatLock[playerColor] = true
    local combatDeck = combatDecks[playerColor]
    plannedUpgrades[playerColor] = deck
    local cards = combatDeck.getObjects()
    local cardNamesToGuids = {}
    for k,card in pairs(cards) do
      if(not cardNamesToGuids[card.nickname]) then
        cardNamesToGuids[card.nickname] = {}
      end
      table.insert(cardNamesToGuids[card.nickname], card.guid)
    end

    local counter = 0
    floatingCards[playerColor] = cardNamesToGuids
    combatDeckPositions[playerColor] = combatDeck.getPosition()
    for cardName,guids in pairs(cardNamesToGuids) do
      local goto1 = copyTable(combatDeck.getPosition())
      goto1.x = goto1.x - (10) + (counter * 4)
      goto1.y = 5
      local goto2 = copyTable(goto1)
      goto2.y = goto2.y-0.1
      local card1 = combatDeck.takeObject({guid=guids[1]})

      card1.setPositionSmooth(goto1)
      card1.setLock(true)
      cardbutton(card1,"DIS","finishUpgrade")
      if(counter < 4) then
        local card2 = combatDeck.takeObject({guid=guids[2]})
        card2.setPositionSmooth(goto2)
        card2.setLock(true)
      else
        local id = "moveCard"..guids[2]
        Timer.destroy(id)
        Timer.create({
          identifier=id,
          function_name='moveObj',
          parameters= { guid=guids[2],pos=goto2,lock=true},
          delay=0.1})
      end
      counter = counter+1
    end
  end
end

function finishUpgrade(clickedCard,playerColor)
  local betterCards = plannedUpgrades[playerColor]
  local sideTablePos = copyTable(betterCards.getPosition())
  local cardNamesToGuids = floatingCards[playerColor]
  local combatDeckPosition = copyTable(combatDeckPositions[playerColor])
  local height = 1.5
  local combatCardGuid
  local discardCardGuid
  for cardName,guids in pairs(cardNamesToGuids) do
    for k,guid in pairs(guids) do
      local card = getObjectFromGUID(guid)
      if(cardName == clickedCard.getName()) then
        sideTablePos.y = height
        card.setPositionSmooth(sideTablePos)
        card.setLock(false)
        discardCardGuid = card.getGUID()
      else
        combatDeckPosition.y = height
        card.setPositionSmooth(combatDeckPosition)
        card.setLock(false)
        card.clearButtons()
        combatCardGuid = card.getGUID()
      end
      height = height+0.1
    end
  end
  local betterGuids = {}
  for k,cardTab in pairs(betterCards.getObjects()) do
    table.insert(betterGuids, cardTab.guid)
  end
  local card1 = betterCards.takeObject({guid=betterGuids[1]})
  combatDeckPosition.y = height
  card1.clearButtons()
  height = height+0.1
  combatDeckPosition.y = height
  timer(betterGuids[1], "moveObj",
    {guid=betterGuids[1],pos=combatDeckPosition,lock=false}, 0.1)
  timer(betterGuids[2], "moveObj",
    {guid=betterGuids[2],pos=combatDeckPosition,lock=false}, 0.2)
  timer(playerColor, 'refindCombatDeck',
    { discard=discardCardGuid, combat=combatCardGuid, player=playerColor}, 2)
  timer(playerColor, "unlockCombat", {playerColor=playerColor}, 2)
end

function refindCombatDeck(params)
  for k,v in pairs(getAllObjects()) do
    if(v.tag == "Deck") then
      for k2,cardTab in pairs(v.getObjects()) do
        if(cardTab.guid == params.combat) then
          combatDecks[params.player] = v
          v.setName("Combat Cards")
        end
        if(cardTab.guid == params.discard) then
          cardbutton(v, "UP", "upgradeCards")
          v.setName("Discarded Combat upgrades")
        end
      end
    end
  end
end

function isObjectInZone(zoneGUID, objectGUID)
  local zone = getObjectFromGUID(zoneGUID)
  if(zone) then
    for k,v in pairs(zone.getObjects()) do
      if(v.getGUID() == objectGUID) then
        return true
      end
    end
  end
  return false
end

function isObjectInZones(zoneGUIDs, objectGUID)
  for k,v in pairs(zoneGUIDs) do
    if(isObjectInZone(k, objectGUID)) then
      return true
    end
  end
  return false
end

function onObjectDropped(playerColor,  obj )
  local p = obj.getPosition()
  if(string.find(obj.getName(), "combat die") and diceRotations[playerColor]
    and not isObjectInZones(diceTrayZones, obj.getGUID())
    and not isObjectInZones(sideTableZones, obj.getGUID())) then
    rollCombatDie(obj, playerColor)
  end
  if(obj.getName() == 'Combat token' and not obj.getVar("owned")) then
    combatTokensToPlayer[obj.getGUID()] = playerColor
    print(obj.getGUID().." : "..playerColor)
    obj.setVar("owned", true)
    obj.setVar("owner", playerColor)
    obj.highlightOn(playerHighlights[playerColor])
  end
  if(obj.getName() == 'Bastion' and not obj.getVar("owned")) then
    obj.setVar("owned", true)
    obj.setVar("owner", playerColor)
  end
  if(obj.getName() == "Reinforcement token" and not obj.getVar("owned")) then
    reinforceTokensToPlayer[obj.getGUID()] = playerColor
    obj.setVar("owned", true)
    obj.setVar("owner", playerColor)
    obj.highlightOn(playerHighlights[playerColor])
  end
end

function onObjectEnterScriptingZone(zone, object)
  if(diceTrayZones[zone.getGUID()]) then
    local id = 'organizeDice'..zone.getGUID()
    local props = diceTrayZones[zone.getGUID()]
    Timer.destroy(id)
    Timer.create({
      identifier=id,
      function_name='organizeDice',
      parameters= { zone = zone, side = props.side, playerColor = props.player, dir=props.dir},
      delay=0.3
    })
  end
end

function organizeDice(params)
  local zone = params.zone
  local side = params.side
  local  playerColor = params.playerColor
  local count = 0
  local held = false
  for k,v in pairs(zone.getObjects()) do
    if( v.getName() and v.held_by_color == nil and string.find(v.getName(), "die")) then
         v.setLock(true)
         v.setRotationSmooth(diceRotations[playerColor][side])
         local pos = copyTable(dicePositions[playerColor][side])
         pos.x = pos.x + ((dieXWidth * count) * params.dir)
         v.setPositionSmooth(pos)
         count = count + 1
         v.setLock(false)
    elseif(v.held_by_color) then
      held = true
    end
  end
  if(held) then
    local id = 'organizeDice'..zone.getGUID()
    Timer.destroy(id)
    Timer.create({
      identifier=id,
      function_name='organizeDice',
      parameters= params,
      delay=0.3
    })
  end
end

function rollCombatDie(die, playerColor)
  local s = math.random(1,6)
  local side = diceSideMap[s]
  local rot = diceRotations[playerColor][side]
  local pos = copyTable(dicePositions[playerColor][side])
  pos.x = pos.x + ((dieXWidth*7)*dicePositions[playerColor].dir)
  die.roll()
  local id = 'setDie'..die.getGUID()
  Timer.destroy(id)
  Timer.create({
    identifier=id,
    function_name='moveObj',
    parameters= {obj=die,pos=pos,rot=rot},
    delay=1.5
  })

end

function moveObj(params)
  local obj = params.obj
  if(params.guid) then
    obj = getObjectFromGUID(params.guid)
  end
  if(params.rot) then
    obj.setRotationSmooth(params.rot)
  end
  if(params.pos) then
    obj.setPositionSmooth(params.pos)
  end
  if(params.lock) then
    obj.setLock(params.lock)
  end
end


function sameRot(rot1, rot2, tolerance)
  local xdif = math.abs(rot1.x-rot2.x)
  local ydif = math.abs(rot1.y-rot2.y)
  local zdif = math.abs(rot1.z-rot2.z)
  return xdif < tolerance and ydif < tolerance and zdif < tolerance
end

function numObjectsInZoneWithRot(zone, rot)
  local  count = 0
  for k,v in pairs(zone.getObjects()) do
    if(sameRot(rot,v.getRotation(), 0.1)) then
      count = count+1
    end
  end
  return count
end

function bagCollision(info)
  if(info and info.object and info.collision_object and info.collision_object.getGUID()) then
    Timer.create({
     identifier='retrieveItems'..info.collision_object.getGUID(),
     function_name='retrieveItems',
     parameters= { bag = info.object},
     delay=0.2
    })
  end
end

function sign(x)
  return x>0 and 1 or -1
end

function retrieveItems(params)
  local bagName = params.bag.getName()
  local retrieveOffset = 10
  local retrieveHeight = 2
  for k,v in pairs(params.bag.getObjects()) do
    local n = v.name
    if(not (string.find(bagName, n) or string.find(bagName, n.."s") or string.find(bagName, string.gsub(n,"y$","ies")))) then
       print("Retrieving")
       local pos = params.bag.getPosition()
       pos['x'] = pos['x']+(retrieveOffset * (-1 * sign(pos['x'])))
       pos['z'] = pos['z']+(retrieveOffset * (-1 * sign(pos['z'])))
       pos['y'] = pos['y']+retrieveHeight
       params.bag.takeObject({guid=v.guid, position=pos})
       retrieveHeight = retrieveHeight+2
    end
  end
end

function commandTokenCollision(info)

  local t = info.collision_object
  if(t and t.getName() and isObjectInZone(MAIN_BOARD_ZONE, info.object.getGUID()) and string.find(t.getName(),'order token')) then
    local targetPos = info.collision_object.getPosition()
    local oPos = info.object.getPosition()
    local tPos = t.getPosition()
    if(oPos['y'] > tPos['y'] and (math.abs(oPos['x'] - tPos['x']) > 0.01 or math.abs(oPos['z'] - tPos['z']) > 0.01)) then
      local newPos = {}
      newPos['y'] = tPos['y']+0.3
      newPos['x'] = tPos['x']
      newPos['z'] = tPos['z']
      info.object.setRotation(commandTokenRotation)
      info.object.setPosition(newPos)
    end
  end
end

function findAll(name)
  local result = {}
  for k,v in pairs(getAllObjects()) do
    if(v.getName() == name) then
      table.insert(result,v.guid)
    end
  end
  return result
end

function findAllWithTag(name)
  local result = {}
  for k,v in pairs(getAllObjects()) do
    if(v.tag == name) then
      table.insert(result,v.guid)
    end
  end
  return result
end

function findAllLike(name)
  local result = {}
  for k,v in pairs(getAllObjects()) do
    if(string.find(v.getName(),name)) then
      table.insert(result,v.guid)
    end
  end
  return result
end

function find(name)
  for k,v in pairs(getAllObjects()) do
    if(v.getName() == name) then
      return v
    end
  end
  return result
end

function storePositions(objectGuids)
 local storage = {}
 local positions = {}
 local guids = {}
 local rotations = {}
 storage['guids'] = guids
 storage['positions'] = positions
 storage['rotations'] = rotations
 local count = 0
  for k, v in pairs(objectGuids) do
   local o = getObjectFromGUID(v)
   table.insert(guids,v)
   table.insert(positions, o.getPosition())
   table.insert(rotations, o.getRotation())
   count = count + 1
 end
 storage['size'] = count
 return storage
end

function resetPositions(storage, random)
  random = random or false
  local positions = storage['positions']
  local guids =  storage['guids']
  local rotations = storage['rotations']
  local offset = 0
  local l = storage['size']
  if(random) then
    offset = math.random(6)
  end
  for k,v in pairs(guids) do
    local o = getObjectFromGUID(v)
    local index = ((k - 1 + l + offset) % l) + 1
    if(o ~= nil) then
      o.setRotationSmooth(rotations[k])
      o.setPositionSmooth(positions[index])
      o.setLock(false)
    else
      retrieveFromContainer(v, rotations[k], positions[index])
    end
  end
end

function retrieveFromContainer(guid,putRot,putPos)
  local objs = getAllObjects()
   for k,container in pairs(objs) do
     if(container.tag == 'Bag' or container.tag == 'Deck') then
        for k2,target in pairs(container.getObjects()) do
          if(target.guid == guid) then
             local takeObjParams = {}
             takeObjParams.guid = guid
             takeObjParams.position = putPos
             takeObjParams.rotation = putRot
             container.takeObject(takeObjParams)
          end
        end
     end
   end
end

function tokenResetButton(domino, tokens)
  button(domino, 'Reset Command\n Tokens', 'resetCommandTokens')
  commandTokenObjects[domino] = storePositions(tokens)
end

function resetCommandTokens(buttonObj, color)
  resetPositions(commandTokenObjects[buttonObj], true)
end

function combatStartButton(domino, deck, playerColor)
  button(domino, 'Start Combat', 'startCombat')
  playerCombatStartButtons[domino] = playerColor
  playerCombatDomino[playerColor] = domino
  combatDecks[playerColor] = deck
end

function startCombat(domino, playerColor)
  if(not combatLock[playerColor]) then
    combatLock[playerColor] = true
    local deck = combatDecks[playerCombatStartButtons[domino]]
    if(combatDeckContents[deck] == nil) then
      deck.flip()
      combatDeckContents[deck] = {table.unpack(deck.getObjects())}
      deck.shuffle()
      deck.dealToColor(5, playerColor)
      timer(playerColor, "initHand", {playerColor=playerColor}, 1)
    end
    timer(playerColor, "unlockCombat", {playerColor=playerColor}, 2)
  end
end

function unlockCombat(params)
  combatLock[params.playerColor] = false
end

function timer(key, fn_name, params, delay)
  local id = fn_name..key
  Timer.destroy(id)
  Timer.create({
    identifier=id,
    function_name=fn_name,
    parameters= params,
    delay=delay
  })
end

function initHand(params)
  for k,card in pairs(Player[params.playerColor].getHandObjects()) do
    cardbutton(card, "PLAY", "playCard")
  end
end

function smoothMove(obj,pos)
  obj.setPositionSmooth(pos)
  print("Moving "..tostring(obj.isSmoothMoving()))
end

function playCard(card,playerColor)
  card.clearButtons()
  card.flip()
  card.setLock(true)
  local firstCardPos = copyTable(dicePositions[playerColor]["combatCard"])
  local jumpPos = copyTable(card.getPosition())
  jumpPos.y = jumpPos.y+10

  backcardbutton(card,"RET","returnCard")
  firstCardPos.x = firstCardPos.x + (4 * dicePositions[playerColor].dir * #playedCombatCards[playerColor])
  card.setPosition(jumpPos)
  smoothMove(card,firstCardPos)
  for k,playedCard in pairs(playedCombatCards[playerColor]) do
    playedCard.clearButtons()
  end
  table.insert(playedCombatCards[playerColor],card)
  card.setLock(false)
end

function returnCard(card,playerColor)
  card.clearButtons()
  local handdata = Player[playerColor].getHandObjects()[1]
  local handPos = copyTable(handdata.getPosition())
  card.setPositionSmooth(handPos)
  table.remove(playedCombatCards[playerColor])
  timer(card.getGUID(), "flipAndInitCard", {card=card}, 0.5)
end

function flipAndInitCard(params)
  params.card.flip()
  cardbutton(params.card, "PLAY", "playCard")
end

function combatEndButton(domino, deck, dice)
  button(domino, 'End Combat', 'endCombat')
  combatDice[domino] = storePositions(dice)
end

function endCombat(domino, playerColor)
  if(not combatLock[playerColor]) then
    combatLock[playerColor] = true
    local deck = combatDecks[playerColor]
    if(combatDeckContents[deck] ~= nil) then
      playedCombatCards[playerColor] = {}
      local cards = combatDeckContents[deck]
      for k,v in pairs(cards) do
        local card = getObjectFromGUID(v['guid'])
        if card ~= nil then
          card.clearButtons()
          card.putObject(deck)
        end
      end
      combatDeckContents[deck] = nil
      deck.flip()
      for k,v in pairs(combatTokensToPlayer) do
          if(v == playerColor) then
            local obj = getObjectFromGUID(k)
            if(obj ~= nil) then
              obj.destruct()
            end
          end
      end
    end
    resetPositions(combatDice[domino])
    timer(playerColor, "unlockCombat", {playerColor=playerColor}, 2)
  end
end

function button (domino, label, fn)
  local button = {}
  button.width = 1300
  button.height = 600
  button.position = {0,-0.2,0}
  button.rotation ={180,90,0}
  button.click_function = fn
  button.label = label
  button.font_size = 180
  button.function_owner = nil
  domino.createButton(button)
end

function cardbutton (card, label, fn)
  local button = {}
  button.width = 125*string.len(label)
  button.height = 250
  button.position = {0,2,0}
  button.rotation ={0,0,0}
  button.click_function = fn
  button.label = label
  button.font_size = 180
  button.function_owner = nil
  card.createButton(button)
end

function backcardbutton (card, label, fn)
  local button = {}
  button.width = 125*string.len(label)
  button.height = 250
  button.position = {0,-2,0}
  button.rotation ={0,0,180}
  button.click_function = fn
  button.label = label
  button.font_size = 180
  button.function_owner = nil
  card.createButton(button)
end

function copyTable(tab)
  local result = {}
  for k,v in pairs(tab) do
    result[k] = v
  end
  return result
end

function setOnCollisionEnter(guids, fnName)
  for k,v in pairs(guids) do
    local o = getObjectFromGUID(v)
    if(o) then
      o:setLuaScript([[
      function onCollisionEnter(collision_info)
          if(self and collision_info and Global and Global.getVar("loaded") ) then
            collision_info['object'] = self
            Global.call(']]..fnName..[[', collision_info)
          end
      end
      ]])
    end
  end
end

function clearLua(guids)
  for k,v in pairs(guids) do
    local o = getObjectFromGUID(v)
    if(o) then
      o:setLuaScript("")
    end
  end
end