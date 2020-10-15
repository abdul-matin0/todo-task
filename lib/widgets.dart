import 'package:flutter/material.dart';

// Task Card Widget
class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Unnamed Task)",
            style: TextStyle(
              color: Color(0xFF211551),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              desc ?? "(No Description Added)",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF86829D),
                height: 1.5, // line height
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// To-do Widget
class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;

  TodoWidget({this.text, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 24.0,
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                right: 12.0,
              ),
              width: 23.0,
              height: 23.0,
              decoration: BoxDecoration(
                color: isDone ? Color(0xFF7349FE) : Colors.transparent,
                border: isDone
                    ? null // if isDone, noBorder else Add border
                    : Border.all(
                        color: Color(0xFF86829D),
                        width: 1.5,
                      ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Image.asset("assets/images/check_icon.png"),
            ),
            Flexible(
              child: Text(
                text ?? "(Unnamed Todo)",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                  color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                ),
              ),
            ),
          ],
        ));
  }
}

// Remove Glow Effect on Scroll
class NoGlowEffect extends ScrollBehavior{
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {

    return child;
  }
}