//
//  Weather.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import Foundation

public struct Weather {
    let temprature: Measurement<UnitTemperature>
    let maxTemprature: Measurement<UnitTemperature>
    let minTemprature: Measurement<UnitTemperature>
    let humidity: Float
    let label: String?
    let date: Date
}
