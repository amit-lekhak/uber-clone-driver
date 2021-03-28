import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

const String mapKey = "AIzaSyAD8_JmEJ9RnwHUp2woLVw9Fyk3B_V2FhU";
const String mapBoxKey =
    "pk.eyJ1IjoicmlzM3IiLCJhIjoiY2s1YzV3NjdtMWV1bDNucG5sb2M0dnJvOSJ9.ywM58I6P5A-s1CVbaOXJcA";

User firebaseUser;

Users userCurrentInfo;

User currentFirebaseUser;

Position currentPosition;

StreamSubscription<Position> homeTabPageStreamSubscription;

final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

Drivers driversInformation;

StreamSubscription<Position> rideStreamSubscription;

String title = "";
