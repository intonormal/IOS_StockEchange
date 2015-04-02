//
//  ViewController.swift
//  StockExchange
//
//  Created by huangzewu on 3/10/15.
//  Copyright (c) 2015 huangzewu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var HKY: UITextField!
    
    @IBOutlet weak var CNY: UITextField!
    
    func loadURL() -> NSString {
        let request = NSURLRequest(URL: NSURL(string:"http://fx.cmbchina.com/hq/")!)
        var response: NSURLResponse?
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil)!
        return NSString(data:urlData, encoding:NSUTF8StringEncoding)!
    }
    
    func parseRate(urlData:NSString) -> Double {
        var HKYArea = urlData.substringFromIndex(urlData.rangeOfString("港币").location)
        var rateArea = HKYArea.substringFromIndex((HKYArea.rangeOfString("<td class=\"numberright\">")!.endIndex))
        var rateAsNSString = rateArea.substringToIndex(rateArea.rangeOfString("</td>")!.startIndex)
        var temp = rateAsNSString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let rateAsDouble = NSNumberFormatter().numberFromString(temp)?.doubleValue
        
        return rateAsDouble!
    }
    
    func getRate() -> Double {
        return parseRate(loadURL())
    }
    
    @IBAction func HKYtoCNY(sender: AnyObject) {
        CNY.text = String(format:"%.4f", (HKY.text as NSString).doubleValue  * getRate() / 100 )
    }
    
    @IBAction func CNYtoHKY(sender: AnyObject) {
        HKY.text = String(format:"%.4f", (CNY.text as NSString).doubleValue / (getRate() / 100))
    }
}

