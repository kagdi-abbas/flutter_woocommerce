import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:woocommerce_app/api/api_service.dart';
import 'package:woocommerce_app/models/customer_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPICallProcess = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? password;
  String? email;

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: ProgressHUD(
        key: UniqueKey(), 
        inAsyncCall: isAPICallProcess,
        opacity: 0.3,
        child: Form(
          key: _formKey,
          child: _loginUI(context),
        ), 
      ),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: true,
      title: Text("User Login"),
    );
  }

  _loginUI(BuildContext context){
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
          Center(
            child: FormHelper.submitButton(
              "Sign In", 
              () {
                if(_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  setState(() {
                    isAPICallProcess = true;  // start loading
                  });

                  APIService.loginCustomer(email!, password!)
                  .then(
                    (response) {
                      setState(() {
                        isAPICallProcess = false;
                      });

                      if(response){
                        FormHelper.showSimpleAlertDialog(
                          // ignore: use_build_context_synchronously
                          context, 
                          "Grocery App", 
                          response 
                          ? "Login Successful" 
                          : "Login Failed", 
                          "Ok", 
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: Colors.deepOrange,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
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