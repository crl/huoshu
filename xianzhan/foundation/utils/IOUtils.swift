//
//  FileUtil.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class IOUtils: NSObject {
    
    static let fileManager=FileManager.default;
    
    static func GetDomDirectory(_ uri:String?=nil)->URL{
        let document=fileManager.urls(for: .documentDirectory, in: .userDomainMask);
        var url=document[0];
        
        if let uri=uri,!uri.isEmpty{
            url=url.appendingPathComponent(uri);
        }
        
        return url;
    }
    
    static func GetFiles(_ fullDirectoryPath:String)->[String]{
        var list=try? fileManager.contentsOfDirectory(atPath: fullDirectoryPath);
        if(list == nil){
            list=[];
        }
        return list!;
    }
    
    static func GetFullPath(_ uri:String,_ baseURL:URL)->String{
        let url=baseURL.appendingPathComponent(uri);
        return url.path;
    }
    
    
    static func Exists(_ fullPath:String)->Bool{
        return fileManager.fileExists(atPath: fullPath);
    }
    
    @discardableResult
    static func CreateFile(_ fullPath:String)->Bool{
        
        if Exists(fullPath)==false{
            return fileManager.createFile(atPath: fullPath, contents: nil, attributes: nil);
        }
        return true;
    }
    
    @discardableResult
    static func RemoveFile(_ fullPath:String)->Bool{
        if(Exists(fullPath)==false){
            return false;
        }
        
        do {
            try fileManager.removeItem(atPath: fullPath);
        } catch {
            return false;
        }
        
        
        return true;
    }
    
    @discardableResult
    static func WriteString(_ value:String,fullPath:String,encoding:String.Encoding = String.Encoding.utf8)->Bool{
        if value.isEmpty{
            return false;
        }
        
        if Exists(fullPath)==false{
            let b=CreateFile(fullPath);
            if b==false{
                return false;
            }
        }
        
        try! value.write(toFile: fullPath, atomically: true, encoding: encoding);
        return true;
    }
    
    static func ReadString(_ fullPath:String,encoding:String.Encoding = String.Encoding.utf8)->String{
        if Exists(fullPath)==false{
            return "";
        }
        
        let t=try! String(contentsOfFile: fullPath, encoding: encoding);
        
        return t;
    }
}
