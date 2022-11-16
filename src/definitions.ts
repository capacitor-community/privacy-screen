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

      /**
       * ios specific configuration
       */
      ios?: {
        /**
         * Configure the color of the privacy screen.
         *
         * The color should be provided as a string using HEX8 code (including hash symbol).
         * If no color code is provided `UIColor.gray` will be used.
         *
         * @example "#27d17fff"
         */
        backgroundColorHex8?: string;
      }
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
