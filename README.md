# Billboard
Billboard is a module that enables the incorporation of advertisement highlights for applications created by independent developers. Its unique feature lies in its execution of ads without the use of tracking measures or unwanted cookies. This way you can still have the annoyance of advertisements without the nasty bits and therefor you get a free "Remove Ads" selling point for your premium tier.  


## How to display an Ad

Billboard provides an easy way to present an ad overlay on any SwiftUI `View`. Here's a simple example:

```swift

@State private var showRandomAdvert = false

ContentView()
    .showAdvertOverlay(when: $showRandomAdvert) {
        // Replace this view with your Paywall
        Text("Your Paywall goes here")
    }

```

Alternatively, you can customize the `AdvertisementView` and position it in any way that suits your app. This view takes a `BillboardAd`, a `BillboardConfiguration` (Optionally), and a view that represents your paywall:

```swift

@State private var advertisement: BillboardAd? = nil
@StateObject var viewModel = BillboardViewModel()

let config = BillboardConfiguration(
    adsJSONURL: URL(string: "YOUR-OWN-SOURCE"),
    allowHaptics: "roadmaptest",
    advertDuration: 30.0
)

ContentView()
    .task {
        let newAdvert = try? await viewModel.fetchRandomAd()
        advertisement = newAdvert
    }   
    .sheet(item: advertisement) { advert in
        AdvertisementView(advert: advert, config: config, paywall: { paywall() })
    }

```



## Ad Guidelines & Requirements
You're welcome to submit your app to be part of this package. Each ad will be reviewed before inclusion.

**[You can submit your app here](https://forms.gle/nWV4dT3taBF62WXbA)**

### App Requirements
- **Apple ID of App**: The Apple ID is a 9- or 10-digit number found in your App Store URL or in App Store Connect.
- **Name of App**: The name of the app you're promoting
- **Title**: The headline of the advertisement (maximum 25 characters).
- **Description**: The description of the advertisement (maximum 140 characters).
- **Media**: The image used in your advertisement.


**Media Guidelines**
- Image should be a minimum of 800x800 in resolution.
- The image should not contain any text outside of the visual content.
- Avoid using your App Icon as the image (as it's already displayed by default).



## Special thanks to
[tundsdev](https://twitter.com/tundsdev) for CachedImage implementation

## Authors
This library is created by [Hidde van der Ploeg](https://hidde.design) feel free to reach out on [Twitter](https://twitter.com/hiddevdploeg) or [Mastodon](https://mastodon.design/@hidde) if you have any questions or remarks.

## License
Billboard is available under the MIT license.
