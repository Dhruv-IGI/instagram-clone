import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../widgets/test_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginInUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      isLoading = false;
    });
    if(res == 'success'){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout:  WebScreenLayout(),
          ),
        ),
      );
    }
    else{
      showSnackBar(context, res);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Flexible(
                  flex: 1, child: Container(),
                ),
                SvgPicture.asset('assets/images/ic_instagram.svg',
                color: primaryColor,
                  width: double.infinity,
                  height: 64,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 64,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: TextFieldInput(
                    textEditngController: _emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: TextFieldInput(
                    textEditngController: _passwordController,
                    hintText: 'Enter your password',
                    keyboardType: TextInputType.text,
                    isPass: true,
                  ),
                ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: GestureDetector(
                    onTap: (){
                      loginUser();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: blueColor,
                      ),
                      width: double.infinity,
                      height: 48,
                      alignment: Alignment.center,
                      child: isLoading == false ? const Text('Log In') : Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      ),
                      child: const Text('Sign up',
                      style: TextStyle(
                        color: blueColor,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ],
                ),
                Flexible(
                  flex: 1, child: Container(),
                ),
              ]
            )),
      ),
    );
  }
}