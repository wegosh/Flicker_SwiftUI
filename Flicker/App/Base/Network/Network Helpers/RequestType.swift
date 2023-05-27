//
//  RequestType.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

enum RequestType{
    case raw
    case urlEncodableForm
    case none
    
    var contentTypeField: String?{
        if case .none = self{
            return nil
        }
        return "Content-Type"
    }
    
    var value: String{
        switch self {
        case .raw:
            return "application/json"
        case .urlEncodableForm:
            return "x-www-form-urlencoded"
        case .none:
            return ""
        }
    }
}
