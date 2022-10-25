//
//  WeeklyWeatherVM.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/25/22.
//

import Foundation
import Combine

class WeaklyWeatherVM {
    
    @Published var city: String = ""
    @Published var forecasts: [Weather] = []
    
    private let service: WeatherService
    private var subscriptions = [AnyCancellable]()
    
    init(service: WeatherService) {
        self.service = service
    }
}
