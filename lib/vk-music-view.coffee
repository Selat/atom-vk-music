module.exports =
class VkMusicView
  constructor: (state) ->
    @element = document.createElement('div')
    @element.classList.add('vk-music')

    message = document.createElement('div')
    message.classList.add('message')
    @element.appendChild(message)

    @audio = new Audio()
    @audio.addEventListener('ended', () => @playNextSong())

  serialize: ->
    return @element.getElementsByClassName('message')[0].textContent

  playNextSong: ->
    if @curId + 1 < @tracks.length
      @play(@curId + 1)

  play: (id) ->
    @curId = id
    @audio.src = @tracks[id]
    @audio.play()

  pause: ->
    @audio.pause()

  resume: ->
    @audio.play()

  print: (items) ->
    @tracks = []
    message = @element.getElementsByClassName('message')[0]
    list = document.createElement('ul')
    for item, id in items
      do(item, id) =>
        li = document.createElement('li')
        a = document.createElement('a')
        a.setAttribute('href', '#')
        a.textContent = "#{item.artist} - #{item.title}"
        a.addEventListener('click', => this.play(id))
        li.appendChild(a)
        list.appendChild(li)
        @tracks.push(item.url)
    message.appendChild(list)

  getTitle: ->
    return "VK Music"

  destroy: ->
    @element.remove()

  getElement: ->
    @element
