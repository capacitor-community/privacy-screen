package com.getcapacitor.plugin.privacyscreen;

import android.view.Window;
import android.view.WindowManager;

public class PrivacyScreen {

    private final PrivacyScreenPlugin plugin;
    private final PrivacyScreenConfig config;

    public PrivacyScreen(PrivacyScreenPlugin plugin, PrivacyScreenConfig config) {
        this.plugin = plugin;
        this.config = config;

        boolean isEnabled = config.isEnabled();
        if (isEnabled) {
            addFlags();
        }
    }

    public void enable(EnableCallback callback) {
        plugin
            .getBridge()
            .executeOnMainThread(() -> {
                addFlags();
                callback.success();
            });
    }

    public void disable(DisableCallback callback) {
        plugin
            .getBridge()
            .executeOnMainThread(() -> {
                clearFlags();
                callback.success();
            });
    }

    private void addFlags() {
        Window window = plugin.getActivity().getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }

    private void clearFlags() {
        Window window = plugin.getActivity().getWindow();
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
}
