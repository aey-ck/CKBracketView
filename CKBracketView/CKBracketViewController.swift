//
//  ViewController.swift
//  CKBracketUsingPanGesture
//
//  Copyright © 2017 Akhil CK. All rights reserved.
//

import UIKit

class CKBracketViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    let contentView = UIView()
    var numberOfRounds:Int  = 4
    var matchesInSection:[Int] = [8,4,2,1]
    var series:[[[String:AnyObject]]] = []
    
    var tableViewW = CGFloat(UIScreen.main.bounds.width * 0.8)
    var tableViewY = CGFloat(25)
    var tableViewX = CGFloat(0)
    var tableViewH = CGFloat(UIScreen.main.bounds.height - 40 ) //64+40
    
    var tableViewDict:[UITableView:Int] = [:]
  
    
    var translationX:CGFloat = 0
    var mainW = UIScreen.main.bounds.width
    
    var tableViewArray: [UITableView] = []
    
    var currentPage = 0{
        didSet{
            for table in tableViewArray{
                table.frame.origin.y = tableViewY
                table.beginUpdates()
                table.endUpdates()
            }
        }
    }
    
    //var didViewLoad = false
    
    
    var cellHeight:CGFloat = 190
    let shrinkedCellHeight:CGFloat = 95
    
    var gest:UIPanGestureRecognizer?   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRounds()
        addPanGestureOverTableView()
       
    }
    
    
    func addPanGestureOverTableView(){
        
        contentView.frame = CGRect(x: 0, y: 20, width: CGFloat(numberOfRounds) * mainW, height: self.view.frame.height)
        self.view.addSubview(contentView)
        
        gest = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(panGesture:)))
        gest?.minimumNumberOfTouches = 1
        self.contentView.addGestureRecognizer(gest!)
        
    }
    
    
    func addRounds(){
        
        for index in 0..<numberOfRounds{
            
            let table = UITableView()
            table.frame = CGRect(x: tableViewX, y: tableViewY, width: tableViewW, height: tableViewH)
            tableViewX += tableViewW
            
            table.delegate = self
            table.dataSource = self
            table.register(UINib(nibName: "CKBracketCell", bundle: nil), forCellReuseIdentifier: "CKBracketCell")
            table.separatorStyle = .none
            table.showsVerticalScrollIndicator = false
            
            tableViewDict[table] =  matchesInSection[index]
            
            tableViewArray.append(table)
            self.contentView.addSubview(table)
            
            table.reloadData()
            
            
        }
        
    }
    
    //MARK: TableViewDataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewDict[tableView]!
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CKBracketCell", for: indexPath) as! CKBracketCell
        cell.title.text = "Match Name"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if currentPage - 1 >= 0{
            
            
            if tableView == tableViewArray[currentPage - 1]{
                
                return shrinkedCellHeight
                
            }else if tableView == tableViewArray[currentPage]{
                
                
                return  cellHeight
            }
            else{
                
                if currentPage + 1 < tableViewArray.count{
                    
                    if tableView == tableViewArray[currentPage + 1]{
                        
                        if currentPage + 1 == tableViewArray.count - 1{
                            return cellHeight*2 // For now only - need to replace this
                            
                        }else{
                            
                            return  CGFloat(currentPage+1) * cellHeight
                        }
                    }
                }
            }
            
            
        }else{//If current page is 0
            
            
            return tableView == tableViewArray[0]  ? cellHeight : 2*cellHeight
            
        }
        
        return 0
        
    }
    
    
    // MARK: PanGesture
    
    func panGestureHandler(panGesture recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        
        if  recognizer.state == .began ||  recognizer.state == .changed{
            
            
            recognizer.view!.center.x = recognizer.view!.center.x + translation.x
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
            translationX = translation.x
            
            
        }else if recognizer.state == .ended{
            
            
            if !recognizer.isLeft(theViewYouArePassing: self.contentView){//If gesture went right
                
                if currentPage == 0{
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0)
                        self.currentPage = 0
                    })
                    
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0 - (self.tableViewW  * CGFloat(self.currentPage - 1)))
                        self.currentPage -= 1
                    })
                    
                }
                
            }else{//Gesture went left
                
                if currentPage == tableViewArray.count - 1{
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0 - (self.tableViewW  * CGFloat(self.currentPage)))
                        
                    })
                    
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        recognizer.view!.frame.origin.x = CGFloat(0 - (self.tableViewW  * CGFloat(self.currentPage + 1)))
                        self.currentPage += 1
                    })
                    
                }
                
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let tablesCount = tableViewArray.count
        if tablesCount <= currentPage + 1{
            return
        }
        
        if scrollView == tableViewArray[currentPage + 1] && currentPage < tablesCount{
            tableViewArray[currentPage].contentOffset = scrollView.contentOffset
            
            
        }
        else if scrollView == tableViewArray[currentPage] && currentPage+1 < tablesCount{
            tableViewArray[currentPage+1].contentOffset = scrollView.contentOffset
        }
        
    }
    
    
}

extension UIPanGestureRecognizer {
    
    func isLeft(theViewYouArePassing: UIView) -> Bool {
        
        let velocityofView : CGPoint = velocity(in: theViewYouArePassing)
        
        if velocityofView.x > 0 {
            print("Gesture went right")
            return false
        } else {
            print("Gesture went left")
            return true
        }
    }
}

