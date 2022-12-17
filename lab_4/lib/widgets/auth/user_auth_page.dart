import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lab_3/widgets/auth/sign_in.dart';
import 'package:lab_3/widgets/auth/sign_up.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? SignIn(
          onClickedSignUp: toggle,
        )
      : SignUp(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
