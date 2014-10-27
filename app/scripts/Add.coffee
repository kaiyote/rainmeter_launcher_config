AddCtrl =
  view: (ctrl) -> [
    m 'label', [
      m 'span.long', 'Choose an existing section:'
      m 'select',
        onchange: (evt) -> m.withAttr evt.target.value, ctrl.section
        value: do ctrl.section
      , ini.groups().map (group) ->
        m 'option', {value: group}, group
      m 'div'
    ]
    m 'label', [
      m 'span.long', 'Or make a new one:'
      m 'input', {onchange: m.withAttr 'value', ctrl.section}
      m 'div'
    ]
    m 'label', [
      m 'span.short', 'Name:'
      m 'input',
        onchange: m.withAttr 'value', ctrl.name
        value: do ctrl.name
      m 'div'
    ]
    m '.flexrow', [
      m 'label', [
        m 'span.short', 'Icon:'
        m 'input',
          onchange: m.withAttr 'value', ctrl.icon
          value: do ctrl.icon
      ]
      m 'button',
        onclick: -> ctrl.openFile no
      , 'Browse...'
    ]
    m '.flexrow', [
      m 'label', [
        m 'span.short', 'Action:'
        m 'input',
          onchange: m.withAttr 'value', ctrl.action
          value: do ctrl.action
      ]
      m 'button',
        onclick: -> ctrl.openFile yes
      , 'Browse...'
    ]
    m '.flexrow', [
      m 'button',
        onclick: -> do ctrl.clear
      , 'Clear'
      m 'button',
        onclick: -> do ctrl.save
      , 'Save'
    ]
    m 'input#icon.hidden[type="file"][accept=".jpg,.jpeg,.ico,.png"]'
    m 'input#action.hidden[type="file"][accept=".exe"]'
  ]

  controller: class
    constructor: ->
      @section = m.prop 'RPG'
      @name = m.prop ''
      @icon = m.prop ''
      @action = m.prop ''

    save: ->
      unless do @name is '' or do @icon is '' or do @action is ''
        ini.addGroup do @section if -1 is ini.groups().indexOf do @section
        ini.addLauncher do @section, do @name, do @icon, do @action
        do window.ini.save
        do @clear

    openFile: (isAction) ->
      file = document.querySelector if isAction then '#action' else '#icon'
      file.onchange = =>
        if isAction then @action file.value else @icon file.value
        file.value = ''
        do m.redraw
      do file.click

    clear: ->
      @name ''
      @icon ''
      @action ''
      @section 'RPG'
      document.querySelector('span.long + input').value = ''
