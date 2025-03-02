import 'dart:core';

import 'package:ai_client/common/utils/loading_indicator.dart';
import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/repositories/ai_api__repository.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// API 列表
class ApiList extends StatefulWidget {
  const ApiList({super.key});

  @override
  State<StatefulWidget> createState() => _ApiListState();
}

/// API 列表的状态管理
class _ApiListState extends State<ApiList> {
  /// AiApi 服务类
  final AiApiService _aiApiService =
      AiApiService(AiApiRepository(AppDatabase()));

  /// API信息列表
  List<AiApiData> _dataList = [];

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
                      title: e.serviceName, // 使用服务名称
                      description:
                          "${e.createdTime.year}-${e.createdTime.month.toString().padLeft(2, '0')}-${e.createdTime.day.toString().padLeft(2, '0')} ${e.createdTime.hour.toString().padLeft(2, '0')}:${e.createdTime.minute.toString().padLeft(2, '0')}:${e.createdTime.second.toString().padLeft(2, '0')}", // 使用年月日时分秒格式展示时间
                    ))
                .toList(),
            builder: (context, cell, index) {
              return TDSwipeCell(
                slidableKey: ValueKey(_dataList[index].id),
                groupTag: 'hret',
                right: TDSwipeCellPanel(
                  extentRatio: 60 / screenWidth,
                  onDismissed: (context) {
                    // 获取数据ID
                    var dataId = _dataList[index].id;
                    // 删除对应的数据
                    _aiApiService.deleteAiApiById(dataId);
                    // 删除操作
                    _dataList.removeAt(index);
                    // 更新长度
                    cellLength.value = _dataList.length;
                  },
                  children: [
                    TDSwipeCellAction(
                      backgroundColor: TDTheme.of(context).errorColor6,
                      label: tr(LocaleKeys.settingPageApiSettingDeleteApi),
                      onPressed: (context) {
                        // 获取数据ID
                        var dataId = _dataList[index].id;
                        // 删除对应的数据
                        _aiApiService.deleteAiApiById(dataId);
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
