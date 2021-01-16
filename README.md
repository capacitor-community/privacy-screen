# capacitor-privacy-screen

[![npm version](https://img.shields.io/npm/v/capacitor-privacy-screen)](https://www.npmjs.com/package/capacitor-privacy-screen)
[![license](https://img.shields.io/npm/l/capacitor-privacy-screen)](https://github.com/robingenz/capacitor-privacy-screen/blob/main/LICENSE)

⚡️ Capacitor plugin that protects your app from displaying a screenshot in [Recents screen](https://developer.android.com/guide/components/activities/recents)/[App Switcher](https://support.apple.com/en-us/HT202070).

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
