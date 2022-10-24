//
//  OpenWeather.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/23/22.
//

import Foundation
import Combine

class OpenWeather: WeatherService {
    
    #warning("Replace your API key here...")
    static let apiKey = Secrets.apiKey
    static let apiUrl = "https://api.openweathermap.org/data/3.0/onecall?"
    
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], Never> {
        guard case let .geo(latitude, longitude) = forLocation else {
            return Just([]).eraseToAnyPublisher()
        }
        
        let url = URL(string: Self.apiUrl + "lat=\(latitude)&lon=\(longitude)&exclude=daily&appid=\(Self.apiKey)")!

        return URLSession.shared.dataTaskPublisher(for: url)
            .print("OPENWEATHER")
            .map(\.data)
            .map(OpenWeatherMapper.map(_:))
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

private class OpenWeatherMapper {
    private init() {}
    
    private struct Root: Decodable {
        let cod: String
        let message: Int
        let list: [_Weather]
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
        
        let weathers = root.list
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
