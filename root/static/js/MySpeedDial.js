
// 	My SpeedDial.js 24/10/14
//	addLoadEvent.js added 26/10/14 removed 05/07/15

//addLoadEvent (ajaxFunc);

/*function ajaxFunc () {
	var heading =  $('#header').val();
	var queryString = "/" + heading;

	var request = $.ajax ({
		url : "edit" + queryString,
		type : "GET",
		datatype : "html"
	});
	
	request.done (function (msg) {
		$('#results').html (msg);
		stripeTables ();
	});
	
	request.fail (function (jqXHR, textStatus) {
		alert ("Request failed : " + textStatus);
	});
}
*/
/*
function getHeading () {
	return document.getElementById('header').value;
}
	
function toggletable () {
	var selected = document.getElementById("header").value;
	var tables = document.getElementsByTagName("table");
	for (var i = 0;i < tables.length; i++) {
		var tableid = tables[i].getAttribute("id"); 
		if (tableid == selected) {
			document.getElementById(tableid).style.display='';
		} else {
			document.getElementById(tableid).style.display='none';
		}
	}
	stripeTables();
}
	
addLoadEvent (toggletable);
*/