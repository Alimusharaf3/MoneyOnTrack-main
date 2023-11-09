import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryListListener,
      builder: (cxt1, newList, _) {
        return ListView.separated(
          itemBuilder: (ctx, index) {
            final Category = newList[index];
            return Card(
              child: ListTile(
               title: Text(Category.name),
                  trailing: IconButton(
                    onPressed: (){
                      CategoryDB.instance.deleteCategory(Category.id);
                    },
                     icon:const Icon(Icons.delete,color: Colors.purple),
              ),
              ),
            );
          },
          separatorBuilder: (ctx1, index) {
            return const SizedBox(height: 5);
          },
          itemCount: newList.length,
        );
      },
    );
  }
}
