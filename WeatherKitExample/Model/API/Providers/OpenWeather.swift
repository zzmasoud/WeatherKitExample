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
    static let apiUrl = URL(string: "https://api.openweathermap.org/data/3.0/onecall?")!
    
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
    
    private struct Root: Decodable {
        let daily: [_Weather]
    }
    
    private struct _Weather: Decodable {
        let dt: Double
        let humidity: Float
        let temp: Temprature
        let overall: Overall
    }
    
    private struct Temprature: Decodable {
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    
    private struct Overall: Decodable {
        let main: String
    }
    
    static func map(_ data: Data) -> [Weather] {
        guard let root = try? JSONDecoder().decode(Root.self, from: data)
        else { return [] }
        
        let weathers = root.daily
        return weathers.map({map($0)})
    }
    
    private static func map(_ weather: _Weather) -> Weather {
        return Weather(
            temprature: weather.temp.day.toMeasurement,
            maxTemprature: weather.temp.max.toMeasurement,
            minTemprature: weather.temp.min.toMeasurement,
            humidity: weather.humidity,
            label: weather.overall.main,
            date: Date(timeIntervalSince1970: weather.dt)
        )
    }
}

fileprivate extension Double {
    var toMeasurement: Measurement<UnitTemperature> {
        return Measurement<UnitTemperature>(value: self, unit: .celsius)
    }
}
