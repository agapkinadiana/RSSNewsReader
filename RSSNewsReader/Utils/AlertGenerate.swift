//
//  AlertGenerate.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 1.12.20.
//

import Foundation
import UIKit

struct AlertGenerate {
    static func alert(title: String?,
                      message: String?,
                      controller: UIViewController,
                      buttons: [String]?,
                      completion: ((UIAlertAction, UIViewController, Int) -> Void)?) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let buttons = buttons {
            for (index, text) in buttons.enumerated() {
                let action = UIAlertAction(title: text, style: .default) { (action) in
                    completion?(action, controller, index)
                }
                alert.addAction(action)
            }
        }
        else {
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                completion?(action, controller, 0)
            }
            alert.addAction(action)
        }

        return alert
    }
}
