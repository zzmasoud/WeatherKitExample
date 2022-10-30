//
//  DailyWeatherRowVM.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/29/22.
//

import Foundation

class DailyWeatherRowVM {
    private let model: Weather
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "DD"
        return formatter
    }()
    
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    init(weather: Weather) {
        self.model = weather
    }
    
    var day: String {
        return Self.dayFormatter.string(from: model.date)
    }
    
    var month: String {
        return Self.monthFormatter.string(from: model.date)
    }
    
    var temperature: String {
        return model.temprature.formatted()
    }
    
    var title: String {
        return model.label ?? "-"
    }
}
