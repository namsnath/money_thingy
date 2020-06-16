import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:money_thingy/providers/category_provider.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, category, child) {
      TreeViewController _treeViewController =
          TreeViewController(children: category.getCategoryTree(transactionTypeId: 2));

      TreeViewTheme _treeViewTheme = TreeViewTheme(
        expanderTheme: ExpanderThemeData(
          type: ExpanderType.chevron,
          modifier: ExpanderModifier.none,
          position: ExpanderPosition.start,
          // color: Colors.red.shade800,
          size: 20,
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          letterSpacing: 0.3,
        ),
        parentLabelStyle: TextStyle(
          fontSize: 16,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(
          size: 18,
          color: Colors.grey.shade800,
        ),
        colorScheme: ColorScheme.light(),
      );

      return Expanded(
        child: TreeView(
          controller: _treeViewController,
          theme: _treeViewTheme
        ),
      );
    });
  }
}
