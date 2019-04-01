//
//  ViewController.swift
//  PersistenceBrianW
//
//  Created by Brian Wawczak on 3/31/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate static let rootKey = "rootKey"
    @IBOutlet var lineFields:[UITextField]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fileURL = self.dataFileURL()
        if (FileManager.default.fileExists(atPath: fileURL.path!)) {
            if let array = NSArray(contentsOf: fileURL as URL) as? [String] {
                for i in 0..<array.count {
                    lineFields[i].text = array[i]
                }
            }
            
            let data = NSMutableData(contentsOf: fileURL as URL)
            let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data! as Data)
            
            let fourLines = unarchiver!.decodeObject(forKey: ViewController.rootKey) as! FourLines
            unarchiver!.finishDecoding()
            if let newLines = fourLines.lines {
                for i in 0..<newLines.count {
                    lineFields[i].text = newLines[i]
                }
            }
        }
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: app)
    }
    
    @objc func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        let fourLines = FourLines()
        let array = (self.lineFields as NSArray).value(forKey: "text") as! [String]
        fourLines.lines = array
        
        //let data = NSMutableData()
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        let data = archiver.encodedData
        //let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(fourLines, forKey: ViewController.rootKey)
        archiver.finishEncoding()
        do {
            try data.write(to: fileURL as URL)
        } catch {
            print("Error is \(error)")
        }
    }

    func dataFileURL() -> NSURL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        url = URL(fileURLWithPath: "") as NSURL
        url = urls.first!.appendingPathComponent("data.archive") as NSURL
        
        return url!
    }
}

