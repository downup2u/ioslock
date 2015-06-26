//
//  DoorOpenViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-3-31.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class DoorOpenViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    var ownerLockArray = [IteasyNfclock.db_lock()]
    var otherLockArray = [IteasyNfclock.db_lock()]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.backgroundColor = UIColor.whiteColor()
        
        var searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        var btnOpenDoor = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnOpenDoor.frame = CGRectMake(0, 0, 32, 32);
        btnOpenDoor.setImage(UIImage(named:"code_x"), forState: UIControlState.Normal)
        btnOpenDoor.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        //btnOpenDoor.setBackgroundImage(UIImage(named: "code_x"), forState: UIControlState.Normal)
        btnOpenDoor.addTarget(self, action: "onClickOpenDoor:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnOpenDoor)
        rightBarButtonItem.tintColor = UIColor.colorWithHex("#f96429")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
  
        
        
        loaddata()
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLockCallback:", name: "onLockCallback", object: nil)
      
    }
    
    var qrCode:QRCodeHelper?
    func onScanedText(txt:String!){
        var curlock:IteasyNfclock.db_lock?
        for lock in GlobalSessionUser.shared.ownerLockArray{
            if(txt == lock.lockdeviceid){
                curlock = lock
            }
        }
        for lock in GlobalSessionUser.shared.otherLockArray{
            if(txt == lock.lockdeviceid){
                curlock = lock
            }
        }
        
        if let curlock = curlock{
            var dvc = self.storyboard?.instantiateViewControllerWithIdentifier("dooropenpop") as! DoorOpenPopViewController
            dvc.curLock = curlock
            self.navigationController?.pushViewController(dvc,animated: true)
        }

    }
    func onClickOpenDoor(sender: UIViewController){
        self.qrCode = QRCodeHelper()
        self.qrCode?.delegate = self.onScanedText
        self.qrCode?.showView(self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onLockCallback(notification: NSNotification){
        loaddata()
        
    }
    override func viewDidAppear(animated: Bool)
    {
       loaddata()
    }
    
    func loaddata(){
        self.ownerLockArray = GlobalSessionUser.shared.ownerLockArray
        self.otherLockArray = GlobalSessionUser.shared.otherLockArray
        self.collectionView.reloadData()
        println("loaddata DoorOpenViewController collectionView:\(self.ownerLockArray.count),\(self.otherLockArray.count),\(self.ownerLockArray)")

      
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var ilock = self.ownerLockArray.count + self.otherLockArray.count
        println("DoorOpenViewController collectionView:\(self.ownerLockArray.count),\(self.otherLockArray.count)")
        return ilock
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var collectionViewCell:UICollectionViewCell!
        var curLock:IteasyNfclock.db_lock!
        var curIndex = 0
        if(indexPath.row < self.ownerLockArray.count){
            collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cellown", forIndexPath: indexPath) as! UICollectionViewCell
            curIndex = indexPath.row
            curLock = self.ownerLockArray[curIndex]
        }
        else{
             collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cellother", forIndexPath: indexPath) as! UICollectionViewCell
            curIndex = indexPath.row - self.ownerLockArray.count
            curLock = self.otherLockArray[curIndex]
            
        }
        var btnlock = collectionViewCell.viewWithTag(101) as! UIButton
        var labelname = collectionViewCell.viewWithTag(102) as! UILabel
        var labelposition = collectionViewCell.viewWithTag(103) as! UILabel
     
        btnlock.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#E2E8F6")), forState: UIControlState.Normal)
        btnlock.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnlock.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#213F7F")), forState: UIControlState.Selected)
        btnlock.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        
//        btnlock.layer.borderColor = UIColor.clearColor().CGColor
//        btnlock.layer.borderWidth = 1
//        btnlock.layer.cornerRadius = 6
//        btnlock.layer.masksToBounds = true
        
        labelname.text = curLock.lockposition
        labelposition.text = curLock.lockdeviceid
        btnlock.layer.setValue(curIndex, forKey: "lockindex")
        
        if(indexPath.row < self.ownerLockArray.count){
            btnlock.layer.setValue("owner", forKey: "locktype")
        }
        else {
            btnlock.layer.setValue("other", forKey: "locktype")
        }
        btnlock.addTarget(self, action: "onClickLock:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return collectionViewCell
    }
    
    @IBAction func onClickLock(sender: AnyObject) {
        var   btnlock = sender as! UIButton
        let index = sender.layer.valueForKey("lockindex") as! Int
        let locktype = sender.layer.valueForKey("locktype") as! String
        var lock = IteasyNfclock.db_lock()
        if(locktype == "owner"){
            lock = self.ownerLockArray[index]
        }
        else if(locktype  == "other"){
            lock = self.otherLockArray[index]
            
        }

        var dvc = self.storyboard?.instantiateViewControllerWithIdentifier("dooropenpop") as! DoorOpenPopViewController
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
        
        self.ownerLockArray.removeAll(keepCapacity: true)
        self.otherLockArray.removeAll(keepCapacity: true)
        for lock in GlobalSessionUser.shared.ownerLockArray{
            if(searchtext == ""){
                self.ownerLockArray.append(lock)
            }
            else{
                
                if let srange = lock.lockposition.rangeOfString(searchtext){
                    self.ownerLockArray.append(lock)
                }
                else if let srange = lock.lockdeviceid.rangeOfString(searchtext){
                    self.ownerLockArray.append(lock)
                }
            }
        }
        for lock in GlobalSessionUser.shared.otherLockArray{
            if(searchtext == ""){
                self.otherLockArray.append(lock)
            }
            else{
                
                if let srange = lock.lockposition.rangeOfString(searchtext){
                    self.otherLockArray.append(lock)
                }
                else if let srange = lock.lockdeviceid.rangeOfString(searchtext){
                    self.otherLockArray.append(lock)
                }
            }
        }
        collectionView.reloadData()
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let colNum: CGFloat = self.view.frame.size.width >= 300 ? 3.0 : 2.0
        
        let width: CGFloat = (self.view.frame.size.width - (1.0 + colNum)) / colNum
        var size = CGSize(width: width, height: width)
       // println("DoorOpenViewController collectionView:\(size)")
        return size
    }
    
}
