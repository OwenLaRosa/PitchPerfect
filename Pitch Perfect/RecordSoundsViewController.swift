//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Owen LaRosa on 11/20/14.
//  Copyright (c) 2014 Owen LaRosa. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
        recordingLabel.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        stopButton.hidden = false
        // record the user's voice
        recordingLabel.text = "recording in progress"
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        // Initialize and prepare the recorder
        do {
            let settings = [String : AnyObject]()
            try audioRecorder = AVAudioRecorder(URL: filePath!, settings: settings)
        } catch _ {
        }
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
        let data = sender as! RecordedAudio
        playSoundsVC.receivedAudio = data
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        // stop the recording in progress
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }

}

