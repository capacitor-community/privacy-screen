package com.getcapacitor.plugin.privacyscreen;

import android.view.Window;
import android.view.WindowManager;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "PrivacyScreen")
public class PrivacyScreenPlugin extends Plugin {

    /**
     * Called when the plugin is first constructed in the bridge.
     * This method sets the FLAG_SECURE flag to treat the content of the window as secure,
     * preventing it from appearing in screenshots or from being viewed on non-secure displays.
     * @see <a href="https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_SECURE">Android Developers</a>
     */
    public void load() {
        addFlags();
    }

    @PluginMethod
    public void enable(final PluginCall call) {
        this.getBridge()
            .executeOnMainThread(
                new Runnable() {
                    @Override
                    public void run() {
                        addFlags();
                        call.resolve();
                    }
                }
            );
    }

    @PluginMethod
    public void disable(final PluginCall call) {
        this.getBridge()
            .executeOnMainThread(
                new Runnable() {
                    @Override
                    public void run() {
                        clearFlags();
                        call.resolve();
                    }
                }
            );
    }

    private void addFlags() {
        Window window = getActivity().getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }

    private void clearFlags() {
        Window window = getActivity().getWindow();
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
}
