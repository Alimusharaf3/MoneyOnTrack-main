import 'package:flutter/material.dart';
import 'package:money_management_app/screens/add_transaction/add_transaction_screen.dart';
import 'package:money_management_app/screens/category/category_screen.dart';
import 'package:money_management_app/screens/home/widgets/bottom_navigation.dart';
import 'package:money_management_app/screens/transactions/transaction_screen.dart';
import '../category/category_add_popup.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static ValueNotifier<int> SelectedIndexNotifier = ValueNotifier(0);

  final _pages = const [TranscationScreen(), CategoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MoneyOnTrack",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 153, 57, 200),
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: SelectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (SelectedIndexNotifier.value == 0) {
            print("ADD Transactions");
            Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
          } else {
            print("Add category");
            showCategoryAddPopup(context);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
