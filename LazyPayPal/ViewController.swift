//
//  ViewController.swift
//  LazyPayPal
//
//  Created by JiniGuruiOS on 04/06/19.
//  Copyright © 2019 LazyCoder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func btnBuy(_ sender: Any) {
        let paymentObj = PayPalTranscation()
        let paymentrequest = PaymentRequest.init(marchantName: "Arjun", itemName: "Shose", price: 122.2, quantity: 1, shipPrice: 0, taxPrice: 0, totalAmount: 0, shortDesc: "Nike - 231", currency: PaypalPrice.Australian_dollar)
        paymentObj.configurePayPalPaymentsDetails(paymentRequest: paymentrequest)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
 
    }

}

