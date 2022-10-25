//
//  WeaklyWeatherView.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import SwiftUI

struct WeaklyWeatherView: View {
    @ObservedObject var viewModel: WeeklyWeatherVM

    init(viewModel: WeeklyWeatherVM) {
      self.viewModel = viewModel
    }

    var body: some View {
        Text("Hello World")
    }
}
