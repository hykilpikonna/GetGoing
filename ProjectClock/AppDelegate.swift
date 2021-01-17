//
//  AppDelegate.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var alarmActivator: AlarmActivator!
    
    /// Override point for customization after application launch.
    func application(_ app: UIApplication, didFinishLaunchingWithOptions op: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Init default settings
        localStorage.register(defaults: [
            "alarms": JSON.stringify([Alarm(alarmTime: Date(), text: "Wake up lol", wakeMethod: wvms[0])])!
        ])
        
        // Start alarm activator
        alarmActivator = AlarmActivator()
        alarmActivator.start()
        
        return true
    }

    func application(_ app: UIApplication, configurationForConnecting session: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: session.role)
    }

    func application(_ app: UIApplication, didDiscardSceneSessions sessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

