import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  final innercolor;
    final outercolor;
  final child;
  const Pixel({super.key, this.child, this.innercolor, this.outercolor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
      
        child: Container(
          padding: EdgeInsets.all(4),
          color: outercolor,
          child:  ClipRRect(
        borderRadius: BorderRadius.circular(10),
      
        child: Container(
 
          color: innercolor,
          child:  Center(child: child,)
        ),
      ),
        ),
      ),
    );
  }
}
