@echo off
chcp 65001 >nul
title 文言文实词 - 打包 APK
cd /d "%~dp0"

echo ============================================
echo   文言文实词 - Android APK 打包工具
echo ============================================
echo.
echo 前置条件：
echo   1. 已安装 Node.js (https://nodejs.org)
echo   2. 已安装 Android Studio (https://developer.android.com/studio)
echo   3. Android Studio 中已安装 Android SDK
echo.
echo ============================================
echo.

:: 检查 Node.js
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未找到 Node.js！请先安装：https://nodejs.org
    pause
    exit /b 1
)
echo [OK] Node.js 已安装

:: 检查 Java
where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未找到 Java！请安装 JDK 17+
    pause
    exit /b 1
)
echo [OK] Java 已安装

:: 检查 ANDROID_HOME
if "%ANDROID_HOME%"=="" (
    if exist "%LOCALAPPDATA%\Android\Sdk" (
        set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
    ) else if exist "%USERPROFILE%\AppData\Local\Android\Sdk" (
        set ANDROID_HOME=%USERPROFILE%\AppData\Local\Android\Sdk
    ) else (
        echo [警告] 未设置 ANDROID_HOME 环境变量
        echo  请在 Android Studio 中：SDK Manager ^> 复制 SDK 路径
        echo  然后手动设置：set ANDROID_HOME=你的SDK路径
    )
)

echo.
echo ============================================
echo 步骤 1/4：安装 npm 依赖
echo ============================================
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [错误] npm install 失败！
    pause
    exit /b 1
)
echo [OK] 依赖安装完成

echo.
echo ============================================
echo 步骤 2/4：复制前端文件到 www/
echo ============================================
xcopy /Y /E "www" "www" >nul
echo [OK] 前端文件已就绪

echo.
echo ============================================
echo 步骤 3/4：同步 Capacitor 配置
echo ============================================
call npx cap sync android
if %ERRORLEVEL% NEQ 0 (
    echo [错误] cap sync 失败！
    pause
    exit /b 1
)
echo [OK] Capacitor 配置同步完成

echo.
echo ============================================
echo 步骤 4/4：在 Android Studio 中打开项目
echo ============================================
echo.
echo Android Studio 打开后：
echo   1. 等待 Gradle 同步完成
echo   2. Build ^> Build Bundle(s) / APK(s) ^> Build APK(s)
echo   3. 生成位置：android\app\build\outputs\apk\debug\
echo.
call npx cap open android

echo.
echo [完成] 返回此窗口后按任意键退出
pause
