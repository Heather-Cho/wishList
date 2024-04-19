//
//  File.swift
//  0415
//
//  Created by t2023-m0114 on 4/15/24.
//

import Foundation

struct RemoteProduct: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
    
    //추가
    let category: String
    let brand: String
}
