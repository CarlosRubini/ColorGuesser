import 'dart:async';
import 'dart:io';
import 'package:color_parser/color_parser.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ColorGuesserHome extends StatefulWidget {
  const ColorGuesserHome({Key? key}) : super(key: key);

  @override
  ColorGuesserHomeState createState() => ColorGuesserHomeState();
}

class ColorGuesserHomeState extends State<ColorGuesserHome> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  MemoryImage? memoryImage;
  Timer? timer;
  int teste = 0;

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(milliseconds: 800), (Timer t) => {_getColorFromImage()});
    loadCamera();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Color Guesser"),
          backgroundColor: Colors.blue,
        ),
        body: Column(children: [
          Expanded(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: controller == null
                      ? const Center(child: Text("Loading Camera..."))
                      : !controller!.value.isInitialized
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : returnCameraPreview())),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
            width: 250,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            margin: const EdgeInsets.all(20),
            child: ImagePixels(
                imageProvider: memoryImage,
                builder: (BuildContext context, ImgDetails img) {
                  if (img.width == null) return Container();

                  Color color = img.pixelColorAt!(
                      (img.width! / 2).round(), (img.height! / 2).round());

                  String colorName = colorStringToColor.entries
                          .firstWhere((element) => element.value == Colors.blue)
                      as String;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)))),
                      const SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              "RGB: ${color.red},${color.green},${color.blue} ",
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                })));
  }

  AspectRatio returnCameraPreview() {
    return AspectRatio(
        aspectRatio: 1 / controller!.value.aspectRatio,
        child: CameraPreview(
          controller!,
          child: const Opacity(
            opacity: 0.5,
            child: Icon(Icons.api_rounded),
          ),
        ));
  }

  _getColorFromImage() async {
    if (controller!.value.isInitialized) {
      XFile file = await controller!.takePicture();
      memoryImage = MemoryImage(await file.readAsBytes());
      File filePath = File(file.path);
      filePath.delete();
      setState(() {});
    }
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  static const Map<String, Color> colorStringToColor = {
    'amber': Colors.amber,
    'amberAccent': Colors.amberAccent,
    'black': Colors.black,
    'black12': Colors.black12,
    'black26': Colors.black26,
    'black38': Colors.black38,
    'black45': Colors.black45,
    'black54': Colors.black54,
    'black87': Colors.black87,
    'blue': Colors.blue,
    'blueAccent': Colors.blueAccent,
    'blueGrey': Colors.blueGrey,
    'brown': Colors.brown,
    'cyan': Colors.cyan,
    'cyanAccent': Colors.cyanAccent,
    'deepOrange': Colors.deepOrange,
    'deepOrangeAccent': Colors.deepOrangeAccent,
    'deepPurple': Colors.deepPurple,
    'deepPurpleAccent': Colors.deepPurpleAccent,
    'green': Colors.green,
    'greenAccent': Colors.greenAccent,
    'grey': Colors.grey,
    'indigo': Colors.indigo,
    'indigoAccent': Colors.indigoAccent,
    'lightBlue': Colors.lightBlue,
    'lightBlueAccent': Colors.lightBlueAccent,
    'lightGreen': Colors.lightGreen,
    'lightGreenAccent': Colors.lightGreenAccent,
    'lime': Colors.lime,
    'limeAccent': Colors.limeAccent,
    'orange': Colors.orange,
    'orangeAccent': Colors.orangeAccent,
    'pink': Colors.pink,
    'pinkAccent': Colors.pinkAccent,
    'purple': Colors.purple,
    'purpleAccent': Colors.purpleAccent,
    'red': Colors.red,
    'redAccent': Colors.redAccent,
    'teal': Colors.teal,
    'tealAccent': Colors.tealAccent,
    'transparent': Colors.transparent,
    'white': Colors.white,
    'white10': Colors.white10,
    'white12': Colors.white12,
    'white24': Colors.white24,
    'white30': Colors.white30,
    'white38': Colors.white38,
    'white54': Colors.white54,
    'white60': Colors.white60,
    'white70': Colors.white70,
    'yellow': Colors.yellow,
    'yellowAccent': Colors.yellowAccent,
  };
}
