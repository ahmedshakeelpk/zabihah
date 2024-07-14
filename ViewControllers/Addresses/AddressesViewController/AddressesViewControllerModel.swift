//
//  AddressesViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 14/07/2024.
//

import Foundation

// MARK: - ModelGetUserAddressResponse
struct ModelGetUserAddressResponse: Codable {
    let id, title, message: String?
    let status: Int?
}
