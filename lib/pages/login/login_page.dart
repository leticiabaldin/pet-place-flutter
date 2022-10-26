import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../styles/colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.next}) : super(key: key);

  final String? next;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    if (loading) return;

    setState(() => loading = true);

    final email = emailController.text.trim();
    final password = passwordController.text;

    final fireAuth = FirebaseAuth.instance;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final credentials = await fireAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await fireAuth.setPersistence(Persistence.LOCAL);

      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Bem vindo(a), ${credentials.user!.displayName}!'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
          backgroundColor: AppColors.primary,
        ),
      );
       goToFlow();
    } catch (e) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Verifique suas credenciais ou crie uma conta.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2500),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    setState(() => loading = false);
  }

  void goToFlow() {
    if (widget.next != null) {
      context.go(widget.next!.replaceAll('%20F', '/'));
    } else {
      context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: double.maxFinite,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 50),
                      child: Column(
                        children: [
                          const SizedBox(height: 56),
                          Image.asset(
                            'assets/logo_blue.png',
                            fit: BoxFit.cover,
                            width: 289,
                            height: 54,
                          ),
                          const SizedBox(height: 64),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }

                              if (!EmailValidator.validate(value.trim())) {
                                return 'Email inválido';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'E-mail:',
                              labelStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF858585),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Senha:',
                              labelStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF858585),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 64),
                          SizedBox(
                            width: double.maxFinite,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  login();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  width: 1,
                                  color: AppColors.primary,
                                ),
                              ),
                              child: Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                               context.go('/create-account');
                              },
                              child: Text(
                                'Não possui uma conta? Clique aqui.',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
