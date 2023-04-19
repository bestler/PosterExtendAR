//
//  PageSize.swift
//  
//
//  Created by Simon Bestler on 12.04.23.
//

import Foundation

enum PageSize: String, CaseIterable {
    case A4, A3, A2, A1, A0

    func getWidhtAndHeight() -> (Float, Float) {
        switch self {
        case .A4:
            return (0.297, 0.21)
        case .A3:
            return (0.42, 0.297)
        case .A2:
            return (0.594, 0.42)
        case .A1:
            return (0.841, 0.594)
        case .A0:
            return (1.189, 0.841)
        }
    }

    func getWidth() -> Float {
        switch self {
        case .A4:
            return 0.297
        case .A3:
            return 0.42
        case .A2:
            return 0.594
        case .A1:
            return 0.841
        case .A0:
            return 1.189
        }
    }

    func gethHeight() -> Float {
        switch self {
        case .A4:
            return 0.21
        case .A3:
            return 0.297
        case .A2:
            return 0.42
        case .A1:
            return 0.594
        case .A0:
            return 0.841
        }
    }
}

