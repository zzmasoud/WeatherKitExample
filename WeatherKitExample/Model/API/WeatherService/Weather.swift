//
//  Weather.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import Foundation

public struct Weather {
    typealias Unit = Measurement<UnitTemperature>
    let temprature: Unit
    let maxTemprature: Unit
    let minTemprature: Unit
    let humidity: Float
    let label: String?
    let date: Date
}

extension Weather: Equatable {}
extension Weather: Identifiable {
    public typealias ID = Date
    
    public var id: Date {
        return self.date
    }
}
