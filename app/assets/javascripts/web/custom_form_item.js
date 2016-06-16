function custom_item_loaded() {
    console.log("custom_item_loaded called, start initializing");
    popup_messages = JSON.parse($("#popup-messages").val());

    initDiet();
    registerCustomItemHandlers();
}

function registerCustomItemHandlers() {

    $(".deleteCustomFormIcon").click(function (e) {
        console.log("delete cf item clicked, "+ e.target.parentElement.action);
        $.ajax({
            url: e.target.parentElement.action,
            type: 'DELETE',
            error: function (jqXHR, textStatus, errorThrown) {
                console.log("delete cf AJAX Error: " + textStatus);
            },
            success: function (data, textStatus, jqXHR) {
                location.href=getParent(document.location.href);
            }
        });
    });

    $(".editCustomFormIcon").click(function (e) {
        console.log("edit cf item clicked, " + e.target.parentElement);
        $("#addFormGroup").removeClass('hidden');
        $("#showFormGroup").addClass('hidden');
    });

    $("#cancelFormButton").click(function (e) {
        console.log("cancel edit clicked, " + e.target.parentElement);
        $("#addFormGroup").addClass('hidden');
        $("#showFormGroup").removeClass('hidden');
    });
    $("#form-add-element").submit(function () {
        console.log("add element clicked " + this);
        console.log($(this).serialize());
        return false;
    });

    $(".listDeleteIcon").click(function(e) {
        var cfeId = e.target.dataset.formelementid;
        var cfId = e.target.dataset.formid;
        var userId = $("#current-user-id").val();
        var url = "/users/"+userId+"/custom_forms/"+cfId+"/custom_form_elements/"+cfeId;
        console.log("del clicked :"+url);
        $.ajax({
            url: url,
            type: 'DELETE',
            error: function (jqXHR, textStatus, errorThrown) {
                console.log("delete cfe AJAX Error: " + textStatus);
            },
            success: function (data, textStatus, jqXHR) {
                location.reload();
            }
        });
    });
}

function getParent(url) {
    var arr = url.split("/");
    var len = arr.length;
    if(arr[len-1]==="") {
        len = len - 1;
    }
    return arr.slice(0, len-1).join("/");
}
