import SwiftUI
import Foundation
import QuestKit

struct ContentView: View {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	
	@EnvironmentObject var globalState: GlobalState
	@EnvironmentObject var observableCollection: CollectionViewModel
	
	@Binding var selectedCategory: String
	@State private var apiAlert: Bool = false
	
	private var selectedGameBinding: Binding<Game>? {
		guard let selectedGame = globalState.selectedGame else { return nil }
		if selectedGame.in_collection == true {
			return $observableCollection.collection.first(where: { $0.id == selectedGame.id })
		}
		if let gameIndex = observableCollection.collection.firstIndex(where: { $0.id == selectedGame.id }) {
			return $observableCollection.collection[gameIndex]
		}
		return Binding(get: { selectedGame }, set: { globalState.selectedGame = $0 })
	}
	
	var body: some View {
		NavigationSplitView(
			sidebar: {
				SidebarView(selection: $selectedCategory)
					.navigationSplitViewColumnWidth(min: 240, ideal: 270)
			}, content: {
				VStack {
					FolderView(category: $selectedCategory)
				}
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
					globalState.showAddGameSheet.toggle()
				}, label: {
					Image(systemName: "plus")
				})
				.help("Add Game")
			}
		}
		.sheet(isPresented: $globalState.showAddGameSheet, content: {
			NewGameView()
		})
		.searchable(text: $globalState.searchString, prompt: "Search Collection...")
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
