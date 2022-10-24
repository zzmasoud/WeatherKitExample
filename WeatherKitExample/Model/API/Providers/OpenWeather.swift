//
//  OpenWeather.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/23/22.
//

import Foundation
import Combine

class OpenWeather: WeatherService {
    private struct API {
        private init() {}
        
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        #warning("Replace your API key here...")
        private static let key = Secrets.apiKey
        
        static func makeForecastURL(lat: Double, lon: Double) -> URL? {
            let lat = String(format: "%.3f", lat)
            let lon = String(format: "%.3f", lon)

            var components = URLComponents()
            components.scheme = API.scheme
            components.host = API.host
            components.path = API.path + "/forecast"

            components.queryItems = [
              URLQueryItem(name: "lat", value: lat),
              URLQueryItem(name: "lon", value: lon),
              URLQueryItem(name: "mode", value: "json"),
              URLQueryItem(name: "units", value: "metric"),
              URLQueryItem(name: "appid", value: API.key)
            ]

            return components.url
        }
    }
        
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], Never> {
        guard case let .geo(latitude, longitude) = forLocation else {
            return Just([]).eraseToAnyPublisher()
        }
        
        guard var url = API.makeForecastURL(lat: latitude, lon: longitude) else {
            return Just([]).eraseToAnyPublisher()
        }
        
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
        let humanReadable: [HumanReadable]
        
        enum CodingKeys: String, CodingKey {
            case dt, main
            case humanReadable = "weather"
        }
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
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            let weathers = root.list
            return weathers.map({map($0)})
        } catch {
            print(error)
            return []
        }
    }
    
    private static func map(_ weather: _Weather) -> Weather {
        return Weather(
            temprature: weather.main.temp.toMeasurement,
            maxTemprature: weather.main.tempMax.toMeasurement,
            minTemprature: weather.main.tempMin.toMeasurement,
            humidity: weather.main.humidity,
            label: weather.humanReadable[0].main,
            date: Date(timeIntervalSince1970: weather.dt)
        )
    }
}

fileprivate extension Double {
    var toMeasurement: Measurement<UnitTemperature> {
        return Measurement<UnitTemperature>(value: self, unit: .celsius)
    }
}
