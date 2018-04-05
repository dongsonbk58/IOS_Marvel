//
//  XibInitProtocol.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import UIKit

protocol XibInstantiatable: class {}
extension UIView: XibInstantiatable {}
extension UIViewController: XibInstantiatable {}

extension XibInstantiatable where Self: UIView {
    static func instantiateFromXib() -> Self {
        guard
            let view = UINib(nibName: String.init(describing: Self.self),
                             bundle: Bundle(for: Self.self)).instantiate(withOwner: nil, options: nil).first as? Self
            else { fatalError("Could not load view from nib.") }
        return view
    }
}

extension XibInstantiatable where Self: UIViewController {
    static func instantiateFromXib() -> Self {
        let nibName = String.init(describing: Self.self)
        let bundle = Bundle.init(for: Self.self)
        if bundle.path(forResource: nibName, ofType: "nib") != nil {
            return Self.init(nibName: nibName, bundle: bundle)
        } else {
            fatalError("Could not load view controller from nib.")
        }
    }
}
