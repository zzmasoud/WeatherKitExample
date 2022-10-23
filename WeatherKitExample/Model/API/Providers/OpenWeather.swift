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
        return Empty().eraseToAnyPublisher()
    }
}
