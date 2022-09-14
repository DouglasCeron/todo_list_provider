import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/todo_list_icons.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final bool showEyeIcon;
  final listenNotifier = ValueNotifier(false);
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  bool obscureText;

  TodoListField({
    Key? key,
    required this.label,
    this.showEyeIcon = false,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: listenNotifier,
      builder: (_, isPasswordVisible, __) {
        return TextFormField(
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            isDense: true,
            labelText: label,
            labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
            suffixIcon: showEyeIcon
                ? IconButton(
                    onPressed: () {
                      listenNotifier.value = !isPasswordVisible;
                      obscureText = !obscureText;
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? TodoListIcons.eye
                          : TodoListIcons.eyeSlash,
                      size: 15,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
