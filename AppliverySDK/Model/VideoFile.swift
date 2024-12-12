//
//  VideoFile.swift
//  Applivery
//
//  Created by Fran Alarza on 2/12/24.
//

import Foundation

struct VideoFile: Decodable {
    let status: Bool
    let data: ViedeoFileData
}

struct ViedeoFileData: Decodable {
    let videoFile: VideoLocationInfo
}

struct VideoLocationInfo: Decodable {
    let bucket: String
    let key: String
    let location: String
}
