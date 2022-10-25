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

public enum WeatherServiceError: Error {
    case network
    case parsing
    case notSupported
}

public protocol WeatherService {
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], WeatherServiceError>
}
