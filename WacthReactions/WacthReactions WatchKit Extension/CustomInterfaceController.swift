//
//  CustomInterfaceController.swift
//  WacthReactions WatchKit Extension
//
//  Created by Owen Henley on 05/05/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import WatchKit
import AVFoundation


class CustomInterfaceController: WKInterfaceController {

    let saveURL = FileManager.default.getDocumentsDirectory().appendingPathComponent("recording.wav")
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

    @IBAction func recordTapped() {
        presentAudioRecorderController(withOutputURL: saveURL,
                                       preset: .narrowBandSpeech,
                                       options: nil) { (success, error) in
                                        if let error = error {
                                            print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                                        }

                                        if success {
                                            print("Saved!")
                                        } else {
                                            print("Could not save!")
                                        }
        }
    }

    @IBAction func playTapped() {
        guard FileManager.default.fileExists(atPath: saveURL.path) else { return }
        try? audioPlayer = AVAudioPlayer(contentsOf: saveURL)
        audioPlayer?.play() // add privacy - microphone in pList
    }
}
