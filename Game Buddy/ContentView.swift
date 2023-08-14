import SwiftUI

struct ContentView: View {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	@EnvironmentObject var observableGameDetails: ObservableGameDetails
	@EnvironmentObject var observableCollection: ObservableCollection

	@State private var apiAlert: Bool = false
	
	private var selectedGameBinding: Binding<Game>? {
		guard let selectedGame = observableGameDetails.selectedGame else { return nil }
		if selectedGame.in_collection == true {
			return $observableCollection.collection.first(where: { $0.id == selectedGame.id })
		}
		if let gameIndex = observableCollection.collection.firstIndex(where: { $0.id == selectedGame.id }) {
			return $observableCollection.collection[gameIndex]
		}
		return Binding(get: { selectedGame }, set: { observableGameDetails.selectedGame = $0 })
	}

	var body: some View {
		NavigationView {
			SidebarView()
		}
		.sheet(isPresented: $observableGameDetails.detailSliderOpen) {
			if let selectedGame = selectedGameBinding {
				GameDetailView(selectedGame: selectedGame).environmentObject(observableCollection)
			}
		}
		.alert("Missing API Keys", isPresented: $apiAlert, actions: {
			Button("Settings", action: {
				NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
			})
			Button("Cancel", action: {
				apiAlert.toggle()
			})
		}, message: {
			Text("Using this app's full functionality requires a valid Client ID and Client Secret from a Twitch developer account. You can add these or get more info in Settings.")
		})
		.onAppear {
			if clientID == "" || clientSecret == "" {
				apiAlert.toggle()
			}
		}
	}
}
