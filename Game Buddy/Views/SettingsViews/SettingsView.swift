import SwiftUI

func savePrefAsString(key: String, value: String) {
	let defaults = UserDefaults.standard
	
	defaults.set(value, forKey: key)
}

struct SettingsView: View {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	
	var body: some View {
		VStack {
			TextField(text: $clientID, label: {
				Text("Client ID")
			})
			TextField(text: $clientSecret, label: {
				Text("Client Secret")
			})
			
			Link(destination: URL(string: "https://dev.twitch.tv/login")!, label: {
				Text("Twitch Dev Portal")
			})
			
			//			ThemePickerView()
			
			//			Button(action: {
			//				exportCollection()
			//			}, label: {
			//				Text(LocalizedStringKey("backup_collection"))
			//			})
			//							Button(action: {
			//								print("You clicked the Restore button")
			//							}, label: {
			//								HStack {
			//									IconSVG(icon: "upload").padding(.trailing, 10)
			//									Text(LocalizedStringKey("restore_collection"))
			//								}
			//							})
			//
			
			
		}
		.padding()
	}
}
