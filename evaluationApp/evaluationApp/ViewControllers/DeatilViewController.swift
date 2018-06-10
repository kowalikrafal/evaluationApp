//
//  DeatilViewController.swift
//  evaluationApp
//
//  Created by Rafal Kowalik on 10.06.2018.
//  Copyright © 2018 rafkow. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    
    var viewFromMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: Any) {
        for subView in self.viewFromMain.subviews{
            if(subView.tag == 66){
                subView.removeFromSuperview()
            }
        }
    }
}
