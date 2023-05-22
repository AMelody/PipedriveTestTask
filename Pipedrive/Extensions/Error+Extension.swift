//
//  Error+Extension.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/22/23.
//

import Foundation

// MARK: -

extension Error {

    var isURLSessionCancelled: Bool {
        let error = self as NSError
        guard error.domain == URLError.errorDomain else { return false }

        return error.code == URLError.cancelled.rawValue
    }

    var noNetworkConnection: Bool {
        let error = self as NSError
        guard error.domain == URLError.errorDomain else { return false }

        return error.code == NSURLErrorCannotConnectToHost ||
            error.code == NSURLErrorNetworkConnectionLost ||
            error.code == NSURLErrorNotConnectedToInternet ||
            error.code == NSURLErrorSecureConnectionFailed
    }
}
