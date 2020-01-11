package com.exlyo.pocontacts;

import android.content.Intent;
import android.net.Uri;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class FilesApi {
    private static final String CHANNEL_NAME = "com.exlyo.pocontacts/files";

    @NonNull
    private final MainActivity mainActivity;

    /*
     * Map of String ("file id") -> Uri tracking the pending file open requests.
     * */
    @NonNull
    private final Map<String, Uri> pendingFileOpenRequests = new HashMap<>();

    FilesApi(@NonNull final MainActivity _mainActivity) {
        mainActivity = _mainActivity;
    }

    void configureFlutterEngine(@NonNull final FlutterEngine _flutterEngine) {
        new MethodChannel(_flutterEngine.getDartExecutor(), FilesApi.CHANNEL_NAME)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull final MethodCall _call, @NonNull final MethodChannel.Result _result) {
                        //noinspection IfCanBeSwitch
                        if (_call.method.equals("getInboxFileId")) {
                            final String inboxFileId = getInboxFileId();
                            _result.success(inboxFileId);
                        } else if (_call.method.equals("discardInboxFileId")) {
                            final String fileId = _call.argument("inboxFileId");
                            discardInboxFileId(fileId);
                            _result.success(null);
                        } else if (_call.method.equals("getCopiedInboxFilePath")) {
                            final String fileId = _call.argument("inboxFileId");
                            final String copiedInboxFilePath = getCopiedInboxFilePath(fileId);
                            _result.success(copiedInboxFilePath);
                        } else if (_call.method.equals("getOutputFilesDirectoryPath")) {
                            final String outputFilesDirectoryPath = getOutputFilesDirectoryPath();
                            _result.success(outputFilesDirectoryPath);
                        } else if (_call.method.equals("shareFileExternally")) {
                            final String filePath = _call.argument("filePath");
                            shareFileExternally(filePath);
                            _result.success(null);
                        } else {
                            _result.notImplemented();
                        }
                    }
                });
    }

    void onNewIntent(@NonNull final Intent _intent) {
        final Uri uri = _intent.getData();
        if (uri == null) {
            return;
        }
        synchronized (pendingFileOpenRequests) {
            pendingFileOpenRequests.put(UUID.randomUUID().toString() + ".vcf", uri);
        }
    }

    private String getInboxFileId() {
        synchronized (pendingFileOpenRequests) {
            final Iterator<String> ksIterator = pendingFileOpenRequests.keySet().iterator();
            if (ksIterator.hasNext()) {
                return ksIterator.next();
            } else {
                return null;
            }
        }
    }

    private void discardInboxFileId(@Nullable final String _fileId) {
        if (_fileId == null) {
            return;
        }
        synchronized (pendingFileOpenRequests) {
            pendingFileOpenRequests.remove(_fileId);
        }
    }

    private String getCopiedInboxFilePath(@Nullable final String _fileId) {
        if (_fileId == null) {
            return null;
        }
        final Uri fileUri = pendingFileOpenRequests.get(_fileId);
        if (fileUri == null) {
            return null;
        }
        try {
            final InputStream inputStream = mainActivity.getContentResolver().openInputStream(fileUri);
            final String destinationFilePath = mainActivity.getCacheDir().getAbsolutePath() + File.separator + _fileId;
            //noinspection ConstantConditions
            Utils.inputStreamToFile(inputStream, destinationFilePath);
            return destinationFilePath;
        } catch (Throwable t) {
            t.printStackTrace();
            return null;
        }
    }

    private String getOutputFilesDirectoryPath() {
        return "TODO";
    }

    private void shareFileExternally(@Nullable final String _filePath) {
        //TODO start a share intent with the file passed in parameters
    }
}
