export interface PrivacyScreenPlugin {
  /**
   * Supported platform(s): Android, iOS
   * Enables the privacy screen protection.
   */
  enable(): Promise<void>;
  /**
   * Supported platform(s): Android, iOS
   * Disables the privacy screen protection.
   */
  disable(): Promise<void>;
}
