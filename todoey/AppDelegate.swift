//
//  AppDelegate.swift
//  todoey
//
//  Created by arjun adappa on 30/07/19.
//  Copyright © 2019 arjun adappa. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
            _ = try Realm()
        }catch{
            print("Error initialising new realm, \(error)")
        }
        return true
    }

                          



}

