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
    private let service = WeatherKit.WeatherService.shared

    func forecast(forLocation location: Location) -> AnyPublisher<[Weather], Never> {
        return Future {
            await self.forecast(forLocation: location)
        }
        .eraseToAnyPublisher()
    }
    
    private func forecast(forLocation location: Location) async -> [Weather] {
        guard let geo = map(location: location) else {
            return []
        }
        
        do {
            let result = try await service.weather(for: geo)
            let weathers = result.dailyForecast.map({$0.mapToWeather()})
            return weathers
            
        } catch {
            return []
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

extension DayWeather {
    func mapToWeather() -> Weather {
        return Weather(
            temprature: highTemperature,
            maxTemprature: highTemperature,
            minTemprature: lowTemperature,
            humidity: -1,
            label: condition.description,
            date: date)
    }
}

extension Future where Failure == Never {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                }
            }
        }
    }
}
