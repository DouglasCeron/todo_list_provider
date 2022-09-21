import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      everVoidCallback: (notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        }
      },
      successCallBack: (notifier, listenerInstance) {
        print('Login efetuado com sucesso');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: ((context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const TodoListLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TodoListField(
                              focusNode: _emailFocus,
                              controller: _emailEC,
                              label: 'E-mail',
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('E-mail Obrigatório'),
                                  Validatorless.email('E-mail inválido'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            TodoListField(
                              controller: _passwordEC,
                              label: 'Password',
                              obscureText: true,
                              showEyeIcon: true,
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha Obrigatória'),
                                Validatorless.min(6,
                                    'Senha deve conter minimo de 6 caracteres'),
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      if (_emailEC.text.isNotEmpty) {
                                        context
                                            .read<LoginController>()
                                            .forgotPassord(_emailEC.text);
                                      } else {
                                        _emailFocus.requestFocus();
                                        Messages.of(context).showError(
                                            'Digite um e-mail para recuperar a senha');
                                      }
                                    },
                                    child: const Text('Esqueceu sua senha?')),
                                ElevatedButton(
                                  onPressed: () {
                                    bool? formValid =
                                        _formkey.currentState?.validate();
                                    if (formValid ?? false) {
                                      final email = _emailEC.text;
                                      final password = _passwordEC.text;
                                      context.read<LoginController>().login(
                                            email,
                                            password,
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text('Login'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                          color: const Color(0xffF0F3F7),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            SignInButton(
                              Buttons.Google,
                              onPressed: () {},
                              padding: const EdgeInsets.all(5),
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              text: 'Continue com o Google',
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Não tem conta?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/register');
                                  },
                                  child: const Text('Cadastre-se'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
