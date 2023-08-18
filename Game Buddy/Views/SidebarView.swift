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
	
	@AppStorage("customCollections") var customCollections: [Folder] = []
	
	@Binding var selection: String
	
	@State private var showNewFolder: Bool = false
	@State private var folderToEdit: UUID?
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
//				if customCollections.count >= 1 {
//					Section("Folders") {
//						ForEach(customCollections) { folder in
//							FolderLinkView(category: folder.name, icon: folder.icon, folderId: folder.id)
//								.contextMenu(menuItems: {
//									Button(action: {
//										folderToEdit = folder.id
//										showNewFolder.toggle()
//									}, label: {
//										Text(LocalizedStringKey("edit"))
//										IconSVG(icon: "pencil")
//									})
//									Button(role: .destructive, action: {
//										if let folderIndex = customCollections.firstIndex(where: { $0.id == folder.id }) {
//											customCollections.remove(at: folderIndex)
//										}
//									}, label: {
//										Text(LocalizedStringKey("delete"))
//										IconSVG(icon: "trash")
//									})
//								})
//						}
//					}
//				}
			}
			.frame(minWidth: 200)
//		.toolbar {
//			ToolbarItem(content: {
//				Button(action: {
//					showNewFolder.toggle()
//				}, label: {
//					Image(systemName: "folder.badge.plus")
//				})
//			})
//		}
//		.sheet(isPresented: $showNewFolder) {
//			NewFolderView(showNewFolder: $showNewFolder, folderId: $folderToEdit)
//		}
		.onAppear {
			platforms = Array(Set(observableCollection.collection.compactMap { $0.platform })).sorted()
		}
	}
}

