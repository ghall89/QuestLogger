import SwiftUI

@main
struct GameBuddyApp: App {
	@Environment(\.openWindow) private var openWindow
	@StateObject var observableCollection = ObservableCollection()
	@StateObject var observableGameDetails = ObservableGameDetails()
	@AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
	@AppStorage("colorTheme") var colorTheme: String = "blue"

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(observableCollection)
				.environmentObject(observableGameDetails)
				.onAppear {
					getMissingCovertArt(collection: observableCollection.collection)
					NSWindow.allowsAutomaticWindowTabbing = false
				}
		}
		.commands {
			CommandGroup(replacing: CommandGroupPlacement.appInfo) {
				Button("About QuestLogger") {
					openWindow(id: "about-window")
				}
			}
			CommandGroup(replacing: CommandGroupPlacement.newItem) {
				Button("Search", action: {
					// set search box as focus
				})
				.keyboardShortcut(KeyboardShortcut(KeyEquivalent("F")))
			}
		}
		Settings {
			SettingsView()
		}
		
		WindowGroup(id: "about-window") {
			AboutView()
		}
		.windowResizability(.contentSize)
		.windowStyle(.hiddenTitleBar)
	}
}
