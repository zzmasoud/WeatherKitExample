//
//  AppleWeather.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import Foundation
import Combine
import WeatherKit
import MapKit

class AppleWeather: WeatherService {
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], Never> {
        return Empty().eraseToAnyPublisher()
    }
    
    private let service = WeatherKit.WeatherService.shared

    func forecast(forLocation location: Location) async -> AnyPublisher<[Weather], Never> {
        guard let geo = map(location: location) else {
            return Just([]).eraseToAnyPublisher()
        }
        
        do {
            let result = try await service.weather(for: geo)
        } catch {
            return Empty().eraseToAnyPublisher()
        }
    }
}

extension AppleWeather {
    private func map(location: Location) -> CLLocation? {
        guard case let .geo(latitude, longitude) = location else {
            return nil
        }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
