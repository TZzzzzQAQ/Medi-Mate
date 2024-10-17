//
//  AuthManager.swift
//  Mobile
//
//  Created by Lykheang Taing on 09/09/2024.
//


import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    var token: String = ""
    
    private init() {}
}
