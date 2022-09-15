//
//  ImageData.swift
//  RealmImageSample
//
//  Created by Tomoya Tanaka on 2022/09/16.
//

import Foundation
import RealmSwift

class Image: Object {
    @Persisted var data: Data
}

