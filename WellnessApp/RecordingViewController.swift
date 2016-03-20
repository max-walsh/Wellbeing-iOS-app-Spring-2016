//
//  RecordingViewController.swift
//  WellnessApp
//
//  Created by Max Walsh on 3/15/16.
//  Copyright © 2016 anna. All rights reserved.
//

import UIKit
import AVFoundation



class RecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer :  AVAudioPlayer!
    
    var fileName =  "/audiofile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupRecorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRecorder() {
        var recordSettings = [AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleLossless)), AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : NSNumber(int: 1), AVSampleRateKey : NSNumber(float: 44100.0) ]
        
        var error : NSError?
        
        do {
            print("recorder: \(getFileURL())")
           try soundRecorder = AVAudioRecorder(URL: getFileURL(), settings: recordSettings as [String : AnyObject])
            let session = AVAudioSession.sharedInstance()
            try!  session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            NSLog("recorder didnt work")
            print("recorder broke")
        }
        
        
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) //as [NSString]
        return paths[0]
    }
    
    func getFileURL() -> NSURL {
        var fileSize:UInt64 = 0
        //print("a")
        let path = getCacheDirectory().stringByAppendingString(fileName)
        //let path = getCacheDirectory().URLByAppendingPathComponent(fileName)
        //print("b")
        let filePath = NSURL(fileURLWithPath: path)
        //print("c")
        do {
            let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(path)
            if let _attr = attr {
                fileSize = _attr.fileSize();
                print("file size: \(fileSize)")
            }
        } catch {
            NSLog("file size didnt work")
        }

        return filePath
    }
    
    @IBAction func Record(sender: UIButton) {
        if sender.titleLabel?.text == "Record" {
            //soundRecorder.record()
            let audioDuration : NSTimeInterval = 60.0
            soundRecorder.recordForDuration(audioDuration)
            sender.setTitle("Stop", forState: .Normal)
            playButton.enabled = false
            
        } else {
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
            playButton.enabled = false
            
        }
    }


    @IBAction func playSound(sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            recordButton.enabled =  false
            sender.setTitle("Stop", forState: .Normal)
            preparePlayer()
            print("after prepare player")
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            recordButton.enabled = true
            sender.setTitle("Play", forState: .Normal)
        }
    }
    
    func preparePlayer() {
        
        var error : NSError?
        var fileSize : UInt64 = 0
        
        do {
            print("before soundplayer")
            print("\(getFileURL())")
            try soundPlayer = AVAudioPlayer(contentsOfURL: getFileURL())

            print("after soundplayer")
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            NSLog("player didnt work")
            print(error)
        }
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.enabled = true
        recordButton.setTitle("Record", forState: .Normal)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled =  true
        playButton.setTitle("Play", forState: .Normal)
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
