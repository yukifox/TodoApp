//
//  MessageView.swift
//  TodoApp
//
//  Created by Trần Huy on 8/10/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UIKit

class MessageController: UIViewController {
    //MARK: - Properties
    private let message: Message
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var messageBtn: UIButton!
    var delegate: MessageProtocol?
    let messageLabel: UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    lazy var messageBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(messageBtnTapped), for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    //MARK: - Init
    init(message: Message) {
        self.message = message
        super.init(nibName: nil, bundle: nil)

    }
    
    convenience init(text: String, action: Message.Action? = nil) {
        let m = Message(text: text, action: action)
        self.init(message: m)
    }
    convenience init(text: String, actionTitle: String, actionHandler: @escaping () -> Void) {
        let m = Message(text: text, actionTitle: actionTitle, actionHandler: actionHandler)
        
        self.init(message: m)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
//    @IBAction func messageBtnTapped(_ sender: Any) {
//        message.action?.handler()
//    }
    
    
    //MARK: - Handler
    func initView() {
        
        view.backgroundColor = .white
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(messageBtn)
        messageBtn.translatesAutoresizingMaskIntoConstraints = false
        messageBtn.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        messageBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        messageLabel.text = message.text
        
        if let action = message.action {
            messageBtn.setTitle(action.title, for: .normal)
        } else {
            messageBtn.removeFromSuperview()
        }
    }
    
    @objc func messageBtnTapped() {
        message.action?.handler()
    }
    
    
    
   
    
    
    //MARK: - Protocol
    
}
