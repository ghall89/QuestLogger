import SwiftUI

func sameColor(_ color1: Color, _ color2: Color) -> Bool {
	return color1 == color2
}

struct ColorSchemeButton: View {
	let colorScheme: String
	@AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
	var body: some View {
		Button(action: {
			preferredColorScheme = colorScheme
		}, label: {
			HStack {
				Text(LocalizedStringKey(colorScheme))
				Spacer()
				if colorScheme == preferredColorScheme {
					IconSVG(icon: "check")
				}
			}
		})
	}
}

struct ThemePickerView: View {
	@AppStorage("colorTheme") var colorTheme: String = "blue"
	@AppStorage("fabPostion") var fabPosition: String = "right"

	internal struct ColorTheme: Identifiable {
		let id: UUID = UUID()
		var title: String
		var color: Color
	}

	var colors = AccentColor.allCases.map { "\($0)" }

	var body: some View {
		Form {
			Menu(LocalizedStringKey("color_scheme")) {
				ColorSchemeButton(colorScheme: "system")
				ColorSchemeButton(colorScheme: "light")
				ColorSchemeButton(colorScheme: "dark")
			}
		}
	}
}
