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

class $ChatSessionsTable extends ChatSessions
    with TableInfo<$ChatSessionsTable, ChatSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdTimeMeta =
      const VerificationMeta('createdTime');
  @override
  late final GeneratedColumn<DateTime> createdTime = GeneratedColumn<DateTime>(
      'created_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _updatedTimeMeta =
      const VerificationMeta('updatedTime');
  @override
  late final GeneratedColumn<DateTime> updatedTime = GeneratedColumn<DateTime>(
      'updated_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _apiConfigIdMeta =
      const VerificationMeta('apiConfigId');
  @override
  late final GeneratedColumn<int> apiConfigId = GeneratedColumn<int>(
      'api_config_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, createdTime, updatedTime, apiConfigId, model, isFavorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<ChatSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('api_config_id')) {
      context.handle(
          _apiConfigIdMeta,
          apiConfigId.isAcceptableOrUnknown(
              data['api_config_id']!, _apiConfigIdMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_time'])!,
      updatedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_time'])!,
      apiConfigId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}api_config_id']),
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
    );
  }

  @override
  $ChatSessionsTable createAlias(String alias) {
    return $ChatSessionsTable(attachedDatabase, alias);
  }
}

class ChatSession extends DataClass implements Insertable<ChatSession> {
  final int id;
  final String title;
  final DateTime createdTime;
  final DateTime updatedTime;
  final int? apiConfigId;
  final String? model;
  final bool isFavorite;
  const ChatSession(
      {required this.id,
      required this.title,
      required this.createdTime,
      required this.updatedTime,
      this.apiConfigId,
      this.model,
      required this.isFavorite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['created_time'] = Variable<DateTime>(createdTime);
    map['updated_time'] = Variable<DateTime>(updatedTime);
    if (!nullToAbsent || apiConfigId != null) {
      map['api_config_id'] = Variable<int>(apiConfigId);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  ChatSessionsCompanion toCompanion(bool nullToAbsent) {
    return ChatSessionsCompanion(
      id: Value(id),
      title: Value(title),
      createdTime: Value(createdTime),
      updatedTime: Value(updatedTime),
      apiConfigId: apiConfigId == null && nullToAbsent
          ? const Value.absent()
          : Value(apiConfigId),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      isFavorite: Value(isFavorite),
    );
  }

  factory ChatSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatSession(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdTime: serializer.fromJson<DateTime>(json['createdTime']),
      updatedTime: serializer.fromJson<DateTime>(json['updatedTime']),
      apiConfigId: serializer.fromJson<int?>(json['apiConfigId']),
      model: serializer.fromJson<String?>(json['model']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'createdTime': serializer.toJson<DateTime>(createdTime),
      'updatedTime': serializer.toJson<DateTime>(updatedTime),
      'apiConfigId': serializer.toJson<int?>(apiConfigId),
      'model': serializer.toJson<String?>(model),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  ChatSession copyWith(
          {int? id,
          String? title,
          DateTime? createdTime,
          DateTime? updatedTime,
          Value<int?> apiConfigId = const Value.absent(),
          Value<String?> model = const Value.absent(),
          bool? isFavorite}) =>
      ChatSession(
        id: id ?? this.id,
        title: title ?? this.title,
        createdTime: createdTime ?? this.createdTime,
        updatedTime: updatedTime ?? this.updatedTime,
        apiConfigId: apiConfigId.present ? apiConfigId.value : this.apiConfigId,
        model: model.present ? model.value : this.model,
        isFavorite: isFavorite ?? this.isFavorite,
      );
  ChatSession copyWithCompanion(ChatSessionsCompanion data) {
    return ChatSession(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdTime:
          data.createdTime.present ? data.createdTime.value : this.createdTime,
      updatedTime:
          data.updatedTime.present ? data.updatedTime.value : this.updatedTime,
      apiConfigId:
          data.apiConfigId.present ? data.apiConfigId.value : this.apiConfigId,
      model: data.model.present ? data.model.value : this.model,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatSession(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdTime: $createdTime, ')
          ..write('updatedTime: $updatedTime, ')
          ..write('apiConfigId: $apiConfigId, ')
          ..write('model: $model, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, createdTime, updatedTime, apiConfigId, model, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatSession &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdTime == this.createdTime &&
          other.updatedTime == this.updatedTime &&
          other.apiConfigId == this.apiConfigId &&
          other.model == this.model &&
          other.isFavorite == this.isFavorite);
}

class ChatSessionsCompanion extends UpdateCompanion<ChatSession> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> createdTime;
  final Value<DateTime> updatedTime;
  final Value<int?> apiConfigId;
  final Value<String?> model;
  final Value<bool> isFavorite;
  const ChatSessionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdTime = const Value.absent(),
    this.updatedTime = const Value.absent(),
    this.apiConfigId = const Value.absent(),
    this.model = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  ChatSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.createdTime = const Value.absent(),
    this.updatedTime = const Value.absent(),
    this.apiConfigId = const Value.absent(),
    this.model = const Value.absent(),
    this.isFavorite = const Value.absent(),
  }) : title = Value(title);
  static Insertable<ChatSession> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? createdTime,
    Expression<DateTime>? updatedTime,
    Expression<int>? apiConfigId,
    Expression<String>? model,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdTime != null) 'created_time': createdTime,
      if (updatedTime != null) 'updated_time': updatedTime,
      if (apiConfigId != null) 'api_config_id': apiConfigId,
      if (model != null) 'model': model,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  ChatSessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<DateTime>? createdTime,
      Value<DateTime>? updatedTime,
      Value<int?>? apiConfigId,
      Value<String?>? model,
      Value<bool>? isFavorite}) {
    return ChatSessionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      apiConfigId: apiConfigId ?? this.apiConfigId,
      model: model ?? this.model,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdTime.present) {
      map['created_time'] = Variable<DateTime>(createdTime.value);
    }
    if (updatedTime.present) {
      map['updated_time'] = Variable<DateTime>(updatedTime.value);
    }
    if (apiConfigId.present) {
      map['api_config_id'] = Variable<int>(apiConfigId.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdTime: $createdTime, ')
          ..write('updatedTime: $updatedTime, ')
          ..write('apiConfigId: $apiConfigId, ')
          ..write('model: $model, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chat_sessions (id)'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<MessageType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MessageType>($ChatMessagesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<MessageRole, String> role =
      GeneratedColumn<String>('role', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MessageRole>($ChatMessagesTable.$converterrole);
  static const VerificationMeta _createdTimeMeta =
      const VerificationMeta('createdTime');
  @override
  late final GeneratedColumn<DateTime> createdTime = GeneratedColumn<DateTime>(
      'created_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('sent'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, content, type, role, createdTime, filePath, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_time')) {
      context.handle(
          _createdTimeMeta,
          createdTime.isAcceptableOrUnknown(
              data['created_time']!, _createdTimeMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      type: $ChatMessagesTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      role: $ChatMessagesTable.$converterrole.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!),
      createdTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_time'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MessageType, String, String> $convertertype =
      const EnumNameConverter<MessageType>(MessageType.values);
  static JsonTypeConverter2<MessageRole, String, String> $converterrole =
      const EnumNameConverter<MessageRole>(MessageRole.values);
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final int sessionId;
  final String content;
  final MessageType type;
  final MessageRole role;
  final DateTime createdTime;
  final String? filePath;
  final String status;
  const ChatMessage(
      {required this.id,
      required this.sessionId,
      required this.content,
      required this.type,
      required this.role,
      required this.createdTime,
      this.filePath,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['content'] = Variable<String>(content);
    {
      map['type'] =
          Variable<String>($ChatMessagesTable.$convertertype.toSql(type));
    }
    {
      map['role'] =
          Variable<String>($ChatMessagesTable.$converterrole.toSql(role));
    }
    map['created_time'] = Variable<DateTime>(createdTime);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      content: Value(content),
      type: Value(type),
      role: Value(role),
      createdTime: Value(createdTime),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      status: Value(status),
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      content: serializer.fromJson<String>(json['content']),
      type: $ChatMessagesTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      role: $ChatMessagesTable.$converterrole
          .fromJson(serializer.fromJson<String>(json['role'])),
      createdTime: serializer.fromJson<DateTime>(json['createdTime']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'content': serializer.toJson<String>(content),
      'type': serializer
          .toJson<String>($ChatMessagesTable.$convertertype.toJson(type)),
      'role': serializer
          .toJson<String>($ChatMessagesTable.$converterrole.toJson(role)),
      'createdTime': serializer.toJson<DateTime>(createdTime),
      'filePath': serializer.toJson<String?>(filePath),
      'status': serializer.toJson<String>(status),
    };
  }

  ChatMessage copyWith(
          {int? id,
          int? sessionId,
          String? content,
          MessageType? type,
          MessageRole? role,
          DateTime? createdTime,
          Value<String?> filePath = const Value.absent(),
          String? status}) =>
      ChatMessage(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        content: content ?? this.content,
        type: type ?? this.type,
        role: role ?? this.role,
        createdTime: createdTime ?? this.createdTime,
        filePath: filePath.present ? filePath.value : this.filePath,
        status: status ?? this.status,
      );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      role: data.role.present ? data.role.value : this.role,
      createdTime:
          data.createdTime.present ? data.createdTime.value : this.createdTime,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('role: $role, ')
          ..write('createdTime: $createdTime, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, sessionId, content, type, role, createdTime, filePath, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.content == this.content &&
          other.type == this.type &&
          other.role == this.role &&
          other.createdTime == this.createdTime &&
          other.filePath == this.filePath &&
          other.status == this.status);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> content;
  final Value<MessageType> type;
  final Value<MessageRole> role;
  final Value<DateTime> createdTime;
  final Value<String?> filePath;
  final Value<String> status;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.role = const Value.absent(),
    this.createdTime = const Value.absent(),
    this.filePath = const Value.absent(),
    this.status = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String content,
    required MessageType type,
    required MessageRole role,
    this.createdTime = const Value.absent(),
    this.filePath = const Value.absent(),
    this.status = const Value.absent(),
  })  : sessionId = Value(sessionId),
        content = Value(content),
        type = Value(type),
        role = Value(role);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? content,
    Expression<String>? type,
    Expression<String>? role,
    Expression<DateTime>? createdTime,
    Expression<String>? filePath,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (role != null) 'role': role,
      if (createdTime != null) 'created_time': createdTime,
      if (filePath != null) 'file_path': filePath,
      if (status != null) 'status': status,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<String>? content,
      Value<MessageType>? type,
      Value<MessageRole>? role,
      Value<DateTime>? createdTime,
      Value<String?>? filePath,
      Value<String>? status}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      content: content ?? this.content,
      type: type ?? this.type,
      role: role ?? this.role,
      createdTime: createdTime ?? this.createdTime,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($ChatMessagesTable.$convertertype.toSql(type.value));
    }
    if (role.present) {
      map['role'] =
          Variable<String>($ChatMessagesTable.$converterrole.toSql(role.value));
    }
    if (createdTime.present) {
      map['created_time'] = Variable<DateTime>(createdTime.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('role: $role, ')
          ..write('createdTime: $createdTime, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $FileAttachmentsTable extends FileAttachments
    with TableInfo<$FileAttachmentsTable, FileAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
      'message_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chat_messages (id)'));
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uploadedAtMeta =
      const VerificationMeta('uploadedAt');
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
      'uploaded_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns =>
      [id, messageId, fileName, filePath, fileSize, fileType, uploadedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_attachments';
  @override
  VerificationContext validateIntegrity(Insertable<FileAttachment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
          _uploadedAtMeta,
          uploadedAt.isAcceptableOrUnknown(
              data['uploaded_at']!, _uploadedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FileAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileAttachment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}message_id'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type'])!,
      uploadedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}uploaded_at'])!,
    );
  }

  @override
  $FileAttachmentsTable createAlias(String alias) {
    return $FileAttachmentsTable(attachedDatabase, alias);
  }
}

class FileAttachment extends DataClass implements Insertable<FileAttachment> {
  final int id;
  final int messageId;
  final String fileName;
  final String filePath;
  final int fileSize;
  final String fileType;
  final DateTime uploadedAt;
  const FileAttachment(
      {required this.id,
      required this.messageId,
      required this.fileName,
      required this.filePath,
      required this.fileSize,
      required this.fileType,
      required this.uploadedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_id'] = Variable<int>(messageId);
    map['file_name'] = Variable<String>(fileName);
    map['file_path'] = Variable<String>(filePath);
    map['file_size'] = Variable<int>(fileSize);
    map['file_type'] = Variable<String>(fileType);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    return map;
  }

  FileAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return FileAttachmentsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      fileName: Value(fileName),
      filePath: Value(filePath),
      fileSize: Value(fileSize),
      fileType: Value(fileType),
      uploadedAt: Value(uploadedAt),
    );
  }

  factory FileAttachment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileAttachment(
      id: serializer.fromJson<int>(json['id']),
      messageId: serializer.fromJson<int>(json['messageId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      fileType: serializer.fromJson<String>(json['fileType']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageId': serializer.toJson<int>(messageId),
      'fileName': serializer.toJson<String>(fileName),
      'filePath': serializer.toJson<String>(filePath),
      'fileSize': serializer.toJson<int>(fileSize),
      'fileType': serializer.toJson<String>(fileType),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
    };
  }

  FileAttachment copyWith(
          {int? id,
          int? messageId,
          String? fileName,
          String? filePath,
          int? fileSize,
          String? fileType,
          DateTime? uploadedAt}) =>
      FileAttachment(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        fileName: fileName ?? this.fileName,
        filePath: filePath ?? this.filePath,
        fileSize: fileSize ?? this.fileSize,
        fileType: fileType ?? this.fileType,
        uploadedAt: uploadedAt ?? this.uploadedAt,
      );
  FileAttachment copyWithCompanion(FileAttachmentsCompanion data) {
    return FileAttachment(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileAttachment(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileType: $fileType, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, messageId, fileName, filePath, fileSize, fileType, uploadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FileAttachment &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.fileName == this.fileName &&
          other.filePath == this.filePath &&
          other.fileSize == this.fileSize &&
          other.fileType == this.fileType &&
          other.uploadedAt == this.uploadedAt);
}

class FileAttachmentsCompanion extends UpdateCompanion<FileAttachment> {
  final Value<int> id;
  final Value<int> messageId;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<int> fileSize;
  final Value<String> fileType;
  final Value<DateTime> uploadedAt;
  const FileAttachmentsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.fileType = const Value.absent(),
    this.uploadedAt = const Value.absent(),
  });
  FileAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int messageId,
    required String fileName,
    required String filePath,
    required int fileSize,
    required String fileType,
    this.uploadedAt = const Value.absent(),
  })  : messageId = Value(messageId),
        fileName = Value(fileName),
        filePath = Value(filePath),
        fileSize = Value(fileSize),
        fileType = Value(fileType);
  static Insertable<FileAttachment> custom({
    Expression<int>? id,
    Expression<int>? messageId,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<int>? fileSize,
    Expression<String>? fileType,
    Expression<DateTime>? uploadedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      if (fileType != null) 'file_type': fileType,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
    });
  }

  FileAttachmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? messageId,
      Value<String>? fileName,
      Value<String>? filePath,
      Value<int>? fileSize,
      Value<String>? fileType,
      Value<DateTime>? uploadedAt}) {
    return FileAttachmentsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileType: $fileType, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AiApiTable aiApi = $AiApiTable(this);
  late final $ChatSessionsTable chatSessions = $ChatSessionsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $FileAttachmentsTable fileAttachments =
      $FileAttachmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [aiApi, chatSessions, chatMessages, fileAttachments];
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
typedef $$ChatSessionsTableCreateCompanionBuilder = ChatSessionsCompanion
    Function({
  Value<int> id,
  required String title,
  Value<DateTime> createdTime,
  Value<DateTime> updatedTime,
  Value<int?> apiConfigId,
  Value<String?> model,
  Value<bool> isFavorite,
});
typedef $$ChatSessionsTableUpdateCompanionBuilder = ChatSessionsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<DateTime> createdTime,
  Value<DateTime> updatedTime,
  Value<int?> apiConfigId,
  Value<String?> model,
  Value<bool> isFavorite,
});

