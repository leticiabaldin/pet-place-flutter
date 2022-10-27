import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pet_place/components/header_widget.dart';
import 'package:pet_place/components/product_dialog_widget.dart';
import 'package:pet_place/styles/colors.dart';

import '../../entities/product.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final productsCollection = FirebaseFirestore.instance
      .collection('products'); //conexão com a collections do banco de dados

  Future<void> openRemoveProductDialog(Product product) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tem certeza que deseja remover o item ${product.name}?'),
        content: const Text('Essa ação não pode ser desfeita'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 8),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).errorColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              removeProduct(product);
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  Future<void> removeProduct(Product product) async {
    await productsCollection.doc(product.id).delete();
  }

  Future<void> openCreateProductDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const ProductDialogWidget(),
    );
  }

  Future<void> openUpdateProductDialog(Product product) async {
    await showDialog(
      context: context,
      builder: (context) => ProductDialogWidget(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FB),
      appBar: AppBar(
        title: Image.asset('assets/logo.png'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          if (FirebaseAuth.instance.currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 48),
              child: TextButton.icon(
                onPressed: () {
                  context.go('/user-profile');
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Meu perfil',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              constraints: const BoxConstraints(maxWidth: 1076),
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                children: [
                  HeaderWidget(
                    title: 'Produtos',
                    trailing: SizedBox(
                      height: 40,
                      child: TextButton.icon(
                        onPressed: openCreateProductDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar item'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: productsCollection.orderBy('name').snapshots(),
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
                          final data = snapshot.data
                              as QuerySnapshot<Map<String, dynamic>>;
                          final products = data.docs
                              .map(
                                (doc) => Product(
                                  id: doc.id,
                                  name: doc.data()['name'],
                                  price: doc.data()['price'],
                                  description: doc.data()['description'],
                                ),
                              )
                              .toList();

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: InkWell(
                                  onTap: () {
                                    context.go('/details/${product.id}');
                                  },
                                  child: ListTile(
                                    title: Text(product.name),
                                    subtitle: Text(product.getFormattedPrice()),
                                    leading: Text('${index + 1}°'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              openUpdateProductDialog(
                                            product,
                                          ),
                                          icon: const Icon(Icons.edit),
                                          splashRadius: 20,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () =>
                                              openRemoveProductDialog(product),
                                          icon: const Icon(Icons.delete),
                                          color: Theme.of(context).errorColor,
                                          splashRadius: 20,
                                        ),
                                      ],
                                    ),
                                    // onTap: () => context.go('/product/${product.id}'),
                                  ),
                                ),
                              );
                            },
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
