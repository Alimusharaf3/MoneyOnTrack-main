import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/model/category/category_model.dart';
import 'package:money_management_app/model/transaction/transaction_model.dart';

// Database name
const TRANSACTION_DB_NAME = 'transacton-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  // Singleton
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionsListListener =
      ValueNotifier([]);

  ValueNotifier<double> incomeNotifer = ValueNotifier(0);
  ValueNotifier<double> expenseNotifer = ValueNotifier(0);
  ValueNotifier<double> balanceNotifer = ValueNotifier(0);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    incomeNotifer.value = 0;
    expenseNotifer.value = 0;
    balanceNotifer.value = 0;

    final list = await getTransactions();
    list.sort((first, second) => second.date.compareTo(first.date));
    transactionsListListener.value.clear();
    transactionsListListener.value.addAll(list);

    await Future.forEach(list, (TransactionModel obj) {
      if (obj.type == Categorytype.income) {
        incomeNotifer.value += obj.amount;
      } else {
        expenseNotifer.value += obj.amount;
      }
      balanceNotifer.value = incomeNotifer.value - expenseNotifer.value;
    });

    incomeNotifer.notifyListeners();
    expenseNotifer.notifyListeners();
    balanceNotifer.notifyListeners();

    transactionsListListener.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();
  }
}
