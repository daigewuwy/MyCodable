//
//  ViewController.swift
//  MTACodable
//
//  Created by 吴伟毅 on 11/12/2024.
//  Copyright (c) 2024 吴伟毅. All rights reserved.
//

import UIKit

import MTACodable

@DecodeMembers
struct User {
    var name: String
    var age: Int
}


@propertyWrapper
class Decode<T> {
    
    var value: T
    
    var wrappedValue: T {
        set {
            value = newValue
            print("type is \(T.self) value is \(value)")
        }
        get {
            value
        }
    }
    
    init(value: T) {
        self.value = value
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

