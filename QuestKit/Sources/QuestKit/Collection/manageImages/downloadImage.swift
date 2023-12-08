import Foundation
import SwiftUI

public func downloadImage(imageId: String) {
	@AppStorage("customDirectoryURL") var customDirectoryURL: URL = URL(string: "~/Documents")!

	guard let url = URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imageId).png") else {
		return
	}
	let task = URLSession.shared.dataTask(with: url) { data, _, error in
		guard let data = data, error == nil else {
			return
		}
		
		var imgDirectory = customDirectoryURL
		imgDirectory.append(path: "Library.quest/img")
		
		do {
			try FileManager.default.createDirectory(at: imgDirectory, withIntermediateDirectories: true, attributes: nil)
		} catch {
			print(error)
		}
		let fileURL = imgDirectory.appendingPathComponent("\(imageId).png")
		do {
			try data.write(to: fileURL)
		} catch {
			print(error)
		}
	}
	task.resume()

}
