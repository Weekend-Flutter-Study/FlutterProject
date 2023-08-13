import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool choolcheckDone = false;
  GoogleMapController? mapController;

  // latitude 위도
  // longitude 경도

  static final LatLng companyLatLng = LatLng(37.5233273, 126.921252);

  // zoom 확대한 정도 (1이 많이 확대된 상태!)
  static final CameraPosition initialPosition =
  CameraPosition(target: companyLatLng, zoom: 15);

  static final double okDistance = 100;

  /* id가 필요한 이유? 맵 위에 여러 동그라미가 있을 경우 구분값 */
  static final Circle withinDistanceCircle = Circle(
      circleId: CircleId('withinDistanceCircle'),
      center: companyLatLng,
      fillColor: Colors.blue.withOpacity(0.5) /* 투명도 50% */,
      radius: okDistance,
      /* 100m */
      strokeColor: Colors.blue,
      strokeWidth: 1);

  static final Circle notWithinDistanceCircle = Circle(
      circleId: CircleId('notWithinDistanceCircle'),
      center: companyLatLng,
      fillColor: Colors.red.withOpacity(0.5) /* 투명도 50% */,
      radius: okDistance,
      /* 100m */
      strokeColor: Colors.red,
      strokeWidth: 1);

  static final Circle checkDoneCircle = Circle(
      circleId: CircleId('checkDoneCircle'),
      center: companyLatLng,
      fillColor: Colors.green.withOpacity(0.5) /* 투명도 50% */,
      radius: okDistance,
      /* 100m */
      strokeColor: Colors.green,
      strokeWidth: 1);

  static final Marker marker =
  Marker(markerId: MarkerId('marker'), position: companyLatLng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar(),
      /* snapShot.data 의 형태를 제너릭으로 명시할 수도 있음 */
      body: FutureBuilder(
        /* future 에는 future 함수를 넣을 수 있다. */
        /* 그리고 future 함수에서 나오는 리턴값을 아래 snapshot 에서 받을 수 있다. */
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          /* snapshot.connectionState? */
          /* waiting -> await 대기중일때 (실행중일떄) */
          /* done    -> 값이 왔을때 */

          /* 값이 오기전까지 프로그레스 */
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == '위치 권한이 허가되었습니다.') {
            return StreamBuilder<Position>(
              // position 이 바뀔때마다 불림
                stream: Geolocator.getPositionStream(),
                /* 위치 권한이 있어야 가능 */
                builder: (context, snapshot) {
                  bool isWithinRanege = false;

                  /* snapshot 에서 계속 위치 받아서 계산 */
                  if (snapshot.hasData) {
                    final start = snapshot.data!; /* 현재위치 */
                    final end = companyLatLng; /* 회사위치 */

                    // 두 점 사이의 거리
                    final distance = Geolocator.distanceBetween(start.latitude,
                        start.longitude, end.latitude, end.longitude);

                    if (distance < okDistance) {
                      isWithinRanege = true;
                    }
                  }

                  return Column(
                    children: [
                      _CustomGoogleMap(
                          initialPosition: initialPosition,
                          /* 출첵 여부 먼저 -> 범위안에 있는지 체크 */
                          circle: choolcheckDone
                              ? checkDoneCircle
                              : isWithinRanege
                              ? withinDistanceCircle
                              : notWithinDistanceCircle,
                          marker: marker,
                          onMapCreated: onMapCreated,
                      ),
                      _ChoolCheckButton(
                        isWithinRange: isWithinRanege,
                        choolCheckDone: choolcheckDone,
                        onPressed: onChoolCheckPressed,
                      )
                    ],
                  );
                });
          }

          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onChoolCheckPressed() async {
    /* 버튼 pop 결과 받기 */
    final result = await showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('출근하기'),
            content: Text('출근을 하시겠습니까?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('취소')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('출근하기'))
            ],
          );
        });

    if (result) {
      setState(() {
        choolcheckDone = true;
      });
    }
  }

  AppBar renderAppbar() {
    return AppBar(
        title: Text(
          '오늘도 출근',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            /* 현재 위치 가져와야 하니까 async */
            onPressed: () async {
              if (mapController == null) {
                return;
              }

              final location = await Geolocator.getCurrentPosition();

              mapController!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                        location.latitude,
                        location.longitude
                    ),
                  ),
              );
            },
            color: Colors.blue,
            icon: Icon(
              Icons.my_location,
            ),
          ),
        ]
    ,
    );
  }

  Future<String> checkPermission() async {
    /* 위치 권한이 켜져 있는지 체크 */
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요';
    }

    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();

      if (checkPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요';
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 세팅에서 허가해주세요';
    }

    return '위치 권한이 허가되었습니다.';
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;
  final MapCreatedCallback onMapCreated;

  const _CustomGoogleMap({required this.initialPosition,
    required this.circle,
    required this.marker,
    required this.onMapCreated,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: initialPosition,
        myLocationButtonEnabled: false,
        /* 내 위치로 가기 */
        circles: Set.from([circle]),
        markers: Set.from([marker]),
        onMapCreated: onMapCreated
      ),
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {
  final bool isWithinRange;
  final VoidCallback onPressed;
  final bool choolCheckDone;

  const _ChoolCheckButton({
    required this.isWithinRange,
    required this.onPressed,
    required this.choolCheckDone,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timelapse_outlined,
              size: 50.0,
              color: choolCheckDone
                  ? Colors.green
                  : isWithinRange
                  ? Colors.blue
                  : Colors.red,
            ),
            const SizedBox(
              height: 20.0,
            ),
            if (!choolCheckDone && isWithinRange)
              TextButton(onPressed: onPressed, child: Text('출근하기'))
          ],
        ));
  }
}

// FutureBuilder Version
//@override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: renderAppbar(),
//       body: FutureBuilder(
//         /* future 에는 future 함수를 넣을 수 있다. */
//         /* 그리고 future 함수에서 나오는 리턴값을 아래 snapshot 에서 받을 수 있다. */
//         future: checkPermission(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           /* snapshot.connectionState? */
//           /* waiting -> await 대기중일때 (실행중일떄) */
//           /* done    -> 값이 왔을때 */
//
//           /* 값이 오기전까지 프로그레스 */
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (snapshot.data == '위치 권한이 허가되었습니다.') {
//             return Column(
//               children: [
//                 _CustomGoogleMap(
//                   initialPosition: initialPosition,
//                   circle: withinDistanceCircle,
//                   marker: marker
//                 ),
//                 _ChoolCheckButton()
//               ],
//             );
//           }
//
//           return Center(
//             child: Text(snapshot.data),
//           );
//         },
//       ),
//     );
//   }
