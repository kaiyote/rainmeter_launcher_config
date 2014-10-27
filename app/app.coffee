'use strict'

document.addEventListener 'DOMContentLoaded', ->
  m.route.mode = 'hash'
  m.module document.querySelector('.header'), MainCtrl