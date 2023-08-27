import SwiftUI
import QuestKit

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
	@Environment(\.openWindow) private var openWindow
	@StateObject var observableCollection = ObservableCollection()
	@StateObject var observableGameDetails = ObservableGameDetails()
	@AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
	@AppStorage("selectedCategory") var selectedCategory: String = "backlog"
	
	@State var showAboutView: Bool = false

	var body: some Scene {
		WindowGroup {
			ContentView(selectedCategory: $selectedCategory)
				.environmentObject(observableCollection)
				.environmentObject(observableGameDetails)
				.onAppear {
					getMissingCovertArt(collection: observableCollection.collection)
					NSWindow.allowsAutomaticWindowTabbing = false
				}
				.preferredColorScheme(applyColorScheme(colorScheme: preferredColorScheme))
				.sheet(isPresented: $showAboutView, content: {
					AboutView(showAboutView: $showAboutView)
				})
		}
		.commands {
			MenuBarView(showAboutView: $showAboutView, selectedCategory: $selectedCategory)
		}
		
		Settings {
			SettingsView()
				.preferredColorScheme(applyColorScheme(colorScheme: preferredColorScheme))
		}
	}
}
