//
//  DependencyInjection.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import Foundation

class DependencyInjection {
    
    static func getWeatherDataRepository() -> WeatherDataRepository {
        
        let jsonDecoder = JSONDecoder()
        
        return RemoteWeatherDataRepository(jsondecoder: jsonDecoder, metricsManager: getMetricsManager())
    }
    
    static func getPreferenceStore() -> PrefrenceStore {
        return PrefrenceStore()
    }
    
    static func getMetricsManager() -> MetricsManager {
        return MetricsManager()
    }
}
