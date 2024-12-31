package com.getcapacitor.plugin.privacyscreen;

import android.view.Window;
import android.view.WindowManager;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "PrivacyScreen")
public class PrivacyScreenPlugin extends Plugin {

    private PrivacyScreen privacyScreen;

    public void load() {
        PrivacyScreenConfig config = getPrivacyScreenConfig();
        privacyScreen = new PrivacyScreen(this, config);
    }

    @PluginMethod
    public void enablePrivacyScreen(final PluginCall call) {
        privacyScreen.enablePrivacyScreen(() -> call.resolve());
    }

    @PluginMethod
    public void disablePrivacyScreen(final PluginCall call) {
        privacyScreen.disablePrivacyScreen(() -> call.resolve());
    }

    @PluginMethod
    public void enableScreenshotProtection(final PluginCall call) {
        privacyScreen.enableScreenshotProtection(() -> call.resolve());
    }

    @PluginMethod
    public void disableScreenshotProtection(final PluginCall call) {
        privacyScreen.disableScreenshotProtection(() -> call.resolve());
    }

    private PrivacyScreenConfig getPrivacyScreenConfig() {
        PrivacyScreenConfig config = new PrivacyScreenConfig();

        // Fetch and set privacy screen enabled state
        Boolean privacyScreenEnabled = getConfig().getBoolean("privacyScreenEnabled", config.isPrivacyScreenEnabled());
        config.setPrivacyScreenEnabled(privacyScreenEnabled);

        // Fetch and set screenshot protection enabled state
        Boolean screenshotProtectionEnabled = getConfig().getBoolean("screenshotProtectionEnabled", config.isScreenshotProtectionEnabled());
        config.setScreenshotProtectionEnabled(screenshotProtectionEnabled);

        return config;
    }
}
