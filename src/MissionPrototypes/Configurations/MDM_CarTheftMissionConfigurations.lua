MDM_CarTheftMissionConfigurations = {}
MDM_CarTheftMissionConfigurations.carThefts = {
  {
    title = "Random Cartheft 1",
    cars = {
      {carId = "berkley_810", position = MDM_Vector:new(-898.71429,-181.9543,4),direction = MDM_Vector:new(-0,000001,-0.000004,0.000150)},
      {carId = "berkley_810", position = MDM_Vector:new(-890.71429,-181.9543,4),direction = MDM_Vector:new(-0,000001,-0.000004,0.000150)}
    },
    destination = {
      position = MDM_Locations.SALIERIS_BAR_FRONTDOOR,
      radius = 20
    },
    bodyguards = {
      {npcId = "18187434932497386406", position = MDM_Utils.GetVector(-897.95825,-194.4371,2.8257189), direction = MDM_Utils.GetVector(-0.57838112,-0.81576669,0)},
      {npcId = "18187434932497386406", position = MDM_Utils.GetVector(-897.15625,-191.52925,2.8107495), direction = MDM_Utils.GetVector(0.27974245,0.96007508,0)}
    }
  },
  {
    title = "Random Cartheft 2",
    cars = {
      {carId = "bolt_truck", position = MDM_Utils.GetVector(-572.73315,-233.52982,3.4779644), direction = MDM_Utils.GetVector(-0.88765001,0.46035552,-0.012262007)}
    },
    destination = {
      position = MDM_Vector:new(-966.93677,-234.86322,4.0429807),
      radius = 20
    },
    bodyguards = {
      -- shotgun
      {npcId = "2624519215596331124", position = MDM_Utils.GetVector(-581.49609,-238.12181,3.8788948), direction = MDM_Utils.GetVector(-0.91509575,0.40323663,0)},
      {npcId = "2624519215596331124", position = MDM_Utils.GetVector(-577.55334,-227.88919,2.9395728), direction = MDM_Utils.GetVector(-0.92140418,-0.38860571,0)},
      -- colt
      {npcId = "18187434932497386406", position = MDM_Utils.GetVector(-572.57776,-224.13161,2.9868155), direction = MDM_Utils.GetVector(-0.48098215,-0.87673044,0),battleArchetype = "archetype_triggerman_base_pol"}
    }
  },
}
