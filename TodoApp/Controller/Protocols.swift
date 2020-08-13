//
//  Protocols.swift
//  TodoApp
//
//  Created by Trần Huy on 8/11/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
protocol MessageProtocol {
    func handlerAddTask(for message: MessageController)
}
