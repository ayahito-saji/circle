// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree .

function getUniqueStr(myStrong) {
    var strong = 1000;
    if (myStrong) strong = myStrong;
    return new Date().getTime().toString(16) + Math.floor(strong*Math.random()).toString(16)
}
function received(data) {
    switch (data["order"]) {
        case "member_changed":  //メンバー変更
            member_changed(data["members"]);
            break;
        case "play_started":
            break;
        case "play_ended":
            break;
    }
    // noticeがセットされている場合は，noticeに表示する
    if (data["notice"]) {
        $("#notice").html(data["notice"]);
    }
    // alertがセットされている場合は，alertに表示する
    if (data["alert"]) {
        $("#alert").html(data["alert"]);
    }
}