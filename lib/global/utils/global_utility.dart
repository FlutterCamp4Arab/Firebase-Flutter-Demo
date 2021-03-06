import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotlinproject/global/utils/widget_helper.dart';
import 'package:permission_handler/permission_handler.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}


//{START IMAGE PICKER}
imagePickDialog(BuildContext context, Function selectedfile) {
  showDialog(
      context: context,
      child: new AlertDialog(
          title: getTxtBlackColor(msg:'Select Option', fontWeight:FontWeight.bold),
          content: Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  getImageFromCamera(context, 0, selectedfile);
                },
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: getTxtBlackColor(msg:'Take Photo' )),
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              GestureDetector(
                  onTap: () {
                    getImageFromCamera(context, 1, selectedfile);
                  },
                  child: Container(
                      padding: EdgeInsets.all(15),
                      child:
                          getTxtBlackColor(msg:'Choose From Gallery'))),
            ],
          ))));
}

Future getImageFromCamera(
    BuildContext context, int imageType, Function selectedfile) async {
  Navigator.pop(context);
  var image = await ImagePicker.pickImage(
      source: imageType == 0 ? ImageSource.camera : ImageSource.gallery);
  selectedfile(image);
}
//{END IMAGE PICKER}

int randomNumber() {
  Random random = new Random();
  return random.nextInt(1000);
}

String formatTime(double time) {
  Duration duration = Duration(milliseconds: time.round());
  return [duration.inHours, duration.inMinutes, duration.inSeconds]
      .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
      .join(':');
}

String filesize(dynamic size, [int round = 2]) {
  int divider = 1024;
  int _size;
  try {
    _size = int.parse(size.toString());
  } catch (e) {
    throw ArgumentError("Can not parse the size parameter: $e");
  }

  if (_size < divider) {
    return "$_size B";
  }

  if (_size < divider * divider && _size % divider == 0) {
    return "${(_size / divider).toStringAsFixed(0)} KB";
  }

  if (_size < divider * divider) {
    return "${(_size / divider).toStringAsFixed(round)} KB";
  }

  if (_size < divider * divider * divider && _size % divider == 0) {
    return "${(_size / (divider * divider)).toStringAsFixed(0)} MB";
  }

  if (_size < divider * divider * divider) {
    return "${(_size / divider / divider).toStringAsFixed(round)} MB";
  }

  if (_size < divider * divider * divider * divider && _size % divider == 0) {
    return "${(_size / (divider * divider * divider)).toStringAsFixed(0)} GB";
  }

  if (_size < divider * divider * divider * divider) {
    return "${(_size / divider / divider / divider).toStringAsFixed(round)} GB";
  }

  if (_size < divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider;
    return "${r.toStringAsFixed(0)} TB";
  }

  if (_size < divider * divider * divider * divider * divider) {
    num r = _size / divider / divider / divider / divider;
    return "${r.toStringAsFixed(round)} TB";
  }

  if (_size < divider * divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider / divider;
    return "${r.toStringAsFixed(0)} PB";
  } else {
    num r = _size / divider / divider / divider / divider / divider;
    return "${r.toStringAsFixed(round)} PB";
  }
}
//Widget getVideoThumb(File videoFile){
//  var _controller = VideoPlayerController.file(videoFile)
//    ..initialize().then((_) {
////      setState(() {});
//    });
//  var videoPla =  VideoPlayer(_controller);
//_controller.dispose();
//  return videoPla;
//}

checkPermission(BuildContext ctx, var _storagePermission,
    Function permissionResult) async {
  var _permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> result =
      await _permissionHandler.requestPermissions(_storagePermission);
  bool isPermissionGrented = false;
  result.forEach((key, values) {
    if (values == PermissionStatus.granted)
      isPermissionGrented = true;
    else {
      isPermissionGrented = false;
      permissionResult(isPermissionGrented);
      showSnackBar(ctx, 'Permission denied');
      return;
    }
  });
  permissionResult(isPermissionGrented);
}
