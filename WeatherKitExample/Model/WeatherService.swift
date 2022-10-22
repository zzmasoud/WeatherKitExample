//
//  WeatherService.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import Foundation
import Combine

public enum Location {
    case geo(latitude: Double, longitude: Double)
    case city(name: String)
}

public protocol WeatherService {
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], Never>
}
