//
//  WeatherService.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import Foundation
import MapKit
import Combine

protocol WeatherService {
    func load(forLocation: CLLocation) -> AnyPublisher<[Weather], Never>
}
