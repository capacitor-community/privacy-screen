declare module '@capacitor/core' {
  interface PluginRegistry {
    PrivacyScreen: PrivacyScreenPlugin;
  }
}

export interface PrivacyScreenPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
