//
//  Weather.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import Foundation

public struct Weather {
    let temprature: UnitTemperature
    let maxTemprature: UnitTemperature
    let minTemprature: UnitTemperature
    let humidity: Float
    let label: String?
    let date: Date
}
