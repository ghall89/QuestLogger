import SwiftUI


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
	@EnvironmentObject var observableCollection: ObservableCollection
	@Binding var selection: String
	@State private var platforms: [String] = []
	
	var body: some View {
		List(selection: $selection) {
			Section("Library") {
				ForEach(Category.allCases, id: \.self.status) { category in
					NavigationLink(value: category.status, label: {
						Label(LocalizedStringKey(category.status), systemImage: category.icon)
					})
				}
			}
			.collapsible(false)
			
			if platforms.count >= 1 {
				Section("Platforms") {
					ForEach(platforms, id: \.self) { platform in
						NavigationLink(value: platform, label: {
							Label(platform, systemImage: "folder.fill")
						})
					}
				}
			}
		}
		.frame(minWidth: 200)
		.onAppear {
			platforms = Array(Set(observableCollection.collection.compactMap { $0.platform })).sorted()
		}
	}
}

