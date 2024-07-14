//
//  AddAddressViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 14/07/2024.
//

import Foundation

// MARK: - ModelEditUserAddressResponse
struct ModelEditUserAddressResponse: Codable {
    let id, title, message: String?
    let status: Int?
}
