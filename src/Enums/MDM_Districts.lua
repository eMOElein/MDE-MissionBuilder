MDM_Districts = {
  LOST_HEAVEN = {
    NONE = {
      textId = "",
      name = "none",
      ogName = "none"
    },
    DISTRICT_01_CHINATOWN  = {
      name = "Chinatown",
      ogName = "Chinatown",
      textId = "866667137695826395"
    },
    DISTRICT_02_LITTLE_ITALY  = {
      name = "Little Italy",
      ogName = "Little Italy",
      textId = "17417388573361358179"
    },
    DISTRICT_03_WORKS_QUARTER  = {
      name = "Works Quarter",
      ogName = "Works Quarter",
      textId = "3087802362996987203"
    },
    DISTRICT_04_CENTRAL_ISLAND = {
      name = "Central Island",
      ogName = "Central Island",
      textId = "2778726331121933808"
    },
    DISTRICT_05_NEW_ARK = {
      name = "North Park",
      ogName = "New Ark",
      textId = "741176917989761654"
    },
    DISTRICT_06_DOWNTOWN = {
      name = "Downtown",
      ogName = "Downtown",
      textId = "17321605341148260715"
    },
    DISTRICT_07_HOBOKEN = {
      name = "Holbrook",
      ogName = "Hoboken",
      textId = "544951812581555386"
    },
    DISTRICT_08_OAKWOOD = {
      name = "Oakwood",
      ogName = "Oakwood",
      textId = "12145753678768324931"
    },
    DISTRICT_09_OAKHILL = {
      name = "Beech Hill",
      ogName = "Oak Hill",
      textId = "7892527449720641603"
    },
    DISTRICT_10_COUNTRYSIDE = {
      name = "Countryside",
      ogName = "Countryside",
      textId = "3826860609487944427"
    },
    DISTRICT_11_AUTODROME = {
      name = "Autodrome",
      ogName = "Autodrome",
      textId = "16134592757659460397"
    }
  }
}

function MDM_Districts.DistrictForTextId(textId)
  for _,d in pairs(MDM_Districts.LOST_HEAVEN) do
    if d.textId == tostring(textId) then
      return d
    end
  end

  return MDM_Districts.LOST_HEAVEN.NONE
end
