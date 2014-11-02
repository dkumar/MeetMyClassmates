$(document).ready(function() {
  $("#emailSignup").blur(function(e) {
    if ($("#emailSignup").val().slice(-13) != "@berkeley.edu") {
       $("#userErrors").text("Dude!!! Email must be berkeley.edu!");
    }
    else if ($("#emailSignup").val() == "") {
      $("#userErrors").text("Dude!!! Email must not be empty!");
    }
    else if($('#emailSignup').val().length > 128){
      $('#userErrors').text("Dude!!! Email is too long");
    }
    else {
    	$('#userErrors').text("");
    }
  });
});