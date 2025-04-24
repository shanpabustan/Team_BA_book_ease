import 'package:flutter/material.dart';
 
 class CustomSmallButton extends StatelessWidget {
   final String text;
   final VoidCallback onPressed;
   final Color backgroundColor;
   final Color textColor;
   final Color borderColor;
   final Color hoverColor;
 
   const CustomSmallButton({
     super.key,
     required this.text,
     required this.onPressed,
     required this.backgroundColor,
     required this.textColor,
     required this.borderColor,
     required this.hoverColor,
   });
 
   @override
   Widget build(BuildContext context) {
     return MouseRegion(
       child: ElevatedButton(
         onPressed: onPressed,
         style: ButtonStyle(
           backgroundColor: WidgetStateProperty.resolveWith((states) {
             if (states.contains(WidgetState.hovered)) {
               return hoverColor;
             }
             return backgroundColor;
           }),
           foregroundColor: WidgetStateProperty.all(textColor),
           shape: WidgetStateProperty.all(RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
             side: BorderSide(color: borderColor),
           )),
           padding: WidgetStateProperty.all(
             const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
           ),
         ),
         child: Text(text),
       ),
     );
   }
 }