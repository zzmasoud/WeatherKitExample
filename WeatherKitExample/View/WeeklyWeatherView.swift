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
        NavigationView {
            List {
                searchField
                
                if viewModel.forecasts.isEmpty {
                    emptySection
                } else {
                    forecastsView
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("ZZWeatherKit")
        }
    }
}

private extension WeeklyWeatherView {
    var searchField: some View {
        HStack(alignment: .center) {
            TextField("e.g. London", text: $viewModel.city)
        }
    }
    
    var emptySection: some View {
        Text("Start typing a city name ...")
            .foregroundColor(.secondary)
    }
    
    var forecastsView: some View {
        Section {
            ForEach(viewModel.forecasts, content: { item in DailyWeatherRow(viewModel: DailyWeatherRowVM(weather: item)) })
        }
    }
    
}
