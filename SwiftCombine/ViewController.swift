//
//  ViewController.swift
//  SwiftCombine
//
//  Created by Ali Shaker on 02/01/2024.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var inputTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriber()
        
    }
    
    fileprivate func setupSubscriber() {
        // prepare publisher
        let newStringPublisher = NotificationCenter.Publisher(center: .default, name: .newString).map({ (notification) -> String? in
            return (notification.object as? String)
        })
        
        // prepare subscriber
        let viewLblSubscriber = Subscribers.Assign(object: viewLbl, keyPath: \.text)
        newStringPublisher.subscribe(viewLblSubscriber)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldChanges = textField.text ?? ""
        var finalString = ""
        if string.isEmpty {
            finalString = String(oldChanges.dropLast())
        } else {
            finalString = oldChanges + string
        }
        NotificationCenter.default.post(name: .newString, object: finalString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Notification.Name {
    static let newString = Notification.Name("new_string")
}

