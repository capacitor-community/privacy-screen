/// <reference types="@capacitor/cli" />

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
}
