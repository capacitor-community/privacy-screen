package com.getcapacitor.plugin.privacyscreen;

import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.util.Log;
import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

public class PrivacyScreen {

    private final PrivacyScreenPlugin plugin;
    private final PrivacyScreenConfig config;
    private View focusMonitorView;
    private View privacyOverlay;
    private static final String TAG = "PrivacyScreen";

    private boolean isPrivacyOverlayEnabled = false;
    private boolean isScreenshotProtectionEnabled = false;

    public PrivacyScreen(PrivacyScreenPlugin plugin, PrivacyScreenConfig config) {
        this.plugin = plugin;
        this.config = config;

        Log.d(TAG, "Initializing PrivacyScreen with current configuration settings.");

        if (config.isScreenshotProtectionEnabled()) {
            Log.d(TAG, "Screenshot protection is enabled in the configuration.");
            enableScreenshotProtection(() -> Log.d(TAG, "Screenshot protection has been enabled."));
        }

        plugin.getActivity().runOnUiThread(() -> {
            FrameLayout root = plugin.getActivity().findViewById(android.R.id.content);
            focusMonitorView = new View(plugin.getContext());
            focusMonitorView.setLayoutParams(new FrameLayout.LayoutParams(1, 1));
            focusMonitorView.setBackgroundColor(Color.TRANSPARENT);

            focusMonitorView.getViewTreeObserver().addOnWindowFocusChangeListener(hasFocus -> {
                if (!hasFocus) {
                    addPrivacyOverlay();
                    Log.d(TAG, "Window has lost focus, adding privacy overlay.");
                } else {
                    removePrivacyOverlay();
                    Log.d(TAG, "Window has gained focus, removing privacy overlay.");
                }
            });

            root.addView(focusMonitorView);
            focusMonitorView.requestFocus();
        });

        // Register lifecycle callbacks
        plugin.getActivity().getApplication().registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {

            @Override
            public void onActivityStarted(Activity activity) {
                if (activity == plugin.getActivity()) {
                    addScreenshotProtectionFlags();
                    Log.d(TAG, "Activity started, removing overlay if present.");
                }
            }

            @Override
            public void onActivityStopped(Activity activity) {
                if (activity == plugin.getActivity()) {
                    addPrivacyOverlay();
                    Log.d(TAG, "Activity stopped, adding overlay.");
                }
            }
            @Override public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            }
            @Override public void onActivitySaveInstanceState(Activity activity, Bundle outState) {}
            @Override public void onActivityResumed(Activity activity) {}
            @Override public void onActivityPaused(Activity activity) {}
            @Override public void onActivityDestroyed(Activity activity) {
                if (activity == plugin.getActivity()) {
                    plugin.getActivity().getApplication().unregisterActivityLifecycleCallbacks(this);
                }
            }
        });
    }


    public void enablePrivacyScreen(Runnable callback) {
        if (!isPrivacyOverlayEnabled) {
            plugin.getBridge().executeOnMainThread(() -> {
                addPrivacyOverlay();
                Log.d(TAG, "Privacy overlay added to the window.");
                if (callback != null) {
                    callback.run();
                }
            });
        }
    }

    public void disablePrivacyScreen(Runnable callback) {
        if (isPrivacyOverlayEnabled) {
            plugin.getBridge().executeOnMainThread(() -> {
                removePrivacyOverlay();
                Log.d(TAG, "Privacy overlay removed from the window.");
                if (callback != null) {
                    callback.run();
                }
            });
        }
    }

    public void enableScreenshotProtection(Runnable callback) {
        if (!isScreenshotProtectionEnabled) {
            plugin.getBridge().executeOnMainThread(() -> {
                addScreenshotProtectionFlags();
                Log.d(TAG, "Screenshot protection flags have been added.");
                if (callback != null) {
                    callback.run();
                }
            });
        }
    }

    public void disableScreenshotProtection(Runnable callback) {
        if (isScreenshotProtectionEnabled) {
            plugin.getBridge().executeOnMainThread(() -> {
                clearScreenshotProtectionFlags();
                Log.d(TAG, "Screenshot protection flags have been cleared.");
                if (callback != null) {
                    callback.run();
                }
            });
        }
    }

    private void addPrivacyOverlay() {
        Window window = plugin.getActivity().getWindow();
        FrameLayout root = (FrameLayout) window.getDecorView().findViewById(android.R.id.content);
        if (privacyOverlay == null) {
            privacyOverlay = new View(plugin.getContext());
            privacyOverlay.setLayoutParams(new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
            privacyOverlay.setBackgroundColor(0xFFFFFFFF);
            Log.d(TAG, "Creating new privacy overlay.");
        } else {
            // If privacyOverlay already has a parent, remove it from that parent first
            if (privacyOverlay.getParent() != null) {
                ((ViewGroup) privacyOverlay.getParent()).removeView(privacyOverlay);
            }
        }
        root.addView(privacyOverlay);
        isPrivacyOverlayEnabled = true;
        Log.d(TAG, "Privacy overlay added to the activity's root view.");
    }

    private void removePrivacyOverlay() {
        if (privacyOverlay != null) {
            if (privacyOverlay.getParent() != null) {
                // Cast the parent to ViewGroup before removing the view
                ViewGroup parent = (ViewGroup) privacyOverlay.getParent();
                parent.removeView(privacyOverlay);
                Log.d(TAG, "Privacy overlay removed from the activity's root view.");
            } else {
                Log.d(TAG, "Privacy overlay was not attached to any parent.");
            }
            privacyOverlay = null;  // Nullify the reference regardless of whether it was removed or not
            isPrivacyOverlayEnabled = false;
        } else {
            Log.d(TAG, "No privacy overlay to remove.");
        }
    }

    private void addScreenshotProtectionFlags() {

        plugin
            .getActivity()
            .getWindow()
            .setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);

        isScreenshotProtectionEnabled = true;
        Log.d(TAG, "FLAG_SECURE added to window.");
    }

    private void clearScreenshotProtectionFlags() {
        Window window = plugin.getActivity().getWindow();
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
        isScreenshotProtectionEnabled = false;
        Log.d(TAG, "FLAG_SECURE cleared from window.");
    }
}
