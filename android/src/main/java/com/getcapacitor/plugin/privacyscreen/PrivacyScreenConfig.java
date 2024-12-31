package com.getcapacitor.plugin.privacyscreen;

public class PrivacyScreenConfig {

    private boolean privacyScreenEnabled = true;
    private boolean screenshotProtectionEnabled = true;

    public boolean isPrivacyScreenEnabled() {
        return privacyScreenEnabled;
    }

    public void setPrivacyScreenEnabled(boolean privacyScreenEnabled) {
        this.privacyScreenEnabled = privacyScreenEnabled;
    }

    public boolean isScreenshotProtectionEnabled() {
        return screenshotProtectionEnabled;
    }

    public void setScreenshotProtectionEnabled(boolean screenshotProtectionEnabled) {
        this.screenshotProtectionEnabled = screenshotProtectionEnabled;
    }
}
