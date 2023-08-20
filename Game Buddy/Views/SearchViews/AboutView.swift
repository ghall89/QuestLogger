import SwiftUI

struct AboutView: View {

	var body: some View {
		VStack {
			HStack {
				VStack {
					Image(nsImage: NSImage(named: Bundle.main.infoDictionary?["CFBundleIconFile"] as? String ?? "AppIcon") ?? NSImage())
						.resizable()
						.frame(width: 80, height: 80)
					Text(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
					Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
					Link(destination: URL(string: "https://github.com/ghall89/questlogger-mac")!, label: {
						Text("GitHub")
					})
				}
				.frame(width: 120)
				VStack {
					Section(LocalizedStringKey("open_source_credits")) {
						Link(destination: URL(string: "https://github.com/Alamofire/Alamofire")!, label: {
							Text("Alamofire")
						})
						Link(destination: URL(string: "https://github.com/lorenzofiamingo/swiftui-cached-async-image")!, label: {
							Text("CachedAsyncImage")
						})
						Link(destination: URL(string: "https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators")!, label: {
							Text("SwiftfulLoadingIndicators")
						})
					}
				}
				.frame(width: 240)
			}
			.padding()
			Text("Made with ❤️ in RI")
				.padding()
		}
		.frame(height: 220)
		.padding()
	}
}
