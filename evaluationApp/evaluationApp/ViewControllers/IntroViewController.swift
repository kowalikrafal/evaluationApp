//
//  IntroViewController.swift
//  evaluationApp
//
//  Created by Rafal Kowalik on 10.06.2018.
//  Copyright © 2018 rafkow. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewController: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        setupViewController()
        getDataForViewController()
    }
    
    //hsabdls
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewController(){
        viewController = instantiateViewController() as! ViewController
    }
    
    func instantiateViewController()-> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "viewControllerID")
        
        return controller
    }
    
    func getDataForViewController(){
        NetworkEngine.getJSON(forUrl: "http://dev.tapptic.com/test/json.php", withCompletionHandler: {json in
            let items = json as NSArray
            for item in items{
                let itemToPass = item as! [String : String]
                if let name = itemToPass["name"], let url = itemToPass["image"]{
                    self.viewController.myArray.append(mainItem(name: name , url: url))
                }
            }
            
            DispatchQueue.main.async {
                self.present(self.viewController, animated: true, completion: nil)
            }
        })
    }
}
