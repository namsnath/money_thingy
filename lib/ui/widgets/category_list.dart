import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:money_thingy/core/providers/category_provider.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  final int transactionTypeIdFilter;
  final int initialSelectedCategory;

  CategoryList(
      {Key key,
      @required this.transactionTypeIdFilter,
      this.initialSelectedCategory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoryListState();
  }
}

class _CategoryListState extends State<CategoryList> {
  String _selectedNode = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, category, child) {
      TreeViewController _treeViewController = TreeViewController(
        children: category.getCategoryTree(
          transactionTypeId: widget.transactionTypeIdFilter,
        ),
        selectedKey: widget.initialSelectedCategory?.toString(),
      );

      TreeViewTheme _treeViewTheme = TreeViewTheme(
        expanderTheme: ExpanderThemeData(
          type: ExpanderType.plusMinus,
          modifier: ExpanderModifier.none,
          position: ExpanderPosition.start,
          animated: true,
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
        colorScheme: ColorScheme.light(background: Colors.transparent),
      );

      return Column(
        children: <Widget>[
          Text(
            'Selected Category',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(_selectedNode),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 400,
            // constraints: BoxConstraints.expand(),
            child: TreeView(
              controller: _treeViewController,
              theme: _treeViewTheme,
              allowParentSelect: true,
              onExpansionChanged: (String key, bool expanded) {
                Node node = _treeViewController.getNode(key);
                if (node != null) {
                  var updated = _treeViewController.updateNode(
                      key, node.copyWith(expanded: expanded));
                  setState(() {
                    _treeViewController =
                        _treeViewController.copyWith(children: updated);
                  });
                }
              },
              onNodeTap: (key) {
                setState(() {
                  _treeViewController =
                      _treeViewController.copyWith(selectedKey: key);
                  _selectedNode = category.categoryHierarchy.firstWhere(
                          (element) => element['id'].toString() == key)[
                      'categoryDisplayName'];
                });
              },
              onNodeDoubleTap: (key) => print('Double Tapped: $key'),
            ),
          ),
        ],
      );
    });
  }
}
