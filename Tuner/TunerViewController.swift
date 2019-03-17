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
    @IBOutlet var frequencyLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var octaveLabel: UILabel!
    
    private var frequency:Double?
    static let noiseThreshold = 0.005
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable microphone tracking.
        AKSettings.audioInputEnabled = true
        let mic = AKMicrophone()
        let tracker = AKFrequencyTracker(mic)
        
        //Disable audio output
        let silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        
        //Start
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
            
            if tracker.amplitude > TunerViewController.noiseThreshold {
                this.amplitudeLabel.text = String(format: "Amplitude: %.6f", tracker.amplitude)
                this.frequencyLabel.text = String(format: "Frequency: %.3f Hz", tracker.frequency)
                if let pitch = try? getPitch(from: tracker.frequency) {
                    this.noteLabel.text = "Note: \(pitch.note.description)"
                    this.octaveLabel.text = "Octave: \(pitch.octave)"
                }
                else {
                    this.noteLabel.text = "Note: Error!"
                    this.octaveLabel.text = "Octave: Error!"
                }
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
}
