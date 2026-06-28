import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app/app_strings.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool isMultiline;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.isMultiline = false,
    this.decoration,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showClear = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleChange);
    _focusNode.addListener(_handleChange);
  }

  void _handleChange() {
    setState(() {
      _showClear = widget.controller.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    _focusNode.removeListener(_handleChange);
    _focusNode.dispose();
    super.dispose();
  }

  InputDecoration _getInputDecoration() {
    if (widget.hint.contains(AppStrings.phone)) {
      return InputDecoration(
        floatingLabelBehavior:
            FloatingLabelBehavior.always, // prefix always visible
        prefix: Text(
          '${AppStrings.phPhonePrefix} ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        suffixIcon: _showClear
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged?.call('');
                  _handleChange();
                },
              )
            : null,
        border: OutlineInputBorder(),
      );
    }

    return InputDecoration(
      hintText: widget.hint,
      prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
      suffixIcon: _showClear
          ? IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                widget.controller.clear();
                widget.onChanged?.call('');
                _handleChange();
              },
            )
          : null,
      border: const OutlineInputBorder(),
    );
  }

  TextInputType _getKeyboardType() {
    if (widget.hint.contains(AppStrings.email)) {
      return TextInputType.emailAddress;
    }
    if (widget.hint.contains(AppStrings.phone)) {
      return TextInputType.phone;
    }
    if (widget.hint.contains(AppStrings.password)) {
      return TextInputType.visiblePassword;
    }
    if (widget.isMultiline) return TextInputType.multiline;
    return TextInputType.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      maxLines: widget.isMultiline ? 5 : 1,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType ?? _getKeyboardType(),
      decoration: widget.decoration ?? _getInputDecoration(),
      inputFormatters: [
        if (widget.hint.contains(AppStrings.phone))
          FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: widget.onChanged,
    );
  }
}
