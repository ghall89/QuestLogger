import SwiftUI
import QuestKit

struct SidebarItemView: View {
	var destination: String
	var text: String
	var icon: String
	var count: Int?
	
	var body: some View {
		NavigationLink(value: destination, label: {
			Label(LocalizedStringKey(text), systemImage: icon)
			Spacer()
			if count != nil {
				Text("\(count!)")
			}
		})
	}
}

struct SidebarView: View {
	@AppStorage("showArchive") var showArchive: Bool = true
	@EnvironmentObject var observableCollection: CollectionViewModel
	@Binding var selection: String
	
	var body: some View {
		List(selection: $selection) {
			Section("Library") {
				ForEach(Status.allCases, id: \.self.status) { status in
					if (status == .archived && showArchive == true) || status != .archived {
						SidebarItemView(destination: status.status,
														text: status.status,
														icon: status.icon,
														count: observableCollection.collection.filter { $0.status == status }.count)
					}
				}
			}
			.collapsible(false)
			
			if observableCollection.platforms.count >= 1 {
				Section("Platforms") {
					ForEach(observableCollection.platforms, id: \.self) { platform in
						SidebarItemView(destination: platform,
														text: platform,
														icon: "folder.fill",
														count: observableCollection.collection.filter { $0.platform == platform }.count)
					}
				}
			}
		}
		.frame(minWidth: 270)
	}
}

