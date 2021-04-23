package com.getcapacitor.plugin.privacyscreen;

import android.view.Window;
import android.view.WindowManager;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "PrivacyScreen")
public class PrivacyScreenPlugin extends Plugin {
    private PrivacyScreenConfig config;

    public void load() {
        config = getPrivacyScreenConfig();
        boolean isEnabled = config.isEnabled();
        if (isEnabled) {
            addFlags();
        }
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

    private PrivacyScreenConfig getPrivacyScreenConfig() {
        PrivacyScreenConfig config = new PrivacyScreenConfig();

        Boolean enable = getConfig().getBoolean("enable", config.isEnabled());
        config.setEnable(enable);

        return config;
    }
}
