import { WebPlugin } from '@capacitor/core';

import type { PrivacyScreenPlugin } from './definitions';

export class PrivacyScreenWeb extends WebPlugin implements PrivacyScreenPlugin {
  async enable(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async disable(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async present(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async dismiss(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
