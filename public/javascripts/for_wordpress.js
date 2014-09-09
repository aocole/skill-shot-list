var locations;
var map;

var myOptions = {
  mapTypeId: google.maps.MapTypeId.HYBRID,
  center: new google.maps.LatLng(47.610, -122.293),
  zoom: 11
};

// used to center and zoom the map
var bounds = new google.maps.LatLngBounds();

// Sample custom marker code created with Google Map Custom Marker Maker
// http://powerhut.co.uk/googlemaps/custom_markers.php
var image = new google.maps.MarkerImage(
  'http://list.skill-shot.com/images/marker.png',
  new google.maps.Size(20,34),
  new google.maps.Point(0,0),
  new google.maps.Point(10,34)
);

var shadow = new google.maps.MarkerImage(
  'http://list.skill-shot.com/images/shadow.png',
  new google.maps.Size(40,34),
  new google.maps.Point(0,0),
  new google.maps.Point(10,34)
);
var shape = {
  coord: [13,0,15,1,16,2,17,3,18,4,18,5,19,6,19,7,19,8,19,9,19,10,19,11,19,12,19,13,18,14,18,15,17,16,16,17,15,18,14,19,14,20,13,21,13,22,12,23,12,24,12,25,11,26,11,27,11,28,11,29,11,30,11,31,11,32,11,33,8,33,8,32,8,31,8,30,8,29,8,28,8,27,8,26,7,25,7,24,7,23,6,22,6,21,5,20,5,19,4,18,3,17,2,16,1,15,1,14,0,13,0,12,0,11,0,10,0,9,0,8,0,7,0,6,1,5,1,4,2,3,3,2,4,1,6,0,13,0],
  type: 'poly'
};

var latlng;
var marker;
infoWindow = new google.maps.InfoWindow({
      });

var setLocations = function(locs) {
  locations = locs;
  if (map != undefined) {
    onLocationsSet();
  }
}

var buildInfo = function(location) {
  var info = "<div style='font-family: \"Trebuchet MS\", sans-serif; white-space:nowrap;'>";
  info += "<div><strong>";
  if (location.url != "") {
    info += "<a href='" + location.url + "'>"
  }
  info += location.name 
  if (location.url != "") {
    info += "</a>"
  }
  info += "</strong></div>"
  
  info += "<a href='http://maps.google.com/maps?q=" + encodeURIComponent([location.address, location.city, location.postal_code].join(', ')) + "'>";
  info += "<address><div>" 
    + location.address + "</div></address></a>";

  info += "<a href='tel:" + encodeURIComponent(location.phone) + "'>" + location.phone + "</a>";

  info += "<ul style='padding-left:8px; margin-top: 0.5em'>";
  jQuery.each(location.machines, function(_, machine) {
    info += "<li>" + machine.title.name + "</li>";
  });
  info += "</ul>";

  info += "</div>";
  return $(info)[0];
}

jQuery(function(){
  if (document.getElementById("map") != null) {
    map = new google.maps.Map(document.getElementById("map"), myOptions);
    if (locations != undefined) {
      onLocationsSet();
    }
  }
});
