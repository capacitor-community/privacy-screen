# capacitor-privacy-screen

[![npm version](https://img.shields.io/npm/v/capacitor-privacy-screen)](https://www.npmjs.com/package/capacitor-privacy-screen)
[![license](https://img.shields.io/npm/l/capacitor-privacy-screen)](https://github.com/robingenz/capacitor-privacy-screen/blob/main/LICENSE)

⚡️ [Capacitor](https://capacitorjs.com/) plugin that protects your app from displaying a screenshot in [Recents screen](https://developer.android.com/guide/components/activities/recents)/[App Switcher](https://support.apple.com/en-us/HT202070).  

On **Android** this plugin sets the [FLAG_SECURE](https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_SECURE) flag to treat the content of the window as secure, preventing it from appearing in screenshots or from being viewed on non-secure displays.  
On **iOS** this plugin hides the webview window when the app is no longer active and loses focus ([UIApplicationWillResignActiveNotification](https://developer.apple.com/documentation/uikit/uiapplicationwillresignactivenotification)) so that a black screen is shown instead.

## Installation

```
npm install capacitor-privacy-screen
npx cap sync
```

On **iOS**, no further steps are needed.

On **Android**, register the plugin in your main activity:

```java
import dev.robingenz.capacitor.privacyscreen.PrivacyScreen;

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

## Changelog

See [CHANGELOG.md](https://github.com/robingenz/capacitor-privacy-screen/blob/main/CHANGELOG.md).

## License

See [LICENSE](https://github.com/robingenz/capacitor-privacy-screen/blob/main/LICENSE).