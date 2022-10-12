import 'package:flutter/material.dart';
import 'package:pet_place/styles/colors.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png'),
        titleSpacing: 182,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(182, 88, 182, 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Container(
                  width: 1076,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nome do produto',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.primary,
                      ),
                      const SizedBox(
                        height: 32,
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/tartaruga.png'),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(32, 0, 16, 16),
                            width: 484,
                            child: Text(
                              'Tartaruga para cachorro super fofa e saudável para o seu pet morder e brincar de arrastar.'
                              ' Ela brilha no escuro, realiza compras, limpa a casa, lava o carro e consegue entreter '
                              'adultos e crianças desde que sejam cachorros. Para cachorros de pequeno, pequeno-médio, '
                              'médio-médio, grande-médio e grande porte!',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 470,
                            color: AppColors.primary,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
