import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../styles/colors.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key, this.next}) : super(key: key);

  final String? next;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  String password = '';

  bool loading = false;

  void checkPasswordController() {
    if (passwordController.text != password) {
      setState(() => password = passwordController.text);
    }
  }

  Future<void> createAccount() async {
    if (loading) return;

    setState(() => loading = true);

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final phone = phoneController.text;
    final address = addressController.text.trim();

    final fireAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final credentials = await fireAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credentials.user!.updateDisplayName(name);
      await fireAuth.setPersistence(Persistence.LOCAL);
      await firestore.doc('userProfile/${credentials.user!.uid}').set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });

      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Seja Bem vindo(a), $name!'),
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
          content: const Text(
              'Não foi possível criar a sua conta. Tente novamente.'),
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
  void initState() {
    super.initState();
    passwordController.addListener(checkPasswordController);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Card(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(40),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: !loading
                                ? () => context.go('/dashboard')
                                : null,
                            child: Image.asset('logo_blue.png'),
                          ),
                        ),
                        const SizedBox(height: 48),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text('Nome Completo:'),
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }

                            if (value.length <= 3) {
                              return 'O campo deve conter no mínimo 4 caracteres';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text('Email:'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }

                            if (!EmailValidator.validate(value)) {
                              return 'Email inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Telefone:'),
                          ),
                          inputFormatters: [phoneFormatter],
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }

                            if (value.length < 15) {
                              return 'Informe um telefone válido';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                          },
                          controller: addressController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Endereço completo:'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Senha:'),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null; // valida o campo e sai do erro
                          },
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text('Confirmar senha:'),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.go,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }

                            if (value != passwordController.text) {
                              return 'As senhas não são iguais';
                            }

                            return null;
                          },
                          onFieldSubmitted: (_) {
                            if (formKey.currentState!.validate()) {
                              createAccount();
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.maxFinite,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: !loading
                                ? () {
                                    if (formKey.currentState!.validate()) {
                                      createAccount();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: AppColors.primary,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: Text(
                              'Criar conta',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.maxFinite,
                          height: 48,
                          child: TextButton(
                            onPressed: !loading
                                ? () {
                                    if (widget.next != null) {
                                      context.go('/?next=${widget.next}');
                                    } else {
                                      context.go('/');
                                    }
                                  }
                                : null,
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text('Voltar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (loading)
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.white.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
