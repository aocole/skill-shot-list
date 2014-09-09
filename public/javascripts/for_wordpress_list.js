var locationsList;
var onLocationsListSet = function() {
  $('#list').html(locationsList)
}
var setLocationsList = function(locs) {
  locationsList = locs[0];
  $(function(){onLocationsListSet()});
}

