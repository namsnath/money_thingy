import 'package:flutter/widgets.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/core/database/database.dart';
import 'package:money_thingy/core/models/category.dart';
import 'package:money_thingy/core/models/transaction_type.dart';

class CategoryProvider extends ChangeNotifier {
  final log = Logger('CategoryProvider');
  final dbProvider = DatabaseProvider.dbProvider;

  static int get defaultCategory => 62; // Miscellaneous

  String getHierarchyQuery() => """
  WITH RECURSIVE categoriesHierarchical(${Category.colId}, ${Category.colFkSelfParentId}, ${Category.colFkTransactionTypeId}, ${Category.colCategory}) AS
		(SELECT ${Category.tableName}.${Category.colId}
				, ${Category.tableName}.${Category.colFkSelfParentId}
        , ${Category.tableName}.${Category.colFkTransactionTypeId}
				, ${Category.tableName}.${Category.colCategory}
			FROM ${Category.tableName}
			ORDER BY ${Category.tableName}.${Category.colCategory})
		, CTE(${Category.colId}, ${Category.colFkSelfParentId}, ${Category.colFkTransactionTypeId}, ${Category.colCategory}, iLevel, iTreeID1, iTreeID2, iTreeID3, iTreeID4, iTreeID5, iTreeID6, iTreeID7, iTreeID8, iTreeID9, iTreeID10) AS
		(SELECT LevelThis.${Category.colId}
				, LevelThis.${Category.colFkSelfParentId}
        , LevelThis.${Category.colFkTransactionTypeId}
        , LevelThis.${Category.colCategory}
				, CAST(0 AS INTEGER)
				, LevelThis.${Category.colId}
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				, CAST(NULL AS INTEGER)
				
			FROM categoriesHierarchical LevelThis
			WHERE LevelThis.${Category.colFkSelfParentId} = 0
		UNION ALL
		SELECT LevelCurr.${Category.colId}
				, LevelCurr.${Category.colFkSelfParentId}
        , LevelCurr.${Category.colFkTransactionTypeId}
        , LevelCurr.${Category.colCategory}
				, LevelParent.iLevel + 1
				, LevelParent.iTreeID1
				, CASE WHEN LevelParent.iLevel = 0 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID2 END
				, CASE WHEN LevelParent.iLevel = 1 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID3 END
				, CASE WHEN LevelParent.iLevel = 2 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID4 END
				, CASE WHEN LevelParent.iLevel = 3 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID5 END
				, CASE WHEN LevelParent.iLevel = 4 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID6 END
				, CASE WHEN LevelParent.iLevel = 5 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID7 END
				, CASE WHEN LevelParent.iLevel = 6 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID8 END
				, CASE WHEN LevelParent.iLevel = 7 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID9 END
				, CASE WHEN LevelParent.iLevel = 8 THEN LevelCurr.${Category.colId} ELSE LevelParent.iTreeID10 END
				FROM CTE LevelParent
			JOIN categoriesHierarchical LevelCurr
				ON LevelParent.${Category.colId} = LevelCurr.${Category.colFkSelfParentId}
			WHERE LevelParent.iLevel < 10
                AND LevelCurr.${Category.colFkSelfParentId} > 0)

	SELECT CTE.${Category.colId}
			, CTE.${Category.colFkSelfParentId}
      , CTE.${Category.colFkTransactionTypeId}
      , t.${TransactionType.colTransactionType} as TxnType
      , CTE.${Category.colCategory} as categoryName
			, CAST(CTE.iLevel + 1 AS INTEGER) AS iLevel
			, CAST((SELECT COUNT(*) FROM ${Category.tableName} mA WHERE mA.${Category.colFkSelfParentId} = CTE.${Category.colId}) AS INTEGER) AS iChildren
      , CTE.iTreeID1
      , CTE.iTreeID2
      , CTE.iTreeID3
      , CTE.iTreeID4
      , CTE.iTreeID5
      , CTE.iTreeID6
      , CTE.iTreeID7
      , CTE.iTreeID8
      , CTE.iTreeID9
      , CTE.iTreeID10
      , c1.${Category.colCategory} as iTree1
      , c2.${Category.colCategory} as iTree2
      , c3.${Category.colCategory} as iTree3
      , c4.${Category.colCategory} as iTree4
      , c5.${Category.colCategory} as iTree5
      , c6.${Category.colCategory} as iTree6
      , c7.${Category.colCategory} as iTree7
      , c8.${Category.colCategory} as iTree8
      , c9.${Category.colCategory} as iTree9
      , c10.${Category.colCategory} as iTree10
		FROM CTE
			JOIN ${Category.tableName}
				ON CTE.${Category.colId} = ${Category.tableName}.${Category.colId}
      JOIN ${TransactionType.tableName} t
        ON CTE.${Category.colFkTransactionTypeId} = t.${TransactionType.colId}
      LEFT JOIN ${Category.tableName} c1
        ON CTE.iTreeID1 = c1.${Category.colId}
      LEFT JOIN ${Category.tableName} c2
        ON CTE.iTreeID2 = c2.${Category.colId}
      LEFT JOIN ${Category.tableName} c3
        ON CTE.iTreeID3 = c3.${Category.colId}
      LEFT JOIN ${Category.tableName} c4
        ON CTE.iTreeID4 = c4.${Category.colId}
      LEFT JOIN ${Category.tableName} c5
        ON CTE.iTreeID5 = c5.${Category.colId}
      LEFT JOIN ${Category.tableName} c6
        ON CTE.iTreeID6 = c6.${Category.colId}
      LEFT JOIN ${Category.tableName} c7
        ON CTE.iTreeID7 = c7.${Category.colId}
      LEFT JOIN ${Category.tableName} c8
        ON CTE.iTreeID8 = c8.${Category.colId}
      LEFT JOIN ${Category.tableName} c9
        ON CTE.iTreeID9 = c9.${Category.colId}
      LEFT JOIN ${Category.tableName} c10
        ON CTE.iTreeID10 = c10.${Category.colId}
      ORDER BY iLevel ASC, categoryName ASC
  """;

