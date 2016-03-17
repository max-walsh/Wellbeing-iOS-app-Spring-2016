//
//  Recording.swift
//  WellnessApp
//
//  Created by Max Walsh on 3/15/16.
//  Copyright © 2016 anna. All rights reserved.
//

import Foundation
import AVFoundation

class Recording {
    
    
    var recordSettings = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
}