import SwiftUI
import Foundation
import QuestKit

struct ContentView: View {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	@EnvironmentObject var observableGameDetails: SelectedGameViewModel
	@EnvironmentObject var observableCollection: CollectionViewModel
	
	@Binding var selectedCategory: String
	@State private var searchString: String = ""
	@State private var apiAlert: Bool = false
	@State private var newGameSheet: Bool = false
	
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
		NavigationSplitView(
			sidebar: {
				SidebarView(selection: $selectedCategory)
					.navigationSplitViewColumnWidth(min: 240, ideal: 270)
			}, content: {
					FolderView(category: $selectedCategory, searchString: $searchString)
					.navigationSplitViewColumnWidth(ideal: 600)
			}, detail: {
				VStack {
					if let selectedGame = selectedGameBinding {
						GameDetailView(selectedGame: selectedGame).environmentObject(observableCollection)
					} else {
						Text("No Game Selected")
							.font(.title)
					}
				}
				.navigationSplitViewColumnWidth(min: 400, ideal: 400, max: 480)
			})
		.frame(minHeight: 800)
		.toolbar {
			ToolbarItem {
				Button(action: {
					newGameSheet.toggle()
				}, label: {
					Image(systemName: "plus")
				})
			}
		}
		.sheet(isPresented: $newGameSheet, content: {
			NewGameView(showSheet: $newGameSheet)
		})
		.searchable(text: $searchString, prompt: "Search Collection...")
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
