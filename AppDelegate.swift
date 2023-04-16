//
//  AppDelegate.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 16.04.23.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        FileManager.default.clearTempDirectory()
    }

}
