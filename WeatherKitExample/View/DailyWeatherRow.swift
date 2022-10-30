//
//  DailyWeatherRow.swift
//  WeatherKitExample
//
//  Created by Masoud Sheikh Hosseini on 10/29/22.
//

import SwiftUI

struct DailyWeatherRow: View {
//    private let viewModel: DailyWeatherRowVM
//    
//    init(viewModel: DailyWeatherRowVM) {
//        self.viewModel = viewModel
//    }
    
    var body: some View {
        HStack {
            VStack {
                Text("29")
                Text("OCT")
            }
            
            HStack {
                Image(systemName: "")
                Text("Rainy")
            }
            
            HStack {
                Text("11 C")
            }
        }
    }
    
}
