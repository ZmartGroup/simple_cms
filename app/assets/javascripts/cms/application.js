//= require cms/jquery-2.1.0.min
//= require cms/bootstrap.min
//= require cms/jHtmlArea-0.7.5.min

$(function(){
    var html_id;
    function isIE(){
	var user_agent = navigator.userAgent.toLowerCase();
	return (user_agent.indexOf('msie') != -1) ? parseInt(user_agent.split('msie')[1]) : false;
    }
    var is_ie = isIE();
    $.browser = {msie: is_ie < 9};
    $("#editor_input").htmlarea({toolbar: ["bold", "italic", "underline"]});

    $(".cms_editable").on("click", function(ev){
        ev.preventDefault();
        html_id = $(this).attr("id");
        $("#editor_item").val(html_id.substring(3));
        $("#editor_input").val($(this).text());
	$("#editor_input").htmlarea('html', $(this).html());
	$(".jHtmlArea, iframe").css('width', '100%');
        $("#editor").removeClass('hide').modal("show");
    });

    $("#editor_form").on("submit", function(ev){
        ev.preventDefault();
        var form = $(this);
        $.post(form.attr("action"), form.serialize(), function(sanitized_html){
	    $("#editor").modal("hide");
            $("#" + html_id).html(sanitized_html);
        });
    });
});
