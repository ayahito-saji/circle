App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    if $('body').attr('data-controller') == 'plays' and $('body').attr('data-action') == 'show'
      App.user.push 'order': 'onload'

  disconnected: ->
    # Called when the subscription has been terminated by the server
    if $('body').attr('data-controller') == 'plays' and $('body').attr('data-action') == 'show'
      $('#alert').html "Connection has been disconnected. <a href='/'>Reconnect</a>"

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#debug').append "<tr><td>Received</td><td>#{JSON.stringify(JSON.parse(data), null, '\t')}</td></tr>"
    console.log JSON.parse(data)

  push: (body) ->
    body.echo_id = getUniqueStr()
    body.controller = $('body').attr('data-controller')
    body.action = $('body').attr('data-action')
    @perform 'received', 'body': body
    $('#debug').append "<tr><td>Pushed</td><td>#{JSON.stringify(body, null, '\t')}</td></tr>"