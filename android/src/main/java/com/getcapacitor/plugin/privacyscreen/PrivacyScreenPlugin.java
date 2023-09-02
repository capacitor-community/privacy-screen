package com.getcapacitor.plugin.privacyscreen;

import android.view.Window;
import android.view.WindowManager;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "PrivacyScreen")
public class PrivacyScreenPlugin extends Plugin {

    private PrivacyScreen implementation;

    public void load() {
        PrivacyScreenConfig config = getPrivacyScreenConfig();
        implementation = new PrivacyScreen(this, config);
    }

    @PluginMethod
    public void enable(final PluginCall call) {
        implementation.enable(() -> call.resolve());
    }

    @PluginMethod
    public void disable(final PluginCall call) {
        implementation.disable(() -> call.resolve());
    }

    private PrivacyScreenConfig getPrivacyScreenConfig() {
        PrivacyScreenConfig config = new PrivacyScreenConfig();

        Boolean enable = getConfig().getBoolean("enable", config.isEnabled());
        config.setEnable(enable);

        return config;
    }
}
