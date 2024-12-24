
import 'package:flutter/material.dart';

class FormcontainerWidget extends StatefulWidget {

  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? hintText;
  final String? labelText;
  final bool? isPasswordField;
  final Key? keyField;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;


  const FormcontainerWidget({
    super.key,
    this.controller,
    this.inputType,
    this.hintText,
    this.keyField,
    this.labelText,
     this.isPasswordField,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    });

  @override
  State<FormcontainerWidget> createState() => _FormcontainerWidgetState();
}

class _FormcontainerWidgetState extends State<FormcontainerWidget> {
  bool _obsecureText= true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.inputType,
        onSaved: widget.onSaved,
        onFieldSubmitted: widget.onFieldSubmitted,
        key: widget.keyField,
        obscureText: widget.isPasswordField == true ? _obsecureText:false,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled:true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black),
          suffixIcon: GestureDetector(
            onTap: (){
              setState(() {
                _obsecureText = !_obsecureText;

              });
            },
            child:
            widget.isPasswordField == true ? Icon(_obsecureText? Icons.visibility_off : Icons.visibility, color: _obsecureText == false? Colors.blue: Colors.grey,): const Text(""),

          ),
        ),





      ),
    );
  }
}
