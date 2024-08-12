/// <reference types="@capacitor/cli" />

import type { PluginListenerHandle } from '@capacitor/core';

declare module '@capacitor/cli' {
  export interface PluginsConfig {
    /**
     * These configuration values are available:
     */
    PrivacyScreen?: {
      /**
       * Configure whether the plugin should be enabled from startup.
       *
       * Only available for Android and iOS.
       *
       * @default true
       * @example true
       */
      enable?: boolean;
      /**
       * Configure whether the plugin should display a custom image from assets instead of a default background gray for the privacy screen.
       *
       * Only available for iOS.
       *
       * @default ""
       * @example "Splashscreen"
       */
      imageName?: string;
      /**
       * Configure the content mode of displayed image.
       *
       * Only available for iOS.
       *
       * @default "center"
       * @example "scaleAspectFit"
       * @see https://developer.apple.com/documentation/uikit/uiview/1622619-contentmode
       */
      contentMode?:
        | 'center'
        | 'scaleToFill'
        | 'scaleAspectFit'
        | 'scaleAspectFill';
      /**
       * Configure whether the plugin should disable/enable the possibility of taking screenshots.
       *
       * Only available for iOS.
       *
       * @default true
       * @example true
       * @since 5.2.0
       */
      preventScreenshots?: boolean;
    };
  }
}

export interface PrivacyScreenPlugin {
  /**
   * Enables the privacy screen protection.
   *
   * Only available for Android and iOS.
   *
   * @since 1.1.0
   */
  enable(): Promise<void>;
  /**
   * Disables the privacy screen protection.
   *
   * Only available for Android and iOS.
   *
   * @since 1.1.0
   */
  disable(): Promise<void>;
  /**
   * Called when the screen recording is started.
   *
   * Only available on iOS for now.
   *
   * @since 3.0.2
   */
  addListener(
    eventName: 'screenRecordingStarted',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle>;
  /**
   * Called when the screen recording is stopped.
   *
   * Only available on iOS for now.
   *
   * @since 3.0.2
   */
  addListener(
    eventName: 'screenRecordingStopped',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle>;
  /**
   * Called when the screenshot is taken.
   *
   * Only available on iOS for now.
   *
   * @since 3.2.0
   */
  addListener(
    eventName: 'screenshotTaken',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle>;
  /**
   * Remove all listeners for this plugin.
   *
   * @since 3.0.2
   */
  removeAllListeners(): Promise<void>;
}
