import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SeaOilTextSize {
  static const double extraSmall = 10.0;
  static const double small = 12.0;
  static const double standard = 14.0;
  static const double medium = 16.0;
  static const double large = 22.0;
}

class SeaOilTextColor {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
}

AppBar appBarWithoutIcon(String apptitle, Color color) {
  return AppBar(
    title: Text(apptitle),
    backgroundColor: color,
  );
}

AppBar appBarWithIcon(
    String apptitle, Color color, bool _isSearching, IconData icon) {
  return AppBar(
    centerTitle: true,
    title: Text(apptitle),
    backgroundColor: color,
    leading: _isSearching ? seaoilIconButton(Icon(icon)) : null,
    actions: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
              onTap: () {}, child: seaoilIconButton(Icon(icon))))
    ],
  );
}

IconButton seaoilIconButton(Icon iconButton) {
  return IconButton(onPressed: () {}, icon: iconButton);
}

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    suffixIcon: Icon(icon, color: const Color.fromRGBO(50, 62, 72, 1.0)),
    hintText: hintText,
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

ElevatedButton seaoilButton(
  String titleButton,
  BuildContext context,
  String navigationName,
) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {},
      child: Text(titleButton));
}

class SeaoilButton extends StatelessWidget {
  SeaoilButton({
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
  });

  final String text;
  final GestureTapCallback onPressed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: onPressed,
        child: Text(text));
  }
}

showModalErrorDialog(BuildContext context, String errrMessage) {
  showDialog(
    context: context,
    builder: (ctx) => Theme(
        data: ThemeData(
            dialogBackgroundColor: Colors.lightBlue,
            dialogTheme: const DialogTheme(backgroundColor: Colors.lightBlue)),
        child: CupertinoAlertDialog(
          title: const Text('Error',
              style: TextStyle(fontSize: 12, color: Colors.black)),
          content: Text(errrMessage),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK',
                  style: TextStyle(fontSize: 12, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )),
  );
}

class LoadingScreen {
  BuildContext theContext;
  final bool barrierDismissible;
  final Color textColor;
  final Color bodyColor;
  final Color circularIndicatorColor;

  LoadingScreen({
    required this.theContext,
    this.barrierDismissible = true,
    this.textColor = Colors.black,
    this.bodyColor = Colors.white,
    this.circularIndicatorColor = Colors.blueAccent,
  });

  void show(BuildContext theContext) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: theContext,
      builder: (BuildContext theContext) {
        return _getAlertDialog();
      },
    );
  }

  Widget _getAlertDialog() {
    return WillPopScope(
      onWillPop: () async => barrierDismissible,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          color: Colors.transparent,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: bodyColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        child: SpinKitFadingCircle(
                          color: circularIndicatorColor,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Please wait.",
                        style: TextStyle(color: textColor, fontSize: 12),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
