//
//  Message.swift
//  FlashChat
//
//  Created by Evgeniy Uskov on 19.12.2020.
//

import Foundation

class Message {
    
    var text: String
    var user: String
    
    init(text: String, user: String) {
        self.text = text
        self.user = user
    }
}

