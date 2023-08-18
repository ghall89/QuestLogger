import SwiftUI

func savePrefAsString(key: String, value: String) {
	let defaults = UserDefaults.standard
	
	defaults.set(value, forKey: key)
}

struct SettingsView: View {
	private enum Tabs: Hashable {
		case twitchAPI, appearance
	}
	
	var body: some View {
		TabView {
			APIView()
				.tabItem {
					Label("Twitch API", systemImage: "server.rack")
				}
				.tag(Tabs.twitchAPI)
			AppearanceView()
				.tabItem {
					Label("Appearance", systemImage: "paintbrush")
				}
				.tag(Tabs.appearance)
		}
		.padding(20)
		.frame(width: 375, height: 150)
	}
}
