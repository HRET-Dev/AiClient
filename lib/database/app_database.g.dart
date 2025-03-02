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
  late final GeneratedColumn<String> serviceName =
      GeneratedColumn<String>('service_name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider =
      GeneratedColumn<String>('provider', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _serviceTypeMeta =
      const VerificationMeta('serviceType');
  @override
  late final GeneratedColumn<String> serviceType =
      GeneratedColumn<String>('service_type', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _baseUrlMeta =
      const VerificationMeta('baseUrl');
  @override
  late final GeneratedColumn<String> baseUrl =
      GeneratedColumn<String>('base_url', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey =
      GeneratedColumn<String>('api_key', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName =
      GeneratedColumn<String>('model_name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _modelConfigMeta =
      const VerificationMeta('modelConfig');
  @override
  late final GeneratedColumn<String> modelConfig = GeneratedColumn<String>(
      'model_config', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
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
        serviceType,
        baseUrl,
        apiKey,
        modelName,
        modelConfig,
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
    if (data.containsKey('service_type')) {
      context.handle(
          _serviceTypeMeta,
          serviceType.isAcceptableOrUnknown(
              data['service_type']!, _serviceTypeMeta));
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
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
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('model_config')) {
      context.handle(
          _modelConfigMeta,
          modelConfig.isAcceptableOrUnknown(
              data['model_config']!, _modelConfigMeta));
    } else if (isInserting) {
      context.missing(_modelConfigMeta);
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
      serviceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_type'])!,
      baseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_url'])!,
      apiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key'])!,
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name'])!,
      modelConfig: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_config'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
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

  /// 服务类型
  final String serviceType;

  /// 基础URL地址
  final String baseUrl;

  /// API密钥
  final String apiKey;

  /// 模型名称
  final String modelName;

  /// 模型配置(JSON格式)
  final String modelConfig;

  /// 是否激活(1:激活 0:未激活)
  final int isActive;

  /// 创建时间
  final DateTime createdTime;

  /// 更新时间
  final DateTime updatedTime;
  const AiApiData(
      {required this.id,
      required this.serviceName,
      required this.provider,
      required this.serviceType,
      required this.baseUrl,
      required this.apiKey,
      required this.modelName,
      required this.modelConfig,
      required this.isActive,
      required this.createdTime,
      required this.updatedTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['service_name'] = Variable<String>(serviceName);
    map['provider'] = Variable<String>(provider);
    map['service_type'] = Variable<String>(serviceType);
    map['base_url'] = Variable<String>(baseUrl);
    map['api_key'] = Variable<String>(apiKey);
    map['model_name'] = Variable<String>(modelName);
    map['model_config'] = Variable<String>(modelConfig);
    map['is_active'] = Variable<int>(isActive);
    map['created_time'] = Variable<DateTime>(createdTime);
    map['updated_time'] = Variable<DateTime>(updatedTime);
    return map;
  }

  AiApiCompanion toCompanion(bool nullToAbsent) {
    return AiApiCompanion(
      id: Value(id),
      serviceName: Value(serviceName),
      provider: Value(provider),
      serviceType: Value(serviceType),
      baseUrl: Value(baseUrl),
      apiKey: Value(apiKey),
      modelName: Value(modelName),
      modelConfig: Value(modelConfig),
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
      serviceType: serializer.fromJson<String>(json['serviceType']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      modelName: serializer.fromJson<String>(json['modelName']),
      modelConfig: serializer.fromJson<String>(json['modelConfig']),
      isActive: serializer.fromJson<int>(json['isActive']),
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
      'serviceType': serializer.toJson<String>(serviceType),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'apiKey': serializer.toJson<String>(apiKey),
      'modelName': serializer.toJson<String>(modelName),
      'modelConfig': serializer.toJson<String>(modelConfig),
      'isActive': serializer.toJson<int>(isActive),
      'createdTime': serializer.toJson<DateTime>(createdTime),
      'updatedTime': serializer.toJson<DateTime>(updatedTime),
    };
  }

  AiApiData copyWith(
          {int? id,
          String? serviceName,
          String? provider,
          String? serviceType,
          String? baseUrl,
          String? apiKey,
          String? modelName,
          String? modelConfig,
          int? isActive,
          DateTime? createdTime,
          DateTime? updatedTime}) =>
      AiApiData(
        id: id ?? this.id,
        serviceName: serviceName ?? this.serviceName,
        provider: provider ?? this.provider,
        serviceType: serviceType ?? this.serviceType,
        baseUrl: baseUrl ?? this.baseUrl,
        apiKey: apiKey ?? this.apiKey,
        modelName: modelName ?? this.modelName,
        modelConfig: modelConfig ?? this.modelConfig,
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
      serviceType:
          data.serviceType.present ? data.serviceType.value : this.serviceType,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      apiKey: data.apiKey.present ? data.apiKey.value : this.apiKey,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      modelConfig:
          data.modelConfig.present ? data.modelConfig.value : this.modelConfig,
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
          ..write('serviceType: $serviceType, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKey: $apiKey, ')
          ..write('modelName: $modelName, ')
          ..write('modelConfig: $modelConfig, ')
          ..write('isActive: $isActive, ')
          ..write('createdTime: $createdTime, ')
          ..write('updatedTime: $updatedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      serviceName,
      provider,
      serviceType,
      baseUrl,
      apiKey,
      modelName,
      modelConfig,
      isActive,
      createdTime,
      updatedTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiApiData &&
          other.id == this.id &&
          other.serviceName == this.serviceName &&
          other.provider == this.provider &&
          other.serviceType == this.serviceType &&
          other.baseUrl == this.baseUrl &&
          other.apiKey == this.apiKey &&
          other.modelName == this.modelName &&
          other.modelConfig == this.modelConfig &&
          other.isActive == this.isActive &&
          other.createdTime == this.createdTime &&
          other.updatedTime == this.updatedTime);
}

class AiApiCompanion extends UpdateCompanion<AiApiData> {
  final Value<int> id;
  final Value<String> serviceName;
  final Value<String> provider;
  final Value<String> serviceType;
  final Value<String> baseUrl;
  final Value<String> apiKey;
  final Value<String> modelName;
  final Value<String> modelConfig;
  final Value<int> isActive;
  final Value<DateTime> createdTime;
  final Value<DateTime> updatedTime;
  const AiApiCompanion({
    this.id = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.provider = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.modelName = const Value.absent(),
    this.modelConfig = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdTime = const Value.absent(),
    this.updatedTime = const Value.absent(),
  });
  AiApiCompanion.insert({
    this.id = const Value.absent(),
    required String serviceName,
    required String provider,
    required String serviceType,
    required String baseUrl,
    required String apiKey,
    required String modelName,
    required String modelConfig,
    this.isActive = const Value.absent(),
    this.createdTime = const Value.absent(),
    this.updatedTime = const Value.absent(),
  })  : serviceName = Value(serviceName),
        provider = Value(provider),
        serviceType = Value(serviceType),
        baseUrl = Value(baseUrl),
        apiKey = Value(apiKey),
        modelName = Value(modelName),
        modelConfig = Value(modelConfig);
  static Insertable<AiApiData> custom({
    Expression<int>? id,
    Expression<String>? serviceName,
    Expression<String>? provider,
    Expression<String>? serviceType,
    Expression<String>? baseUrl,
    Expression<String>? apiKey,
    Expression<String>? modelName,
    Expression<String>? modelConfig,
    Expression<int>? isActive,
    Expression<DateTime>? createdTime,
    Expression<DateTime>? updatedTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceName != null) 'service_name': serviceName,
      if (provider != null) 'provider': provider,
      if (serviceType != null) 'service_type': serviceType,
      if (baseUrl != null) 'base_url': baseUrl,
      if (apiKey != null) 'api_key': apiKey,
      if (modelName != null) 'model_name': modelName,
      if (modelConfig != null) 'model_config': modelConfig,
      if (isActive != null) 'is_active': isActive,
      if (createdTime != null) 'created_time': createdTime,
      if (updatedTime != null) 'updated_time': updatedTime,
    });
  }

  AiApiCompanion copyWith(
      {Value<int>? id,
      Value<String>? serviceName,
      Value<String>? provider,
      Value<String>? serviceType,
      Value<String>? baseUrl,
      Value<String>? apiKey,
      Value<String>? modelName,
      Value<String>? modelConfig,
      Value<int>? isActive,
      Value<DateTime>? createdTime,
      Value<DateTime>? updatedTime}) {
    return AiApiCompanion(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      provider: provider ?? this.provider,
      serviceType: serviceType ?? this.serviceType,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
      modelConfig: modelConfig ?? this.modelConfig,
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
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (modelConfig.present) {
      map['model_config'] = Variable<String>(modelConfig.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
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
          ..write('serviceType: $serviceType, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKey: $apiKey, ')
          ..write('modelName: $modelName, ')
          ..write('modelConfig: $modelConfig, ')
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
  required String serviceType,
  required String baseUrl,
  required String apiKey,
  required String modelName,
  required String modelConfig,
  Value<int> isActive,
  Value<DateTime> createdTime,
  Value<DateTime> updatedTime,
});
typedef $$AiApiTableUpdateCompanionBuilder = AiApiCompanion Function({
  Value<int> id,
  Value<String> serviceName,
  Value<String> provider,
  Value<String> serviceType,
  Value<String> baseUrl,
  Value<String> apiKey,
  Value<String> modelName,
  Value<String> modelConfig,
  Value<int> isActive,
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

  ColumnFilters<String> get serviceType => $composableBuilder(
      column: $table.serviceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelConfig => $composableBuilder(
      column: $table.modelConfig, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isActive => $composableBuilder(
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

  ColumnOrderings<String> get serviceType => $composableBuilder(
      column: $table.serviceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelConfig => $composableBuilder(
      column: $table.modelConfig, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isActive => $composableBuilder(
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

  GeneratedColumn<String> get serviceType => $composableBuilder(
      column: $table.serviceType, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get apiKey =>
      $composableBuilder(column: $table.apiKey, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<String> get modelConfig => $composableBuilder(
      column: $table.modelConfig, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
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
            Value<String> serviceType = const Value.absent(),
            Value<String> baseUrl = const Value.absent(),
            Value<String> apiKey = const Value.absent(),
            Value<String> modelName = const Value.absent(),
            Value<String> modelConfig = const Value.absent(),
            Value<int> isActive = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
            Value<DateTime> updatedTime = const Value.absent(),
          }) =>
              AiApiCompanion(
            id: id,
            serviceName: serviceName,
            provider: provider,
            serviceType: serviceType,
            baseUrl: baseUrl,
            apiKey: apiKey,
            modelName: modelName,
            modelConfig: modelConfig,
            isActive: isActive,
            createdTime: createdTime,
            updatedTime: updatedTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serviceName,
            required String provider,
            required String serviceType,
            required String baseUrl,
            required String apiKey,
            required String modelName,
            required String modelConfig,
            Value<int> isActive = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
            Value<DateTime> updatedTime = const Value.absent(),
          }) =>
              AiApiCompanion.insert(
            id: id,
            serviceName: serviceName,
            provider: provider,
            serviceType: serviceType,
            baseUrl: baseUrl,
            apiKey: apiKey,
            modelName: modelName,
            modelConfig: modelConfig,
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
