package com.pdf_view_sample

import be.tramckrijte.workmanager.WorkmanagerPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant

class App : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        WorkmanagerPlugin.setPluginRegistrantCallback(this)
    }

    override fun registerWith(reg: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(RemoveSomePlugin(reg))
    }
}

class RemoveSomePlugin(private val reg: PluginRegistry) : PluginRegistry by reg {
    override fun hasPlugin(regKey: String): Boolean =
            if (regKey == "pt.tribeiro.flutter_plugin_pdf_viewer.FlutterPluginPdfViewerPlugin") {
                true //Prevent the Flutter PDF plugin from re-registering itself in the background isolate
            } else {
                reg.hasPlugin(regKey)
            }
}
