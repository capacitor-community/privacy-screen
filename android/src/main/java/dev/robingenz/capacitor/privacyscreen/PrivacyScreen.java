package dev.robingenz.capacitor.privacyscreen;

import android.view.WindowManager;
import androidx.appcompat.app.AppCompatActivity;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;

@NativePlugin
public class PrivacyScreen extends Plugin {

    /**
     * Called when the plugin is first constructed in the bridge.
     * This method sets the FLAG_SECURE flag to treat the content of the window as secure,
     * preventing it from appearing in screenshots or from being viewed on non-secure displays.
     * @see <a href="https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_SECURE">Android Developer</a>
     */
    public void load() {
        AppCompatActivity activity = getActivity();
        activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
}
