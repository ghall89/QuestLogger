import Foundation

func formatDate(date: Date) -> String {
	print(date)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "MMM dd, yyyy"
	let dateString = dateFormatter.string(from: date)
	return dateString
}
