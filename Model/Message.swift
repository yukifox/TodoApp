//
//  Message.swift
//  TodoApp
//
//  Created by Trần Huy on 8/10/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
struct Message {
    struct Action {
        let title: String
        let handler: () -> Void
    }
    let text: String
    let action: Action?
    
    init(text: String, action: Action? = nil) {
        self.text = text
        self.action = action
    }
    
    init(text: String, actionTitle: String, actionHandler: @escaping() -> Void) {
        self.text = text
        self.action = Action(title: actionTitle, handler: actionHandler)
    }
}
