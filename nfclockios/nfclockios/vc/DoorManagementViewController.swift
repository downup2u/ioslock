//
//  DoorManagementViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-3-31.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class DoorManagementViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.backgroundColor = UIColor.whiteColor()
        
        var searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLockCallback:", name: "onLockCallback", object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onLockCallback(notification: NSNotification){
        collectionView.reloadData()
    }

    @IBOutlet var collectionView: UICollectionView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: <UICollectionViewDataSource>
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var ilock = GlobalSessionUser.shared.ownerLockArray.count
        return ilock + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var collectionViewCell:UICollectionViewCell!
        if(indexPath.row == 0){
            collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("celladdlock", forIndexPath: indexPath) as! UICollectionViewCell
            var btnaddlock = collectionViewCell.viewWithTag(101) as! UIButton
            btnaddlock.addTarget(self, action: "onClickAddnew:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        else{
            var  curLock = GlobalSessionUser.shared.ownerLockArray[indexPath.row - 1]
            collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
            var btnlock = collectionViewCell.viewWithTag(101) as! UIButton
            var labelname = collectionViewCell.viewWithTag(102) as! UILabel
            var labelposition = collectionViewCell.viewWithTag(103) as! UILabel
            
            btnlock.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#E2E8F6")), forState: UIControlState.Normal)
            btnlock.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btnlock.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#213F7F")), forState: UIControlState.Selected)
            btnlock.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            
//            btnlock.layer.borderColor = UIColor.clearColor().CGColor
//            btnlock.layer.borderWidth = 1
//            btnlock.layer.cornerRadius = 6
//            btnlock.layer.masksToBounds = true
            
            var lockposition = curLock.lockposition
            var lockname = curLock.lockdeviceid
            labelname.text = lockname
            labelposition.text = lockposition
            btnlock.layer.setValue("owner", forKey: "locktype")
            btnlock.layer.setValue(indexPath.row - 1, forKey: "lockindex")
            
            btnlock.addTarget(self, action: "onClickLock:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        return collectionViewCell
    }
    
    @IBAction func onClickAddnew(sender:AnyObject){
        let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("lockaddview") as! LockRegisterViewController
        self.navigationController?.pushViewController(dvc, animated: true)
       // LockRegisterViewController
    }
    
    @IBAction func onClickLock(sender: AnyObject) {
        var   btnlock = sender as! UIButton
        let index = sender.layer.valueForKey("lockindex") as! Int
        let locktype = sender.layer.valueForKey("locktype") as! String
        
        var lock = IteasyNfclock.db_lock()
        if(locktype == "owner"){
            lock = GlobalSessionUser.shared.ownerLockArray[index]
        }
        else if(locktype  == "other"){
            lock = GlobalSessionUser.shared.otherLockArray[index]
          
        }
        
        var storyBoardTask = UIStoryboard(name:"lock",bundle:nil)
        var dvc = storyBoardTask.instantiateViewControllerWithIdentifier("lockmanageview") as! LockManagementViewController
        dvc.curLock = lock
        self.navigationController?.pushViewController(dvc,animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searchtext = searchBar.text
        doSearch(searchBar,searchtext:searchtext)
       // keyboard.endEditing()
    }
    
    
    func searchBar(searchBar: UISearchBar,textDidChange searchText: String){
        
        doSearch(searchBar,searchtext:searchText)
    }
    
    
    func doSearch(searchBar: UISearchBar,var searchtext :String){
        //   searchBar.setShowsCancelButton(true, animated: true)
//        self.userArray.removeAll(keepCapacity: true)
//        for userbuilder in Globals.shared.userArray{
//            if(searchtext == ""){
//                self.userArray.append(userbuilder)
//            }
//            else{
//                
//                if let srange = userbuilder.realname.rangeOfString(searchtext){
//                    self.userArray.append(userbuilder)
//                }
//            }
//            
//        }
//        self.memberstable.reloadData()
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let colNum: CGFloat = self.view.frame.size.width >= 300 ? 3.0 : 2.0
        
        let width: CGFloat = (self.view.frame.size.width - (1.0 + colNum)) / colNum
        return CGSize(width: width, height: width)
    }
}
