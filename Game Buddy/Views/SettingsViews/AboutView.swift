import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
	private var aboutBoxWindowController: NSWindowController?
	
	func showAboutPanel() {
		if aboutBoxWindowController == nil {
			let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable,/* .resizable,*/ .titled]
			let window = NSWindow()
			window.styleMask = styleMask
			window.contentView = NSHostingView(rootView: AboutView())
			aboutBoxWindowController = NSWindowController(window: window)
		}
		
		aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
	}
}

struct AboutView: View {

	var body: some View {
		VStack {
			
//				Image(uiImage: UIImage(named: Bundle.main.infoDictionary?["CFBundleIconFile"] as? String ?? "AppIcon") ?? UIImage())
//					.resizable()
//					.frame(width: 100, height: 100)
//					.clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
//					.prettyShadow(.normal)
//					.padding()
				Text(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
				Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")


			Section(LocalizedStringKey("open_source_credits")) {
				Link(destination: URL(string: "https://github.com/JWAutumn/ACarousel")!, label: {
					Text("ACarousel")
				})
				Link(destination: URL(string: "https://github.com/Alamofire/Alamofire")!, label: {
					Text("Alamofire")
				})
				Link(destination: URL(string: "https://github.com/lorenzofiamingo/swiftui-cached-async-image")!, label: {
					Text("CachedAsyncImage")
				})
				Link(destination: URL(string: "https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators")!, label: {
					Text("SwiftfulLoadingIndicators")
				})
				Link(destination: URL(string: "https://github.com/globulus/swiftui-shake-gesture/")!, label: {
					Text("SwiftUIShakeGesture")
				})
			}
		}
		.frame(width: 200, height: 300)
		.navigationTitle("About QuestLogger")
	}
}
