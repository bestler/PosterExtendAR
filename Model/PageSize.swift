//
//  PageSize.swift
//  
//
//  Created by Simon Bestler on 12.04.23.
//

import Foundation

enum PageSize: String, CaseIterable {
    case DINA4, DINA3, DINA2, DINA1, DINA0

    func getWidhtAndHeight() -> (Float, Float) {
        switch self {
        case .DINA4:
            return (0.297, 0.21)
        case .DINA3:
            return (0.42, 0.297)
        case .DINA2:
            return (0.594, 0.42)
        case .DINA1:
            return (0.841, 0.594)
        case .DINA0:
            return (1.189, 0.841)
        }
    }

    func getWidth() -> Float {
        switch self {
        case .DINA4:
            return 0.297
        case .DINA3:
            return 0.42
        case .DINA2:
            return 0.594
        case .DINA1:
            return 0.841
        case .DINA0:
            return 1.189
        }
    }

    func gethHeight() -> Float {
        switch self {
        case .DINA4:
            return 0.21
        case .DINA3:
            return 0.297
        case .DINA2:
            return 0.42
        case .DINA1:
            return 0.594
        case .DINA0:
            return 0.841
        }
    }
}

