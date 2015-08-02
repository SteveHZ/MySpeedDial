/*
window.onload = function () {
	stripeTables ();
}

$(document).ready (function () {
	stripeTables ();
});
*/

function stripeTables() {
	if (!document.getElementsByTagName) return false;
	var tables = document.getElementsByTagName("table");
	for (var i=0; i<tables.length; i++) {
		var odd = false;
		var rows = tables[i].getElementsByTagName("tr");
		for (var j=0; j<rows.length; j++) {
			if (odd == true) {
				addClass (rows[j],"stripes");
				odd = false;
			} else {
				odd = true;
			}
		}
	}
}

function addClass (element, value) {
	if (! element.className) {
		element.className = value;
	} else {
		var newClassName = element.className;
		newClassName += " ";
		newClassName += value;
		element.className = newClassName;
	}
}
