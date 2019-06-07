//
//  PayPalTranscation.swift
//  Pods
//
//  Created by JiniGuruiOS on 04/06/19.
//

import Foundation

class PayPalTranscation:NSObject {
    let defaultString = "N/A"
    let items:NSMutableArray = NSMutableArray()
    // Paypal configure
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    //MARK: Paypal Setup
    func acceptCreditCards() -> Bool {
        return self.payPalConfig.acceptCreditCards
    }
    
    func setAcceptCreditCards(acceptCreditCards: Bool) {
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards()
    }
    
    
    func configurePayPalPaymentsDetails(paymentRequest:PaymentRequest) {
   
        self.configurePaypal(strMarchantName: paymentRequest.marchantName ?? defaultString)
        
        let item = PayPalItem.init(name: paymentRequest.itemName ?? defaultString, withQuantity: paymentRequest.quantity ?? 1, withPrice: paymentRequest.price ?? 0, withCurrency: paymentRequest.currency?.rawValue ?? PaypalPrice.Australian_dollar.rawValue, withSku: nil)
        items.add(item)
        
        self.goforPayNow(shipPrice: paymentRequest.shipPrice, taxPrice: paymentRequest.taxPrice, totalAmount: paymentRequest.totalAmount, strShortDesc: paymentRequest.shortDesc, strCurrency: paymentRequest.currency?.rawValue)
    }
    
    //MARK: Start Payment
    func goforPayNow(shipPrice:NSDecimalNumber?, taxPrice:NSDecimalNumber?, totalAmount:NSDecimalNumber?, strShortDesc:String?, strCurrency:String?) {

        var subtotal : NSDecimalNumber = 0
        if items.count > 0 {
            subtotal = PayPalItem.totalPrice(forItems: items as [AnyObject])
        } else {
            subtotal = totalAmount ?? 0
        }
        
          let shipping = shipPrice ?? 0
          let tax = taxPrice ?? 0
            let description = strShortDesc ?? ""
        
        
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: strCurrency!, shortDescription: description, intent: .sale)
        
        payment.items = items as [AnyObject]
        payment.paymentDetails = paymentDetails
        
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards();
        
        if self.payPalConfig.acceptCreditCards == true {
            print("We are able to do the card payment")
        }
        
        if (payment.processable) {
            let objVC = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            self.alertWithSingleButton(alertVC: objVC!)
        }
        else {
            print("Payment not processalbe: \(payment)")
        }
    }
    
    //MARK: Configure paypal
    func configurePaypal(strMarchantName:String) {
        if items.count>0 {
            items.removeAllObjects()
        }
        // Set up payPalConfig
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards();
        self.payPalConfig.merchantName = strMarchantName
        self.payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full") as URL?
        self.payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full") as URL?
        
        self.payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0]
        
        self.payPalConfig.payPalShippingAddressOption = .payPal;
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        PayPalMobile.preconnect(withEnvironment: environment)
    }
   
}


//MARK: - Paypal Delegate methods -

extension PayPalTranscation: PayPalPaymentDelegate {
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true) { () -> Void in
            print("and Dismissed")
        }
        print("Payment cancel")
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentViewController.dismiss(animated: true) { () -> Void in
            print("and done",completedPayment.confirmation)
            print(completedPayment.paymentDetails)
        }
        print("Paymane is going on")
    }
    
}



extension PayPalTranscation {
   
     func alertWithSingleButton(alertVC: PayPalPaymentViewController) {
        
        let topViewController = UIApplication.topViewController()
       
        guard let topVC = topViewController else {
            return
        }
        debugPrint("This is Top View Controller:- " + String(describing: topViewController.self))
        
        if topVC.isModal {
            topVC.presentingViewController?.present(alertVC, animated: true, completion: { () -> Void in
                print("Paypal Presented")
            })
            return
        }
        if let tabbar = topVC.tabBarController {
            tabbar.present(alertVC, animated: true, completion: { () -> Void in
                print("Paypal Presented")
            })
        } else {
            topVC.present(alertVC, animated: true, completion: { () -> Void in
                print("Paypal Presented")
            })
        }
        
    }
}


extension UIViewController {
    var isModal: Bool {
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController === navigationController {
            return true
        }
        if let presentingVC = tabBarController?.presentingViewController, presentingVC is UITabBarController {
            return true
        }
        return false
    }
}



extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    class func setStatusBarStyleWithAnimation(style: UIStatusBarStyle) {
        UIView.animate(withDuration: 0.5) { () -> Void in
            UIApplication.shared.statusBarStyle = style
        }
    }
    
    class func schemeAvailable(scheme: String) -> Bool {
        if let url = URL(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
