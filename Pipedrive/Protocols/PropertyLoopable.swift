//
//  PropertyLoopable.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/22/23.
//

import Foundation

// MARK: -

protocol PropertyLoopable
{
    func allProperties() -> [String: Any]
}

// MARK: -

extension PropertyLoopable
{
    func allProperties() -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle, style == .struct || style == .class else {

            return [:]
        }

        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe else {
                continue
            }

            result[label] = valueMaybe
        }

        return result
    }
}
