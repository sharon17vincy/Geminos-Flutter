import 'package:flutter/material.dart';
import '../Theme.dart';

class SolidButton extends StatefulWidget {
  final double width;
  final bool solid;
  final bool loading;
  final String title;
  final VoidCallback onTap;

  const SolidButton({Key? key, required this.title, required this.width, required this.solid, required this.loading,  required this.onTap}) : super(key: key);

  @override
  _SolidButtonState createState() => _SolidButtonState();
}

class _SolidButtonState extends State<SolidButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: widget.solid ? Colors.transparent : Colors.black),
          color: appTheme.primaryColor),
      child: widget.loading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      )
          : widget.title.contains("Connect to Google Account") ? Row(
            children: [
              const SizedBox(width: 16,),
              const Image(
                  image: AssetImage(
                    'assets/images/google.png',
                  ),
                  width: 25.0),
              const SizedBox(width: 16,),
              Text(
              widget.title,
              style: normalStyle.copyWith(color: widget.solid ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
            ],
          ) : Text(
          widget.title,
          style: normalStyle.copyWith(color: widget.solid ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
    );
  }

}
