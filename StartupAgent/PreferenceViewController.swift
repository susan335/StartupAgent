//
//  PreferenceViewController.swift
//  StartupAgent
//
//  Created by Yohta Watanave on 2017/05/12.
//  Copyright © 2017年 Yohta Watanave. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferenceViewController: NSViewController {

    @IBOutlet weak var checkbox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    private var itemReferencesInLoginItems: (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        guard let loginItems = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList?
            else { return (nil, nil) }
        
        let loginItemsCopy = LSSharedFileListCopySnapshot(loginItems, nil).takeRetainedValue() as NSArray as! [LSSharedFileListItem]
        guard !loginItemsCopy.isEmpty else { return(nil, kLSSharedFileListItemBeforeFirst.takeRetainedValue()) }

        let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
        let itemUrl = UnsafeMutablePointer<Unmanaged<CFURL>?>.allocate(capacity: 1)
        defer { itemUrl.deallocate(capacity: 1) }
        
        for item in loginItemsCopy {
            if let itemUrl = LSSharedFileListItemCopyResolvedURL(item, 0, nil), (itemUrl.takeRetainedValue() as URL) == appUrl {
                return (item, loginItemsCopy.last)
            }
        }
        return (nil, loginItemsCopy.last)
    }
    
    @IBAction func checkboxDidValueChange(_ sender: Any) {
        guard let checkbox = sender as? NSButton else { return }
        
        let itemReferences = itemReferencesInLoginItems
        let isSet = itemReferences.existingReference != nil
        let type = kLSSharedFileListSessionLoginItems.takeUnretainedValue()
        if let loginItemsRef = LSSharedFileListCreate(nil, type, nil).takeRetainedValue() as LSSharedFileList? {
            
            if checkbox.state == NSOnState && !isSet {
                let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL
                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
            }
            else if checkbox.state != NSOnState && isSet, let itemRef = itemReferences.existingReference {
                LSSharedFileListItemRemove(loginItemsRef, itemRef)
            }
        }
    }
}
