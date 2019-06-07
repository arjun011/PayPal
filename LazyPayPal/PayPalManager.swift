//
//  PayPalManager.swift
//  tolk-24-7
//
//  Created by Arjun Patel on 22/05/19.
//  Copyright © 2019 Daniel Adlouni. All rights reserved.
//

import Foundation
/// Manage PayPal payment Keys 
struct PaypalKeyManager {
    static let Production = "AbGVfDO9d-q8Fdh56uTPWC8rzShUYKJjW2QeiX9XdpBauor4lkbKsFM_kvIFsytFEh36AcUWRFmocszA"
    static let Sandbox = "AVkNuDTgSsCLZPWUuLSLf8nYrR6fByjrcWoiXH7A8IN7Vl7mHfUtcceFIJbNZsfFJJNeX4FZSlawWMJo"
}

enum PaypalPrice: String {
    case Swedish_Krona = "SEK"
    case Indian = "INR"
    case Australian_dollar = "AUD"
}

struct PaymentRequest {
    var marchantName:String?
    var itemName:String?
    var price:NSDecimalNumber?
    var quantity:UInt?
    var shipPrice:NSDecimalNumber?
    var taxPrice:NSDecimalNumber?
    var totalAmount:NSDecimalNumber?
    var shortDesc:String?
    var currency:PaypalPrice?
}


