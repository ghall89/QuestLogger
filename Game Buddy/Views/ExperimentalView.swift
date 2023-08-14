import SwiftUI

struct ExperimentalView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	
	@State private var sortOrder = [KeyPathComparator(\Game.name)]
	@State private var selectedGame: Game.ID? = nil
	
	@State private var selection1: String = "item_one"
	@State private var selection2: String = "item_one"
	
	var body: some View {
		VStack {
			Menu("Test", content: {
				Picker("Picker1", selection: $selection1, content: {
					Text("Item 1").tag("item_one")
					Text("Item 2").tag("item_two")
					Text("Item 3").tag("item_three")
				})
				Picker("Picker2", selection: $selection2, content: {
					Text("Item 1").tag("item_one")
					Text("Item 2").tag("item_two")
					Text("Item 3").tag("item_three")
				})
			})
			Table(observableCollection.collection, selection: $selectedGame, sortOrder: $sortOrder) {
				TableColumn("Title", value: \.name)
				TableColumn("Status") { item in
					Text(item.status?.rawValue ?? "")
				}
				TableColumn("Platform") { item in
					Text(item.platform ?? "")
				}
				TableColumn("Updated") { item in
					Text(formatDate(date: item.status_date ?? Date()))
				}
				TableColumn("Release Date") { item in
					Text(formatDate(date: item.first_release_date ?? Date()))
				}
			}
			.onChange(of: sortOrder) {
				observableCollection.collection.sort(using: $0)
			}
		}
	}
}

