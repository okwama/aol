# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep SQLite classes
-keep class com.tekartik.sqflite.** { *; }
-keep class io.flutter.plugins.flutter_plugin_android_lifecycle.** { *; }

# Keep HTTP classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Keep Gson classes if used
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep model classes (adjust package name as needed)
-keep class com.jlwfoundation.app.models.** { *; }

# Keep notification classes
-keep class androidx.work.** { *; }
-keep class com.google.firebase.messaging.** { *; }

# Keep file picker classes
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Keep connectivity classes
-keep class androidx.core.net.** { *; }

# Keep shared preferences
-keep class androidx.preference.** { *; }

# Keep cached network image
-keep class com.davemorrissey.labs.subscaleview.** { *; }

# Keep local notifications
-keep class com.dexterous.** { *; }

# Keep secure storage
-keep class androidx.security.crypto.** { *; }

# Keep toast
-keep class io.github.ponnamkarthik.toast.fluttertoast.** { *; }

# Keep table calendar
-keep class com.apptreesoftware.barcodescan.** { *; }

# Keep path provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep flutter local notifications
-keep class com.dexterous.** { *; }

# Keep all Flutter plugins
-keep class io.flutter.plugins.** { *; }

# Keep all classes in your app package
-keep class com.jlwfoundation.app.** { *; }

# Google Play Core classes
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Flutter deferred components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Keep Flutter embedding classes
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Remove System.out.println in release builds
-assumenosideeffects class java.io.PrintStream {
    public void println(%);
    public void println(**);
}
