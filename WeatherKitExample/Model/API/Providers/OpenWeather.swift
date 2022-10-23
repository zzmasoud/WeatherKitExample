//
//  OpenWeather.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/23/22.
//

import Foundation
import Combine

class OpenWeather: WeatherService {
    static let apiKey = "05b620cf268c91d00a8a7291d39b2ecb"
    
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], Never> {
        URLSession.shared.dataTaskPublisher(for: Self.apiUrl)
            .map(\.data)
            .map(OpenWeatherMapper.map(_:))
            .eraseToAnyPublisher()
        
        return Empty().eraseToAnyPublisher()
    }
}

private class OpenWeatherMapper {
    private init() {}
    
    static func map(_ data: Data) -> [Weather] {
        return []
    }
}
