$(document).ready(function() {
	
	// oAuth code 
	gapi.load('auth2', function() {
		gapi.auth2.init();
	});

	function onSignIn(googleUser) {
	  var profile = googleUser.getBasicProfile();
	  console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
	  console.log('Name: ' + profile.getName());
	  console.log('Image URL: ' + profile.getImageUrl());
	  console.log('Email: ' + profile.getEmail());
	},

	function signOut() {
		var auth2 = gapi.auth2.getAuthInstance();
	  auth2.signOut().then(function () {
	    console.log('User signed out.');
	  });
	}
	if (auth2.isSignedIn.get()) {
	  var profile = auth2.currentUser.get().getBasicProfile();
	  console.log('ID: ' + profile.getId());
	  console.log('Full Name: ' + profile.getName());
	  console.log('Given Name: ' + profile.getGivenName());
	  console.log('Family Name: ' + profile.getFamilyName());
	  console.log('Image URL: ' + profile.getImageUrl());
	  console.log('Email: ' + profile.getEmail());
	}
})