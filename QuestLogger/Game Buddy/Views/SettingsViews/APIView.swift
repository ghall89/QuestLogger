import SwiftUI

struct APIView: View {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	
	var body: some View {
		Form {
			Text("In order to use QuestLogger to access data on IGDB, you will need a Twitch developer account.")
				.fixedSize(horizontal: false, vertical: true)
			Link(destination: URL(string: "https://dev.twitch.tv/login")!, label: {
				Text("Twitch Dev Portal")
			})
			Divider()
			TextField(text: $clientID, label: {
				Text("Client ID")
			})
			TextField(text: $clientSecret, label: {
				Text("Client Secret")
			})
		}
	}
}

