//
//  Constant.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import UIKit
import SwiftHash

let heightTabbar = 49.0
let heightStatusBar = 20.0
let heightNavigationBar = 44.0
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let apiKey = "ce6b7d1982c52510f98eeec62180f202"
let privateKey = "98a64f8db0d6b8136c63bdf5818b538c75d46dbc"
let tsInt = 1
let hash = MD5("\(tsInt)" + privateKey + apiKey).lowercased()
let appName = "Marvel"
