//
//  Mphasis_WeatherTests.swift
//  Mphasis-WeatherTests
//
//  Created by CHB on 8/12/24.
//

import XCTest
@testable import Mphasis_Weather

final class Mphasis_WeatherTests: XCTestCase {

    var weatherVM: WeatherViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherVM = WeatherViewModel(weatherDataRepository: DependencyInjection.getWeatherDataRepository(), preferenceStore: DependencyInjection.getPreferenceStore(), metricsManager: DependencyInjection.getMetricsManager())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        weatherVM = nil
        try super.tearDownWithError()
    }
    
    func testGetWeatherData() throws {
        weatherVM.getWeatherData(city: "")
        weatherVM.getWeatherData(city: "Austin")
        weatherVM.getWeatherData(city: "Plano")
        weatherVM.getWeatherData(city: "Mumbai")
        weatherVM.getWeatherData(city: "London")
    }
    
    func testGetRecentCity() throws {
        let city = weatherVM.getRecentCity()
        XCTAssertFalse(city == "")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure (metrics: [
            XCTClockMetric(),
            XCTCPUMetric(),
            XCTStorageMetric(),
            XCTMemoryMetric()
          ]){
            // Put the code you want to measure the time of here.
              weatherVM.getWeatherData(city: "Austin")
        }
    }

}
