//
//  StringExtensions.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/2/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation

extension String {
  func separate(every stride: Int = 4, with separator: Character = "-") -> String {
    return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
  }
}
