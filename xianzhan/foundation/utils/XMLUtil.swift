//
//  XMLUtil.swift
//  xianzhan
//
//  Created by crl on 2018/11/20.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class XMLUtil: NSObject {
    
    static func SimpleParse(xml:Data) -> [String:XMLItemVO] {
        let parser=XMLParser(data: xml);
        
        let cc=SimpleXMLParser();
        
        parser.delegate=cc;
        
        if !parser.parse(){
            print(parser.parserError ?? "parserError");
        }
        
        return cc.data;
    }
}

class XMLItemVO:NSObject{
    var name:String = "";
    var value:String = "";
    private var _attribute: [String : String] = [:];
    
    public var attribute: [String : String]{
        get{
            return _attribute;
        }
        
        set{
            _attribute=newValue;
            
            self.name=self._attribute["name"] ?? "";
            self.value=self.attribute["value"] ?? "";
        }
    }
}


class SimpleXMLParser:NSObject,XMLParserDelegate{
    
    var data:[String:XMLItemVO];
    
    private var currentItemVO:XMLItemVO?;
    
    override init() {
        data=[:];
        super.init();
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        var name=attributeDict["name"] ?? "";
        
        if name.isEmpty{
            name=elementName;
        }else{
            name=elementName+"."+name;
        }
        
        currentItemVO=data[name] ?? nil;
        
        if currentItemVO == nil
        {
            currentItemVO = XMLItemVO();
        }
        
        currentItemVO!.attribute=attributeDict;
        
        data[name]=currentItemVO;
        
//        print("start",elementName,namespaceURI ?? "",qName ?? "",attributeDict);
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("end",elementName,namespaceURI ?? "",qName ?? "");
        
        currentItemVO=nil;
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters char: String) {
//        print("found:::::::::::::");
//        print(char);
//        print(":::::::::::::");
        
        if let c=currentItemVO{
            let t=char.trimmingCharacters(in: .whitespaces);
            if c.value.isEmpty && !t.isEmpty{
                c.value=char;
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
         //print(parseError);
    }
}
