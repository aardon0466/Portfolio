package edu.floridapoly.mobiledeviceapps.mediadatabase;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.FileUtils;
import android.provider.MediaStore;
import android.provider.OpenableColumns;
import android.view.View;
import android.widget.Button;
import android.widget.CursorAdapter;
import android.widget.ImageButton;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class FilesActivity extends AppCompatActivity {

    //Bar Buttons
    private ImageButton FilesButton;
    private ImageButton SettingsButton;
    private ImageButton SearchButton;
    private ImageButton GalleryButton;
    //Other
    private ImageButton ImportButton;
    private SQLiteDBHandler db;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_files);

        //FILE SCREEN BUTTON
        FilesButton = (android.widget.ImageButton)findViewById(R.id.bar_FilesButton);
        FilesButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(FilesActivity.this, FilesActivity.class);
                startActivity(intent);

            }
        });

        //SETTINGS SCREEN BUTTON
        SettingsButton = (android.widget.ImageButton)findViewById(R.id.bar_SettingsButton);
        SettingsButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(FilesActivity.this, SettingsActivity.class);
                startActivity(intent);

            }
        });

        //SEARCH SCREEN BUTTON
        SearchButton = (android.widget.ImageButton)findViewById(R.id.bar_SearchButton);
        SearchButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(FilesActivity.this, SearchActivity.class);
                startActivity(intent);

            }
        });

        //GALLERY SCREEN BUTTON
        GalleryButton = (android.widget.ImageButton)findViewById(R.id.bar_GalleryButton);
        GalleryButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(FilesActivity.this, GalleryActivity.class);
                startActivity(intent);

            }
        });

        //IMPORT MEDIA BUTTON
        ImportButton = (android.widget.ImageButton)findViewById(R.id.importMediaButton);
        ImportButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                i.setType("*/*");
                i.setAction(Intent.ACTION_GET_CONTENT);

                launchSomeActivity.launch(i);
                //startActivityForResult(Intent.createChooser(i, "Select Image"), 101);
            }
        });
    }
    //IMPORT MEDIA
    /*

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == 101 && resultCode == RESULT_OK && data != null){
            Uri uri = data.getData();

            String path = getRealPath(this, uri);
            String name = getFileName(uri);

            try {
                insertToStorage(name, path);
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

    private void insertToStorage(String name, String path) throws IOException {
        FileOutputStream fos = openFileOutput(name, MODE_APPEND);

        File file = new File(path);

        byte[] bytes = getBytesFromFile(file);

        fos.write(bytes);
        fos.close();

        Toast.makeText(getApplicationContext(), "File saved in: " + getFilesDir() + "/" + name, Toast.LENGTH_SHORT).show();

    }

    private byte[] getBytesFromFile(File file) throws IOException {
        //compile 'org.apache.commons:commons-io:1.3.2'
        //byte[] data = FileUtils.readFileToByteArray(file);
        //byte[] data = getBytesFromFile(file);
        byte[] data = Files.readAllBytes(file.toPath());
        return data;
    }

    private String getFileName(Uri uri) {
        String result = null;
        if(uri.getScheme().equals("content")){
            Cursor cursor = getContentResolver().query(uri, null, null, null, null);
            try {
                if(cursor != null && cursor.moveToFirst()){
                    result = cursor.getString(cursor.getColumnIndexOrThrow(OpenableColumns.DISPLAY_NAME));
                }
            } finally {
                cursor.close();
            }
        }
        if (result == null) {
            result = uri.getPath();
            int cut = result.lastIndexOf('/');
            if(cut != -1) {
                result = result.substring(cut + 1);
            }
        }
        return result;
    }

    private String getRealPath(Context context, Uri uri) {
        String[] proj = {MediaStore.Images.Media.DATA};
        Cursor cursor = context.getContentResolver().query(uri, proj, null, null, null);
        if(cursor != null){
            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            return cursor.getString(column_index);
        }
        return null;
    }

     */
    ActivityResultLauncher<Intent> launchSomeActivity
            = registerForActivityResult(
            new ActivityResultContracts
                    .StartActivityForResult(),
            result -> {
                if (result.getResultCode()
                        == Activity.RESULT_OK) {
                    Intent data = result.getData();
                    // do your operation from here....
                    if (data != null
                            && data.getData() != null) {
                        Uri selectedImageUri = data.getData();
                        Bitmap selectedImageBitmap;
                        try {
                            selectedImageBitmap
                                    = MediaStore.Images.Media.getBitmap(
                                    this.getContentResolver(),
                                    selectedImageUri);

                            saveToInternalStorage(selectedImageBitmap);
                        }
                        catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });

    private String saveToInternalStorage(Bitmap bitmapImage) throws IOException {
        ContextWrapper cw = new ContextWrapper(getApplicationContext());
        //Get current date and time
        SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyy_HH:mm:ss", Locale.getDefault());
        String currentDateandTime = sdf.format(new Date());

        // path to /data/data/edu.floridapoly.mobiledeviceapps.mediadatabase/app_imageDir
        File directory = cw.getDir("imageDir", Context.MODE_PRIVATE);

        // Create imageDir
        String name = currentDateandTime + ".jpg";
        File mypath=new File(directory,name);

        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(mypath);
            // Use the compress method on the BitMap object to write image to the OutputStream
            bitmapImage.compress(Bitmap.CompressFormat.PNG, 100, fos);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // Add new image to database
        byte[] image = Files.readAllBytes(mypath.toPath());
        db.addEntry(name, image);

        return directory.getAbsolutePath();
    }



}
