//
//  WeeklyWeatherVM.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/25/22.
//

import Foundation
import Combine

class WeeklyWeatherVM: ObservableObject {
    
    @Published var city: String = ""
    @Published var forecasts: [Weather] = []
    
    private let service: WeatherService
    private var subscriptions = [AnyCancellable]()
    
    init(service: WeatherService, scheduler: DispatchQueue = DispatchQueue(label: "WeeklyWeatherVM")) {
        self.service = service
        $city
       // to skip empty string ("")
            .dropFirst()
            .filter({$0.count > 3})
        // to prevent HTTP request for every single new character, instead wait for 1 second after user stopped typing
            .debounce(for: 1, scheduler: scheduler)
            .sink(receiveValue: { text in
                self.fetchWeather(forLocation: .city(name: text))
            })
            .store(in: &subscriptions)
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
                case .failure(let error):
                    self.forecasts = []
                }
                
            } receiveValue: { [weak self] forecasts in
                guard let self = self else { return }
                
                self.forecasts = forecasts
            }
            .store(in: &subscriptions)

    }
}
