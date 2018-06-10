//
//  mainItem.swift
//  evaluationApp
//
//  Created by Rafal Kowalik on 10.06.2018.
//  Copyright © 2018 rafkow. All rights reserved.
//

import UIKit

class mainItem: NSObject {
    
    var name: String
    var url :String
    
    init(name: String, url: String){
        self.name = name
        self.url = url
    }
}
