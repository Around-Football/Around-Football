//
//  Constants.swift
//  Around-Football
//
//  Created by 진태영 on 10/11/23.
//

import Foundation

import FirebaseFirestore

let DB_REF = Firestore.firestore()

let REF_FIELD = DB_REF.collection("Field")
let REF_RECRUIT = DB_REF.collection("Recruit")
