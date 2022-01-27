MDM_AssassinationMissionConfigurations = {}

MDM_AssassinationMissionConfigurations.assassinations = {
  {
    targets = {
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-619.09271,128.21832,4.2791152), direction = MDM_Utils.GetVector(0.54440945,0.83881962,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-627.24426,133.86072,3.0343933), direction = MDM_Utils.GetVector(-0.2209993,0.97527397,0)}

    },
    bodyguards =  {
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-615.6922,140.68567,2.9645715), direction = MDM_Utils.GetVector(-0.95410025,0.29948747,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-617.73419,141.56444,2.930263), direction = MDM_Utils.GetVector(0.91701645,-0.39884949,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-621.28583,129.85281,3.0684185), direction = MDM_Utils.GetVector(-0.48827451,0.87269008,0)}
    },
    carAssets = {
      {carId = "houston_coupe_bv01", position = MDM_Utils.GetVector(-634.09747,162.89331,3.1696486), direction = MDM_Utils.GetVector(-0.99951327,-0.026886089,-0.015828749)},
      {carId = "bolt_model_b", position = MDM_Utils.GetVector(-634.32898,158.32219,3.1312945), direction = MDM_Utils.GetVector(-0.9995988,-0.0072584697,0.027381405)},
      {carId = "shubert_e_six", position = MDM_Utils.GetVector(-633.83429,146.96365,3.0672972), direction = MDM_Utils.GetVector(-0.99991751,0.0098424237,0.0082522798)},
      {carId = "bolt_v8", position = MDM_Utils.GetVector(-633.86102,142.65585,3.1448483), direction = MDM_Utils.GetVector(-0.99973619,0.011355918,0.019970432)}
    },
    radius = 100
  },
  --------------------------------------------------------------------------------------------------------------------------------------
  {
    targets = {
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-739.00458,-103.00416,3.345438), direction = MDM_Utils.GetVector(-0.97510791,0.22173083,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-751.69855,-101.16547,3.3296781), direction = MDM_Utils.GetVector(0.022184556,0.99975389,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-743.74915,-102.82958,3.2788515), direction = MDM_Utils.GetVector(-0.095474869,0.99543184,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-748.77435,-102.7972,3.2815247), direction = MDM_Utils.GetVector(-0.088245489,0.99609876,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-741.43982,-109.1955,3.1800852), direction = MDM_Utils.GetVector(-0.24508351,0.96950197,0)},
      {npcId = "13604348442857333985", position = MDM_Utils.GetVector(-746.35504,-108.79321,3.1880631), direction = MDM_Utils.GetVector(0.6138714,0.78940606,0)}
    },
    carAssets = {
      {carId = "culver_airmaster", position = MDM_Utils.GetVector(-762.0705,-96.109596,3.453923), direction = MDM_Utils.GetVector(-0.0035166806,-0.99998617,-0.0039761043)},
      {carId = "houston_coupe_bv01", position = MDM_Utils.GetVector(-766.12494,-96.091537,3.5123169), direction = MDM_Utils.GetVector(0.016593218,-0.99986267,-0.00022748865)},
      {carId = "bolt_v8", position = MDM_Utils.GetVector(-753.49084,-95.722183,3.507232), direction = MDM_Utils.GetVector(0.021635549,-0.99976659,-0.00011146694)},
      {carId = "shubert_six", position = MDM_Utils.GetVector(-742.74146,-95.697556,3.4032197), direction = MDM_Utils.GetVector(-0.025636019,-0.99967033,0.0015905245)}
    },
    radius = 100
  }

}

function MDM_AssassinationMissionConfigurations.CreateRandomAssassinationMission()
  local config = MDM_AssassinationMissionConfigurations.PickRandomAssassination()
  return MDM_AssassinationMission:new(config)
end

function MDM_AssassinationMissionConfigurations.PickRandomAssassination()
  local count = #MDM_AssassinationMissionConfigurations.assassinations

  local random = math.random(1,count)

  for index,assassination in ipairs(MDM_AssassinationMissionConfigurations.assassinations) do
    if index == random then
      return assassination
    end
  end
end
