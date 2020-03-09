// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let prayerTimes = try? newJSONDecoder().decode(PrayerTimes.self, from: jsonData)

import Foundation

// MARK: - PrayerTimes
struct PrayerTime: Codable {
    let code: Int?
    let status: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let timings: Timings?
//    let date: DateClass?
//    let meta: Meta?
}


// MARK: - Timings
struct Timings: Codable {
    let fajr, sunrise, dhuhr: String?
    let asr: ASR?
    let sunset, maghrib, isha, imsak: String?
    let midnight: String?

    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case sunrise = "Sunrise"
        case dhuhr = "Dhuhr"
        case asr = "Asr"
        case sunset = "Sunset"
        case maghrib = "Maghrib"
        case isha = "Isha"
        case imsak = "Imsak"
        case midnight = "Midnight"
    }
}

enum ASR: String, Codable {
    case the1529Eet = "15:29 (EET)"
    case the1530Eet = "15:30 (EET)"
}
