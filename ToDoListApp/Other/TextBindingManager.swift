//
//  TextBindingManager.swift
//  takko
//
//  Created by Ying-Ying Lin on 5/2/20.
//  Copyright © 2020 yl. All rights reserved.
//

import SwiftUI

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        } // didset
    } // text
    
    let characterLimit: Int

    init(limit: Int = 5) {
        characterLimit = limit
    }
}
