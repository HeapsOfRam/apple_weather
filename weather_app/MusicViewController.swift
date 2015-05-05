//
//  MusicViewController.swift
//  weather_app
//
//  Created by Ryan March on 5/5/15.
//  Copyright (c) 2015 Ryan March. All rights reserved.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {

    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("weather", ofType: "mp3")
        let url = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: url, error: nil)
        
        player.prepareToPlay()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play_music(sender: AnyObject) {
        player.play()
    }

    @IBAction func stop_music(sender: AnyObject) {
        player.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
