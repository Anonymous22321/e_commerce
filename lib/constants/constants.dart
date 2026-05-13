import 'package:e_commerce/constants/colors.dart';
import 'package:flutter/material.dart';

class Constants {
  // CustomTitleText title({
  //  required String title,
  //   Color? color,
  //   double? fontSize,
  //   String? fontFamily,
  //   FontStyle? fontStyle,
  // }) => CustomTitleText();
  // TextStyle headingText({
  //   Color? color,
  //   String? fontFamily,
  //   FontStyle? fontStyle,
  // }) => TextStyle(
  //   fontSize: 30,
  //   fontWeight: FontWeight.bold,
  //   color: color ?? Colors.black,
  //   fontFamily: fontFamily ?? 'Cairo',
  //   fontStyle: fontStyle ?? FontStyle.normal,
  // );
  //
  // TextStyle subTitleText({
  //   Color? color,
  //   String? fontFamily,
  //   FontStyle? fontStyle,
  // }) => TextStyle(
  //   fontSize: 20,
  //   fontWeight: FontWeight.w600,
  //   color: color ?? Colors.grey,
  //   fontFamily: fontFamily ?? 'Cairo',
  //   fontStyle: fontStyle ?? FontStyle.normal,
  // );

  static const CASHED_USER_DATA = "user";


  List<String> labels = [
    "Men",
    "Women",
    "Games",
    "Devices",
    "Gadgets",
    "Accessories",
  ];


  // InputDecoration textFieldStyle({required String hint}) {
  //   return InputDecoration(
  //     hintText: hint,
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(15),
  //       borderSide: BorderSide(color: Colors.grey),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(15),
  //       borderSide: BorderSide(color: Colors.blue),
  //     ),
  //     errorBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(15),
  //       borderSide: BorderSide(color: Colors.red),
  //     ),
  //     focusedErrorBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(15),
  //       borderSide: BorderSide(color: Colors.red),
  //     ),
  //   );
  // }
}

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.title,
    this.fontSize = 22,
    this.height,
    this.maxLines =1,
    this.color = Colors.black,
    this.fontFamily = 'SfProDisplay',
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.bold,
  });

  final String title;
 final int maxLines;
  final double fontSize;
  final double? height;
  final Color color;
  final String fontFamily;
  final FontStyle fontStyle;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        color: color,
        fontFamily: fontFamily,
        fontStyle: fontStyle,

      ),
    );
  }
}

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     this.backgroundColor = primaryColor,
//     this.title = '',
//     this.textColor = Colors.black,
//     this.onPressed,
//     this.width = double.infinity,
//     super.key,
//   });
//
//   final Color backgroundColor;
//   final Color textColor;
//   final String title;
//   final double width;
//   final void onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     final double h = MediaQuery.sizeOf(context).height;
//     final double w = MediaQuery.sizeOf(context).width;
//     return SizedBox(
//       width: width,
//       height: .06 * h,
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
//         child: CustomText(title: title, color: textColor!),
//       ),
//     );
//   }
// }

//Custom Button with icons
class CustomButton extends StatelessWidget {
  const CustomButton({
    this.backgroundColor = primaryColor,
    this.title = '',
    this.textColor = Colors.black,
   required this.onPressed,
    this.width = double.infinity,
    this.icon,
    super.key,
  });

  final Color backgroundColor;
  final Color textColor;
  final String title;
  final double width;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: width,
      height: .06 * h,
      child: ElevatedButton.icon(
        icon: icon,
        style: ElevatedButton.styleFrom(
          iconSize: 25,
          padding: EdgeInsets.only(left: 5),
          alignment: AlignmentGeometry.centerStart,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          
        ),
        onPressed: onPressed,
        label: Center(
          child: CustomText(title: title, color: textColor),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String? hint;
  final String? labelText;
  final bool obscureText; // Pass this in
  final Widget? suffixIcon; // Pass the icon in
  final void Function(String)? onChange;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    this.hint,
    this.labelText,
    this.suffixIcon,
    this.obscureText = false,
    this.onChange,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sharedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.grey),
    );
    return TextFormField(
      onChanged: onChange,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hint,
        border: sharedBorder,
        enabledBorder: sharedBorder,
        focusedBorder: sharedBorder.copyWith(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: sharedBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: sharedBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}


