import SwiftUI
import AppKit

struct LibraryPane: View {
	@AppStorage("showArchive") var showArchive: Bool = true
	@AppStorage("customDirectoryURL") var customDirectoryURL: URL = URL(string: "~/Documents")!
	
	var body: some View {
		VStack {
			Toggle("Show archive", isOn: $showArchive)
			Divider()
			Text(String(describing: customDirectoryURL))
				.lineLimit(1)
				.padding(6)
				.background(
					RoundedRectangle(cornerRadius: 8)
						.fill(Material.ultraThick)
				)
			HStack {
				Button("Show in Finder", action: showInFinder)
				Button("Choose...", action: chooseDirectory)
			}
			
			
		}
	}
	
	private func chooseDirectory() {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseFiles = false
		panel.canChooseDirectories = true
		if panel.runModal() == .OK {
			customDirectoryURL = panel.url!
			print(customDirectoryURL)
		}
	}
	
	private func showInFinder() {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let workspace = NSWorkspace.shared
		
		workspace.activateFileViewerSelecting([customDirectoryURL])
	}
}
