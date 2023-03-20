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

export interface CapturingResult {
  /**
   * Returns the state of capturing
   * Only available on iOS.
   * @since 1.0.0
   */
  capturing: boolean;
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
   * Present the privacy screen protection.
   *
   * Only available for iOS.
   *
   * @since 3.0.2
   */
  present(): Promise<void>;

  /**
   * Dismiss the privacy screen protection.
   *
   * Only available for iOS.
   *
   * @since 3.0.2
   */
  dismiss(): Promise<void>;

  /**
   * Listen for screen captures.
   *
   * Only available on iOS.
   *
   * @since 3.0.2
   */
  addListener(
    eventName: 'capturingDetected',
    listenerFunc: (result: CapturingResult) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Remove all listeners for this plugin.
   *
   * @since 3.0.2
   */
  removeAllListeners(): Promise<void>;
}
