import SwiftUI
import QuestKit

extension Array: RawRepresentable where Element: Codable {
	public init?(rawValue: String) {
		guard let data = rawValue.data(using: .utf8),
					let result = try? JSONDecoder().decode([Element].self, from: data)
		else {
			return nil
		}
		self = result
	}
	
	public var rawValue: String {
		guard let data = try? JSONEncoder().encode(self),
					let result = String(data: data, encoding: .utf8)
		else {
			return "[]"
		}
		return result
	}
}

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
	@EnvironmentObject var observableCollection: ObservableCollection
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

