import Foundation
import CoreTelephony

func formatDate(date: Date) -> String {
	print(date)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "MMM dd, yyyy"
	let dateString = dateFormatter.string(from: date)
	return dateString
}


func checkConnectivity() -> Bool {
//	let networkInfo = CTTelephonyNetworkInfo()
//	let currentRadioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology
//	if currentRadioAccessTechnology == nil {
//		// Airplane mode is on or cellular data is turned off
//		return false
//	} else if currentRadioAccessTechnology?.count == 0 {
//		// Wi-Fi is turned off
//		return false
//	} else {
//		// Wi-Fi or cellular data is turned on
		return true
//	}
}
