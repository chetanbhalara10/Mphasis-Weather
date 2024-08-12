//
//  Mphasis_WeatherUITests.swift
//  Mphasis-WeatherUITests
//
//  Created by CHB on 8/12/24.
//

import XCTest

final class Mphasis_WeatherUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testWeatherUIButtons() {
        app.buttons["Weather"].tap()
        let textField = app.textFields["Please enter city name"]
        textField.tap()
        textField.typeText("Austin")
        app.buttons["Search"].tap()
        sleep(10)
        app.buttons["Current Location"].tap()
        XCUIApplication().keyboards.buttons["Return"].tap()
        sleep(10)
        app.buttons["Back"].tap()
        sleep(10)
        app.buttons["About Us"].tap()
        sleep(10)
        app.buttons["Back"].tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
