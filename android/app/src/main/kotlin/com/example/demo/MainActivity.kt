package com.example.demo

import android.os.Bundle
import com.amap.api.maps.MapsInitializer
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // 高德 SDK 隐私合规（必须在 SDK 任何接口调用前设置）
        MapsInitializer.updatePrivacyShow(this, true, true)
        MapsInitializer.updatePrivacyAgree(this, true)
        super.onCreate(savedInstanceState)
    }
}
