//
//  StoreProduct.swift
//  xianzhan
//
//  Created by crl on 2018/11/8.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import StoreKit;

class RFStoreProduct: NSObject,SKStoreProductViewControllerDelegate {
    var storeView:SKStoreProductViewController;
    override init() {
        storeView=SKStoreProductViewController();
        super.init();
        storeView.delegate=self;
    }
    
    func load(appID:String){
        storeView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:appID]) { (result, error) in
            if(result){
                RFAppUtils.Present(self.storeView, animated: true, completion: nil);
            }else if(error != nil){
                print("error: %@",error!);
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController){
        viewController.dismiss(animated: true, completion: nil);
    }
}
