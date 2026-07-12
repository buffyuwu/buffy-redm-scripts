--Pulling Essentials
VORPcore = exports.vorp_core:GetCore()
BccUtils = exports['bcc-utils'].initiate()
FeatherMenu =  exports['feather-menu'].initiate()

BCCDocumentsMainMenu = FeatherMenu:RegisterMenu('bcc-documents:mainmenu', {
    top = '50%',
    left = '50%',
    ['720width'] = '500px',
    ['1080width'] = '600px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '900px',
    style = {},
    contentslot = {
      style = {
        ['height'] = '350px',
        ['min-height'] = '250px',
        ['border'] = '6px solid #000',
      }
    },
    draggable = true
  }, {
    opened = function()
        DisplayRadar(false)
    end,
    closed = function()
        DisplayRadar(true)
    end,
})

BCCDocumentsInspectMenu = FeatherMenu:RegisterMenu('bcc-documents:inspectmenu', {
    top = '50%',
    left = '50%',
    ['720width'] = '700px',
    ['1080width'] = '700px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '700px',
    style = {['background-image'] = 'url()',},
    contentslot = {
      style = {
        ['height'] = '350px',
        ['min-height'] = '250px',
        ['background-image'] = 'url(https://files.catbox.moe/juy0d8.jpg)',
        ['border'] = '6px solid #000',
        ['border-radius'] = '25px',
      }
    },
    draggable = true
  }, {
    opened = function()
        DisplayRadar(false)
    end,
    closed = function()
        DisplayRadar(true)
    end,
})