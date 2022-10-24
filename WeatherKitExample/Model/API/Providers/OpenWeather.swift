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
        let main: Main
        let humanReadable: HumanReadable
    }
    
    private struct Main: Decodable {
        let temp, tempMin, tempMax: Double
        let pressure: Int
        let humidity: Float

        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
        }
    }
    
    private struct HumanReadable: Decodable {
        let id: Int
        let main, weatherDescription, icon: String

        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }
    
    static func map(_ data: Data) -> [Weather] {
        guard let root = try? JSONDecoder().decode(Root.self, from: data)
        else { return [] }
        
        let weathers = root.list
        return weathers.map({map($0)})
    }
    
    private static func map(_ weather: _Weather) -> Weather {
        return Weather(
            temprature: weather.main.temp.toMeasurement,
            maxTemprature: weather.main.tempMax.toMeasurement,
            minTemprature: weather.main.tempMin.toMeasurement,
            humidity: weather.main.humidity,
            label: weather.humanReadable.main,
            date: Date(timeIntervalSince1970: weather.dt)
        )
    }
}

fileprivate extension Double {
    var toMeasurement: Measurement<UnitTemperature> {
        return Measurement<UnitTemperature>(value: self, unit: .celsius)
    }
}
