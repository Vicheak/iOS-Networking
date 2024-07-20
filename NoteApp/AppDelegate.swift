//
//  AppDelegate.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //test login screen
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "TestViewController")
    
//        window?.rootViewController = UINavigationController(rootViewController: LoginScreenViewController())
        
        
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = LoginScreenViewController()
        }
        window?.makeKeyAndVisible()

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .systemBackground
        
        let navigationBarScrollAppearance = UINavigationBarAppearance()
        navigationBarScrollAppearance.configureWithDefaultBackground()
        navigationBarScrollAppearance.backgroundColor = .customBackgroundColor
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .customBackgroundColor
        
        let tabBarScrollAppearance = UITabBarAppearance()
        tabBarScrollAppearance.configureWithDefaultBackground()
        tabBarScrollAppearance.backgroundColor = .customBackgroundColor
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarScrollAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarScrollAppearance
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //remove all files from tmp directory
        FileUtil.deleteAllTmpFile()
        
        try? CoreDataManager.shared.context.save()
    }

}

