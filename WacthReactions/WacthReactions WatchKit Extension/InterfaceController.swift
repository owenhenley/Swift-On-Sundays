//
//  InterfaceController.swift
//  WacthReactions WatchKit Extension
//
//  Created by Owen Henley on 05/05/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import WatchKit
import AVFoundation

class InterfaceController: WKInterfaceController, SoundPlaying {
    var audioPlayer: AVAudioPlayer?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func playSound1() {
        playSound(named: "resonant")

    }

    @IBAction func playSound2() {
        playSound(named: "wind")
    }

    @IBAction func playSound3() {
        playSound(named: "chime")
    }

    @IBAction func playSound4() {
        playSound(named: "dirt")
    }

}
