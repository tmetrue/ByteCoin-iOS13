//
//  ExchangeRateModel.swift
//  ByteCoin
//
//  Created by Torstein Meland on 08/09/2021.
//

import Foundation

struct ExchangeRateModel {
    let base: String
    let quote: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
