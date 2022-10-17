import 'package:flutter/material.dart';
import 'package:pet_place/styles/colors.dart';

import '../../components/card_component.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FB),
      appBar: AppBar(
        title: Image.asset('assets/logo.png'),
        titleSpacing: 182,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                constraints: const BoxConstraints(maxWidth: 1076),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 88 ,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Populares',
                          style: TextStyle(
                            fontSize: 28,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                       const Spacer(),
                        Row(
                          children: [
                            SizedBox(
                              width: 288,
                              height: 40,
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  labelText: 'Search here!',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 1,
                                        style: BorderStyle.solid),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 1,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(
                                left: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      color: const Color(0xFF00297A),
                      height: 1.2,
                      width: double.maxFinite,
                    ),
                    Row(
                      children: const [
                        CardProductComponent(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
