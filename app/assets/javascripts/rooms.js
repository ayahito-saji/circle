/*
 Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
 You can use CoffeeScript in this file: http://coffeescript.org/
 */

var Input = {
    click_button: function(obj) {
        var data_auth = obj.getAttribute("data-auth");
        var param_objects = $("[data-auth='"+data_auth+"']");
        var params = {};
        for(var i=0;i<param_objects.length;i++){
            param_object = param_objects[i];
            switch (param_object.getAttribute("data-type")){
                case "button":
                    params[param_object.name] = ["boolean", false];
                    break;
                default:
                    params[param_object.name] = ["string", param_object.value];
                    break;

            }
        }
        params[obj.name] = ["boolean", true];
        console.log(param_objects);
        console.log(params);
        App.user.push({'order': 'action', 'params': params, 'action_auth': data_auth});
    }
}