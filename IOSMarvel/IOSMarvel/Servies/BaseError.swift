//
//  BaseError.swift
//  Structure_IOS
//
//  Created by DaoLQ on 10/23/17.
//  Copyright © 2017 DaoLQ. All rights reserved.
//

import Foundation

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)

    public var errorMessage: String? {
        switch self {
        case .networkError:
            return "Network Error"
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let error):
            if let error = error {
                return error.message
            }
            return "Error"
        default:
            return "Unexpected Error"
        }
    }

    private func getHttpErrorMessage(httpCode: Int) -> String? {
        if (300...308).contains(httpCode) {
            // Redirection
            return "It was transferred to a different URL. I'm sorry for causing you trouble"
        }
        if ( 400...451).contains(httpCode) {
            // Client error
            return "An error occurred on the application side. Please try again later!"
        }
        if (500...511).contains(httpCode) {
            // Server error
            return "A server error occurred. Please try again later!"
        }
        // Unofficial error
        return "An error occurred. Please try again later!"
    }
}
