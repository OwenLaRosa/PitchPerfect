//
//  RecordAudio.swift
//  Pitch Perfect
//
//  Created by Owen LaRosa on 12/1/14.
//  Copyright (c) 2014 Owen LaRosa. All rights reserved.
//

import Foundation

/// Model class for recorded audio. Stores properties for the file's title and path.
class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init(url: NSURL, title:String) {
        self.filePathUrl = url
        self.title = title
    }
}