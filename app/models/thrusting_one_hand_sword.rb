class ThrustingOneHandSword < Weapon
  include ItemExtensions::Mapping
  BASE_NAMES = G_BASE_NAMES['weapon']['thrusting_one_hand_sword']

  document_type 'item'
  index_name { TireIndex.name(Thread.current[:current_league_id]) }
end
