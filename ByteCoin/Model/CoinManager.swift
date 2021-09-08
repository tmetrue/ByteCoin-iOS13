//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func coinManager(_ coinManager: CoinManager, didUpdate exchangeRate: ExchangeRateModel) -> Void
    func coinManager(_ coinManager: CoinManager, didFail error: Error) -> Void
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = API_KEY // From Secrets.swift (or similar)
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create an URL
        if let url = URL(string: urlString) {
            // 2. Create an URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if let err = error {
                    delegate?.coinManager(self, didFail: err)
                    return
                }
                
                if let safeData = data {
                    if let exchangeRate = self.parseJSON(safeData) {
                        delegate?.coinManager(self, didUpdate: exchangeRate)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ exchangeRateData: Data) -> ExchangeRateModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ExchangeRateData.self, from: exchangeRateData)
            let base = decodedData.asset_id_base
            let quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let exchangeRate = ExchangeRateModel(base: base, quote: quote, rate: rate)
            print("\(exchangeRate.quote)/\(exchangeRate.base): \(exchangeRate.rate)")
            return exchangeRate
        } catch {
            delegate?.coinManager(self, didFail: error)
            return nil
        }
    }
}
