// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

/// 支持的目标平台
enum Target {
  windows,
  linux,
  android,
  ios,
  macos,
}

extension TargetExt on Target {
  /// 获取操作系统名称
  String get os {
    if (this == Target.macos) {
      return "darwin";
    }
    return name;
  }

  /// 检查当前运行平台是否与目标平台相同
  bool get same {
    if (this == Target.android) {
      return true;
    }
    if (Platform.isWindows && this == Target.windows) {
      return true;
    }
    if (Platform.isLinux && this == Target.linux) {
      return true;
    }
    if (Platform.isMacOS && this == Target.macos) {
      return true;
    }
    return false;
  }

  /// 获取动态库扩展名
  String get dynamicLibExtensionName {
    final String extensionName;
    switch (this) {
      case Target.android || Target.linux:
        extensionName = ".so";
        break;
      case Target.windows:
        extensionName = ".dll";
        break;
      case Target.ios:
        extensionName = ".dylib";
        break;
      case Target.macos:
        extensionName = ".dylib";
        break;
    }
    return extensionName;
  }

  /// 获取可执行文件扩展名
  String get executableExtensionName {
    final String extensionName;
    switch (this) {
      case Target.windows:
        extensionName = ".exe";
        break;
      default:
        extensionName = "";
        break;
    }
    return extensionName;
  }
}

/// 支持的架构类型
enum Arch { amd64, arm64, arm }

/// 构建项配置
class BuildItem {
  Target target;
  Arch? arch;
  String? archName;

  BuildItem({
    required this.target,
    this.arch,
    this.archName,
  });

  @override
  String toString() {
    return 'BuildItem{target: $target, arch: $arch, archName: $archName}';
  }
}

/// 构建工具类
class Build {
  /// 所有支持的构建项配置
  static List<BuildItem> get buildItems => [
        BuildItem(
          target: Target.macos,
        ),
        BuildItem(
          target: Target.linux,
          arch: Arch.arm64,
        ),
        BuildItem(
          target: Target.linux,
          arch: Arch.amd64,
        ),
        BuildItem(
          target: Target.windows,
          arch: Arch.amd64,
        ),
        BuildItem(
          target: Target.windows,
          arch: Arch.arm64,
        ),
        BuildItem(
          target: Target.android,
          arch: Arch.arm,
          archName: 'armeabi-v7a',
        ),
        BuildItem(
          target: Target.android,
          arch: Arch.arm64,
          archName: 'arm64-v8a',
        ),
        BuildItem(
          target: Target.android,
          arch: Arch.amd64,
          archName: 'x86_64',
        ),
      ];

  /// 应用名称
  static String get appName => "AiClient";

  /// 输出目录路径
  static String get distPath => join(current, "dist");

  /// 执行命令
  static Future<void> exec(
    List<String> executable, {
    String? name,
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = true,
  }) async {
    if (name != null) print("执行命令: $name");
    try {
      final process = await Process.start(
        executable[0],
        executable.sublist(1),
        environment: environment,
        workingDirectory: workingDirectory,
        runInShell: runInShell,
      );
      
      process.stdout.listen((data) {
        print(utf8.decode(data));
      });
      
      process.stderr.listen((data) {
        print(utf8.decode(data));
      });
      
      final exitCode = await process.exitCode;
      if (exitCode != 0 && name != null) {
        throw "命令执行失败: $name (退出码: $exitCode)";
      }
    } catch (e) {
      print("命令执行异常: $e");
      if (name != null) throw "命令 '$name' 执行失败: $e";
      rethrow;
    }
  }

  /// 将命令字符串转换为可执行列表
  static List<String> getExecutable(String command) {
    print("命令: $command");
    return command.split(" ");
  }

  /// 安装或检查 fastforge 工具
  static Future<void> getFastforge() async {
    try {
      // 检查 fastforge 是否已经安装
      final result = await Process.run('fastforge', ['--version']);
      if (result.exitCode != 0) {
        // 如果没有安装，执行安装命令
        print("fastforge未安装或版本检查失败，开始安装...");
        await exec(
          name: "安装 fastforge",
          getExecutable("dart pub global activate fastforge"),
        );

        // 验证安装是否成功
        final verifyResult = await Process.run('fastforge', ['--version']);
        if (verifyResult.exitCode != 0) {
          throw "fastforge安装失败，请确保Dart SDK已正确安装并添加到PATH中";
        }
        print("fastforge安装成功，版本: ${verifyResult.stdout.toString().trim()}");
      } else {
        print("fastforge 已安装，版本: ${result.stdout.toString().trim()}");
      }
    } catch (e) {
      // 处理ProcessException，这通常意味着命令不存在
      if (e is ProcessException) {
        print("fastforge命令不存在，尝试安装...");
        try {
          await exec(
            name: "安装 fastforge",
            getExecutable("dart pub global activate fastforge"),
          );
          print("fastforge安装成功");
        } catch (installError) {
          print("安装fastforge失败: $installError");
          throw "无法安装fastforge，请确保Dart SDK已正确安装并添加到PATH中";
        }
      } else {
        print("获取fastforge时出错: $e");
        rethrow;
      }
    }
  }

