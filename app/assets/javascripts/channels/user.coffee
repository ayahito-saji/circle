window.broadcast_id = -1
App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    if $('body').attr('data-controller') == 'rooms' and $('body').attr('data-action') == 'show'
      console.log("Connected")
      App.user.push 'order': 'onload'

  disconnected: ->
    # Called when the subscription has been terminated by the server
    if $('body').attr('data-controller') == 'rooms' and $('body').attr('data-action') == 'show'
      console.log("Disconnected")
      $('#alert').html("Connection has been disconnected. <a href='/'>Reconnect</a>")

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if window.broadcast_id < data['broadcast_id'] or data['broadcast_id'] == -1
      window.broadcast_id = data['broadcast_id']
      console.log(data)
      eval(data['value'])
    #alert(data['broadcast_id']+"\n"+data['value'])

  push: (body) ->
    @perform 'push', 'body': body
