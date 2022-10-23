//
//  WeatherKitExampleTests.swift
//  WeatherKitExampleTests
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import XCTest
import Combine

final class WeatherKitExampleTests: XCTestCase {
    
    var subscriptions = [AnyCancellable]()

    func test_forecastByCityName_deliversEmpty() {
        let sut = AppleWeather()
        let cityName = "Berlin"
        
        let exp = expectation(description: "waiting...")
        sut.forecast(forLocation: .city(name: cityName))
            .sink(receiveValue: { forecasts in
                XCTAssertEqual(forecasts, [])
                exp.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 1)
    }
    
    override func tearDown() {
        super.tearDown()
        subscriptions = []
    }

}