  /// 获取应用版本号
  static Future<String> getAppVersion() async {
    try {
      // 读取pubspec.yaml文件获取版本号
      final pubspecFile = File(join(current, 'pubspec.yaml'));
      if (!pubspecFile.existsSync()) {
        print("警告: 未找到pubspec.yaml文件，使用默认版本号0.0.1");
        return "0.0.1";
      }

      final content = await pubspecFile.readAsString();
      final versionRegex = RegExp(r'version:\s*([0-9]+\.[0-9]+\.[0-9]+)');
      final match = versionRegex.firstMatch(content);

      if (match != null && match.groupCount >= 1) {
        final version = match.group(1)!;
        print("从pubspec.yaml获取到版本号: $version");
        return version;
      } else {
        print("警告: 在pubspec.yaml中未找到版本号，使用默认版本号0.0.1");
        return "0.0.1";
      }
    } catch (e) {
      print("获取版本号时出错: $e，使用默认版本号0.0.1");
      return "0.0.1";
    }
  }

  /// 复制文件
  static void copyFile(String sourceFilePath, String destinationFilePath) {
    final sourceFile = File(sourceFilePath);
    if (!sourceFile.existsSync()) {
      throw "源文件不存在: $sourceFilePath";
    }
    
    final destinationFile = File(destinationFilePath);
    final destinationDirectory = destinationFile.parent;
    if (!destinationDirectory.existsSync()) {
      destinationDirectory.createSync(recursive: true);
      print("创建目标目录: ${destinationDirectory.path}");
    }
    
    try {
      sourceFile.copySync(destinationFilePath);
      print("文件复制成功: $sourceFilePath -> $destinationFilePath");
    } catch (e) {
      print("文件复制失败: $e");
      throw "复制文件失败: $sourceFilePath -> $destinationFilePath: $e";
    }
  }
}

/// 构建命令类
class BuildCommand extends Command {
  Target target;

  BuildCommand({
    required this.target,
  }) {
    if (target == Target.android || target == Target.linux) {
      argParser.addOption(
        "arch",
        valueHelp: arches.map((e) => e.name).join(','),
        help: '指定 $name 构建的架构',
      );
    } else {
      argParser.addOption(
        "arch",
        help: '指定 $name 构建的架构名称',
      );
    }
  }

  @override
  String get description => "构建 $name 应用";

  @override
  String get name => target.name;

  /// 获取目标平台支持的架构列表
  List<Arch> get arches => Build.buildItems
      .where((element) => element.target == target && element.arch != null)
      .map((e) => e.arch!)
      .toList();

  /// 安装Linux构建依赖
  Future<void> _getLinuxDependencies(Arch arch) async {
    // 更新软件包列表
    await Build.exec(
      Build.getExecutable("sudo apt update -y"),
    );

    // 安装基本工具，包括file命令
    await Build.exec(
      Build.getExecutable("sudo apt install -y wget curl file"),
    );

    // 安装其他依赖
    await Build.exec(
      Build.getExecutable("sudo apt install -y ninja-build libgtk-3-dev"),
    );
    await Build.exec(
      Build.getExecutable("sudo apt install -y libayatana-appindicator3-dev"),
    );
    await Build.exec(
      Build.getExecutable("sudo apt-get install -y libkeybinder-3.0-dev"),
    );
    await Build.exec(
      Build.getExecutable("sudo apt install -y locate"),
    );
    
    if (arch == Arch.amd64) {
      await Build.exec(
        Build.getExecutable("sudo apt install -y rpm patchelf"),
      );
      await Build.exec(
        Build.getExecutable("sudo apt install -y libfuse2"),
      );
      
      final downloadName = arch == Arch.amd64 ? "x86_64" : "aarch_64";
      await Build.exec(
        Build.getExecutable(
          "wget -O appimagetool https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$downloadName.AppImage",
        ),
      );
      await Build.exec(
        Build.getExecutable(
          "chmod +x appimagetool",
        ),
      );
    }
    
    await Build.exec(
      Build.getExecutable(
        "sudo mv appimagetool /usr/local/bin/",
      ),
    );
  }

  /// 安装macOS构建依赖
  Future<void> _getMacosDependencies() async {
    await Build.exec(
      Build.getExecutable("npm install -g appdmg"),
    );
  }

  /// 使用fastforge构建应用
  Future<void> _buildFastforge({
    required Target target,
    required String targets,
    String args = '',
  }) async {
    await Build.getFastforge();

    if (args.isNotEmpty) {
      args = "--flutter-build-args=verbose $args";
    }

    await Build.exec(
      name: name,
      Build.getExecutable(
        "fastforge package --skip-clean --platform ${target.name} --targets $targets $args",
      ),
    );
  }

  /// 获取系统架构
  Future<String?> get systemArch async {
    if (Platform.isWindows) {
      return Platform.environment["PROCESSOR_ARCHITECTURE"];
    } else if (Platform.isLinux || Platform.isMacOS) {
      final result = await Process.run('uname', ['-m']);
      return result.stdout.toString().trim();
    }
    return null;
  }

