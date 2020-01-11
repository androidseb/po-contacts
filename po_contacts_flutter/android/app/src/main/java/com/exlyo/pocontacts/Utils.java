package com.exlyo.pocontacts;

import java.io.FileOutputStream;
import java.io.InputStream;

public class Utils {
    public static void inputStreamToFile(final InputStream _inputStream, final String _destLocalFilePath) throws Throwable {
        final FileOutputStream fos = new FileOutputStream(_destLocalFilePath);
        final byte[] buffer = new byte[2048];
        int read = _inputStream.read(buffer);
        while (read != -1) {
            fos.write(buffer, 0, read);
            read = _inputStream.read(buffer);
        }
    }
}
