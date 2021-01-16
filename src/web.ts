import { WebPlugin } from '@capacitor/core';
import { PrivacyScreenPlugin } from './definitions';

export class PrivacyScreenWeb extends WebPlugin implements PrivacyScreenPlugin {
  constructor() {
    super({
      name: 'PrivacyScreen',
      platforms: ['web'],
    });
  }
}

const PrivacyScreen = new PrivacyScreenWeb();

export { PrivacyScreen };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(PrivacyScreen);
