# Required for Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep annotations (this resolves the missing class error)
-keepattributes *Annotation*
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers

-dontwarn okio.**
-dontwarn com.google.**

# Flutter core
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.view.** { *; }

# Flutter MethodChannel and PlatformChannel
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler
-keepclassmembers class * {
    public <init>(...);
}

# Firebase (Auth, Messaging, Core, etc.)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep any models or classes accessed via reflection (e.g., from Gson or JSON parsing)
-keepclassmembers class * {
    *** get*(...);
    void set*(...);
}

# Prevent shrinking of deserialized or dynamically used classes
-keep class com.taskmaster.my_flutter_app.** { *; }

# Keep views and widgets (especially if you are using custom views or hybrid composition)
-keep class * extends android.view.View { *; }
-keep class * extends android.widget.TextView { *; }
-keep class * extends androidx.appcompat.widget.AppCompatTextView { *; }

# Optional safety net
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**


# SharedPreferences, if used
-keep class android.content.SharedPreferences { *; }

# Required for Kotlin (optional but recommended)
-keep class kotlin.Metadata { *; }

# Retain annotations used by Firebase and Kotlin
-keepattributes Signature
-keepattributes RuntimeVisibleAnnotations, RuntimeInvisibleAnnotations

# If using serialization libraries like Gson or Moshi
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Optional: Keep any service or receiver used in manifest
-keep class **.MainActivity
-keep class **.Application
-keep class **.FirebaseMessagingService
-keep class **.FirebaseInstanceIdService
-keep class **.BroadcastReceiver
