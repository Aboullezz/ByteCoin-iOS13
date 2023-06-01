//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit
protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdatePrice(price: String, currency: String)
}
struct CoinManager {
    
    var delegate:CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apikey = "93993702-A726-4199-B83E-96CCB42531CC"
    
    let currencyArray = ["AUD","USD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    
    
    func getCoinPrice (for currency: String) {
//        1. creat a URL
        let urlString = "\(baseURL)/\(currency)?apikey=\(apikey)"
        if let url = URL(string: urlString) {
//                        print(urlString)
            //            2. Creat Session
            let session = URLSession(configuration: .default)
            //            3. Give the Session a Task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            //        4. Start the Task
            task.resume()
        }
    }
    func parseJSON (_ coinData: Data) -> Double? {
//        1. Creat a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodeData.rate
                return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

