import SwiftUI
@main
struct ViceCityCountdownApp: App {
  var body: some Scene {
    WindowGroup { CountdownView().preferredColorScheme(.dark) }
  }
}
