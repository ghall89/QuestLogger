import Foundation

var igdbGameSummaryFields: String = "name,cover.image_id,screenshots.image_id,first_release_date"

var igdbGameDetailFields: String = "platforms.*,platforms.platform_logo.image_id,summary,genres.name,similar_games"

var igdbGameWhere: [String] = [
	"where cover != null",
	"screenshots != null",
	"first_release_date != null",
	"platforms != null",
	"platforms.abbreviation != null",
	"(category = 0 | category = 8 | category = 9 | category = 4 | category = 2)",
	"keywords != [24124,1617,1787,2004,1147,3384]"
]

var igdbGameLimit: Int = 24

