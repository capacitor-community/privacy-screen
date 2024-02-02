<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Privacy Screen</h3>
<p align="center"><strong><code>@capacitor-community/privacy-screen</code></strong></p>
<p align="center">
Capacitor Privacy Screen Plugin
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2024?style=flat-square" />
  <a href="https://github.com/capacitor-community/privacy-screen/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/actions/workflow/status/capacitor-community/privacy-screen/ci.yml?branch=main&style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/privacy-screen"><img src="https://img.shields.io/npm/l/@capacitor-community/privacy-screen?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/privacy-screen"><img src="https://img.shields.io/npm/dw/@capacitor-community/privacy-screen?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/privacy-screen"><img src="https://img.shields.io/npm/v/@capacitor-community/privacy-screen?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-0-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Introduction

⚡️ [Capacitor](https://capacitorjs.com/) plugin that protects your app from displaying a screenshot in [Recents screen](https://developer.android.com/guide/components/activities/recents)/[App Switcher](https://support.apple.com/en-us/HT202070).

On **Android**, this plugin sets the [FLAG_SECURE](https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_SECURE) flag to treat the content of the window as secure, preventing it from appearing in screenshots or from being viewed on non-secure displays.  
On **iOS**, this plugin hides the webview window when the app is no longer active and loses focus ([UIApplicationWillResignActiveNotification](https://developer.apple.com/documentation/uikit/uiapplicationwillresignactivenotification)) so that a gray screen is shown instead. It also prevents screenshots (a black screen will be captured).

### Using the Camera Plugin

Disabling screenshots can interfere with plugins that hide the WebView like the Camera plugin. To avoid issues call `disable` before using a plugin and then `enable` after you are finished.

## Maintainers

| Maintainer | GitHub                                    | Social                                        |
| ---------- | ----------------------------------------- | --------------------------------------------- |
| Robin Genz | [robingenz](https://github.com/robingenz) | [@robin_genz](https://twitter.com/robin_genz) |

## Installation

```
npm install @capacitor-community/privacy-screen
npx cap sync
```

## Configuration

<docgen-config>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

These configuration values are available:

| Prop            | Type                 | Description                                                                                                                                                 | Default           |
| --------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| **`enable`**    | <code>boolean</code> | Configure whether the plugin should be enabled from startup. Only available for Android and iOS.                                                            | <code>true</code> |
| **`imageName`** | <code>string</code>  | Configure whether the plugin should display a custom image from assets instead of a default background gray for the privacy screen. Only available for iOS. | <code>""</code>   |

### Examples

In `capacitor.config.json`:

```json
{
  "plugins": {
    "PrivacyScreen": {
      "enable": true,
      "imageName": "Splashscreen"
    }
  }
}
```

In `capacitor.config.ts`:

```ts
/// <reference types="@capacitor/privacy-screen" />

import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  plugins: {
    PrivacyScreen: {
      enable: true,
      imageName: "Splashscreen",
    },
  },
};

export default config;
```

</docgen-config>

## Demo

A working example can be found here: [robingenz/capacitor-plugin-demo](https://github.com/robingenz/capacitor-plugin-demo)

## Usage

The plugin only needs to be installed. The protection is enabled by default.  
However, you have the option to enable/disable the protection:

```js
import { PrivacyScreen } from '@capacitor-community/privacy-screen';

const enable = async () => {
  await PrivacyScreen.enable();
};

const disable = async () => {
  await PrivacyScreen.disable();
};
```

## API

<docgen-index>

* [`enable()`](#enable)
* [`disable()`](#disable)
* [`addListener('screenRecordingStarted', ...)`](#addlistenerscreenrecordingstarted)
* [`addListener('screenRecordingStopped', ...)`](#addlistenerscreenrecordingstopped)
* [`addListener('screenshotTaken', ...)`](#addlistenerscreenshottaken)
* [`removeAllListeners()`](#removealllisteners)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### enable()

```typescript
enable() => Promise<void>
```

Enables the privacy screen protection.

Only available for Android and iOS.

**Since:** 1.1.0

--------------------


### disable()

```typescript
disable() => Promise<void>
```

Disables the privacy screen protection.

Only available for Android and iOS.

**Since:** 1.1.0

--------------------


### addListener('screenRecordingStarted', ...)

```typescript
addListener(eventName: 'screenRecordingStarted', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Called when the screen recording is started.

Only available on iOS for now.

| Param              | Type                                  |
| ------------------ | ------------------------------------- |
| **`eventName`**    | <code>'screenRecordingStarted'</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>            |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

**Since:** 3.0.2

--------------------


### addListener('screenRecordingStopped', ...)

```typescript
addListener(eventName: 'screenRecordingStopped', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Called when the screen recording is stopped.

Only available on iOS for now.

| Param              | Type                                  |
| ------------------ | ------------------------------------- |
| **`eventName`**    | <code>'screenRecordingStopped'</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>            |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

**Since:** 3.0.2

--------------------


### addListener('screenshotTaken', ...)

```typescript
addListener(eventName: 'screenshotTaken', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Called when the screenshot is taken.

Only available on iOS for now.

| Param              | Type                           |
| ------------------ | ------------------------------ |
| **`eventName`**    | <code>'screenshotTaken'</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>     |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

**Since:** 3.2.0

--------------------


### removeAllListeners()

```typescript
removeAllListeners() => Promise<void>
```

Remove all listeners for this plugin.

**Since:** 3.0.2

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |

</docgen-api>

## Changelog

See [CHANGELOG.md](https://github.com/capacitor-community/privacy-screen/blob/main/CHANGELOG.md).

## License

See [LICENSE](https://github.com/capacitor-community/privacy-screen/blob/main/LICENSE).
