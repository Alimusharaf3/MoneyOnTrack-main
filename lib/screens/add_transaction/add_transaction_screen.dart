import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/db/transaction/transaction_db.dart';
import 'package:money_management_app/model/category/category_model.dart';
import 'package:money_management_app/model/transaction/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  static const routeName = 'add-transaction';
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? _selectedDate;
  Categorytype? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = Categorytype.income;
    super.initState();
  }

// purpose ,date,amount ,Income/expense, category
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Purpose',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  )),
            ),
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
            ),
            TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now());

                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      print(_selectedDateTemp.toString());
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate!.toString())),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                    value: Categorytype.income,
                    groupValue: _selectedCategorytype,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategorytype = Categorytype.income;
                        _categoryID = null;
                      });
                    }),
                const Text("Income"),
                Radio(
                    value: Categorytype.expense,
                    groupValue: _selectedCategorytype,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategorytype = Categorytype.expense;
                        _categoryID = null;
                      });
                    }),
                const Text("Expense"),
              ],
            ),
            //Category
            DropdownButton(
                hint: const Text("Select Category"),
                value: _categoryID,
                items: (_selectedCategorytype == Categorytype.income
                        ? CategoryDB.instance.incomeCategoryListListener
                        : CategoryDB.instance.expenseCategoryListListener)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () => _selectedCategoryModel = e,
                  );
                }).toList(),
                onChanged: (selectItem) {
                  setState(() {
                    _categoryID = selectItem;
                  });
                }),
            //Submit button
            ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;

    if (_purposeText.isEmpty &&
        _amountText.isEmpty &&
        _categoryID == null &&
        _selectedDate == null) {
      return;
    }

    if (_selectedCategoryModel == null) {
      return;
    }

    final parsedAmount = double.tryParse(_amountText);
    if (parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
        purpose: _purposeText,
        amount: parsedAmount,
        date: _selectedDate!,
        type: _selectedCategorytype!,
        category: _selectedCategoryModel!);

    await TransactionDB.instance.addTransaction(_model);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    TransactionDB.instance.refresh();
  }
}
