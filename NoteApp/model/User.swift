//
//  User.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 20/7/24.
//

import Foundation

struct User: Codable {
    var id: UUID
    var fullName: String
    var email: String
    var username: String
    var createdAt: Date
    var updatedAt: Date
    var isEmailVerified: Bool
    var status: String
}
