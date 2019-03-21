//
//  IAP.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import StoreKit;

class RFAbstractIAP: RFEventDispatcher,SKPaymentTransactionObserver {
    var productsRequest:RFProductsRequest!;
    var paymentQueue:SKPaymentQueue!;
    
    override init() {
        super.init();
        productsRequest=RFProductsRequest();
        paymentQueue=SKPaymentQueue.default();
        paymentQueue.add(self);
    }
    
    
    func pay(_ productID:String) {
        
        let canMakePayments=SKPaymentQueue.canMakePayments();
        if canMakePayments == false {
            RFAppUtils.Alert("不能支付");
            return;
        }
        
        showLoading(true);
        let product=productsRequest.get(productID);
        if let p=product {
            let payment=SKPayment(product: p);
            paymentQueue.add(payment);
        }else{
            //
            self.productID=productID;
            productsRequest.ons(RFEvent.COMPLETE,RFEvent.FAILED,handle:#selector(requestHandle), self);
            productsRequest.load(listString: productID);
        }
    }
    
    private var productID:String?=nil;
    
    @objc func requestHandle(e:RFEvent) {
        showLoading(false);
        productsRequest.offs(RFEvent.COMPLETE,RFEvent.FAILED,handle:#selector(requestHandle), self);
        
        if let p=productID {
            productID=nil;
            let product=productsRequest.get(p);
            if(product != nil ){
                pay(p);
            }
        }
    }
    
    //SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchased:
                paymentQueue.finishTransaction(transaction);
                doPurchased(transaction);
            case .failed:
                paymentQueue.finishTransaction(transaction);
                showLoading(false);
            case .purchasing: break
            case .restored: break
            case .deferred: break
            }
        }
    }
    
    
    func doPurchased(_ transaction:SKPaymentTransaction) {
        let receiptURL=Bundle.main.appStoreReceiptURL;
        do {
            let receiptData=try Data(contentsOf: receiptURL!);
            let encodeStr=receiptData.base64EncodedString(options: .endLineWithLineFeed);
            verifyReceipt(encodeStr);
        } catch {
            showLoading(false);
            print(error);
        }
    }
    
    
    func showLoading(_ v:Bool) {
        RFAppUtils.Loading(v);
    }
    
    //to override;
    func verifyReceipt(_ receipt:String) {
        showLoading(false);
    }
}
