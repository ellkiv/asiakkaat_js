<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Päivitä asiakas</title>
</head>
<body onkeydown="tutkiKey(event)">
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="4" id="ilmo"></th>
				<th colspan="2" class="oikealle"><a href="listaaasiakkaat.jsp">Takaisin listaukseen</a></th>
			</tr>	
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sähköposti</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="button" id="tallenna" value="Hyväksy" onclick="vieTiedot()"></td>
			</tr>
		</tbody>
	</table>
	<input type=hidden name="asiakas_id" id=asiakas_id>
</form>
<span id="ilmo"></span>
</body>
<script>

function tutkiKey(event){
	if(event.keyCode==13){//Enter
		vieTiedot();
	}		
}

document.getElementById("etunimi").focus(); //kursosri etunimikentällä
var asiakas_id = requestURLParam("asiakas_id"); //Funktio löytyy scripts/main.js
	
	fetch("asiakkaat/haeyksi/" + asiakas_id,{//Lähetetään kutsu backendiin
	      method: 'GET'	      
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastausteksti objektiksi
		return response.json()
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		console.log(responseJson);		
		document.getElementById("etunimi").value = responseJson.etunimi;	
		document.getElementById("sukunimi").value = responseJson.sukunimi;	
		document.getElementById("puhelin").value = responseJson.puhelin;	
		document.getElementById("sposti").value = responseJson.sposti;
		document.getElementById("asiakas_id").value = responseJson.asiakas_id;
	});
//Funktio tietojen muuttamista varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana muutetut tiedot json-stringinä.
//PUT /asiakkaat/
	function vieTiedot(){	
		var ilmo="";
		var etunimi = document.getElementById("etunimi").value;
		var sukunimi = document.getElementById("sukunimi").value;
		var puhelin = document.getElementById("puhelin").value;
		var sposti = document.getElementById("sposti").value;
		
		if(etunimi.length<2 || etunimi.length>50){
			ilmo="Etunimi ei kelpaa!";		
		} else if(sukunimi.length<2 || sukunimi.length>50){
			ilmo="Sukunimi ei kelpaa!";		
		} else if(puhelin.length>20 || puhelin.length<5){
			ilmo="Puhelinnumero ei kelpaa!";
		} else if(sposti.length>100 || sposti.length<5 || sposti.indexOf("@")==-1){
			ilmo="Sähköposti ei kelpaa!";		
		}
		if(ilmo!=""){
			document.getElementById("ilmo").innerHTML=ilmo;
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
			return;
		}
		document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
		document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
		document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
		document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
		var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
		console.log(formJsonStr);
		//Lähetään muutetut tiedot backendiin
		fetch("asiakkaat",{//Lähetetään kutsu backendiin
		      method: 'PUT',
		      body:formJsonStr
		    })
		.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json();
		})
		.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Tietojen päivitys epäonnistui";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML= "Tietojen päivitys onnistui";			      	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		});	
		document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake	
}
</script>
</html>