class Staff < Weapon
  include ItemExtensions::Mapping
  BASE_NAMES = G_BASE_NAMES['weapon']['staff']

  document_type 'item'
  index_name { TireIndex.name(Thread.current[:current_league_id]) }
end
