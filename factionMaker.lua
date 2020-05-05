function detailedbutton(domino, label, fn, font_size)
  local button = {}
  button.width = 1300
  button.height = 600
  button.position = {0, -0.2, 0}
  button.rotation = {180, 90, 0}
  button.click_function = fn
  button.label = label
  button.font_size = font_size
  button.function_owner = nil
  button.tooltip = label
  domino.createButton(button)
  domino.hide_when_face_down = false
end

function button(domino, label, fn)
  detailedbutton(domino, label, fn, 180)
end


packFactionDomino = "0e761d"
startingCombatCards = "2e3ebd"
level0cards = "5253b0"
level2cards = "abd4e8"
level3cards = "8d6f11"
startingUnits = "991cd5"
additionalForces = "8a17dc"
advanceTokens="3b4268"

dominateTokens="197b1d"
strategizeTokens="489dab"
deployTokens="41e50c"


bagIds = {}
seq = 0

function makeBag(name)
  local x = (seq % 5) * 5
  local z = (( math.floor(seq / 5)) * 5)
  seq = seq + 1
  if bagIds[name] == nil then
    print("Creating Bag " .. name)

    spawnParams = {
        type = "bag",
        position          = {x=x, y=0, z=z},
        rotation          = {x=0, y=0, z=0},
        scale             = {x=1, y=1, z=1},
        sound             = false,
        snap_to_grid      = false,
        callback_function = function(obj) spawn_callback(obj, name) end
    }
    spawnObject(spawnParams)
  else
    print("Moving Existing Bag " .. name)

    getObjectFromGUID(bagIds[name]).setPositionSmooth({x=x, y=0, z=z}, false, true)
  end
end

function spawn_callback(object_spawned, name)
  object_spawned.setName(name)
  object_spawned.setLock(true)
  bagIds[name] = object_spawned.getGUID()
end


function onLoad(statestring)
  print("Loading Existing Bags")
  for k, obj in pairs(getAllObjects()) do
    if obj.tag == "Bag" then
      print("Bag " .. obj.getName() .. " loaded")
      bagIds[obj.getName()] = obj.getGUID()
    end
  end
  print("Creating button")

  button(getObjectFromGUID(packFactionDomino), "Create Faction", "create_faction")
  
  print("Making missing bags")

  makeBag("Starting Combat Cards")
  makeBag("Level 0 Cards")
  makeBag("Level 2 Cards")
  makeBag("Level 3 Cards")
  makeBag("Starting Units")
  makeBag("Additional Forces")
  makeBag("Advance Tokens")
  makeBag("Dominate Tokens")
  makeBag("Strategize Tokens")
  makeBag("Deploy Tokens")
  makeBag("Faction Card")
  makeBag("Event Deck")
  makeBag("Order Upgrades")
  makeBag("Objective Tokens")
  makeBag("Cities")
  makeBag("Factories")
  makeBag("Bastions")
  makeBag("Combat Dice")
  makeBag("System Tile")
  makeBag("Materiel Counter")

  makeBag("Faction")


end

ySeq = 5

function moveBagApplyName(bagName, name)
  local bagId = bagIds[bagName]
  local factionBag = getObjectFromGUID(bagIds["Faction"])
  local fPos = factionBag.getPosition()
  local placePos = {x = fPos.x, y = fPos.y + ySeq, z = fPos.z}
  ySeq = ySeq +1
  local bag = getObjectFromGUID(bagId)
  for k, obj in pairs(bag.getObjects()) do
    bag.takeObject(
      {
        guid = obj.guid,
        position = placePos,
        smooth = false,
        callback_function = function(pulledObj) pulledObj.setLock(true); pulledObj.setName(name); factionBag.putObject(pulledObj) end
      }
    )
  end

end

function getGuidsFromBag(bagName)
  local bag = getObjectFromGUID(bagIds[bagName])
  local factionBag = getObjectFromGUID(bagIds["Faction"])
  local fPos = factionBag.getPosition()
  local placePos = {x = fPos.x, y = fPos.y + ySeq, z = fPos.z}
  ySeq = ySeq +1
  local result = {}
  for k, obj in pairs(bag.getObjects()) do
    table.insert(result, obj.guid)
    bag.takeObject(
      {
        guid = obj.guid,
        position = placePos,
        smooth = false,
        callback_function = function(pulledObj) pulledObj.setLock(true); factionBag.putObject(pulledObj) end
      }
    )
  end
  return result
end

function onScriptingButtonDown(button_number, playerColor)
  if (button_number == 1) then
    local player = Player[playerColor]
    local obj = player.getHoverObject()
    print(obj.getGUID())
    print(obj.getVar("fs-meta"))
  end
end

function tabToS(tab)
  local s = "{"
  for k, v in pairs(tab) do
    s = s .. k .. "=" .. tostring(v) .. ","
  end
  s = s .. "}"
  return s
end

function create_faction()

  local factionBag = getObjectFromGUID(bagIds["Faction"])
  

  moveBagApplyName("Starting Combat Cards", "Combat Cards")
  moveBagApplyName("Event Deck", "Event cards")
  
  moveBagApplyName("Level 0 Cards", "Combat upgrades (LV 0)")
  moveBagApplyName("Level 2 Cards", "Combat upgrades (LV 2)")
  moveBagApplyName("Level 3 Cards", "Combat upgrades (LV 3)")

  moveBagApplyName("Faction Card", "Faction Card")
  moveBagApplyName("Order Upgrades", "Order upgrades")
  moveBagApplyName("Objective Tokens", "Objective tokens")
  moveBagApplyName("Cities", "Cities")
  moveBagApplyName("Factories", "Factories")
  moveBagApplyName("Bastions", "Bastions")
  moveBagApplyName("Combat Dice",  "combat die")
  moveBagApplyName("System Tile", "System tile")
  moveBagApplyName("Materiel Counter","materiel")
  
  local factionGuids = {
    orderTokens = {
      advance = getGuidsFromBag("Advance Tokens"),
      deploy = getGuidsFromBag("Deploy Tokens"),
      strategize = getGuidsFromBag("Strategize Tokens"),
      dominate = getGuidsFromBag("Dominate Tokens")
    },
    startingUnits = getGuidsFromBag("Starting Units"),
     
    modelPiles = getGuidsFromBag("Additional Forces"),
    factionBag = bagIds["Faction"]
  }

  print("Tab is " .. tabToS(factionGuids))

  local factionBag = getObjectFromGUID(bagIds["Faction"])
  print("GUID data " .. JSON.encode(factionGuids))
  factionBag.setTable("fs-meta", factionGuids)

  factionBag.setLuaScript([[
  function onSave()
    return JSON.encode(self.getTable("fs-meta"))
  end
  
  function onLoad(saved_data)
    if saved_data ~= nil then
      print("Loaded " .. saved_data)
      local tab = JSON.decode(saved_data)
      tab["factionBag"] = self.getGUID()
      self.setTable("fs-meta", JSON.decode(saved_data))
    end
  end
  ]])
end

