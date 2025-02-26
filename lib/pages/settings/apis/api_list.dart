import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../generated/locale_keys.dart';

/// API 列表
class ApiList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApiListState();
}

/// API 列表
class _ApiListState extends State<ApiList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TDEmpty(
        type: TDEmptyType.plain,
        emptyText: tr(LocaleKeys.thisFeatureIsUnderDevelopment),
      ),
    );
  }
}
