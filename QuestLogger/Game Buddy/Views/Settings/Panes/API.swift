import SwiftUI

struct APIPane: View {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	
	var body: some View {
		VStack {
			Text("In order to use QuestLogger to access data on IGDB, you will need a Twitch developer account.")
				.fixedSize(horizontal: false, vertical: true)
				.multilineTextAlignment(.center)
			Link(destination: URL(string: "https://dev.twitch.tv/login")!, label: {
				Text("Twitch Dev Portal")
			})
			Divider()
			Form {
				TextField("Client ID:", text: $clientID)
				TextField("Client Secret:", text: $clientSecret)
			}
		}
	}
}

