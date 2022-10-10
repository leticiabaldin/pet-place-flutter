import 'package:flutter/material.dart';

import '../../styles/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FB),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Container(
              width: double.maxFinite,
              color: Colors.white,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 40, 32, 50),
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
                        ),
                        const SizedBox(height: 72),
                        SizedBox(
                          width: double.maxFinite,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.secondary,
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
                      ],
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
