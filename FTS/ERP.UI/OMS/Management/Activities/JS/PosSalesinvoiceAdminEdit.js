validateInvoiceNumber = function () {
    var invoiceNumber = $("#SearchInv").val();
    if (invoiceNumber == "") {
        return;
    }
    var jsonData = {};
    jsonData.invoiceNumber = invoiceNumber;
    $.ajax({
        type: "POST",
        url: "PosSalesinvoiceAdminEdit.aspx/GetInvoiceDetails",
        data: JSON.stringify(jsonData),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: "true",
        cache: "false",
        success: function (msg) {
            var obj = msg.d;
            if (obj.status == "Ok") {

                if (obj.invoiceId == "")
                    ShowMsg("This Invoice Number Does not exists");
                else
                    window.location.href = 'PosSalesinvoiceAdminEdit.aspx?id=' + obj.invoiceId;

            } else {
                console.log(obj.Msg);
            }
        },
        Error: function (x, e) {
        }
    });


}

ShowMsg = function (msg) {
    jAlert(msg);
}

UpdateClientClick = function () {
    if ($("#UpdateField").val() == "PaymnetDetails") {
        SelectAllData();
    }
}


$(document).ready(function () {
    hideAllcontrol();
    $('#UpdateField').change(function () {
        var UpdatedField = $(this).val();
        hideAllcontrol();
        if (UpdatedField == "docNo") {
            $("#divInvoiceNumber").show();
        }
        else if (UpdatedField == "PaymnetDetails") {
            $("#divPaymentDetails").show();
        }
        else if (UpdatedField == "BillingShipping") {
            $("#divBillingShipping").show();
        }
        else if (UpdatedField == "FinanceBlock") {
            $("#divFinanceBlock").show();
        }

    });
});

hideAllcontrol = function () {
    $("#divInvoiceNumber").hide();
    $("#divPaymentDetails").hide();
    $("#divBillingShipping").hide();
    $("#divFinanceBlock").hide();
}

SearchManualReceipt = function () {

    cManualReceipt.PerformCallback('validateReceiptNumber');

}

ShowManualReceiptPopup = function () {
    cManualReceipt.Show();
}

UpdateManualReceipt = function () {
    cManualReceipt.PerformCallback('UpdateManualReceipt');
    return false;
}


CopyToshipping = function () {
    $("#txtShippingAddress1").val($("#txtBillingAddress1").val());
    $("#txtShippingAddress2").val($("#txtBillingAddress2").val());
    $("#txtShippingAddress3").val($("#txtBillingAddress3").val());
    $("#txtShippingLandmark").val($("#txtBillingLandMark").val());
    $("#txtShippingPin").val($("#txtBillingPin").val());
}

CopyToBilling = function () {
    $("#txtBillingAddress1").val($("#txtShippingAddress1").val());
    $("#txtBillingAddress2").val($("#txtShippingAddress2").val());
    $("#txtBillingAddress3").val($("#txtShippingAddress3").val());
    $("#txtBillingLandMark").val($("#txtShippingLandmark").val());
    $("#txtBillingPin").val($("#txtShippingPin").val());
}