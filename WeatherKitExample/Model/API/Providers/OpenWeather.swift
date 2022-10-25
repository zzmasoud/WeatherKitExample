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
        
    func forecast(forLocation: Location) -> AnyPublisher<[Weather], WeatherServiceError> {
        guard case let .geo(latitude, longitude) = forLocation else {
            return Fail(error: WeatherServiceError.notSupported)
                .eraseToAnyPublisher()
        }
        
        guard let url = API.makeForecastURL(lat: latitude, lon: longitude) else {
            return Fail(error: WeatherServiceError.network)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .print("OPENWEATHER")
            .flatMap(maxPublishers: .max(1)) { result in
                OpenWeatherMapper.decode(result.data)
            }
            .mapError({ error in
                    .parsing
            })
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
    
    struct _Weather: Decodable {
        let dt: Double
        let main: Main
        let humanReadable: [HumanReadable]
        
        enum CodingKeys: String, CodingKey {
            case dt, main
            case humanReadable = "weather"
        }
    }
    
    struct Main: Decodable {
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
    
    struct HumanReadable: Decodable {
        let id: Int
        let main, weatherDescription, icon: String

        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }
    
    static func decode(_ data: Data) -> AnyPublisher<[Weather], Never> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: Root.self, decoder: decoder)
            .map({$0.list.toWeathers()})
            .assertNoFailure()
            .eraseToAnyPublisher()
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

private extension Array where Element == OpenWeatherMapper._Weather {
    func toWeathers() -> [Weather] {
        return map { weather in
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
}


fileprivate extension Double {
    var toMeasurement: Measurement<UnitTemperature> {
        return Measurement<UnitTemperature>(value: self, unit: .celsius)
    }
}
