//
//  extention.swift
//  on the Map Wael
//
//  Created by Wael Yazqi on 2019-06-28.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
}
}
