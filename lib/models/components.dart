class Components {
  final double frameDuration;
  final double frameKm;
  final double forkDuration;
  final double forkKm;
  final double stringDuration;
  final double stringKm;
  final double brakeForwardDuration;
  final double brakeForwardKm;
  final double brakeBackwardDuration;
  final double brakeBackwardKm;
  final double wheelForwardDuration;
  final double wheelForwardKm;
  final double wheelBackwardDuration;
  final double wheelBackwardKm;
  final double tireForwardDuration;
  final double tireForwardKm;
  final double tireBackwardDuration;
  final double tireBackwardKm;
  final double airChamberForwardDuration;
  final double airChamberForwardKm;
  final double airChamberBackwardDuration;
  final double airChamberBackwardKm;
  final double transmissionDuration;
  final double transmissionKm;

  Components(
      this.frameDuration,
      this.frameKm,
      this.forkDuration,
      this.forkKm,
      this.stringDuration,
      this.stringKm,
      this.brakeForwardDuration,
      this.brakeForwardKm,
      this.brakeBackwardDuration,
      this.brakeBackwardKm,
      this.wheelForwardDuration,
      this.wheelForwardKm,
      this.wheelBackwardDuration,
      this.wheelBackwardKm,
      this.tireForwardDuration,
      this.tireForwardKm,
      this.tireBackwardDuration,
      this.tireBackwardKm,
      this.airChamberForwardDuration,
      this.airChamberForwardKm,
      this.airChamberBackwardDuration,
      this.airChamberBackwardKm,
      this.transmissionDuration,
      this.transmissionKm);

  Components.fromJson(Map<String, dynamic> json)
      : frameDuration = double.parse(json['frame_duration']),
        frameKm = double.parse(json['frame_km']),
        forkDuration = double.parse(json['fork_duration']),
        forkKm = double.parse(json['fork_km']),
        stringDuration = double.parse(json['string_duration']),
        stringKm = double.parse(json['string_km']),
        brakeForwardDuration = double.parse(json['brake_forward_duration']),
        brakeForwardKm = double.parse(json['brake_forward_km']),
        brakeBackwardDuration = double.parse(json['brake_backward_duration']),
        brakeBackwardKm = double.parse(json['brake_backward_km']),
        wheelForwardDuration = double.parse(json['wheel_forward_duration']),
        wheelForwardKm = double.parse(json['wheel_forward_km']),
        wheelBackwardDuration = double.parse(json['wheel_backward_duration']),
        wheelBackwardKm = double.parse(json['wheel_backward_km']),
        tireForwardDuration = double.parse(json['tire_forward_duration']),
        tireForwardKm = double.parse(json['tire_forward_km']),
        tireBackwardDuration = double.parse(json['tire_backward_duration']),
        tireBackwardKm = double.parse(json['tire_backward_km']),
        airChamberForwardDuration =
            double.parse(json['air_chamber_forward_duration']),
        airChamberForwardKm = double.parse(json['air_chamber_forward_km']),
        airChamberBackwardDuration =
            double.parse(json['air_chamber_backward_duration']),
        airChamberBackwardKm = double.parse(json['air_chamber_backward_km']),
        transmissionDuration = double.parse(json['transmission_duration']),
        transmissionKm = double.parse(json['transmission_km']);
}
