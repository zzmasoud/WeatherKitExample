//
//  DailyWeatherRow.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/29/22.
//

import SwiftUI

struct DailyWeatherRow: View {
    private let viewModel: DailyWeatherRowVM
    
    init(viewModel: DailyWeatherRowVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(viewModel.day)
                Text(viewModel.month)
            }
            
            HStack {
                Image(systemName: "")
                Text(viewModel.title)
            }
            
            HStack {
                Text(viewModel.temperature)
            }
        }
    }
    
}
