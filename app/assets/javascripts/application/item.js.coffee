class Item
  constructor: (@item, @layoutSize) ->

  toJson: ->
    id: @item.id
    item_type: @item.item_type
    full_name: @fullName()
    w: @item.w
    h: @item.h
    raw_icon: @item.raw_icon
    sockets: @sockets()
    indexed_at: @item.indexed_at
    requirements: @requirements()
    thread_id: @item.thread_id
    rarity_name: @rarityName()
    visible_stats: @visibleStats()
    isSkill: @isSkill()
    properties: @properties()
    account: @account()
    price_button: @priceButton()
    verify_button: @verifyButton()
    pm_button: @pmButton()
    corrupted: @item.corrupted

  # Helpers

  priceButton: ->
    return if $.isEmptyObject(@item.price)

    [orb, price] = [null, null]

    $.each @item.price, (_orb, _price) -> orb = _orb; price = _price

    price: price
    orb: orb
    btn_class: @btnClass()

  verifyButton: ->
    id: @item.id
    btn_class: @btnClass()

  pmButton: ->
    btn_class: @btnClass()

  btnClass: ->
    "btn-#{@layoutSize}" if @layoutSize != "large"

  properties: ->
    props = switch @item.archetype
      when 0 then @weapon_props()
      when 1 then @armour_props()
      when 2 then @misc_props()

    props = props.concat @hiddenStats()

    $.map props, (prop, i) ->
      prop if prop && prop.value > 0

  weapon_props: ->
    [
      { name: "DPS", value: @item.dps, meta_data: "dps", data_attr: "sort" }
      { name: "pDPS", value: @item.physical_dps, meta_data: "physical_dps", data_attr: "sort" }
      { name: "APS", value: @item.aps, meta_data: "aps", data_attr: "sort" }
    ].concat @weapon_and_misc_props()

  armour_props: ->
    [
      { name: "Evasion", value: @item.evasion, meta_data: "evasion", data_attr: "sort" }
      { name: "Armour", value: @item.armour, meta_data: "armour", data_attr: "sort" }
      { name: "ES", value: @item.energy_shield, meta_data: "energy_shield", data_attr: "sort" }
      { name: "% Chance to Block", value: @item.block_chance, meta_data: "block_chance", data_attr: "sort" }
    ]

  misc_props: ->
    @weapon_and_misc_props()

  weapon_and_misc_props: ->
    [
      { name: "Physical Dmg", value: @displayedPhysDmg(), meta_data: "physical_damage", data_attr: "sort" }
      { name: "Elemental Dmg", value: @item.elemental_damage, meta_data: "elemental_damage", data_attr: "sort" }
      { name: "CS Chance", value: @item.critical_strike_chance, meta_data: "critical_strike_chance", data_attr: "sort" }
    ]

  displayedPhysDmg: ->
    if @item.raw_physical_damage
      "#{@item.raw_physical_damage} (#{@item.physical_damage})"
    else
      @item.physical_damage

  hiddenStats: ->
    $.map @item.stats, (stat, i) ->
      if stat.hidden
        name: stat.name
        value: stat.value
        data_attr: "mod"
        meta_data: stat.mod_id

  requirements: ->
    league_name: @capitalize(@item.league_name)
    requires_level: if @item.item_type ==  "Map" then "Level" else "Requires level"
    level: @item.level
    required_stats: @requiredStats()
    quality: @item.quality

  requiredStats: ->
    $.map ["dex", "str", "int"], (stat, i) =>
      if (stat_value = @item[stat])
        stat: stat
        value: stat_value

  account: ->
    Handlebars.templates.account { account: @item.account }

  fullName: ->
    fullname = @item.name
    if @item.base_name && @item.base_name != @item.name
      fullname = fullname + " #{@item.base_name}"
    fullname

  rarityName: ->
    @item.rarity_name.toLowerCase()

  visibleStats: ->
    $.map @item.stats, (stat, i) ->
      unless stat.hidden
        stat["klass"] = "implicit" if stat.implicit
        stat

  sockets: ->
    JSON.stringify(@item.sockets)

  isSkill: ->
    @item.item_type == "Skill"

  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  @cacheTemplates: ->
    Handlebars.templates ||= {}
    Handlebars.templates.account = Handlebars.compile($("#account-template").html())
    Handlebars.templates.facet = Handlebars.compile($("#facet-template").html())
    Handlebars.templates.item = Handlebars.compile($("#result-template").html())
    Handlebars.templates.no_results = Handlebars.compile($("#no-results-template").html())
    Handlebars.templates.pagination = Handlebars.compile($("#pagination-template").html())

    # This template NEEDS to be precompiled because of the
    # different search types, and the impossibility
    # to easily override the field names
    # Handlebars.templates.stat = Handlebars.compile($("#stat-template").html())

  @create: (item, layoutSize = "large") ->
    new Item(item, layoutSize)

@App.Item = Item
