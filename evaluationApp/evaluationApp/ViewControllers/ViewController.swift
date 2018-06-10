//
//  ViewController.swift
//  evaluationApp
//
//  Created by Rafal Kowalik on 10.06.2018.
//  Copyright © 2018 rafkow. All rights reserved.
//

import UIKit
import SDWebImage

let kiPhone6Plus = "iPhone7,1"

class ViewController: UIViewController{
    
    //MARK: Properties
    public var myArray : [mainItem] = []
    private var tableView: UITableView!
    private var detailVC: DetailViewController!
    private var selectDefaultValue = -1;
    private var loading = false;
    
    private var barHeight: CGFloat{
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    private var displayWidth: CGFloat{
        return self.view.frame.width;
    }
    
    private var displayHeight: CGFloat{
        return self.view.frame.height;
    }
    
    private var isiPadOr6P: Bool{
        return (UIDevice.current.userInterfaceIdiom == .pad || UIDevice.getModelIdentifier() == kiPhone6Plus)
    }
    
    func getFirstArticle(){
        if(UIDevice.current.orientation.isLandscape && isiPadOr6P){
            if(selectDefaultValue == -1 && !loading){
                loading = true;
                getDataForDetailViewController(forUrl: myArray[0].name)
            }
        }
    }
    
    func selectDefaultIndexPathForiPadLandscape(forViewController viewController: UIViewController){
        if(selectDefaultValue == -1){
            getFirstArticle()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            if let cell =  tableView.cellForRow(at: indexPath), let cellText = cell.textLabel{
                cellText.textColor = UIColor.white
                self.view.addSubview(viewController.view)
            }
        } else {
            self.view.addSubview(viewController.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDetailViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureColorForCell(forCell cell: UITableViewCell){
        let view = UIView()
        view.backgroundColor = UIColor.red
        cell.selectedBackgroundView = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayoutTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Setup methods from viewDidLoad
    
    func setupTableView(){
        let heightTB = displayHeight - barHeight
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: heightTB))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    
    func setupDetailViewController(){
        detailVC = instantiateDetailViewController() as! DetailViewController
    }
    
    func instantiateDetailViewController() ->UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "detailVCId")
        
        return controller
    }
    
    func setTableViewFrame(){
        self.tableView.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight)
    }
    
    func removeSubviewFromSuperview(withTag tag: Int){
        for subView in self.view.subviews{
            if(subView.tag == tag){
                subView.removeFromSuperview()
            }
        }
    }
    
    func updateLayoutTableView(){
        if(UIDevice.current.orientation.isLandscape && isiPadOr6P){
            let widthTB = displayWidth/3
            self.tableView.frame = CGRect(x: 0, y: barHeight, width: widthTB, height: displayHeight - barHeight)
            
            let widthDetailVC = displayWidth - widthTB
            detailVC.view.frame = CGRect(x: widthTB, y: barHeight, width: widthDetailVC, height: displayHeight)
            detailVC.view.tag = 99
            detailVC.navigationBar.isHidden = true;
            selectDefaultIndexPathForiPadLandscape(forViewController: detailVC)
        } else {
            removeSubviewFromSuperview(withTag:99)
            detailVC.view.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight)
            detailVC.navigationBar.isHidden = false
            setTableViewFrame()
        }
    }
    
    //MARK: Networking functions
    
    func getDataForDetailViewController(forUrl url: String){
        NetworkEngine.getDataForDetailView(url: url, withCompletionHandler: { json in
            guard let text = json["text"] else {
                return
            }
            
            guard let image = json["image"] else {
                return
            }
            
            self.detailVC.imgView.sd_setImage(with: URL(string:("\(image)")), placeholderImage: UIImage(named: "placeholder.png"), options: .refreshCached, completed: nil)
            
            DispatchQueue.main.async {
                self.detailVC.labelText.text = ("\(text)")
                self.detailVC.view.frame = CGRect(x: 0, y: self.barHeight, width: self.displayWidth, height: self.displayHeight)
                self.detailVC.navigationBar.topItem?.title = ("\(text)")
                self.view.addSubview(self.detailVC.view)
            }
        })
    }
}

//MARK: UITableView Delegate methods
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectDefaultValue = indexPath.row
        
        self.removeSubviewFromSuperview(withTag: 99)
        self.removeSubviewFromSuperview(withTag: 66)
        self.detailVC.view.tag = 66
        self.detailVC.viewFromMain = self.view
        if let cell = tableView.cellForRow(at: indexPath){
            configureColorForCell(forCell: cell)
            cell.textLabel?.textColor = UIColor.white
        }
        getDataForDetailViewController(forUrl: myArray[indexPath.row].name)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        if let cell = tableView.cellForRow(at: indexPath){
            cell.selectedBackgroundView = view
            cell.textLabel?.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        
        if let cell = tableView.cellForRow(at: indexPath){
            cell.selectedBackgroundView = view
        }
    }
}

//MARK: UITableViewController datasource methods
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        configureColorForCell(forCell: cell)
        if(myArray.count > 0){
            cell.textLabel!.text = "\(myArray[indexPath.row].name)"
            cell.imageView?.sd_setImage(with: URL(string: myArray[indexPath.row].url), placeholderImage: UIImage(named: "placeholder.png"), options: .refreshCached, completed: nil)
        }
        return cell
    }
}

//MARK: UIDevice extension
public extension UIDevice {
    static func getModelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
