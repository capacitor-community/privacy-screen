import { registerPlugin } from '@capacitor/core';

import { PrivacyScreenPlugin } from './definitions';

const PrivacyScreen = registerPlugin<PrivacyScreenPlugin>('PrivacyScreen', {
  web: () => import('./web').then(m => new m.PrivacyScreenWeb()),
});

export * from './definitions';
export { PrivacyScreen };
