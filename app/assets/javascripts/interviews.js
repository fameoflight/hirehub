$(document).on("focus", "[data-behaviour~='datepicker']", function (e) {
    $(this).datepicker({"format": "dd/mm/yyyy", "weekStart": 1, "autoclose": true});
    $(this).removeClass('table-bordered table-striped');
});

$(document).on("focus", "[data-behaviour~='timepicker']", function (e) {
    $(this).timepicker();
    $(this).removeClass('table-bordered table-striped');
});
