import 'dart:core';

import 'package:ai_client/common/utils/db/database_helper.dart';
import 'package:ai_client/common/utils/loading_indicator.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// API 列表
class ApiList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApiListState();
}

/// API 列表的状态管理
class _ApiListState extends State<ApiList> {
  // 获取数据库实例
  final dbHelper = DatabaseHelper();

  /// API信息列表
  List<Map<String, dynamic>> _dataList = [];

  /// 是否显示加载中状态
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 初始化数据库和数据
    _initDatabaseAndData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 初始化数据库和数据
  Future<void> _initDatabaseAndData() async {
    try {
      // 设置加载状态为 true
      setState(() => _isLoading = true);

      // 查询数据
      var data = await dbHelper.query(AIApi.tableName);

      // 空数据添加默认数据
      if (data.isEmpty) {
        // 创建默认数据实体
        final newService = AIApi(
          serviceName: 'Default OpenAI GPT-4o',
          serviceType: 'TEXT_GEN',
          baseUrl: 'https://free.zeroai.chat/v1/chat/completions',
          apiKey: 'hret',
          modelName: 'gpt-4o',
          maxTokens: 2000,
        ).toMap();
        // 添加默认数据到数据库
        await dbHelper.insert(AIApi.tableName, newService);
        // 刷新数据
        data = await dbHelper.query(AIApi.tableName);
      }

      if (mounted) {
        setState(() {
          _dataList = List.from(data); // 更新数据列表
          _isLoading = false; // 设置加载状态为 false
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false); // 发生错误时设置加载状态为 false
      }
    }
  }

  /// 渲染数据列表
  Widget _buildDataListSwiperCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    final cellLength = ValueNotifier(_dataList.length); // 使用 ValueNotifier<int>

    return Padding(
      padding: const EdgeInsets.all(8.0),
      // 数据列表
      child: ValueListenableBuilder<int>(
        valueListenable: cellLength, // 监控 ValueNotifier<int>
        builder: (BuildContext context, value, Widget? child) {
          return TDCellGroup(
            cells: _dataList
                .map((e) => TDCell(
                      title: e['serviceName'], // 使用服务名称
                      note: e['note'], // 使用备注
                      description: e['description'], // 使用描述
                    ))
                .toList(),
            builder: (context, cell, index) {
              return TDSwipeCell(
                slidableKey: ValueKey(_dataList[index]['id']),
                groupTag: 'hret',
                right: TDSwipeCellPanel(
                  extentRatio: 60 / screenWidth,
                  onDismissed: (context) {
                    // 获取数据ID
                    var dataId = _dataList[index]['id'];
                    // 删除对应的数据
                    dbHelper.delete(AIApi.tableName, where: 'id = $dataId');
                    // 删除操作
                    _dataList.removeAt(index);
                    // 更新长度
                    cellLength.value = _dataList.length;
                  },
                  children: [
                    TDSwipeCellAction(
                      backgroundColor: TDTheme.of(context).errorColor6,
                      label: '删除',
                      onPressed: (context) {
                        // 获取数据ID
                        var dataId = _dataList[index]['id'];
                        // 删除对应的数据
                        dbHelper.delete(AIApi.tableName, where: 'id = $dataId');
                        // 删除操作
                        _dataList.removeAt(index);
                        // 更新长度
                        cellLength.value = _dataList.length;
                      },
                    ),
                  ],
                ),
                cell: cell,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 判断是否显示加载中
    if (_isLoading) {
      return LoadingIndicator.buildLoadingIndicator(context); // 显示加载指示器
    }

    // 渲染数据列表
    return _buildDataListSwiperCell(context);
  }
}
