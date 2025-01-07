import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locationProvider.g.dart';
@Riverpod(keepAlive:true)

class LocationGetter extends _$LocationGetter{
  @override
 FutureOr<Position> build(){
    return determinePosition();

  }
}