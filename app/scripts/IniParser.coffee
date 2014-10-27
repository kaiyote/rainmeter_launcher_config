class IniParser
  constructor: (@filePath, callback) ->
    @ini = {}
    @orderedKeys = []
    groupRegex = /^\[.+?\][\s\S]+?(?=^\[)/gm
    titleRegex = /\[(.+?)\]/
    keyPairRegex = /(.+?)=(.+)/
    
    parseGroup = (group) =>
      lines = group.split @newLine
      # first line is always groupTitle
      key = lines[0].match(titleRegex)[1]
      @orderedKeys.push key
      @ini[key] = {}
      for line in lines[1..]
        if (pair = line.match keyPairRegex) isnt null
          @ini[key][pair[1]] = pair[2]
          
    require('fs').readFile @filePath, encoding: 'utf8', (err, data) =>
      if err then @ini.error = err else
        lastIndex = 0
        @newLine = if data.match /\r\n/ then '\r\n' else '\n'
        until (match = groupRegex.exec data) is null
          parseGroup match[0]
          lastIndex = groupRegex.lastIndex
        # groupRegex only matches up to, but not including, the last one
        parseGroup data.substr(lastIndex)
        
        callback and do callback
        
  save: ->
    data = []
    for key in @orderedKeys
      data.push "[#{key}]"
      for key, value of @ini[key]
        data.push "#{key}=#{value}"
      data.push ''
    require('fs').writeFile "C:\\Users\\Tim\\Desktop\\testIni.ini", data.join @newLine
    
  set: (section, key, value) ->
    unless @ini[section]
      @ini[section] = {}
      @orderedKeys.push section
    @ini[section][key] = value unless !key? or !value?
    return
    
  remove: (section, key) ->
    unless key then delete @ini[section] else delete @ini[section][key]
    
class AppLauncherParser extends IniParser
  static: ->
    _.filter @orderedKeys, (key) => @ini[key].Static?
    
  groups: ->
    _.filter @orderedKeys, (key) => !@ini[key].Static? and @ini[key].Meter is 'String'
    
  launchers: (group) ->
    _.filter @orderedKeys, (key) => !@ini[key].Static? and @ini[key].Meter is 'Image' and if group then -1 < @ini[key].Group.split('|').indexOf group else yes
    
  addLauncher: (group, name, icon, action) ->
    orderedIndex = @orderedKeys.indexOf if @launchers(group).length is 0 then group else _.last @launchers group
    groupIndex = @launchers(group).length
    
    @set name, 'Meter', 'Image'
    @set name, 'Group', "Launcher|#{group}"
    @set name, 'MeterStyle', 'StyleLauncher'
    @set name, 'X', if groupIndex % 5 is 0 then '5' else '5R'
    @set name, 'Y', if groupIndex % 5 is 0 then '5R' else 'r'
    @set name, 'ImageName', icon
    @set name, 'LeftMouseUpAction', "!Execute [\"#{action}\"]"
    
    launcher = do @orderedKeys.pop
    @orderedKeys.splice orderedIndex + 1, 0, launcher
    return
    
  addGroup: (name) ->
    index = @groups().length
    @set name, 'Meter', 'String'
    @set name, 'MeterStyle', 'StyleText|StyleHeader'
    @set name, 'Y', if index is 0 then '3' else '3R'
    return