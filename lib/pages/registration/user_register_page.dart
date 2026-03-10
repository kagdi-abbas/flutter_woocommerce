import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:woocommerce_app/api/api_service.dart';
import 'package:woocommerce_app/models/customer_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAPICallProcess = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? fullName;
  String? password;
  String? confirmPassword;
  String? email;

  bool hidePassword = true, hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: ProgressHUD(
        key: UniqueKey(), 
        child: Form(
          key: _formKey,
          child: _registerUI(context),
        ), 
        inAsyncCall: isAPICallProcess,
        opacity: 0.3,
      ),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: true,
      title: Text("Registration"),
    );
  }

  _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              "Online Grocery",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          _buildInputField(
            context, 
            "Full Name", 
            const Icon(Icons.face), 
            (valValue) => valValue.isEmpty ? '* Required' : null, 
            (saveVal) => fullName = saveVal.toString().trim(),
          ),
          SizedBox(
            height: 15,
          ),
          _buildInputField(
            context, 
            "Email", 
            const Icon(Icons.email_outlined), 
            (valValue) { 
              if(valValue.isEmpty) { 
                return '* Required'; 
              } 
              if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(valValue)) {
                return "Invalid E-mail";
              }
              return null;
            }, 
            (saveVal) => email = saveVal.toString().trim(),
          ),
          SizedBox(
            height: 15,
          ),
          _buildInputField(
            context, 
            "Password", 
            const Icon(Icons.lock_open),
            (valValue) => valValue.isEmpty ? '* Required' : null, 
            (saveVal) => password = saveVal.toString().trim(),
            onChange: (val) => {password = val},
            suffixIcon: IconButton(
              onPressed: () => {
                setState(() {
                  hidePassword = !hidePassword;
                }),
              },
              icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
            ),
            obscureText: hidePassword,
          ),
          SizedBox(
            height: 15,
          ),
          _buildInputField(
            context, 
            "Confirm Password", 
            const Icon(Icons.lock_open),
            (valValue) {
              if(valValue!.isEmpty){
                return '* Required';
              }
              if(valValue != password){
                return 'Confirm Password not matched';
              }
              else {
                return null;
              }
            }, 
            (saveVal) => confirmPassword = saveVal.toString().trim(),
            suffixIcon: IconButton(
              onPressed: () => {
                setState(() {
                  hideConfirmPassword = !hideConfirmPassword;
                }),
              },
              icon: Icon(hideConfirmPassword ? Icons.visibility_off : Icons.visibility),
            ),
            obscureText: hideConfirmPassword,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Sign Up", 
              () {
                if(_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  setState(() {
                    isAPICallProcess = true;  // start loading
                  });

                  CustomerModel customerModel = CustomerModel(
                    email, fullName, password
                  );

                  APIService.registerUser(customerModel)
                  .then(
                    (response) {
                      setState(() {
                        isAPICallProcess = false;
                      });
                      FormHelper.showSimpleAlertDialog(
                        // ignore: use_build_context_synchronously
                        context, 
                        "Registration", 
                        response ? "Registration Successful" : "Registration Failed", 
                        "Ok", 
                        () {
                          Navigator.of(context).pop();
                        }
                      );
                    },
                  );
                }
              },
              btnColor: Colors.deepOrange,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context,
    String label,
    Icon prefixIcon,
    Function validator,
    Function onSaved, {
      Function? onChange,
      Widget? suffixIcon,
      obscureText = false,
    }){
      return FormHelper.inputFieldWidget(
        context, 
        label, 
        label, 
        validator, 
        onSaved,
        showPrefixIcon: true,
        prefixIcon: prefixIcon,
        borderRadius: 10,
        contentPadding: 15,
        fontSize: 14,
        prefixIconPaddingLeft: 10,
        prefixIconColor: Colors.black,
        borderColor: Colors.grey.shade200,
        textColor: Colors.black,
        hintFontSize: 14,
        hintColor: Colors.black.withAlpha(153),
        backgroundColor: Colors.grey.shade100,
        borderFocusColor: Colors.grey.shade200,
        obscureText: obscureText,
        suffixIcon: suffixIcon,
        onChange: onChange,
      );
  }
}