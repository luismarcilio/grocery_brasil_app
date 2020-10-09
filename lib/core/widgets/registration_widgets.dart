import 'package:flutter/material.dart';

import 'AppTheme.dart' as AppTheme;

Container getDefaultContainer({Widget child}) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: child);
}

Widget authField(
    {IconData icon,
    String labelText,
    TextEditingController controller,
    bool obscureText = false}) {
  return getDefaultContainer(
      child: TextField(
    obscureText: obscureText,
    decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
        labelText: labelText),
    controller: controller,
  ));
}

Widget loginTextField(TextEditingController controller) {
  return authField(
      icon: Icons.email, labelText: 'Email', controller: controller);
}

Widget passwordTextField(TextEditingController controller) {
  return authField(
      icon: Icons.vpn_key,
      labelText: 'Password',
      controller: controller,
      obscureText: true);
}

FlatButton getFlatButton(
    {IconData icon, String text, Color color, Function onPressed}) {
  return FlatButton(
    onPressed: onPressed,
    child: Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      height: 50,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 20,
          ),
          Icon(icon, color: AppTheme.style.backgroundColor),
          SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: TextStyle(color: AppTheme.style.backgroundColor),
          ),
        ],
      ),
    ),
  );
}
