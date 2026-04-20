# nomed

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
nomed
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ kotlin
│  │  │  └─ errors
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  ├─ errors
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ example
│  │     │  │        └─ nomed
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle.kts
│  ├─ gradle
│  │  └─ wrapper
│  │     ├─ gradle-wrapper.jar
│  │     └─ gradle-wrapper.properties
│  ├─ gradle.properties
│  ├─ gradlew
│  ├─ gradlew.bat
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
│  │  └─ Release.xcconfig
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ components
│  │  ├─ custom_button.dart
│  │  └─ custom_text_field.dart
│  ├─ config
│  │  ├─ app_config.dart
│  │  ├─ colors.dart
│  │  └─ style.dart
│  ├─ core
│  │  ├─ constents.dart
│  │  ├─ helper.dart
│  │  ├─ request_premmisiion_location.dart
│  │  └─ service_locator.dart
│  ├─ features
│  │  ├─ auth
│  │  │  ├─ bloc
│  │  │  │  ├─ auth_cubit.dart
│  │  │  │  └─ auth_state.dart
│  │  │  ├─ domain
│  │  │  │  ├─ auith_network.dart
│  │  │  │  ├─ auth_repository.dart
│  │  │  │  └─ auth_socket.dart
│  │  │  ├─ model
│  │  │  │  └─ user_model.dart
│  │  │  └─ ui
│  │  │     ├─ screens
│  │  │     │  ├─ auth_gate.dart
│  │  │     │  ├─ login_page.dart
│  │  │     │  └─ register_page.dart
│  │  │     └─ widgets
│  │  ├─ chat
│  │  │  ├─ bloc
│  │  │  │  ├─ chat_rooms_list_bloc.dart
│  │  │  │  ├─ chat_room_list_state.dart
│  │  │  │  ├─ chat_room_membership_cubit.dart
│  │  │  │  ├─ chat_room_membership_state.dart
│  │  │  │  ├─ message_bloc.dart
│  │  │  │  ├─ message_state.dart
│  │  │  │  └─ room_join_state.dart
│  │  │  ├─ domain
│  │  │  │  ├─ message_network.dart
│  │  │  │  └─ message_socket.dart
│  │  │  ├─ model
│  │  │  │  └─ message_model.dart
│  │  │  └─ ui
│  │  │     ├─ screens
│  │  │     │  ├─ chat_messgae_page.dart
│  │  │     │  └─ chat_page.dart
│  │  │     └─ widgets
│  │  ├─ home
│  │  │  ├─ bloc
│  │  │  │  ├─ create_room_cubit.dart
│  │  │  │  ├─ create_room_state.dart
│  │  │  │  ├─ room_cubit.dart
│  │  │  │  ├─ room_details_cubit.dart
│  │  │  │  ├─ room_details_state.dart
│  │  │  │  └─ room_state.dart
│  │  │  ├─ domain
│  │  │  ├─ model
│  │  │  │  └─ room_model.dart
│  │  │  └─ ui
│  │  │     ├─ screens
│  │  │     │  ├─ create_room_page.dart
│  │  │     │  └─ home_page.dart
│  │  │     └─ widgets
│  │  │        └─ room_bottomsheet.dart
│  │  └─ navigation
│  │     └─ app_navigation.dart
│  ├─ main.dart
│  └─ shared
│     └─ network
│        └─ room_network.dart
├─ nomed-server
│  ├─ nodemon.json
│  ├─ package-lock.json
│  ├─ package.json
│  ├─ src
│  │  ├─ app.ts
│  │  ├─ config
│  │  │  ├─ db.ts
│  │  │  └─ env.ts
│  │  ├─ controller
│  │  │  ├─ auth.controller.ts
│  │  │  ├─ messages.controller.ts
│  │  │  └─ room.controller.ts
│  │  ├─ middleware
│  │  │  └─ auth.middleware.ts
│  │  ├─ model
│  │  │  ├─ chatroom.model.ts
│  │  │  ├─ message.model.ts
│  │  │  └─ user.model.ts
│  │  ├─ router
│  │  │  ├─ auth.route.ts
│  │  │  ├─ message.route.ts
│  │  │  └─ room.route.ts
│  │  ├─ server.ts
│  │  ├─ socket
│  │  │  ├─ chat
│  │  │  │  └─ chat.event.ts
│  │  │  ├─ romm
│  │  │  │  └─ room.event.ts
│  │  │  └─ socket.ts
│  │  ├─ types
│  │  │  └─ express.d.ts
│  │  └─ utils
│  │     ├─ token.utils.ts
│  │     └─ zodhelper.utils.ts
│  └─ tsconfig.json
├─ pubspec.lock
├─ pubspec.yaml
├─ README.md
└─ test
   └─ widget_test.dart

```