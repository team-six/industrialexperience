//Menu Drop Down
$(".top-level > span").click(function(){	
	$(this).next(".second-level").slideToggle("fast");
});

//Import CSV Toggle
$(".import-button").click(function(){
	$("div.csv-import").slideToggle();
});

//Hide Flash alert after 3 seconds
setTimeout(function(){
  $(".flash").fadeOut("slow");
},3000);


//Find active link, open parent
$(".current").parent().parent().find("span").click();

$(".active-section").show();

//Live Clock

function updateClock(){
	var currentTime = new Date ( );
  var currentHours = currentTime.getHours ( );
  var currentMinutes = currentTime.getMinutes ( );
  var currentSeconds = currentTime.getSeconds ( );

  // Pad the minutes and seconds with leading zeros, if required
  currentMinutes = ( currentMinutes < 10 ? "0" : "" ) + currentMinutes;
  currentSeconds = ( currentSeconds < 10 ? "0" : "" ) + currentSeconds;

  // Choose either "AM" or "PM" as appropriate
  var timeOfDay = ( currentHours < 12 ) ? "AM" : "PM";

  // Convert the hours component to 12-hour format if needed
  //currentHours = ( currentHours > 12 ) ? currentHours - 12 : currentHours;

  // Convert an hours component of "0" to "12"
  //currentHours = ( currentHours == 0 ) ? 12 : currentHours;

  // Compose the string for display
  var currentTimeString = currentHours + ":" + currentMinutes ;
   
   
  $("#clock").text(currentTimeString);       
}


 setInterval('updateClock()', 0);

 $("body").nanoScroller();



