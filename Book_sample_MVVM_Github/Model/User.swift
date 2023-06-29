//
//  User.swift
//  Book_sample_MVVM_Github
//
//  Created by Taki on 2023/06/28.
//

import Foundation

final class User {
    let id: Int
    let name: String
    let iconUrl: String
    let webUrl: String
    
    init(attributes: [String: Any]) {
        id = attributes["id"] as! Int
        name = attributes["login"] as! String
        iconUrl = attributes["avatar_url"] as! String
        webUrl = attributes["html_url"] as! String
    }
}
