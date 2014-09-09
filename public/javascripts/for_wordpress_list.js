var locationsList;
var onLocationsListSet = function() {
  jQuery('#list').html(locationsList)
}
var setLocationsList = function(locs) {
  locationsList = locs[0];
  jQuery(function(){onLocationsListSet()});
}

