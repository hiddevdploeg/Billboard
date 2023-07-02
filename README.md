![Header Photo@2x](https://github.com/hiddevdploeg/Billboard/assets/5016984/727e403b-9814-4eaf-902e-6daa943897ce)

# Billboard
Billboard is a module that enables the incorporation of advertisement highlights for applications created by independent developers. Its unique feature lies in its execution of ads without the use of tracking measures or unwanted cookies. This way, you can still be annoyed by advertisements without the nasty bits, and therefore you get a free "Remove Ads" selling point for your premium tier.

**These ads do NOT generate revenue or track anything**


## How to display an Ad

Billboard provides an easy way to present an ad overlay on any SwiftUI `View`. Here's a simple example:

```swift

@State private var showRandomAdvert = false

ContentView()
    .showBillboard(when: $showRandomAdvert) {
        // Replace this view with your Paywall
        Text("Your Paywall goes here")
    }

```

Alternatively, you can customize the `BillboardView` and position it in any way that suits your app. This view takes a `BillboardAd`, a `BillboardConfiguration` (Optionally), and a view that represents your paywall:

```swift

@State private var advertisement: BillboardAd? = nil
@StateObject var viewModel = BillboardViewModel()


ContentView()
    .task {
        let newAdvert = try? await viewModel.fetchRandomAd()
        advertisement = newAdvert
    }   
    .fullScreenCover(item: $advertisement) { advert in
        BillboardView(advert: advert, paywall: { Text("Paywall") })
    }

```

**TIP**: When you're running a debug version of your app you can tap on the timer to show a dismiss button right away.

![NowPlaying Copy 4@1x](https://github.com/hiddevdploeg/Billboard/assets/5016984/cbddccf6-0870-4446-9941-792151c090be)

## Configuration

Billboard let's you define some configuration to fit your needs better.

``` swift
public struct BillboardConfiguration {
    
    /// The URL pointing to the JSON in the `BillboardAdResponse` format.
    public let adsJSONURL: URL?
    
    /// Enable or disable haptics
    public let allowHaptics: Bool
    
    /// The duration of the advertisement
    public let duration: TimeInterval
    
    public init(adsJSONURL: URL? = URL(string:"https://billboard-source.vercel.app/ads.json"),
                allowHaptics: Bool = true,
                advertDuration: TimeInterval = 15.0) {
        self.adsJSONURL = adsJSONURL
        self.allowHaptics = allowHaptics
        self.duration = advertDuration
    }
}
```

This also allows you to use your own source of ads that follow the `BillboardAdResponse` format.

```swift

@State private var showRandomAdvert = false

let config = BillboardConfiguration(
    adsJSONURL: URL(string: "YOUR-OWN-SOURCE"),
    allowHaptics: false,
    advertDuration: 30.0
)

ContentView()
    .showBillboard(when: $showRandomAdvert, configuration: config) {
        // Replace this view with your Paywall
        Text("Your Paywall goes here")
    }

```


## BillboardAdResponse
Here's an example of how your source list could look like.

```json
{
  "ads" : [
    {
      "appStoreID" : "1574243765",
      "name" : "NowPlaying",
      "title": "Learn everything about any song",
      "description" : "A music companion app that lets you discover the stories behind and song, album or artist.",
      "media": "https://pub-378e0dd96b5343108a04317ebddebb4e.r2.dev/nowplaying.png",
      "backgroundColor" : "344442",
      "textColor" : "EFDED7",
      "tintColor" : "EFDED7",
      "fullscreen": false,
      "transparent": true
    }
  ]
}

```

![Ad Example@2x](https://github.com/hiddevdploeg/Billboard/assets/5016984/ac4a94b9-87b5-4a88-9fc9-bbbd62563c59)

## Ad Guidelines & Requirements
Submit your app to be featured as an Ad for everyone using the Billboard package to display Advertisements.
Each ad will be reviewed before inclusion.

**[You can submit your app here](https://forms.gle/nWV4dT3taBF62WXbA)**

### Ad Requirements
- **Apple ID of App**: The Apple ID is a 9- or 10-digit number found in your App Store URL or in App Store Connect.
- **Name of App**: The name of the app you're promoting
- **Title**: The advertisement headline (maximum 25 characters).
- **Description**: The advertisement description (maximum 140 characters).
- **Media**: The image used in your advertisement.

#### Media Guidelines
- Image should be a minimum of 800x800 in resolution.
- The image should not contain any text outside of the visual content.
- Avoid using your App Icon as the image (as it's already displayed by default).
- Provide an image with no background or has a single color (avoid gradients).
- Photos are allowed as well but will be displayed differently.

## FAQ
### Which Ads are presented when I use the default config
You'll find a list of all currently used ads in the example app.

## Special thanks to
[tundsdev](https://twitter.com/tundsdev) for CachedImage implementation

## Authors
This library is created by [Hidde van der Ploeg](https://hidde.design). Feel free to reach out on [Twitter](https://twitter.com/hiddevdploeg) or [Mastodon](https://mastodon.design/@hidde) if you have any questions or remarks.

## License
Billboard is available under the MIT license.
