part of 'manager.dart';

/// A class that contains the information needed to create a join
class JoinBuilder {
  /// The table that the join is being applied to
  final Table currentTable;

  /// The referenced table that will be joined
  final Table referencedTable;

  /// The column of the [currentTable] which will be use to create the join
  final GeneratedColumn currentColumn;

  /// The column of the [referencedTable] which will be use to create the join
  final GeneratedColumn referencedColumn;

  /// Whether this join should be used to read columns from the referenced table
  final bool useColumns;

  /// Class that describes how a ordering that is being
  /// applied to a referenced table
  /// should be joined to the current table
  @internal
  JoinBuilder(
      {required this.currentTable,
      required this.referencedTable,
      required this.currentColumn,
      required this.referencedColumn,
      this.useColumns = false});

  /// The name of the alias that this join will use
  String get aliasedName {
    return referencedColumn.tableName;
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is JoinBuilder) {
      return other.currentColumn == currentColumn &&
          other.referencedColumn == referencedColumn &&
          other.useColumns == useColumns;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return Object.hash(currentColumn, referencedColumn);
  }

  @override
  String toString() {
    return 'Join between $currentTable and $referencedTable';
  }

  /// Build a join from this join builder
  Join buildJoin() {
    return leftOuterJoin(
        referencedTable, currentColumn.equalsExp(referencedColumn),
        useColumns: useColumns);
  }
}

/// An interface for classes which need to hold the information needed to create
/// orderings or where expressions.
///
/// Example:
/// ```dart
/// todos.filter((f) => f.category.id(3))
/// ```
///
/// In the above example, f.category returns a [ComposableFilter] object, which
/// is a subclass of [_Composable].
/// This resulting where expression will require a join to be created
/// between the `categories` and `todos` table.
///
/// This interface is used to ensure that the [ComposableFilter] object will have
/// the information needed to create the join by expressions.
abstract interface class _Composable {
  /// The join builders that are associated with this class
  /// They are ordered by the order in which they were added
  /// These will be used by the [TableManagerState] to create the joins
  /// that are needed to create the where expression
  Set<JoinBuilder> get joinBuilders;
}
