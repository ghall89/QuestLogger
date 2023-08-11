import SwiftUI

func applyColorScheme(colorScheme: String) -> ColorScheme? {

	switch colorScheme {
		case "light":
			return .light
		case "dark":
			return .dark
		default:
			return nil
	}
}

@main
struct GameBuddyApp: App {
//	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	@StateObject var observableCollection = ObservableCollection()
	@StateObject var observableGameDetails = ObservableGameDetails()

	@AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
	@AppStorage("colorTheme") var colorTheme: String = "blue"

	var body: some Scene {
		WindowGroup {
			AppNavView()
				.userAccentColor(colorTheme)
				.preferredColorScheme(applyColorScheme(colorScheme: preferredColorScheme))
				.environmentObject(observableCollection)
				.environmentObject(observableGameDetails)
				.onAppear {
					getMissingCovertArt(collection: observableCollection.collection)
				}
		}
//		.commands {
//			CommandGroup(replacing: CommandGroupPlacement.appInfo) {
//				Button(action: {
//					appDelegate.showAboutPanel()
//				}) {
//					AboutView()
//				}
//			}
//		}
		Settings {
			SettingsView()
		}
		
	}
}