  List<Category> _categoryList = [];
  List<Category> get categoryList => _categoryList;

  List<Map<String, dynamic>> _categoryHierarchy = [];
  List<Map<String, dynamic>> get categoryHierarchy => _categoryHierarchy;

  Map<int, String> _categoryHierarchyMap = {};
  Map<int, String> get categoryHierarchyMap => _categoryHierarchyMap;

  CategoryProvider() {
    // Initialise the state on Provider initialization
    getAllCategories();
  }

  Future getAllCategories() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> allCategoriesResult =
        await db.query(Category.tableName, columns: Category.columns);

    List<Category> accounts = allCategoriesResult.isNotEmpty
        ? allCategoriesResult
            .map((item) => Category.fromDatabaseJson(item))
            .toList()
        : [];

    List<Map<String, dynamic>> categoryHierarchyResult =
        await db.rawQuery(getHierarchyQuery());
    Map<int, String> categoryMap = {};

    categoryHierarchyResult = categoryHierarchyResult.map((v) {
      Map<String, dynamic> temp = Map<String, dynamic>.from(v);

      List<String> categories = [];

      for (int j = 1; j <= 10; j++) {
        if (temp['iTree$j'] != null) categories.add(temp['iTree$j']);
        else break;
      }
      
      temp['categoryDisplayName'] = categories.join(':');
      categoryMap[temp['id']] = temp['categoryDisplayName'];
      
      return temp;
    }).toList();

    this._categoryList = accounts;
    this._categoryHierarchy = categoryHierarchyResult;
    this._categoryHierarchyMap = categoryMap;

    notifyListeners();
  }

  Future<List<Category>> getCategories(
      {List<String> columns = Category.columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(Category.tableName,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(Category.tableName, columns: columns);
    }

    List<Category> accounts = result.isNotEmpty
        ? result.map((item) => Category.fromDatabaseJson(item)).toList()
        : [];

    this._categoryList = accounts;

    return accounts;
  }

  List<Node> getCategoryTree({int transactionTypeId: 1}) {
    List<Node> tree = [];

    for (int i = 0; i < _categoryHierarchy.length; i++) {
      var current = _categoryHierarchy[i];
      if (current[Category.colFkTransactionTypeId] != transactionTypeId)
        continue;

      var currentId = current[Category.colId];
      var level = current['iLevel'];
      var categoryName = current['iTree$level'];

      var newNode = Node(
        label: categoryName,
        key: currentId.toString(),
        children: [],
      );

      if (level == 1) {
        tree.add(newNode);
      } else {
        // Find index in tree corresponding to key indicated for first level
        var index = tree
            .indexWhere((node) => node.key == current['iTreeID1'].toString());
        // Set parent node to found index
        var parentNode = tree[index];

        for (int j = 2; j < level; j++) {
          // Find index in children of Node for the key indicated in the Jth level
          var index = parentNode?.children?.indexWhere(
              (node) => node.key == current['iTreeID$j'].toString());
          // Set parent node to found index
          parentNode = parentNode?.children[index];
        }

        // In the resulting parent Node, add the new node
        parentNode?.children?.add(newNode);
      }
    }

    return tree;
  }

  Future<int> addCategory(Category account) async {
    final db = await dbProvider.database;
    var result = await db.insert(Category.tableName, account.toDatabaseJson());

    this._categoryList = await getAllCategories();

    return result;
  }

  Future<int> updateCategory(Category account) async {
    final db = await dbProvider.database;

    var result = await db.update(Category.tableName, account.toDatabaseJson(),
        where: '${Category.colId} = ?', whereArgs: [account.id]);

    this._categoryList = await getAllCategories();

    return result;
  }

  Future<int> deleteCategory(int id) async {
    final db = await dbProvider.database;

    var result =
        await db.delete(Category.tableName, where: 'id = ?', whereArgs: [id]);

    this._categoryList = await getAllCategories();

    return result;
  }
}
