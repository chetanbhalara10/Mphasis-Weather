//
//  WeatherViewModel.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    @Published var weatherData : WeatherData?
    @Published var cityNameErrorMessage: String? = ""
    
    var weatherDataRepository: WeatherDataRepository!
    var preferenceStore: PrefrenceStore!
    private var metricsManager: MetricsManager?
    
    init(weatherDataRepository: WeatherDataRepository!, preferenceStore: PrefrenceStore!, metricsManager: MetricsManager!) {
        self.weatherDataRepository = weatherDataRepository
        self.preferenceStore = preferenceStore
        self.metricsManager = metricsManager
    }
    
    func getWeatherData(city: String) {
        
        let startTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        
        do {
            weatherData = try weatherDataRepository.getWeatherData(city: city)
            cityNameErrorMessage = ""
            preferenceStore.storeLastSearch(city: city)
        } catch {
            if(error as! RequestError == RequestError.invalideCity){
                cityNameErrorMessage = "Please enter a valid US city!"
            } else {
                cityNameErrorMessage = "Please try again later!"
            }
        }
        
        let endTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        metricsManager?.emitMatrics(matricName: "ViewModel.WeatherData.Time", time: ((endTime - startTime)))
    }
    
    func getRecentCity() -> String {
        return preferenceStore.retrieveLastSearch()
    }
}
