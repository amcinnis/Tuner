//
//  TunerViewController.swift
//  Tuner
//
//  Created by Austin McInnis on 9/4/18.
//  Copyright © 2018 Austin McInnis. All rights reserved.
//

import AudioKit
import UIKit

class TunerViewController: UIViewController {

    @IBOutlet var amplitudeLabel: UILabel!
    private var frequency:Double?
    @IBOutlet var frequencyLabel: UILabel!
    let noiseThreshold = 0.005
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable microphone tracking.
        AKSettings.audioInputEnabled = true
        let mic = AKMicrophone()
        let tracker = AKFrequencyTracker(mic)
        let silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        do {
            try AudioKit.start()
        }
        catch {
            print("AudioKit did not start!")
        }
        mic.start()
        tracker.start()
        
        // Track input frequency, 100ms intervals
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            [weak self] (timer) in
            guard let this = self else { return }
            
            if tracker.amplitude > this.noiseThreshold {
                this.amplitudeLabel.text = String(format: "Amplitude: %.6f", tracker.amplitude)
                this.frequencyLabel.text = String(format: "Frequency: %.3f Hz", tracker.frequency)
                this.frequencyLabel.sizeToFit()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let timer = self.timer {
            timer.invalidate()
        }
        else {
            print("Did not invalidate timer")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
