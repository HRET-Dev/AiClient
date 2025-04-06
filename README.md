# AiClient

AiClient 是一个跨平台的 AI 聊天客户端应用程序，支持多种 AI API 服务商和多语言界面。

## 功能预览
![image](/README/home.png)
![image](/README/chat.png) 
![image](/README/history.png) 
![image](/README/setting.png)
![image](/README/setting_api.png)

## 功能特点

- **多 API 支持**：支持连接多种 AI 服务提供商的 API
- **聊天功能**：与 AI 进行自然语言对话
- **历史记录**：保存和管理聊天历史
- **多语言支持**：应用界面支持多种语言切换
- **API 管理**：添加、编辑、删除和导入 API 配置

## 技术栈

- 使用 Flutter/Dart 开发
- 支持 Android、iOS、Windows、macOS 和 Linux 平台

## TODO

- 消息重发
- 消息删除
- 聊天附件功能

## 本地开发指南

### 环境要求
```yaml
  Flutter: ">=3.0.0 <4.0.0"
  Dart: ">=3.0.0 <4.0.0"
  MacOS: macOS 10.15+（用于macOS开发）
  iOS: Xcode 13.0+（用于iOS开发）
  Android: Android SDK（用于Android开发）
```

### 1. 项目获取配置

#### 1.1 克隆项目
```bash
# 克隆项目
git clone https://github.com/HRET-Dev/AiClient.git

# 进入项目
cd AiClient
```
#### 1.2 安装依赖
```bash
flutter pub get
```

#### 1.3 代码生成
```bash
# 生成drift相关代码
dart run build_runner build
```

### 🎉 运行项目
```bash
# 运行项目
flutter run
```