final class $$ChatSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatSessionsTable, ChatSession> {
  $$ChatSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChatMessagesTable, List<ChatMessage>>
      _chatMessagesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chatMessages,
              aliasName: $_aliasNameGenerator(
                  db.chatSessions.id, db.chatMessages.sessionId));

  $$ChatMessagesTableProcessedTableManager get chatMessagesRefs {
    final manager = $$ChatMessagesTableTableManager($_db, $_db.chatMessages)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatMessagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get apiConfigId => $composableBuilder(
      column: $table.apiConfigId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  Expression<bool> chatMessagesRefs(
      Expression<bool> Function($$ChatMessagesTableFilterComposer f) f) {
    final $$ChatMessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableFilterComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get apiConfigId => $composableBuilder(
      column: $table.apiConfigId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));
}

class $$ChatSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => column);

  GeneratedColumn<int> get apiConfigId => $composableBuilder(
      column: $table.apiConfigId, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  Expression<T> chatMessagesRefs<T extends Object>(
      Expression<T> Function($$ChatMessagesTableAnnotationComposer a) f) {
    final $$ChatMessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatSessionsTable,
    ChatSession,
    $$ChatSessionsTableFilterComposer,
    $$ChatSessionsTableOrderingComposer,
    $$ChatSessionsTableAnnotationComposer,
    $$ChatSessionsTableCreateCompanionBuilder,
    $$ChatSessionsTableUpdateCompanionBuilder,
    (ChatSession, $$ChatSessionsTableReferences),
    ChatSession,
    PrefetchHooks Function({bool chatMessagesRefs})> {
  $$ChatSessionsTableTableManager(_$AppDatabase db, $ChatSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
            Value<DateTime> updatedTime = const Value.absent(),
            Value<int?> apiConfigId = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              ChatSessionsCompanion(
            id: id,
            title: title,
            createdTime: createdTime,
            updatedTime: updatedTime,
            apiConfigId: apiConfigId,
            model: model,
            isFavorite: isFavorite,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<DateTime> createdTime = const Value.absent(),
            Value<DateTime> updatedTime = const Value.absent(),
            Value<int?> apiConfigId = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              ChatSessionsCompanion.insert(
            id: id,
            title: title,
            createdTime: createdTime,
            updatedTime: updatedTime,
            apiConfigId: apiConfigId,
            model: model,
            isFavorite: isFavorite,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chatMessagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatMessagesRefs) db.chatMessages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatMessagesRefs)
                    await $_getPrefetchedData<ChatSession, $ChatSessionsTable,
                            ChatMessage>(
                        currentTable: table,
                        referencedTable: $$ChatSessionsTableReferences
                            ._chatMessagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatSessionsTableReferences(db, table, p0)
                                .chatMessagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatSessionsTable,
    ChatSession,
    $$ChatSessionsTableFilterComposer,
    $$ChatSessionsTableOrderingComposer,
    $$ChatSessionsTableAnnotationComposer,
    $$ChatSessionsTableCreateCompanionBuilder,
    $$ChatSessionsTableUpdateCompanionBuilder,
    (ChatSession, $$ChatSessionsTableReferences),
    ChatSession,
    PrefetchHooks Function({bool chatMessagesRefs})>;
typedef $$ChatMessagesTableCreateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<int> id,
  required int sessionId,
  required String content,
  required MessageType type,
  required MessageRole role,
  Value<DateTime> createdTime,
  Value<String?> filePath,
  Value<String> status,
});
typedef $$ChatMessagesTableUpdateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<int> id,
  Value<int> sessionId,
  Value<String> content,
  Value<MessageType> type,
  Value<MessageRole> role,
  Value<DateTime> createdTime,
  Value<String?> filePath,
  Value<String> status,
});

final class $$ChatMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage> {
  $$ChatMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.chatSessions.createAlias(
          $_aliasNameGenerator(db.chatMessages.sessionId, db.chatSessions.id));

  $$ChatSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$ChatSessionsTableTableManager($_db, $_db.chatSessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FileAttachmentsTable, List<FileAttachment>>
      _fileAttachmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.fileAttachments,
              aliasName: $_aliasNameGenerator(
                  db.chatMessages.id, db.fileAttachments.messageId));

  $$FileAttachmentsTableProcessedTableManager get fileAttachmentsRefs {
    final manager =
        $$FileAttachmentsTableTableManager($_db, $_db.fileAttachments)
            .filter((f) => f.messageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_fileAttachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MessageType, MessageType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<MessageRole, MessageRole, String> get role =>
      $composableBuilder(
          column: $table.role,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$ChatSessionsTableFilterComposer get sessionId {
    final $$ChatSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableFilterComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> fileAttachmentsRefs(
      Expression<bool> Function($$FileAttachmentsTableFilterComposer f) f) {
    final $$FileAttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fileAttachments,
        getReferencedColumn: (t) => t.messageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FileAttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.fileAttachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$ChatSessionsTableOrderingComposer get sessionId {
    final $$ChatSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$ChatSessionsTableAnnotationComposer get sessionId {
    final $$ChatSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> fileAttachmentsRefs<T extends Object>(
      Expression<T> Function($$FileAttachmentsTableAnnotationComposer a) f) {
    final $$FileAttachmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fileAttachments,
        getReferencedColumn: (t) => t.messageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FileAttachmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.fileAttachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (ChatMessage, $$ChatMessagesTableReferences),
    ChatMessage,
    PrefetchHooks Function({bool sessionId, bool fileAttachmentsRefs})> {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<MessageType> type = const Value.absent(),
            Value<MessageRole> role = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            sessionId: sessionId,
            content: content,
            type: type,
            role: role,
            createdTime: createdTime,
            filePath: filePath,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required String content,
            required MessageType type,
            required MessageRole role,
            Value<DateTime> createdTime = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            sessionId: sessionId,
            content: content,
            type: type,
            role: role,
            createdTime: createdTime,
            filePath: filePath,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatMessagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sessionId = false, fileAttachmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (fileAttachmentsRefs) db.fileAttachments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$ChatMessagesTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$ChatMessagesTableReferences._sessionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (fileAttachmentsRefs)
                    await $_getPrefetchedData<ChatMessage, $ChatMessagesTable,
                            FileAttachment>(
                        currentTable: table,
                        referencedTable: $$ChatMessagesTableReferences
                            ._fileAttachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatMessagesTableReferences(db, table, p0)
                                .fileAttachmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.messageId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (ChatMessage, $$ChatMessagesTableReferences),
    ChatMessage,
    PrefetchHooks Function({bool sessionId, bool fileAttachmentsRefs})>;
typedef $$FileAttachmentsTableCreateCompanionBuilder = FileAttachmentsCompanion
    Function({
  Value<int> id,
  required int messageId,
  required String fileName,
  required String filePath,
  required int fileSize,
  required String fileType,
  Value<DateTime> uploadedAt,
});
typedef $$FileAttachmentsTableUpdateCompanionBuilder = FileAttachmentsCompanion
    Function({
  Value<int> id,
  Value<int> messageId,
  Value<String> fileName,
  Value<String> filePath,
  Value<int> fileSize,
  Value<String> fileType,
  Value<DateTime> uploadedAt,
});

final class $$FileAttachmentsTableReferences extends BaseReferences<
    _$AppDatabase, $FileAttachmentsTable, FileAttachment> {
  $$FileAttachmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ChatMessagesTable _messageIdTable(_$AppDatabase db) =>
      db.chatMessages.createAlias($_aliasNameGenerator(
          db.fileAttachments.messageId, db.chatMessages.id));

  $$ChatMessagesTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<int>('message_id')!;

    final manager = $$ChatMessagesTableTableManager($_db, $_db.chatMessages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FileAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $FileAttachmentsTable> {
  $$FileAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnFilters(column));

  $$ChatMessagesTableFilterComposer get messageId {
    final $$ChatMessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableFilterComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FileAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FileAttachmentsTable> {
  $$FileAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnOrderings(column));

  $$ChatMessagesTableOrderingComposer get messageId {
    final $$ChatMessagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableOrderingComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FileAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FileAttachmentsTable> {
  $$FileAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => column);

  $$ChatMessagesTableAnnotationComposer get messageId {
    final $$ChatMessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FileAttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FileAttachmentsTable,
    FileAttachment,
    $$FileAttachmentsTableFilterComposer,
    $$FileAttachmentsTableOrderingComposer,
    $$FileAttachmentsTableAnnotationComposer,
    $$FileAttachmentsTableCreateCompanionBuilder,
    $$FileAttachmentsTableUpdateCompanionBuilder,
    (FileAttachment, $$FileAttachmentsTableReferences),
    FileAttachment,
    PrefetchHooks Function({bool messageId})> {
  $$FileAttachmentsTableTableManager(
      _$AppDatabase db, $FileAttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> messageId = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String> fileType = const Value.absent(),
            Value<DateTime> uploadedAt = const Value.absent(),
          }) =>
              FileAttachmentsCompanion(
            id: id,
            messageId: messageId,
            fileName: fileName,
            filePath: filePath,
            fileSize: fileSize,
            fileType: fileType,
            uploadedAt: uploadedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int messageId,
            required String fileName,
            required String filePath,
            required int fileSize,
            required String fileType,
            Value<DateTime> uploadedAt = const Value.absent(),
          }) =>
              FileAttachmentsCompanion.insert(
            id: id,
            messageId: messageId,
            fileName: fileName,
            filePath: filePath,
            fileSize: fileSize,
            fileType: fileType,
            uploadedAt: uploadedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FileAttachmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (messageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.messageId,
                    referencedTable:
                        $$FileAttachmentsTableReferences._messageIdTable(db),
                    referencedColumn:
                        $$FileAttachmentsTableReferences._messageIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FileAttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FileAttachmentsTable,
    FileAttachment,
    $$FileAttachmentsTableFilterComposer,
    $$FileAttachmentsTableOrderingComposer,
    $$FileAttachmentsTableAnnotationComposer,
    $$FileAttachmentsTableCreateCompanionBuilder,
    $$FileAttachmentsTableUpdateCompanionBuilder,
    (FileAttachment, $$FileAttachmentsTableReferences),
    FileAttachment,
    PrefetchHooks Function({bool messageId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AiApiTableTableManager get aiApi =>
      $$AiApiTableTableManager(_db, _db.aiApi);
  $$ChatSessionsTableTableManager get chatSessions =>
      $$ChatSessionsTableTableManager(_db, _db.chatSessions);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$FileAttachmentsTableTableManager get fileAttachments =>
      $$FileAttachmentsTableTableManager(_db, _db.fileAttachments);
}
