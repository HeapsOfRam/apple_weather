//
//  VideoViewController.swift
//  weather_app
//
//  Created by Ryan March on 5/5/15.
//  Copyright (c) 2015 Ryan March. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoViewController: UIViewController {

    var player : MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var url = NSURL(string: "https://s3.amazonaws.com/pluscast/vod/wcvb/master.m3u8")
        
        player = MPMoviePlayerController(contentURL: url)
        player.prepareToPlay()
        //player.play()
        
        view.addSubview(player.view)
        player.view.frame = CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y + 100, 300, 240)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
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
