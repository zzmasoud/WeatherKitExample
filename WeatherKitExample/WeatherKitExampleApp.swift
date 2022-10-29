//
//  WeatherKitExampleApp.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import SwiftUI

@main
struct WeatherKitExampleApp: App {
    
    let service: WeatherService = OpenWeather()
    
    var body: some Scene {
        WindowGroup {
            WeeklyWeatherView(viewModel: WeeklyWeatherVM(service: service))
        }
    }
}
