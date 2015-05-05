//
//  ViewController.swift
//  weather_app
//
//  Created by Ryan March on 5/5/15.
//  Copyright (c) 2015 Ryan March. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension String{
    func uri_encoded() -> String{
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
}

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet var city_text: UITextField!
    @IBOutlet var measurement_unit: UISegmentedControl!
    @IBOutlet var temperature_label: UILabel!
    @IBOutlet var image_icon: UIImageView!
    @IBOutlet var map_view: MKMapView!
    
    var manager : CLLocationManager!
    
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
        temperature_label.alpha = 1
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            { () -> Void in
                let root = self.get_weather_from_url("q=\(self.city_text.text)")
                
                let message : AnyObject? = root.objectForKey("message")
                
                if message == nil{
                    let main = root.objectForKey("main") as NSDictionary
                    
                    let weather = root.objectForKey("weather") as NSArray
                    let first_weather = weather[0] as NSDictionary
                    let icon_name = first_weather.objectForKey("icon") as String
                    let icon_url = "http://openweathermap.org/img/w/\(icon_name).png"
                    
                    var image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon_url)!)!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        UIView.animateWithDuration(1, animations: { () -> Void in
                            self.temperature_label.text = (main.objectForKey("temp") as NSNumber).stringValue
                            self.temperature_label.alpha = 1
                        })
                    })
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image_icon.image = image
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in                            UIView.animateWithDuration(1, animations: { () -> Void in
                        self.temperature_label.text = message! as? String
                        self.temperature_label.alpha = 1
                        })
                    })
                }
        })
    }
    
    func retrieve_json(data : NSData) -> NSDictionary
    {
        var error : NSError?
        let response : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        
        return response as NSDictionary
    }
    
    @IBAction func locate_me(sender: AnyObject) {
        if manager.respondsToSelector(Selector("requestWhenInUseAuthorization")){
            manager.requestWhenInUseAuthorization()
        }
        
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        let last_location = locations.last as CLLocation
        get_weather_by_location(last_location)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        var region = MKCoordinateRegion(center: last_location.coordinate, span: span)
        
        map_view.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        
    }
    
    func get_weather_by_location(last_location : CLLocation){
        let queries = "lat=\(last_location.coordinate.latitude)&lon=\(last_location.coordinate.longitude)"
        let root = get_weather_from_url(queries)
        
        let main = root.objectForKey("main") as NSDictionary
        let temp = (main.objectForKey("temp") as NSNumber).floatValue
        
        let weather = root.objectForKey("weather") as NSArray
        let first_weather = weather[0] as NSDictionary
        let icon_name = first_weather.objectForKey("icon") as String
        let icon_url = "http://openweathermap.org/img/w/\(icon_name).png"
        
        var image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon_url)!)!)
        
        temperature_label.text = "\(temp)"
        image_icon.image = image
        city_text.text = root.objectForKey("name") as String
    }
    
    func get_proper_measurement_unit() -> String{
        return measurement_unit.selectedSegmentIndex==0 ? "metric" : "imperial"
    }
    
    func remove_keyboard(container: UIView){
        for var i=0; i<container.subviews.count; i+=1 {
            let current_view = container.subviews[i] as UIView
            if current_view is UITextField{
                current_view.resignFirstResponder()
            }else if(current_view.isMemberOfClass(UIView)){
                remove_keyboard(current_view)
            }
        }
    }
    
    func get_weather_from_url(queries: String) -> NSDictionary{
        let url_string = "http://api.openweathermap.org/data/2.5/weather?\(queries)&units=\(get_proper_measurement_unit())"
        let url = NSURL(string: url_string.uri_encoded())!
        let data = NSData(contentsOfURL: url)
        return retrieve_json(data!)
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
        
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        manager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

