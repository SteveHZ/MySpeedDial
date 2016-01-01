<script type = "text/javascript">

	function getHeading () {
		return document.getElementById('header').value;
	}
	
	function toggleTable () {
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
	
	addLoadEvent (toggleTable);
</script>