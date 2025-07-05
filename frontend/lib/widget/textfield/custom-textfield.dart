import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String subText;
  final double height;
  final double width;
  final bool? issubFixIcon;
  final String? subFixIconPath;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.subText,
    required this.controller,
    required this.height,
    required this.width,
    this.issubFixIcon,
    this.subFixIconPath,
    required this.isPassword,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.subText,
            style: const TextStyle(fontSize: 14, color: Color(0xFF207198))),
        const SizedBox(height: 5),
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            cursorColor: const Color(0xFF207198),
            decoration: InputDecoration(
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : (widget.issubFixIcon ?? false) &&
                          widget.subFixIconPath != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            widget.subFixIconPath!,
                            width: 24,
                            height: 24,
                          ),
                        )
                      : const SizedBox(),
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF207198),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF207198),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF207198),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
