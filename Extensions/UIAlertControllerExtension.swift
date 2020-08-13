//
//  UIAlertControllerExtension.swift
//  TodoApp
//
//  Created by Trần Huy on 8/12/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

private var DatePickerHelperKey: UInt8 = 0
extension UIAlertController {
    func addDatePicker(_ configuration: @escaping(UITextField, UIDatePicker) -> Void) {
        addTextField(configurationHandler: {(tf) in
            let dp = UIDatePicker()
            configuration(tf, dp)
            tf.inputView = dp
            
            let helper = AlertDatePickerHelper(textField: tf, datePicker: dp)
            objc_setAssociatedObject(tf, &DatePickerHelperKey, helper, .OBJC_ASSOCIATION_RETAIN)
        })
    }
    
    var datePickers: Array<UIDatePicker?>? {
        guard let fields = textFields else { return nil}
        return fields.map{$0.inputView as? UIDatePicker }
    }
    
    class AlertDatePickerHelper: NSObject {
        
        weak var textField: UITextField?
        let formatter: DateFormatter
        
        init(textField: UITextField, datePicker: UIDatePicker) {
            self.textField = textField
            formatter = DateFormatter()
            
            super.init()
            
            switch datePicker.datePickerMode {
                case .date:
                    formatter.dateStyle = .long
                    formatter.timeStyle = .none
                case .dateAndTime:
                    formatter.dateStyle = .long
                    formatter.timeStyle = .long
                case .time:
                    formatter.dateStyle = .none
                    formatter.timeStyle = .long
                default:
                    fatalError("Unsupported date picker mode")
            }
            
            datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        }
        
        @objc func datePickerChanged(_ datePicker: UIDatePicker) {
            textField?.text = formatter.string(from: datePicker.date)
        }
        
    }
}
