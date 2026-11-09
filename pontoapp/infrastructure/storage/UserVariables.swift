//
//  UserVariables.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 09/11/26.
//

import Foundation

enum UserVariables {
//    static var appleID: String?
//    static var email: String?
    static var name: String {
        get { UserDefaults.standard.string(forKey: "name") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "name") }
    }
//    static var hasSelectedMemoji: Bool = false
//    static var hasCompletedFirstCheckIn: Bool = false
//    static var hasCompletedTutorial: Bool = false
//    static var hasSeenWelcome: Bool = false
//    static var memoji: String = ""
    static var studentID: String {
        get { UserDefaults.standard.string(forKey: "studentId") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "studentId") }
    }
    //static var userID: String?
}
