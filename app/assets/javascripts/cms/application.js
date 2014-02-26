//= require cms/jquery-2.1.0.min
//= require bootstrap.min

$(function(){
    var html_id;

    $(".cms_editable").on("click", function(ev){
        ev.preventDefault();
        html_id = $(this).attr("id");
        $("#editor_item").val(html_id.substring(3));
        $("#editor_input").val($(this).text());
        $("#editor").removeClass('hide').modal("show");
    });

    $("#editor_form").on("submit", function(ev){
        ev.preventDefault();
        var form = $(this);
        $.post(form.attr("action"), form.serialize());
        $("#editor").modal("hide");
        $("#" + html_id).text($("#editor_input").val());
    });
});
