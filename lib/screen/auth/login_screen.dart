import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:produce_api/controller/auth_controller.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({
    super.key,
  });

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation logoanimation;

  late FocusNode focusNode;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final authcontroller = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    logoanimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    logoanimation.addListener(() => setState(() {}));
    animationController.forward();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void submit() async {
    final form = authcontroller.formKey.currentState;
    if (form!.validate()) {
      form.save();
      
      authcontroller.fetchLoginData(
        phone: authcontroller.phoneController.value.text,
        password: authcontroller.passwordController.value.text,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                height: 50.0,
              ),
              const FlutterLogo(
                size: 120,
                duration: Duration(seconds: 2),
                curve: Curves.easeIn,
              ),
              Container(
                height: 80.0,
              ),
              Form(
                key: authcontroller.formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: authcontroller.phoneController.value,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        hintText: "PhoneNumber",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: "Karla",
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 25, right: 10),
                          child: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "Karla",
                      ),
                      validator: (val) {
                        if (val!.isEmpty) return 'Invalid PhoneNumber';
                        return authcontroller.phoneErrorMessage.value.isNotEmpty
                            ? authcontroller.phoneErrorMessage.value
                            : null;
                      },
                      onSaved: (val) =>
                          authcontroller.phoneController.value.text = val ?? "",
                      onFieldSubmitted: (val) =>
                          FocusScope.of(context).requestFocus(focusNode),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0)),
                    TextFormField(
                      controller: authcontroller.passwordController.value,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: "Karla",
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 25, right: 10),
                          child: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "Karla",
                      ),
                      obscureText: true,
                      validator: (val) {
                        if (val!.isEmpty) return 'Invalid Password';
                        if (val.length < 6) return "Password too short";
                        return authcontroller
                                .passwordErrorMessage.value.isNotEmpty
                            ? authcontroller.passwordErrorMessage.value
                            : null;
                      },
                      onSaved: (val) => authcontroller
                          .passwordController.value.text = val ?? "",
                      focusNode: focusNode,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Karla",
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 80.0)),
              GestureDetector(
                onTap: () {
                  debugPrint("----work----");
                  submit();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400]!.withOpacity(.6),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "Karla",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account?",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Karla",
                      fontSize: 14.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => SignUpScreen(
                      //       auth: widget.auth,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text(
                      " Sign Up",
                      style: TextStyle(
                        color: Colors.deepPurple[400]!,
                        fontFamily: "Karla",
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
