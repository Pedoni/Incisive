# =========================
# KEEP UNITY CORE CLASSES
# =========================
-keep class com.unity3d.player.** { *; }
-keep class com.unity3d.services.** { *; }

# Keep native methods (Unity uses JNI)
-keepclasseswithmembers class * {
    native <methods>;
}

# =========================
# KEEP flutter_embed_unity BRIDGE
# =========================
-keep class com.learntoflutter.flutter_embed_unity_android.** { *; }
