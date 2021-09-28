import 'package:flutter/material.dart';
import 'package:seaoil_flutter/common/widgets/widgets.dart';
import 'package:seaoil_flutter/repository/login_repo.dart';
import 'package:seaoil_flutter/view_models/login_models.dart';
import 'package:seaoil_flutter/views/findus/findus_view.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/';
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  var _mobileNumber, _password, errorMessage;
  late TextEditingController _mobileNumberController;
  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _mobileNumberController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );
    return SafeArea(
      child: Scaffold(
        appBar: appBarWithoutIcon("Login", Colors.lightBlue),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Text("Mobile Number"),
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileNumberController,
                    autofocus: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Mobile Number is required!";
                      } else {
                        _mobileNumber = value;
                      }
                    },
                    onSaved: (value) =>
                        value!.isEmpty ? null : _mobileNumber = value,
                    decoration: buildInputDecoration(
                        'Enter Mobile Number', Icons.phone),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Password"),
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _passwordController,
                    autofocus: false,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required!";
                      } else {
                        _password = value;
                      }
                    },
                    onSaved: (value) =>
                        value!.isEmpty ? null : _password = value,
                    decoration:
                        buildInputDecoration('Enter Password', Icons.lock),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SeaoilButton(
                            text: 'Login',
                            onPressed: () {
                              doValidate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  doValidate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      doLogin();
    } else {
      // formKey.currentState!.save();
      // doLogin();
    }
  }

  doLogin() async {
    await LoginRepository.attemptLogin(
            LoginDataRequest(mobileNumber: _mobileNumber, password: _password))
        .then((value) {
      if (value.status == "success") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/findus", (Route<dynamic> route) => false);
      }
    }).catchError((e) {
      errorMessage = e.toString();
      showModalErrorDialog(context, errorMessage);
    });
  }
}
