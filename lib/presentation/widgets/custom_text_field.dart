import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final Iterable<String>? autofillHints;
  final int? maxLines;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? label;
  final String? hintText;
  final bool isObscure;
  final Color? fill;
  final bool isBorder;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? trailing;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;

  const PrimaryTextField({
    super.key,
    this.autofillHints,
    this.maxLines = 1,
    this.hintText,
    this.isObscure = false,
    this.trailing,
    this.fill,
    this.isBorder = true,
    this.contentPadding,
    this.controller,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.label,
    this.prefixIcon,
    this.keyboardType,
  });

  @override
  PrimaryTextFieldState createState() => PrimaryTextFieldState();
}

class PrimaryTextFieldState extends State<PrimaryTextField> {
  late bool _isObscure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      autofillHints: widget.autofillHints,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : widget.trailing,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
}
