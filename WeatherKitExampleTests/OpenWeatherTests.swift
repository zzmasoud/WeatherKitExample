//
//  OpenWeatherTests.swift
//  WeatherKitExampleTests
//
//  Created by Masoud Sheikh Hosseini on 10/24/22.
//

import XCTest
import Combine

final class OpenWeatherTests: XCTestCase {

    var subscriptions = [AnyCancellable]()
    
    func test_forecastByCityName_deliversEmpty() {
        let sut = OpenWeather()
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
    
    func test_forecastByGeo_deliversNonEmpty() {
        let sut = OpenWeather()
        // Berlin
        let location = (lat: 52.5200 , long: 13.4050)
        
        let exp = expectation(description: "waiting...")
        sut.forecast(forLocation: .geo(latitude: location.lat, longitude: location.long))
            .sink(receiveValue: { forecasts in
                XCTAssert(forecasts.count > 0)
                exp.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 5)
    }

    override func tearDown() {
        super.tearDown()
        subscriptions = []
    }
}
