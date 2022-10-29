//
//  WeeklyWeatherView.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/22/22.
//

import SwiftUI

struct WeeklyWeatherView: View {
    @ObservedObject var viewModel: WeeklyWeatherVM

    init(viewModel: WeeklyWeatherVM) {
      self.viewModel = viewModel
    }

    var body: some View {
        searchField
        Text("RESULTS:")
        Text(viewModel.city)
        Text(viewModel.forecasts.map({$0.label!}).joined(separator: "\n"))
    }
}

private extension WeeklyWeatherView {
    var searchField: some View {
      HStack(alignment: .center) {
        TextField("e.g. London", text: $viewModel.city)
      }
    }
}
