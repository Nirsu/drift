import 'package:drift/drift.dart';

/// Database-specific options used by drift.
///
/// Instances of this class are primarily meant to be generated by `drift_dev`,
/// which will override the database options based on compile-time options.
class DriftDatabaseOptions {
  /// Configuration for [SqlTypes] describing how to map Dart values from and to
  /// SQL values.
  @Deprecated('Use createTypeMapping instead')
  final SqlTypes types;

  final bool _storeDateTimeAsText;

  /// Creates database-specific database options.
  ///
  /// When [storeDateTimeAsText] is enabled (it defaults to `false` for
  /// backwards-compatibility), drift's datetime columns will be stored as text.
  /// By default, they will be stored as unix timestamps (integers).
  ///
  /// For details on how datetimes can be stored, see [the documentation].
  ///
  /// [the documentation]: https://drift.simonbinder.eu/docs/getting-started/advanced_dart_tables/#supported-column-types
  const DriftDatabaseOptions({
    bool storeDateTimeAsText = false,
  })  : _storeDateTimeAsText = storeDateTimeAsText,
        // ignore: deprecated_member_use_from_same_package
        types =
            storeDateTimeAsText ? const SqlTypes(true) : const SqlTypes(false);

  /// Creates a type mapping suitable for these options and the given [dialect].
  SqlTypes createTypeMapping(SqlDialect dialect) {
    return SqlTypes(_storeDateTimeAsText, dialect);
  }
}
