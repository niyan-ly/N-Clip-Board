//
//  AppDelegate.swift
//  N Clip Board
//
//  Created by branson on 2019/9/8.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import OpenQuicklyX
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  var openQuicklyController: OpenQuicklyWindowController!
  let hk = HotKey(key: .space, modifiers: [.control])

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    let opqOptions = OpenQuicklyOptions()
    opqOptions.delegate = self
    openQuicklyController = OpenQuicklyWindowController(options: opqOptions)
    hk.keyDownHandler = {
      self.openQuicklyController.toggle()
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

extension AppDelegate: OpenQuicklyDelegate {
  func openQuickly(item: Any) -> NSView? {
    return nil
//    guard let language = item as? Language else { return nil }
//
//    let view = NSStackView()
//
//    let imageView = NSImageView(image: language.image)
//
//    let title = NSTextField()
//
//    title.isEditable = false
//    title.isBezeled = false
//    title.isSelectable = false
//    title.focusRingType = .none
//    title.drawsBackground = false
//    title.font = NSFont.systemFont(ofSize: 14)
//    title.stringValue = language.name
//
//    let subtitle = NSTextField()
//
//    subtitle.isEditable = false
//    subtitle.isBezeled = false
//    subtitle.isSelectable = false
//    subtitle.focusRingType = .none
//    subtitle.drawsBackground = false
//    subtitle.stringValue = language.subtitle
//    subtitle.font = NSFont.systemFont(ofSize: 12)
//
//    let text = NSStackView()
//    text.orientation = .vertical
//    text.spacing = 2.0
//    text.alignment = .left
//
//    text.addArrangedSubview(title)
//    text.addArrangedSubview(subtitle)
//
//    view.addArrangedSubview(imageView)
//    view.addArrangedSubview(text)
//
//    return view
  }
  
  func valueWasEntered(_ value: String) -> [Any] {
//    let matches = languages.filter {
//      $0.name.lowercased().contains(value.lowercased())
//    }
//
//    return matches
    print("valueWasEntered")
    return []
  }
  
  func itemWasSelected(selected item: Any) {
//    guard let language = item as? Language else { return }
//
//    print("\(language.name) was selected")
  }
  
  func searchBarClosed() {
    
  }
  
  
}
