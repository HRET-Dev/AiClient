import 'dart:core';

import 'package:ai_client/common/utils/loading_indicator.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/pages/settings/apis/api_info.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// API 列表
class ApiList extends StatefulWidget {
  const ApiList({super.key});

  @override
  State<StatefulWidget> createState() => _ApiListState();
}

/// API 列表的状态管理
class _ApiListState extends State<ApiList> {
  /// AiApi 服务类
  late AiApiService _aiApiService = AiApiService();

  /// API信息列表
  List<AiApi> _dataList = [];

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
      var data = await _aiApiService.initDefaultAiApiConfig();

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
  Widget _buildDataList() {
    // 主题配置
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      // 数据列表
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _dataList.length,
          itemBuilder: (context, index) {
            final item = _dataList[index];
            return Dismissible(
              key: ValueKey(item.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // 在安全的时机执行删除操作
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // 获取数据ID
                  var dataId = item.id;
                  // 删除对应的数据
                  _aiApiService.deleteAiApiById(dataId);
                  // 使用 setState 安全地更新 UI
                  setState(() {
                    _dataList.removeAt(index);
                  });
                });
              },
              child: Card(
                color: theme.colorScheme.onSecondary,
                shadowColor: theme.colorScheme.secondary,
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(item.serviceName),
                  subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(item.updateTime)),
                  onTap: () async {
                    // 通过弹窗打开 api 信息页面
                    final result = await showDialog(
                      context: context,
                      builder: (context) => ApiInfo(aiApi: item),
                    );

                    // 如果编辑成功，刷新列表
                    if (result == true) {
                      // 重新查询数据
                      var data = await _aiApiService.getAllAiApis();
                      setState(() {
                        // 更新数据列表
                        _dataList = List.from(data);
                      });
                    }
                  },
                ),
              ),
            );
          },
        ),
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
    return _buildDataList();
  }
}
