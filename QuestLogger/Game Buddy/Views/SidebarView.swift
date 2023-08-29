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

struct SidebarView: View {
	@AppStorage("showArchive") var showArchive: Bool = true
	@EnvironmentObject var observableCollection: ObservableCollection
	@Binding var selection: String
	
	var body: some View {
		List(selection: $selection) {
			Section("Library") {
				ForEach(Status.allCases, id: \.self.status) { category in
					if (category == .archived && showArchive == true) || category != .archived {
						NavigationLink(value: category.status, label: {
							Label(LocalizedStringKey(category.status), systemImage: category.icon)
						})
					}
				}
			}
			.collapsible(false)
			
			if observableCollection.platforms.count >= 1 {
				Section("Platforms") {
					ForEach(observableCollection.platforms, id: \.self) { platform in
						NavigationLink(value: platform, label: {
							Label(platform, systemImage: "folder.fill")
						})
					}
				}
			}
		}
		.frame(minWidth: 200)
	}
}

