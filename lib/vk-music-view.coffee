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
    @curId = 0

  serialize: ->
    return @element.getElementsByClassName('message')[0].textContent

  playNextSong: ->
    if @curId + 1 < @tracks.length
      @play(@curId + 1)

  getLi: (id) ->
    @element.getElementsByClassName('message')[0]
            .getElementsByTagName('ul')[0].getElementsByTagName('li')[id]

  play: (id) ->
    li = @getLi(@curId)
    li.classList.remove('vk-music-current-song')
    @curId = id
    li = @getLi(@curId)
    li.classList.add('vk-music-current-song')
    @audio.src = @tracks[id]
    @audio.play()

  pause: ->
    @audio.pause()

  resume: ->
    @audio.play()

  next: ->
    if @curId + 1 < @tracks.length
      @play(@curId + 1)

  prev: ->
    if @curId - 1 >= 0
      @play(@curId - 1)

  highlightSelectedSong: (id) ->
    li = @getLi(id)
    li.classList.remove('vk-music-song')
    li.classList.add('vk-music-selected-song')

  unhighlightUnselectedSong: (id) ->
    li = @getLi(id)
    li.classList.remove('vk-music-selected-song')
    li.classList.add('vk-music-song')

  print: (items) ->
    @tracks = []
    message = @element.getElementsByClassName('message')[0]
    list = document.createElement('ul')
    for item, id in items
      do(item, id) =>
        li = document.createElement('li')
        li.addEventListener('mouseenter', => @highlightSelectedSong(id))
        li.addEventListener('mouseleave', => @unhighlightUnselectedSong(id))
        li.addEventListener('click', => this.play(id))
        a = document.createElement('a')
        a.setAttribute('href', '#')
        a.textContent = "#{item.artist} - #{item.title}"
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
