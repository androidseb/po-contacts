package com.exlyo.pocontacts;

import android.content.Intent;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @NonNull
    private final FilesApi filesApi;

    public MainActivity() {
        super();
        filesApi = new FilesApi(this);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine _flutterEngine) {
        GeneratedPluginRegistrant.registerWith(_flutterEngine);
        filesApi.configureFlutterEngine(_flutterEngine);
    }

    @Override
    protected void onNewIntent(@NonNull final Intent _intent) {
        super.onNewIntent(_intent);
        filesApi.onNewIntent(_intent);
    }
}
