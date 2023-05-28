//
//  Array+Extension.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import Foundation

extension Array where Element: Hashable {
    func uniqueElements() -> [Element] {
        var uniqueElements = Set<Element>()
        return filter { uniqueElements.insert($0).inserted }
    }
}
