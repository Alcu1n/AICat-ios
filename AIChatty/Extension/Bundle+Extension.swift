//
//  Bundle+Extension.swift
//  AIChatty
//

import Foundation

extension Bundle {
    var releaseVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
