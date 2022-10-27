import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_place/components/header_widget.dart';
import 'package:pet_place/styles/colors.dart';

import '../../entities/product.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.productId}) : super(key: key);

  final String productId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final products =
        FirebaseFirestore.instance.doc('products/${widget.productId}');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Image.asset('assets/logo.png'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard');
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: products.snapshots(),
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
          final data =
              (snapshot.data as DocumentSnapshot<Map<String, dynamic>>).data()!;
          final product = Product(
            id: snapshot.data!.id,
            name: data['name'],
            price: data['price'],
            description: data['description'],
            image: data['image'],
          );

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1076),
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  HeaderWidget(title: product.name),
                  const SizedBox(height: 32),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      final isMobile = constraints.maxWidth <= 700;

                      final imageWidget = Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: AspectRatio(
                          aspectRatio: 9 / 12,
                          child: Builder(builder: (context) {
                            if (product.image == null) {
                              return Container(
                                color: Theme.of(context).disabledColor,
                                width: double.maxFinite,
                                height: double.maxFinite,
                                child: const Center(
                                  child: Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                    size: 64,
                                  ),
                                ),
                              );
                            }
                            return Image.network(
                              product.image!,
                              width: double.maxFinite,
                              height: double.maxFinite,
                              fit: BoxFit.cover,
                            );
                          }),
                        ),
                      );
                      final descriptionWidget = Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Valor do produto: ',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  TextSpan(
                                    text: product.getFormattedPrice(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );

                      if (isMobile) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                child: imageWidget,
                              ),
                              const SizedBox(height: 16),
                              descriptionWidget,
                            ],
                          ),
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageWidget,
                          const SizedBox(width: 32),
                          Expanded(
                            child: SingleChildScrollView(
                              child: descriptionWidget,
                            ),
                          ),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
