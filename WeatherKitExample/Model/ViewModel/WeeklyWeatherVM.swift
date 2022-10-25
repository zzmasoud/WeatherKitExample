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
    
    func fetchWeather(forLocation location: Location) {
        service.forecast(forLocation: location)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.forecasts = []
                }
                
            } receiveValue: { [weak self] forecasts in
                guard let self = self else { return }
                
                self.forecasts = forecasts
            }
            .store(in: &subscriptions)

    }
}
