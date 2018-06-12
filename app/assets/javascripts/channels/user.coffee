App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    if $('body').attr('data-controller') == 'rooms' and $('body').attr('data-action') == 'show'
      App.user.push 'order': 'onload'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log(data)
    eval(data)

  push: (body) ->
    @perform 'push', 'body': body
