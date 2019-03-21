//
//  ViewController.swift
//  BeautyGallery
//
//  Created by Jake Lin on 29/08/2014.
//  Copyright (c) 2014 rushjet. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
                            
    @IBOutlet weak var beautyPicker: UIPickerView!
    
    let beauties = ["范冰冰", "李冰冰", "王菲", "杨幂", "周迅"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        beautyPicker.dataSource = self as! UIPickerViewDataSource
        beautyPicker.delegate = self as! UIPickerViewDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue:
        UIStoryboardSegue, sender: Any!) {
            if segue.identifier == "GoToGallery" {
                let index = beautyPicker.selectedRow(inComponent: 0)
                
                let vc = segue.destination as! GalleryViewController
                switch index {
                case 0:
                    vc.imageName = "fanbingbing"
                case 1:
                    vc.imageName = "libingbing"
                case 2:
                    vc.imageName = "wangfei"
                case 3:
                    vc.imageName = "yangmi"
                case 4:
                    vc.imageName = "zhouxun"
                default:
                    vc.imageName = nil
                }
            }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
    
        print("closed!")
    }
}

