import Foundation

// Formats a given `Date` instance into a string representation using the "MMM dd, yyyy" format.

// - Parameters:
// - date: The `Date` instance to be formatted into a string.

// - Returns: A string representing the formatted date in the "MMM dd, yyyy" format.

func formatDate(date: Date) -> String {
	print(date)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "MMM dd, yyyy"
	let dateString = dateFormatter.string(from: date)
	return dateString
}
