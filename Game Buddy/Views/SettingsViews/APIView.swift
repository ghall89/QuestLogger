import SwiftUI

struct APIView: View {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	
	var body: some View {
		Form {
			TextField(text: $clientID, label: {
				Text("Client ID")
			})
			TextField(text: $clientSecret, label: {
				Text("Client Secret")
			})
			
			Link(destination: URL(string: "https://dev.twitch.tv/login")!, label: {
				Text("Twitch Dev Portal")
			})
		}
	}
}

