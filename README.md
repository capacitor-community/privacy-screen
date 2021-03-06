<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Privacy Screen</h3>
<p align="center"><strong><code>@capacitor-community/privacy-screen</code></strong></p>
<p align="center">
Capacitor Privacy Screen Plugin
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2021?style=flat-square" />
  <a href="https://github.com/capacitor-community/privacy-screen/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/capacitor-community/privacy-screen/CI/main?style=flat-square" /></a>
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
On **iOS**, this plugin hides the webview window when the app is no longer active and loses focus ([UIApplicationWillResignActiveNotification](https://developer.apple.com/documentation/uikit/uiapplicationwillresignactivenotification)) so that a gray screen is shown instead.

## Maintainers

| Maintainer | GitHub                                    | Social                                        |
| ---------- | ----------------------------------------- | --------------------------------------------- |
| Robin Genz | [robingenz](https://github.com/robingenz) | [@robin_genz](https://twitter.com/robin_genz) |

## Installation

```
npm install @capacitor-community/privacy-screen
npx cap sync
```

On **iOS**, no further steps are needed.

On **Android**, register the plugin in your main activity:

```java
import com.getcapacitor.plugin.privacyscreen.PrivacyScreen;

public class MainActivity extends BridgeActivity {

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // Initializes the Bridge
    this.init(
        savedInstanceState,
        new ArrayList<Class<? extends Plugin>>() {
          {
            // Additional plugins you've installed go here
            // Ex: add(TotallyAwesomePlugin.class);
            add(PrivacyScreen.class);
          }
        }
      );
  }
}
```

## Configuration

No configuration required for this plugin.

## Usage

The plugin only needs to be installed.
The protection is enabled by default.
However, you have the option to enable/disable the protection:

```js
import { Plugins } from '@capacitor/core';
import '@capacitor-community/privacy-screen';

const enable = async () => {
  await Plugins.PrivacyScreen.enable();
};

const disable = async () => {
  await Plugins.PrivacyScreen.disable();
};
```

## API

<docgen-index></docgen-index>

<docgen-api>
<!-- run docgen to generate docs from the source -->
<!-- More info: https://github.com/ionic-team/capacitor-docgen -->
</docgen-api>

## Changelog

See [CHANGELOG.md](https://github.com/capacitor-community/privacy-screen/blob/main/CHANGELOG.md).

## License

See [LICENSE](https://github.com/capacitor-community/privacy-screen/blob/main/LICENSE).
