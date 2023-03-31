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
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
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
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  /**
   * Remove all listeners for this plugin.
   *
   * @since 3.0.2
   */
  removeAllListeners(): Promise<void>;
}
