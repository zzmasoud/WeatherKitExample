//
//  Apple.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import Foundation
import Combine
import WeatherKit

class Apple: WeatherService {
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], Never> {
        return Empty().eraseToAnyPublisher()
    }
}
