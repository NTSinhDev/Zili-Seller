import java.util.regex.Matcher
import java.util.regex.Pattern
import java.util.Properties
import java.io.File
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // The Google services Gradle plugin
    id("com.google.gms.google-services")
}

// Load properties from local.properties file at app level (root of project)
val localProperties = Properties()
// Get the root directory of the project (2 levels up from android/app/)
val rootDir = project.rootDir.parentFile
val localPropertiesFile = File(rootDir, "android.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
    println("Loaded properties from: ${localPropertiesFile.absolutePath}")
} else {
    println("Warning: android.properties not found at: ${localPropertiesFile.absolutePath}")
}

// Helper function to get property with default value
fun getLocalProperty(key: String, defaultValue: String = ""): String {
    return localProperties.getProperty(key, defaultValue)
}

android {
    namespace = "com.zili_coffee.seller"
    compileSdk = getLocalProperty("app.compileSdk", "36").toInt()
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Load values from local.properties file
        applicationId = getLocalProperty("app.applicationId", "com.zili_coffee.seller")
        minSdk = getLocalProperty("app.minSdk", "28").toInt()
        targetSdk = getLocalProperty("app.targetSdk", "33").toInt()
        versionCode = getLocalProperty("app.versionCode", "1").toInt()
        
        val versionNameBase = getLocalProperty("app.versionName", "1.0.0")
        val versionNameSuffix = getLocalProperty("app.versionNameSuffix", "")
        versionName = getLocalProperty("app.versionName", "1.0.0")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.7.0"))


  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")


  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
  
  // Core library desugaring for flutter_local_notifications
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}