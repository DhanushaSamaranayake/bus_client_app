class ActiveNearByAvailableDrivers {
  String? driverId;
  double? locationLatitude;
  double? locationLongitude;

  ActiveNearByAvailableDrivers({
    this.driverId,
    this.locationLatitude,
    this.locationLongitude,
  });

  /*ActiveNearByAvailableDrivers.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    locationLatitude = json['location_latitude'];
    locationLongitude = json['location_longitude'];
  }*/
}