  @override
  Future<void> run() async {
    final archName = argResults?["arch"];
    final currentArches =
        arches.where((element) => element.name == archName).toList();
    final arch = currentArches.isEmpty ? null : currentArches.first;

    print("目标平台: $target");

    if (arch == null &&
        target != Target.android &&
        target != Target.ios &&
        target != Target.macos) {
      throw "无效的架构参数，请指定有效的架构";
    }

    // 获取应用版本号
    final appVersion = await Build.getAppVersion();
    print("应用版本: $appVersion");

    switch (target) {
      case Target.windows:
       final archStr = archName != null ? "-$archName" : "";
        _buildFastforge(
          target: target,
          targets: "exe,zip",
          args: "--artifact-name=${Build.appName}-$appVersion$archStr",
        );
        return;
      case Target.linux:
        final targetMap = {
          Arch.arm64: "linux-arm64",
          Arch.amd64: "linux-x64",
        };
        final targets = [
          "deb",
          if (arch == Arch.amd64) ...[
            "appimage",
            "rpm",
          ],
        ].join(",");
        final defaultTarget = targetMap[arch];
        await _getLinuxDependencies(arch!);
        _buildFastforge(
          target: target,
          targets: targets,
          args: "--build-target-platform $defaultTarget",
        );
        return;
      case Target.android:
        final archNameMap = {
          Arch.arm: "armeabi-v7a",
          Arch.arm64: "arm64-v8a",
          Arch.amd64: "x86_64",
        };
        final defaultArches = [Arch.arm, Arch.arm64, Arch.amd64];
        final buildArches = defaultArches
            .where((element) => arch == null ? true : element == arch)
            .toList();

        // 创建版本输出目录
        final versionDistPath = join(Build.distPath, appVersion);
        final outputDir = Directory(versionDistPath);
        if (!outputDir.existsSync()) {
          outputDir.createSync(recursive: true);
          print("创建输出目录: $versionDistPath");
        }

        // 使用一次性命令构建所有目标架构的APK
        print("开始构建所有目标架构的Android APK");
        await Build.exec(
          name: "构建Android APK",
          Build.getExecutable(
            "flutter build apk --split-per-abi",
          ),
        );

        // 复制并重命名所有生成的APK文件
        for (final buildArch in buildArches) {
          final archDisplayName = archNameMap[buildArch]!;

          // 构建自定义APK名称
          final apkName =
              "${Build.appName}-$appVersion-android-$archDisplayName.apk";
          final sourceApkPath = join(current, "build", "app", "outputs",
              "flutter-apk", "app-$archDisplayName-release.apk");
          final destApkPath = join(versionDistPath, apkName);

          // 检查源文件是否存在
          if (File(sourceApkPath).existsSync()) {
            Build.copyFile(sourceApkPath, destApkPath);
            print("已生成 APK: $destApkPath");
          } else {
            print("警告: 未找到 $archDisplayName 架构的APK文件: $sourceApkPath");
          }
        }
        return;
      case Target.ios:
        // 执行本地构建脚本 ios_build.sh
        await Build.exec(
          name: "构建iOS应用",
          Build.getExecutable(
            "bash ios_build.sh",
          ),
        );
        return;
      case Target.macos:
        await _getMacosDependencies();
        await _buildFastforge(
          target: target,
          targets: "dmg",
        );

        // 构建完成后，查找并重命名 DMG 文件
        final appVersion = await Build.getAppVersion();

        // 查找DMG 文件
        print("正在搜索 DMG 文件...");
        bool found = false;

        // 检查版本目录
        final versionDir = Directory(join(Build.distPath, appVersion));
        if (versionDir.existsSync()) {
          final files = versionDir.listSync();
          for (final entity in files) {
            if (entity is File &&
                entity.path.endsWith('.dmg') &&
                entity.path.contains(appVersion)) {
              print("在版本目录中找到 DMG 文件: ${entity.path}");
              try {
                // 在原目录中重命名文件
                final customDmgName = "${Build.appName}-$appVersion-macos.dmg";
                final customDmgPath = join(dirname(entity.path), customDmgName);
                File(entity.path).renameSync(customDmgPath);
                print("已将 DMG 文件重命名为: $customDmgName");
                found = true;
                break;
              } catch (e) {
                print("重命名 DMG 文件失败: $e");
              }
            }
          }
        }

        if (!found) {
          print("警告: 未找到任何 DMG 文件，请检查 fastforge 的输出路径");
        }
        return;
    }
  }
}

/// 主函数
Future<void> main(List<String> args) async {
  try {
    final runner = CommandRunner("setup", "构建应用程序");
    runner.addCommand(BuildCommand(target: Target.android));
    runner.addCommand(BuildCommand(target: Target.ios));
    runner.addCommand(BuildCommand(target: Target.linux));
    runner.addCommand(BuildCommand(target: Target.windows));
    runner.addCommand(BuildCommand(target: Target.macos));
    await runner.run(args);
  } catch (e) {
    print("构建失败: $e");
    exit(1);
  }
}
