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
