//
//  ViewController.swift
//  weather_app
//
//  Created by Ryan March on 5/5/15.
//  Copyright (c) 2015 Ryan March. All rights reserved.
//

import UIKit

extension String{
    func uri_encoded() -> String{
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var city_text: UITextField!
    @IBOutlet var measurement_unit: UISegmentedControl!
    
    @IBAction func background_tap(sender: AnyObject) {
        remove_keyboard(self.view)
    }
    
    @IBAction func unit_has_changed(sender: AnyObject) {
        get_weather_for_city(sender)
        
        let storage = NSUserDefaults.standardUserDefaults()
        storage.setInteger(measurement_unit.selectedSegmentIndex, forKey: "unit")
        storage.synchronize()
    }
    
    @IBAction func get_weather_for_city(sender: AnyObject) {
        let url_string = "http://api.openweathermap.org/data/2.5/weather?q=\(city_text.text)&units=\(get_proper_measurement_unit())"
        let url = NSURL(string: url_string.uri_encoded())!
        let json = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
        
        println(json)
    }
    
    func get_proper_measurement_unit() -> String{
        return measurement_unit.selectedSegmentIndex==0 ? "metric" : "imperial"
    }
    
    func remove_keyboard(container: UIView){
        for var i=0; i<container.subviews.count; i+=1 {                    let current_view = container.subviews[i] as UIView
            if current_view is UITextField{
                current_view.resignFirstResponder()
            }else if(current_view.isMemberOfClass(UIView)){
                remove_keyboard(current_view)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storage = NSUserDefaults.standardUserDefaults()
        let unit = storage.integerForKey("unit")
        measurement_unit.selectedSegmentIndex = unit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

