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
			CommandGroup(replacing: CommandGroupPlacement.appInfo) {
				Button("About QuestLogger") {
					showAboutView.toggle()
				}
			}
			CommandGroup(replacing: CommandGroupPlacement.newItem) {
				Button("Search", action: {
					// set search box as focus
				})
				.keyboardShortcut(KeyboardShortcut(KeyEquivalent("F")))
			}
			CommandGroup(replacing: CommandGroupPlacement.sidebar, addition: {
				ForEach(Array(Category.allCases.enumerated()), id: \.element.status) { index, category in
					Button(LocalizedStringKey(category.status), action: {
						selectedCategory = category.status
					})
					.tag(index)
					.keyboardShortcut(KeyboardShortcut(KeyEquivalent(Character(String(index + 1)))))
				}
				Divider()
			})
			CommandGroup(replacing: CommandGroupPlacement.help, addition: {
				Link("Report an Issue", destination: URL(string:"https://github.com/ghall89/questlogger-mac/issues")!)
			})
		}
		
		Settings {
			SettingsView()
				.preferredColorScheme(applyColorScheme(colorScheme: preferredColorScheme))
		}
	}
}
