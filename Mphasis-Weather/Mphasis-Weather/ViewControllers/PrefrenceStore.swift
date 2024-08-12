//
//  PrefrenceStore.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import Foundation

class PrefrenceStore {
    func storeLastSearch(city: String){
        UserDefaults.standard.set(city, forKey: "lastSeachCity") //setObject
    }
    
    func retrieveLastSearch() -> String {
        if (UserDefaults.standard.string(forKey: "lastSeachCity") == nil) {
            return ""
        }
        return UserDefaults.standard.string(forKey: "lastSeachCity")!
    }
}
