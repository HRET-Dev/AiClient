// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AiApiTable extends AiApi with TableInfo<$AiApiTable, AiApiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiApiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serviceNameMeta =
      const VerificationMeta('serviceName');
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
      'service_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseUrlMeta =
      const VerificationMeta('baseUrl');
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
      'base_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
      'api_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelsMeta = const VerificationMeta('models');
  @override
  late final GeneratedColumn<String> models = GeneratedColumn<String>(
      'models', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdTimeMeta =
      const VerificationMeta('createdTime');
  @override
  late final GeneratedColumn<DateTime> createdTime = GeneratedColumn<DateTime>(
      'created_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedTimeMeta =
      const VerificationMeta('updatedTime');
  @override
  late final GeneratedColumn<DateTime> updatedTime = GeneratedColumn<DateTime>(
      'updated_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serviceName,
        provider,
        baseUrl,
        apiKey,
        models,
        isActive,
        createdTime,
        updatedTime
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_api';
  @override
  VerificationContext validateIntegrity(Insertable<AiApiData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('service_name')) {
      context.handle(
          _serviceNameMeta,
          serviceName.isAcceptableOrUnknown(
              data['service_name']!, _serviceNameMeta));
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(_baseUrlMeta,
          baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta));
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta));
    } else if (isInserting) {
      context.missing(_apiKeyMeta);
    }
    if (data.containsKey('models')) {
      context.handle(_modelsMeta,
          models.isAcceptableOrUnknown(data['models']!, _modelsMeta));
    } else if (isInserting) {
      context.missing(_modelsMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_time')) {
      context.handle(
          _createdTimeMeta,
          createdTime.isAcceptableOrUnknown(
              data['created_time']!, _createdTimeMeta));
    }
    if (data.containsKey('updated_time')) {
      context.handle(
          _updatedTimeMeta,
          updatedTime.isAcceptableOrUnknown(
              data['updated_time']!, _updatedTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiApiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiApiData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serviceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_name'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      baseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_url'])!,
      apiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key'])!,
      models: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}models'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_time'])!,
      updatedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_time'])!,
    );
  }

  @override
  $AiApiTable createAlias(String alias) {
    return $AiApiTable(attachedDatabase, alias);
  }
}

class AiApiData extends DataClass implements Insertable<AiApiData> {
  /// 主键ID
  final int id;

  /// 服务名称
  final String serviceName;

  /// 服务提供商
  final String provider;

  /// 基础URL地址
  final String baseUrl;

  /// API密钥
  final String apiKey;

  /// 模型列表 (多个模型以逗号分隔)
  final String models;

  /// 是否激活 (默认激活)
  final bool isActive;

  /// 创建时间
  final DateTime createdTime;

