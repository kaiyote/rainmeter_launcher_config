EditCtrl =
  view: (ctrl) ->
    m '.flexrow', [
      m '.listContainer', [
        m 'ul.unstyled', _.reject(ini.orderedKeys, (key) -> ini.ini[key].Static is '1' or -1 < ini.ini[key].MeterStyle.indexOf 'StyleHeader').map (key) ->
          m 'li',
            onclick: (evt) -> ctrl.edit evt.target
          , key
      ]
      m '.editContainer', [
        m '.flexrow', [
          m 'span.short', 'Name:'
          m 'input',
            onchange: m.withAttr 'value', (val) -> ctrl.section = val
            value: ctrl.section or ''
        ]
      ]
    ]
    
  controller: class
    edit: (target) ->
      elm.classList.remove 'focused' for elm in document.querySelectorAll '.listContainer li'
      target.classList.add 'focused'
      @originalSection = @section = target.innerText
      @target = ini.ini[@section]