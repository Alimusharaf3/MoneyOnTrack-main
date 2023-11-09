import 'package:flutter/material.dart';
import 'package:money_management_app/db/transaction/transaction_db.dart';

class BalanceInfo extends StatelessWidget {
  const BalanceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff843dff)),
        height: 200,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffbea6ff)),
                    height: 90,
                    width: 150,
                    padding: const EdgeInsets.all(2),
                    child: ValueListenableBuilder(
                      valueListenable: TransactionDB.instance.incomeNotifer,
                      builder: (ctx1, value, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Income",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 34, 119, 8)),
                            ),
                            Text(
                              value.toString(),
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xfff3f1ff)),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffbea6ff)),
                    height: 90,
                    width: 150,
                    child: ValueListenableBuilder(
                      valueListenable: TransactionDB.instance.expenseNotifer,
                      builder: (ctx2, value, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Expense",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 157, 25, 10)),
                            ),
                            Text(
                              value.toString(),
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xfff3f1ff)),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffbea6ff)),
                height: 60,
                width: 390,
                child: ValueListenableBuilder(
                  valueListenable: TransactionDB.instance.balanceNotifer,
                  builder: (ctx3, value, _) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Balance",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff843dff)),
                          ),
                          Text(
                            "₹${value.toString()}",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xfff3f1ff),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