  /// 更新时间
  final DateTime updatedTime;
  const AiApiData(
      {required this.id,
      required this.serviceName,
      required this.provider,
      required this.baseUrl,
      required this.apiKey,
      required this.models,
      required this.isActive,
      required this.createdTime,
      required this.updatedTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['service_name'] = Variable<String>(serviceName);
    map['provider'] = Variable<String>(provider);
    map['base_url'] = Variable<String>(baseUrl);
    map['api_key'] = Variable<String>(apiKey);
    map['models'] = Variable<String>(models);
    map['is_active'] = Variable<bool>(isActive);
    map['created_time'] = Variable<DateTime>(createdTime);
    map['updated_time'] = Variable<DateTime>(updatedTime);
    return map;
  }

  AiApiCompanion toCompanion(bool nullToAbsent) {
    return AiApiCompanion(
      id: Value(id),
      serviceName: Value(serviceName),
      provider: Value(provider),
      baseUrl: Value(baseUrl),
      apiKey: Value(apiKey),
      models: Value(models),
      isActive: Value(isActive),
      createdTime: Value(createdTime),
      updatedTime: Value(updatedTime),
    );
  }

  factory AiApiData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiApiData(
      id: serializer.fromJson<int>(json['id']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      provider: serializer.fromJson<String>(json['provider']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      models: serializer.fromJson<String>(json['models']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdTime: serializer.fromJson<DateTime>(json['createdTime']),
      updatedTime: serializer.fromJson<DateTime>(json['updatedTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serviceName': serializer.toJson<String>(serviceName),
      'provider': serializer.toJson<String>(provider),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'apiKey': serializer.toJson<String>(apiKey),
      'models': serializer.toJson<String>(models),
      'isActive': serializer.toJson<bool>(isActive),
      'createdTime': serializer.toJson<DateTime>(createdTime),
      'updatedTime': serializer.toJson<DateTime>(updatedTime),
    };
  }

  AiApiData copyWith(
          {int? id,
          String? serviceName,
          String? provider,
          String? baseUrl,
          String? apiKey,
          String? models,
          bool? isActive,
          DateTime? createdTime,
          DateTime? updatedTime}) =>
      AiApiData(
        id: id ?? this.id,
        serviceName: serviceName ?? this.serviceName,
        provider: provider ?? this.provider,
        baseUrl: baseUrl ?? this.baseUrl,
        apiKey: apiKey ?? this.apiKey,
        models: models ?? this.models,
        isActive: isActive ?? this.isActive,
        createdTime: createdTime ?? this.createdTime,
        updatedTime: updatedTime ?? this.updatedTime,
      );
  AiApiData copyWithCompanion(AiApiCompanion data) {
    return AiApiData(
      id: data.id.present ? data.id.value : this.id,
      serviceName:
          data.serviceName.present ? data.serviceName.value : this.serviceName,
      provider: data.provider.present ? data.provider.value : this.provider,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      apiKey: data.apiKey.present ? data.apiKey.value : this.apiKey,
      models: data.models.present ? data.models.value : this.models,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdTime:
          data.createdTime.present ? data.createdTime.value : this.createdTime,
      updatedTime:
          data.updatedTime.present ? data.updatedTime.value : this.updatedTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiApiData(')
          ..write('id: $id, ')
          ..write('serviceName: $serviceName, ')
          ..write('provider: $provider, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKey: $apiKey, ')
          ..write('models: $models, ')
          ..write('isActive: $isActive, ')
          ..write('createdTime: $createdTime, ')
          ..write('updatedTime: $updatedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serviceName, provider, baseUrl, apiKey,
      models, isActive, createdTime, updatedTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiApiData &&
          other.id == this.id &&
          other.serviceName == this.serviceName &&
          other.provider == this.provider &&
          other.baseUrl == this.baseUrl &&
          other.apiKey == this.apiKey &&
          other.models == this.models &&
          other.isActive == this.isActive &&
          other.createdTime == this.createdTime &&
          other.updatedTime == this.updatedTime);
}

class AiApiCompanion extends UpdateCompanion<AiApiData> {
  final Value<int> id;
  final Value<String> serviceName;
  final Value<String> provider;
  final Value<String> baseUrl;
  final Value<String> apiKey;
  final Value<String> models;
  final Value<bool> isActive;
  final Value<DateTime> createdTime;
  final Value<DateTime> updatedTime;
  const AiApiCompanion({
    this.id = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.provider = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.models = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdTime = const Value.absent(),
    this.updatedTime = const Value.absent(),
  });
  AiApiCompanion.insert({
    this.id = const Value.absent(),
    required String serviceName,
    required String provider,
    required String baseUrl,
    required String apiKey,
    required String models,
    this.isActive = const Value.absent(),
    this.createdTime = const Value.absent(),
    this.updatedTime = const Value.absent(),
  })  : serviceName = Value(serviceName),
        provider = Value(provider),
        baseUrl = Value(baseUrl),
        apiKey = Value(apiKey),
        models = Value(models);
  static Insertable<AiApiData> custom({
    Expression<int>? id,
    Expression<String>? serviceName,
    Expression<String>? provider,
    Expression<String>? baseUrl,
    Expression<String>? apiKey,
    Expression<String>? models,
    Expression<bool>? isActive,
    Expression<DateTime>? createdTime,
    Expression<DateTime>? updatedTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceName != null) 'service_name': serviceName,
      if (provider != null) 'provider': provider,
      if (baseUrl != null) 'base_url': baseUrl,
      if (apiKey != null) 'api_key': apiKey,
      if (models != null) 'models': models,
      if (isActive != null) 'is_active': isActive,
      if (createdTime != null) 'created_time': createdTime,
      if (updatedTime != null) 'updated_time': updatedTime,
    });
  }

  AiApiCompanion copyWith(
      {Value<int>? id,
      Value<String>? serviceName,
      Value<String>? provider,
      Value<String>? baseUrl,
      Value<String>? apiKey,
      Value<String>? models,
      Value<bool>? isActive,
      Value<DateTime>? createdTime,
      Value<DateTime>? updatedTime}) {
    return AiApiCompanion(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      provider: provider ?? this.provider,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      models: models ?? this.models,
      isActive: isActive ?? this.isActive,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (models.present) {
      map['models'] = Variable<String>(models.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdTime.present) {
      map['created_time'] = Variable<DateTime>(createdTime.value);
    }
    if (updatedTime.present) {
      map['updated_time'] = Variable<DateTime>(updatedTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiApiCompanion(')
          ..write('id: $id, ')
          ..write('serviceName: $serviceName, ')
          ..write('provider: $provider, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKey: $apiKey, ')
          ..write('models: $models, ')
          ..write('isActive: $isActive, ')
          ..write('createdTime: $createdTime, ')
          ..write('updatedTime: $updatedTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AiApiTable aiApi = $AiApiTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [aiApi];
}

typedef $$AiApiTableCreateCompanionBuilder = AiApiCompanion Function({
  Value<int> id,
  required String serviceName,
  required String provider,
  required String baseUrl,
  required String apiKey,
  required String models,
  Value<bool> isActive,
  Value<DateTime> createdTime,
  Value<DateTime> updatedTime,
});
typedef $$AiApiTableUpdateCompanionBuilder = AiApiCompanion Function({
  Value<int> id,
  Value<String> serviceName,
  Value<String> provider,
  Value<String> baseUrl,
  Value<String> apiKey,
  Value<String> models,
  Value<bool> isActive,
  Value<DateTime> createdTime,
  Value<DateTime> updatedTime,
});

class $$AiApiTableFilterComposer extends Composer<_$AppDatabase, $AiApiTable> {
  $$AiApiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get models => $composableBuilder(
      column: $table.models, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => ColumnFilters(column));
}

class $$AiApiTableOrderingComposer
    extends Composer<_$AppDatabase, $AiApiTable> {
  $$AiApiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get models => $composableBuilder(
      column: $table.models, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => ColumnOrderings(column));
}

class $$AiApiTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiApiTable> {
  $$AiApiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get apiKey =>
      $composableBuilder(column: $table.apiKey, builder: (column) => column);

  GeneratedColumn<String> get models =>
      $composableBuilder(column: $table.models, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => column);
}

class $$AiApiTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiApiTable,
    AiApiData,
    $$AiApiTableFilterComposer,
    $$AiApiTableOrderingComposer,
    $$AiApiTableAnnotationComposer,
    $$AiApiTableCreateCompanionBuilder,
    $$AiApiTableUpdateCompanionBuilder,
    (AiApiData, BaseReferences<_$AppDatabase, $AiApiTable, AiApiData>),
    AiApiData,
    PrefetchHooks Function()> {
  $$AiApiTableTableManager(_$AppDatabase db, $AiApiTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiApiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiApiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiApiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serviceName = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String> baseUrl = const Value.absent(),
            Value<String> apiKey = const Value.absent(),
            Value<String> models = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
            Value<DateTime> updatedTime = const Value.absent(),
          }) =>
              AiApiCompanion(
            id: id,
            serviceName: serviceName,
            provider: provider,
            baseUrl: baseUrl,
            apiKey: apiKey,
            models: models,
            isActive: isActive,
            createdTime: createdTime,
            updatedTime: updatedTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serviceName,
            required String provider,
            required String baseUrl,
            required String apiKey,
            required String models,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
            Value<DateTime> updatedTime = const Value.absent(),
          }) =>
              AiApiCompanion.insert(
            id: id,
            serviceName: serviceName,
            provider: provider,
            baseUrl: baseUrl,
            apiKey: apiKey,
            models: models,
            isActive: isActive,
            createdTime: createdTime,
            updatedTime: updatedTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AiApiTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AiApiTable,
    AiApiData,
    $$AiApiTableFilterComposer,
    $$AiApiTableOrderingComposer,
    $$AiApiTableAnnotationComposer,
    $$AiApiTableCreateCompanionBuilder,
    $$AiApiTableUpdateCompanionBuilder,
    (AiApiData, BaseReferences<_$AppDatabase, $AiApiTable, AiApiData>),
    AiApiData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AiApiTableTableManager get aiApi =>
      $$AiApiTableTableManager(_db, _db.aiApi);
}
