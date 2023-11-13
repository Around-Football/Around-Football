//
//  StreamError.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
