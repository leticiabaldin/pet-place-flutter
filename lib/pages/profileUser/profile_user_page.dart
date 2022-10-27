import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_place/components/header_widget.dart';

import '../../styles/colors.dart';

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  final String name;
  final String email;
  final String phone;
  final String address;
}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final reference = FirebaseFirestore.instance.doc(
    'userProfile/${FirebaseAuth.instance.currentUser!.uid}',
  ); //conexão com a collections do banco de dados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FB),
      appBar: AppBar(
        title: Image.asset('assets/logo.png'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard');
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1076),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(title: 'Meus Dados'),
              FutureBuilder(
                  future: reference.get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          (snapshot.error as FirebaseException).message ??
                              'Um erro desconhecido ocorreu',
                        ),
                      );
                    }
                    final data = (snapshot.data
                            as DocumentSnapshot<Map<String, dynamic>>)
                        .data()!;
                    final user = UserProfile(
                      name: data['name'],
                      email: data['email'],
                      phone: data['phone'],
                      address: data['address'],
                    );

                    return Expanded(
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(16),
                              child: Image.asset('assets/userDogImage.jpg'),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).disabledColor,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              width: 100,
                              height: 100,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Nome: ',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: user.name,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Email: ',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: user.email,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Telefone: ',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: user.phone,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Endereço: ',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: user.address,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
