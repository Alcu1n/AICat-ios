//
//  SKProduct+Extension.swift
//  AIChatty
//

import StoreKit

extension SKProduct {
    var locatedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }

    var currencySymbol: String {
        return priceLocale.currencySymbol ?? "$"
    }
}
