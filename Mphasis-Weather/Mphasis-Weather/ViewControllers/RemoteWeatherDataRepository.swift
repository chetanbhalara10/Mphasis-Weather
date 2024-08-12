//
//  RemoteWeatherDataRepository.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import Foundation

enum RequestError: Error {
    case invalideCity
}

class RemoteWeatherDataRepository: WeatherDataRepository {
    
    //We can store this API Key in keychain for security pupose
    let apiKey = "130e252e4c3b8eb8dbac6529f3585a95"
    var responseData: Data?
    private var jsonDecoder: JSONDecoder?
    private var metricsManager: MetricsManager?
        
    init(jsondecoder: JSONDecoder!, metricsManager: MetricsManager!) {
        jsonDecoder = jsondecoder
        self.metricsManager = metricsManager
    }
    
    func getWeatherData(city: String) throws -> WeatherData {
        
        let startTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        
        var weatherData: WeatherData? = WeatherData()
        
        guard try validateCity(cityName: city) else {
            throw RequestError.invalideCity
        }
        
        try getWeatherDetailsByCity(cityName: city, weatherData: &weatherData!)
        
        let endTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        metricsManager?.emitMatrics(matricName: "WeatherData.Time", time: ((endTime - startTime)))
        
        return weatherData!
    }
    
    private func callAPI(apiURL: String) {
        
        let encodedURL = apiURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let semaphore = DispatchSemaphore(value: 0) //1. create a counting semaphore
        
        guard let url = URL(string: encodedURL) else{
            print("Error in URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let data = data{
                self.responseData = data
                semaphore.signal() //3. count it up
            }
        }
        
        task.resume()
        
        semaphore.wait()  //2. wait for finished counting
    }
    
    private func getWeatherDetailsByCity(cityName : String, weatherData: inout WeatherData) throws {
        
        let startTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        
        let apiURL = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)"
        
        callAPI(apiURL: apiURL)
        
        do {
            let responseModel = try jsonDecoder!.decode(WeatherAPIResponse.self, from: responseData!)
            
            weatherData.temp = responseModel.main?.temp ?? 0.0
            weatherData.temp_min = responseModel.main?.temp_min ?? 0.0
            weatherData.temp_max = responseModel.main?.temp_max ?? 0.0
            
            weatherData.description = ""
            if responseModel.weather?[0] != nil {
                weatherData.description = responseModel.weather?[0].description ?? ""
            }
            
            weatherData.humidity = responseModel.main?.humidity ?? 0
            weatherData.visibility = responseModel.visibility ?? 0
            weatherData.speed = responseModel.wind?.speed ?? 0.0
            
            var timeResult = Double(responseModel.sys?.sunrise ?? Int(0.0))
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            if timeResult != 0.0 {
                dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                dateFormatter.timeZone = .current
                weatherData.sunrise = dateFormatter.string(from: date)
            }
            
            timeResult = Double(responseModel.sys?.sunset ?? Int(0.0))
            if timeResult != 0.0 {
                dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                dateFormatter.timeZone = .current
                weatherData.sunset = dateFormatter.string(from: date)
            }
            
        } catch {
            throw error
        }
        
        let endTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        metricsManager?.emitMatrics(matricName: "WeatherDetails.Time", time: (endTime - startTime) )
    }
    
    private func validateCity(cityName: String) throws -> Bool {
        
        let startTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        
        let apiURL = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=\(apiKey)"
        
        callAPI(apiURL: apiURL)
        
        do {
            let json = try JSONSerialization.jsonObject(with: responseData! as Data, options: []) as? NSArray
            if json != nil {
                for inweather in json! {
                    if let checkinweather = inweather as? NSDictionary {
                        if let country = checkinweather["country"] as? String {
                            if country == "US" {
                                
                                let endTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
                                metricsManager?.emitMatrics(matricName: "ValidateCity.Time", time: (endTime - startTime) )
                                
                                return true
                            }
                        }
                    }
                }
            }
        } catch {
            throw error
        }
        
        let endTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        metricsManager?.emitMatrics(matricName: "WeatherDetails.Time", time: (endTime - startTime) )
        
        return false
    }
}
