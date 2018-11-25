//
//  ProductsRequest.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import StoreKit;


class ProductsRequest:EventDispatcher,SKProductsRequestDelegate {
    var dic:[String:SKProduct]=[:];
    
    func load(listString:String) {
        let list=listString.components(separatedBy: ";");
        var set:Set<String>=[];
        
        for item in list {
            set.insert(item);
        }
        
        let request=SKProductsRequest(productIdentifiers: set);
        request.delegate=self;
        request.start();
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            dic[product.productIdentifier]=product;
        }
        self.simpleDispatch(EventX.COMPLETE, dic);
    }
    
    
    func get(_ productId:String) -> SKProduct? {
        return dic[productId];
    }
    

}
