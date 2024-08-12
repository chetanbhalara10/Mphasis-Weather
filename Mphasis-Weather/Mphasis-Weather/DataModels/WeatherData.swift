//
//  WeatherData.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import Foundation

struct WeatherData: Decodable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
    var description: String
    var humidity: Int
    var visibility: Int
    var speed: Double
    var sunrise: String
    var sunset: String

    init() {
        temp = 0.0
        temp_min = 0.0
        temp_max = 0.0
        description = ""
        humidity = 0
        visibility = 0
        speed = 0.0
        sunrise = ""
        sunset = ""
    }
    
    mutating func resetData() {
        temp = 0.0
        temp_min = 0.0
        temp_max = 0.0
        description = ""
        humidity = 0
        visibility = 0
        speed = 0.0
        sunrise = ""
        sunset = ""
    }
}
