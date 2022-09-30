import 'package:flutter/material.dart';
import 'package:pet_place/styles/colors.dart';

class CardProductComponent extends StatelessWidget {
  const CardProductComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 196,
      height: 236,
      margin: const EdgeInsets.only(left: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              color: Color(0x25000000),
              blurRadius: 2,
            )
          ],),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        onPressed: () {},
        child: Card(
          child: Column(
            children: [
              Image.asset("assets/bolinha.png"),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                height: 1,
                decoration: const BoxDecoration(
                  color: Color(0x20000000),
                ),
              ),
              Text(
                'Bolinha do mal',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'R\$34.50',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
