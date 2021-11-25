import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:sos_app/main.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/widgets.dart';

class SosHomePage extends StatelessWidget {

  SosHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DelayedList(),
      ),
    );
  }
}

class DelayedList extends StatefulWidget {
  @override
  _DelayedListState createState() => _DelayedListState();
}

class _DelayedListState extends State<DelayedList> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    return isLoading ? ShimmerList() : DataList(timer);
  }
}

class DataList extends StatelessWidget {
  final Timer timer;
  final howToUsePopUp = HowToUseData.howToUsePopUp;

  DataList(this.timer);

  @override
  Widget build(BuildContext context) {
    timer.cancel();
    return Scaffold(
      body:
        Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          // children: <Widget>[
          children: <Widget>[ 
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              
              child:  HowToUseButton(
                  tileColor: howToUsePopUp.color,
                  pageTitle: howToUsePopUp.title,
                  onTileTap: () => context.router.push(
                    HowToUseRoute(
                      howToUseID: howToUsePopUp.id,
                    ),
                  ) // onTileTap
                ),
            ), // How To Use App Placeholder  
            

            SizedBox(height: 20), // Spacing visuals

            Center(
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.35,
                // alignment: Alignment.center,
                // color: Colors.grey,
                child: 
                  Image.asset(
                    "assets/images/SoundwavePlaceholder.png",
                    fit: BoxFit.fitWidth
                  ),
              ), // Soundwave Placeholder
            ),
            

            SizedBox(height: 20), // Spacing visuals

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              
              children: <Widget>[
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.grey,
                  child: 
                    Image.asset(
                    "assets/images/CameraPlaceholder.jpg",
                    fit: BoxFit.cover
                  ),
                  // child: FrontCameraPreview(),
                ), // Front Camera Preview Placeholder

                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  // color: Colors.grey,
                  child: BackCameraPreview(),
                ), // Back Camera Preview Placeholder
              ],
            ), // Front/Back camera placheolders

            SizedBox(height: 20), // Spacing visuals

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Center(
                    child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Text('MVP Scenario Call Button')
                  ), 
                ), // Scenario MVP Button Placeholder (GENERIC MEDICAL SCENARIO)

                Center(
                    child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Text('Scenario Call Button # 2')
                  ), 
                ), // Scenario Two Button Placeholder

                // Center(
                //     child: Container(
                //     margin: EdgeInsets.symmetric(vertical: 8),
                //     height: 50,
                //     width: MediaQuery.of(context).size.width * 0.8,
                //     alignment: Alignment.center,
                //     color: Colors.grey,
                //     child: Text('Scenario Call Button # 3')
                //   ), 
                // ), // Scenario Three 
              ],
            ) // SOS Scenario Button Placeholders
          ],
        ),
      ) 
    );
  }
}

/************** FRONT CAMERA LOGIC START **************/
// class FrontCameraPreview extends StatefulWidget {
//   final color;
//   final size;

//   FrontCameraPreview({this.color, this.size});

//   @override
//   _FrontCameraPreview createState() => _FrontCameraPreview();
// }

// class _FrontCameraPreview extends State<FrontCameraPreview> {
//   late CameraController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(cameras[1], ResolutionPreset.medium);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return AspectRatio(
//         aspectRatio: controller.value.aspectRatio,
//         child: CameraPreview(controller));
//   }
// }
/************** FRONT CAMERA LOGIC START **************/


/************** BACK CAMERA LOGIC START **************/
class BackCameraPreview extends StatefulWidget {
  final color;
  final size;

  BackCameraPreview({this.color, this.size});

  @override
  _BackCameraPreview createState() => _BackCameraPreview();
}

class _BackCameraPreview extends State<BackCameraPreview> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
 /************** BACK CAMERA LOGIC END **************/

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey,
                child: ShimmerLayout(),
                period: Duration(milliseconds: time),
              ));
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle
            ),
          ),// How To Use App Placeholder  

          SizedBox(height: 20), // Spacing visuals

          Center(
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center,
              color: Colors.grey,
            ), // Soundwave Placeholder
          ),
          

          SizedBox(height: 20), // Spacing visuals

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: <Widget>[
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.grey,
              ), // Front Camera Preview Placeholder

              Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.grey,
              ), // Back Camera Preview Placeholder
            ],
          ), // Front/Back camera placheolders

          SizedBox(height: 20), // Spacing visuals

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ), // Scenario One Button Placeholder (GENERIC MEDICAL SCENARIO)

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ), // Scenario Two Button Placeholder

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ), // Scenario Three Button Placeholder

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ) // Scenario Four Button Placeholder
            ],
          ) // SOS Scenario Button Placeholders
        ],
      ),
    );
  }
}