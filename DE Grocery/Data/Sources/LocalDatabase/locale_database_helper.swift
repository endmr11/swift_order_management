//
//  locale_database_helper.swift
//  DE Grocery
//
//  Created by Eren Demir on 22.05.2022.
//

import Foundation


class LocaleDatabaseHelper {
    
    static let localStorage = UserDefaults.standard
    let currentUserEmail:String? = localStorage.string(forKey: LocaleDatabaseConstants.userEmailKey)
    let isLoggedIn:Bool? = localStorage.bool(forKey: LocaleDatabaseConstants.userLoggedInKey)
    let currentUserId:Int? = localStorage.integer(forKey: LocaleDatabaseConstants.userIdKey)
    let currentUserName:String? = localStorage.string(forKey: LocaleDatabaseConstants.userNameKey)
    let currentUserSurname:String? = localStorage.string(forKey: LocaleDatabaseConstants.userSurnameKey)
    let currentUserToken:String? = localStorage.string(forKey: LocaleDatabaseConstants.userTokenKey)
    let currentUserType:Int? = localStorage.integer(forKey: LocaleDatabaseConstants.userTypeKey)
    let isLight:Bool? = localStorage.bool(forKey: LocaleDatabaseConstants.userThemeKey)
    let currentUserLang:String? = localStorage.string(forKey: LocaleDatabaseConstants.userLangKey)
    
    func setCurrentUserMail(userEmail:String?){
        if userEmail != nil {
            LocaleDatabaseHelper.localStorage.set(userEmail, forKey: LocaleDatabaseConstants.userEmailKey)
        }
    }
    
    func setCurrentUserLoggedIn(loggedIn:Bool?){
        if loggedIn != nil {
            LocaleDatabaseHelper.localStorage.set(loggedIn, forKey: LocaleDatabaseConstants.userLoggedInKey)
        }
    }
    func setCurrentUserId(userId:Int?){
        if userId != nil {
            LocaleDatabaseHelper.localStorage.set(userId, forKey: LocaleDatabaseConstants.userIdKey)
        }
    }
    func setCurrentUserName(userName:String?){
        if userName != nil {
            LocaleDatabaseHelper.localStorage.set(userName, forKey: LocaleDatabaseConstants.userNameKey)
        }
    }
    func setCurrentUserSurname(userSurname:String?){
        if userSurname != nil {
            LocaleDatabaseHelper.localStorage.set(userSurname, forKey: LocaleDatabaseConstants.userSurnameKey)
        }
    }
    func setCurrentUserToken(token:String?){
        if token != nil {
            LocaleDatabaseHelper.localStorage.set(token, forKey: LocaleDatabaseConstants.userTokenKey)
        }
    }
    func setCurrentUserType(userType:Int?){
        if userType != nil {
            LocaleDatabaseHelper.localStorage.set(userType, forKey: LocaleDatabaseConstants.userTypeKey)
        }
    }
    func setCurrentUserTheme(isLight:Bool?){
        if isLight != nil {
            LocaleDatabaseHelper.localStorage.set(isLight, forKey: LocaleDatabaseConstants.userThemeKey)
        }
    }
    func setCurrentUserLang(lang:String?){
        if lang != nil {
            LocaleDatabaseHelper.localStorage.set(lang, forKey: LocaleDatabaseConstants.userLangKey)
        }
    }
    
    func userSessionClear() {
        LocaleDatabaseHelper.localStorage.removeObject(forKey: LocaleDatabaseConstants.userEmailKey)
        LocaleDatabaseHelper.localStorage.removeObject(forKey: LocaleDatabaseConstants.userIdKey)
        LocaleDatabaseHelper.localStorage.removeObject(forKey: LocaleDatabaseConstants.userNameKey)
        LocaleDatabaseHelper.localStorage.removeObject(forKey: LocaleDatabaseConstants.userSurnameKey)
        LocaleDatabaseHelper.localStorage.removeObject(forKey: LocaleDatabaseConstants.userTokenKey)
        LocaleDatabaseHelper.localStorage.removeObject(forKey: LocaleDatabaseConstants.userTypeKey)
        LocaleDatabaseHelper.localStorage.removeObject(forKey: LocaleDatabaseConstants.userLoggedInKey)
    }
}
