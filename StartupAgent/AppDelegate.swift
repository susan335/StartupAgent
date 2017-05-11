//
//  AppDelegate.swift
//  StartupAgent
//
//  Created by Yohta Watanave on 2017/05/12.
//  Copyright © 2017年 Yohta Watanave. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = NSImage(named: "MenuIcon")
        icon?.isTemplate = true // best for dark mode
        self.statusItem.image = icon
        self.statusItem.menu = self.menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        return .terminateNow
    }
}

