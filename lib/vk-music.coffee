VkMusicView = require './vk-music-view'
{CompositeDisposable} = require 'atom'
VK = require 'vk-io'

module.exports = VkMusic =
  vkMusicView: null
  subscriptions: null
  vk: null
  config: {
    userId: {
      title: 'User ID',
      description: 'Id of a user from which to fetch the playlist.',
      type: 'string',
      default: ''
    },
    accessToken: {
      title: 'Access token',
      description: 'Paster here your access token',
      type: 'string',
      default: ''
    },
  },

  activate: (state) ->
    @vk = new VK({token: atom.config.get('vk-music.accessToken')})
    @vkMusicView = new VkMusicView(state.vkMusicViewState)
    pane = atom.workspace.getActivePane()
    item = pane.addItem(@vkMusicView)
    pane.activateItem(item)

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'vk-music:open': => @open()
    @subscriptions.add atom.commands.add 'atom-workspace', 'vk-music:pause': => @pause()
    @subscriptions.add atom.commands.add 'atom-workspace', 'vk-music:resume': => @resume()
    @subscriptions.add atom.commands.add 'atom-workspace', 'vk-music:next': => @next()
    @subscriptions.add atom.commands.add 'atom-workspace', 'vk-music:prev': => @prev()

  deactivate: ->
    @subscriptions.dispose()
    @vkMusicView.destroy()

  serialize: ->
    vkMusicViewState: @vkMusicView.serialize()

  open: ->
    @vk.api.audio.get({user_id: atom.config.get('vk-music.userId')})
      .then((items) => @vkMusicView.print(items.items))
      .catch((error) -> console.log error)
    pane = atom.workspace.getActivePane()
    item = pane.addItem(@vkMusicView)
    pane.activateItem(item)

  pause: ->
    @vkMusicView.pause()

  resume: ->
    @vkMusicView.resume()

  next: ->
    @vkMusicView.next()

  prev: ->
    @vkMusicView.prev()
