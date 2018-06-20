/*
 Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
 You can use CoffeeScript in this file: http://coffeescript.org/
 */

var Input = {
    click_button: function(obj) {
        console.log("Click Button: Value: "+obj.innerText+"\nAuth Token:"+obj.getAttribute("data-auth"));
        App.user.push({'order': 'action', 'type': 'button', 'value': obj.innerText, 'action_auth': obj.getAttribute("data-auth")});
    }
}