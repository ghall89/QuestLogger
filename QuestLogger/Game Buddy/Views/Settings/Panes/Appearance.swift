import SwiftUI

func sameColor(_ color1: Color, _ color2: Color) -> Bool {
	return color1 == color2
}

struct AppearancePane: View {
	@AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
	@AppStorage("showTitleInGridView") var showTitleInGridView: Bool = false
	
	internal struct ColorTheme: Identifiable {
		let id: UUID = UUID()
		var title: String
		var color: Color
	}
	
	var body: some View {
		VStack {
			Toggle("Show Game Titles in Grid View", isOn: $showTitleInGridView)
			Picker(selection: $preferredColorScheme, content: {
				Text("System").tag("system")
				Text("Light").tag("light")
				Text("Dark").tag("dark")
			}, label: {
				Text("Light/Dark Mode:")
			})
		}
	}
}
