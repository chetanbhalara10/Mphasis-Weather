//
//  WeatherDataRepository.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import Foundation

protocol WeatherDataRepository {
    func getWeatherData(city: String) throws -> WeatherData
}
