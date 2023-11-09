import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/model/category/category_model.dart';

ValueNotifier<Categorytype> selectedCategoryNotifier =
    ValueNotifier(Categorytype.income);

Future<void> showCategoryAddPopup(context) async {
  final _nameEditingController = TextEditingController();
  showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Title(
                    color: Colors.deepPurple,
                    child: const Text(
                      "Add Category",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autofocus: true,
                  controller: _nameEditingController,
                  decoration: const InputDecoration(
                      hintText: 'Enter a Category',
                      border: OutlineInputBorder()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RadioButton(title: 'Income', type: Categorytype.income),
                      RadioButton(title: 'Expense', type: Categorytype.expense),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      final _name = _nameEditingController.text;
                      if (_name.isEmpty) {
                        return;
                      }
                      final _type = selectedCategoryNotifier.value;
                      final _category = CategoryModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _name,
                          type: _type);
                      CategoryDB.instance.insertCategory(_category);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("ADD")),
              ],
            ),
          ),
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final Categorytype type;
  RadioButton({super.key, required this.title, required this.type});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (ctx, newCategory, _) {
            return Radio<Categorytype>(
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
