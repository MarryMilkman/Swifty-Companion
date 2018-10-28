//
//  Data.swift
//  Companion
//
//  Created by Ivan SELETSKYI on 10/16/18.
//  Copyright © 2018 Ivan SELETSKYI. All rights reserved.
//

let MY_AWESOME_UID = "4e9a213bc3518dca219fac6ba22e233b04082709c0b2cef5b21bcc4d9fb883fe"
let MY_AWESOME_SECRET = "24e50c902a6a088b39c8079c1d9286633c333cbe49cf9189d59319b642af44b0"

var tokenObj: AnyObject?


struct dataUser: Decodable {
    var cursus_users: [cursesUser]
    var displayname: String
    var email: String
    var image_url: String
    var location: String?
    var login: String
    var phone: String?
    var projects_users: [projectUser]
}

// curs

struct cursesUser: Decodable {
    var level: Float
    var skills: [skillStruct]
    var cursus: cursusStruct
}

struct cursusStruct: Decodable {
    var name: String
}

struct skillStruct: Decodable {
    var name: String
    var level: Float
}

// projects_user

struct projectUser: Decodable {
    var final_mark: Int?
    var project: projectStruct
    var status: String
    var occurrence: Int?
    var validated: Int?
}

struct projectStruct: Decodable {
    var slug: String
    var name: String
    var parent_id: Int?
}
