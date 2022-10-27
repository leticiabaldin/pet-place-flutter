import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pet_place/styles/colors.dart';

import '../entities/product.dart';
import '../pages/dashboard/dashboard_page.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class ProductDialogWidget extends StatefulWidget {
  const ProductDialogWidget({Key? key, this.product}) : super(key: key);

  final Product? product;

  @override
  State<ProductDialogWidget> createState() => _ProductDialogWidgetState();
}

class _ProductDialogWidgetState extends State<ProductDialogWidget> {
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  void fillControllers() {
    final product = widget.product!;
    nameController.text = product.name;
    priceController.text =
        'R\$ ${product.price.toStringAsFixed(2)}'.replaceAll('.', ',');
    descriptionController.text = product.description;
  }

  Future<void> saveProduct() async {
    if (loading) return;

    setState(() => loading = true);

    final name = nameController.text.trim();
    final price = double.parse(priceController.text
        .trim()
        .replaceFirst('R\$', '')
        .trim()
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    final description = descriptionController.text.trim();
    final collection = FirebaseFirestore.instance.collection('products');
    final doc = widget.product != null
        ? collection.doc(widget.product!.id)
        : collection.doc();
    final data = <String, dynamic>{
      'name': name,
      'price': price,
      'description': description,
    };

    await doc.set(data, SetOptions(merge: true));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    if (widget.product != null) fillControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product != null ? 'Editar produto' : 'Criar produto',
                style: TextStyle(fontSize: 22, color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  labelText: 'Nome do produto:',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  labelText: 'Preço:',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                minLines: 4,
                maxLines: 10,
                controller: descriptionController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  labelText: 'Descrição:',
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: loading ? null : saveProduct,
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
