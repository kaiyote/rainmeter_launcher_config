MainCtrl =
  view: (ctrl) -> [
    m '.ctrlbar', [
      m '.title', 'Config Launcher'
      m '.close',
        onclick: -> do ctrl.close
      , 'x'
    ]
    m '.tabs', [
      m 'a.tab',
        href: '#/add'
        class: ctrl.isActive '/add'
      , 'Add'
      m 'a.tab',
        href: '#/edit'
        class: ctrl.isActive '/edit'
      , 'Edit'
      m 'a.tab',
        href: '#/remove'
        class: ctrl.isActive '/remove'
      , 'Remove'
      m 'a.tab',
        href: '#/reorder'
        class: ctrl.isActive '/reorder'
      , 'Reorder'
    ]
  ]

  controller: class
    constructor: ->
      gui = require 'nw.gui'
      @window = do gui.Window.get
      @app = gui.App
      window.ini = new AppLauncherParser 'C:\\Users\\Tim\\Documents\\Rainmeter\\Skins\\SysTracker\\App Launcher\\App_Launcher.ini', ->
        m.route document.querySelector('.content'), '/add',
          '/add': AddCtrl
          '/remove': RemoveCtrl
          '/reorder': ReorderCtrl
          '/edit': EditCtrl

    close: ->
      do @window.close

    isActive: (route) ->
      if route is do m.route
        return 'active'
      ''
