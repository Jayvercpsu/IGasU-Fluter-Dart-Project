plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.i_gas_u"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    tasks.withType<JavaCompile> {
        options.compilerArgs.addAll(listOf("-Xlint:-options"))
    }

    defaultConfig {
        applicationId = "com.example.i_gas_u"
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        debug {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
            isCrunchPngs = false
        }
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            isCrunchPngs = true
            isDebuggable = false
            isZipAlignEnabled = true
        }
    }

    splits {
        abi {
            isEnable = true
            reset()
            include("arm64-v8a", "armeabi-v7a")
            isUniversalApk = true
        }
    }

    lint {
        checkReleaseBuilds = false
        abortOnError = false
        disable += listOf("InvalidPackage", "MissingTranslation")
    }

    packaging {
        resources {
            pickFirsts += listOf(
                "**/libc++_shared.so",
                "**/libjsc.so",
                "**/libjscexecutor.so",
                "**/libflipper.so",
                "**/libfb.so"
            )
            excludes += listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/ASL2.0",
                "META-INF/LGPL2.1",
                "META-INF/AL2.0",
                "META-INF/proguard/**",
                "**/*.kotlin_metadata",
                "**/*.version",
                "**/*.properties",
                "**/*.txt",
                "**/*.json",
                "DebugProbesKt.bin",
                "kotlin/**",
                "**/kotlin-tooling-metadata.json"
            )
        }
        jniLibs {
            pickFirsts += listOf("**/libc++_shared.so", "**/libjsc.so")
        }
    }

    bundle {
        language { enableSplit = true }
        density { enableSplit = false }
        abi { enableSplit = false }
    }

    dexOptions {
        jumboMode = true
        preDexLibraries = true
    }

    buildFeatures {
        buildConfig = true
        viewBinding = false
        dataBinding = false
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("androidx.vectordrawable:vectordrawable:1.1.0")
}
