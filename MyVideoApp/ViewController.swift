//
//  ViewController.swift
//  MyVideoApp
//
//  Created by Charles Konkol on 2015-06-06.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
//1) Imports
import MediaPlayer
import MobileCoreServices
import AVFoundation
import CoreData
import CoreMedia

//2 Add to ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
//3 Add variables
    var moviePlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
     var videodb:NSManagedObject!
   var vidlink:String!
    
//4) Add ManagedObject Data Context
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
//5) Add variable contactdb (used from UITableView
   

//6  Create Outlet & Action for btnRecord
   
  
    @IBOutlet weak var btnRecord: UIButton!
    
    @IBAction func btnRecord(sender: AnyObject) {
        
        if txtName.text == ""
        {
            var alert = UIAlertController(title: "Name Required", message: "Please add name for video", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
               RecordVideo()
        }
     
        
    }

//7  Create Action for btnSave
    @IBAction func btnSave(sender: AnyObject) {
        if (videodb != nil) {
            // Update existing device
            videodb.setValue(txtName.text, forKey: "name")
            
        } else {
            // Create a new device
            let entityDescription =
            NSEntityDescription.entityForName("Video",
                inManagedObjectContext: managedObjectContext!)
            
            let photod = Video(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            
            photod.name = txtName.text
            photod.datestamp = txtDate.text
            println("asdadadad: " + vidlink)
            photod.link = vidlink
        }
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            // status.text = err.localizedFailureReason
        } else {
            self.dismissViewControllerAnimated(false, completion: nil)
            
        }

        
    }
    
//8  Create Outlet & Action for btnPlay
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBAction func btnPlay(sender: AnyObject) {
        let movieURL = NSURL.fileURLWithPath(vidlink!)
        
        moviePlayer = MPMoviePlayerController(contentURL: movieURL)
       
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.scalingMode = .Fill
        self.view.addSubview(moviePlayer.view)
        moviePlayer.setFullscreen(true, animated: true)
        moviePlayer.play()
        
    }

//9  Create Outlet for txtName
    @IBOutlet weak var txtName: UITextField!
    
//10  Create Outlet for txtDate
    
    @IBOutlet weak var txtDate: UITextField!
    
//10  Create Action for btnBack
    @IBAction func btnBack(sender: AnyObject) {
         self.dismissViewControllerAnimated(false, completion: nil)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

//11 Code to check if record selected
        if (videodb != nil) {
  
            txtName.text = videodb.valueForKey("name") as! String
            txtDate.text = videodb.valueForKey("datestamp") as! String
                 println(videodb.valueForKey("datestamp") as! String)
            let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
            vidlink =  videodb.valueForKey("link") as! String
            println("vidlink: " + vidlink)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidFinishPlaying:" , name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer)
            
            btnSave.enabled = false
            btnRecord.hidden=true
            
        } else {
            // Create a new device
            let date = NSDate()
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            formatter.dateStyle = .ShortStyle
            formatter.stringFromDate(date)
            println(formatter.stringFromDate(date))
            txtDate.text = formatter.stringFromDate(date)
            txtName.becomeFirstResponder()
            btnPlay.hidden=true
             btnSave.enabled = false
        }
        
    }
    
//12 Record Function
    
    func RecordVideo()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            println("captureVideoPressed and camera available.")
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            println("Camera not available.")
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//13 ImagePicker finish recording
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
       
        //Random #
        let myVar: Int = Int(rand())
//        var strVar = String(myVar)
        
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
        let fileManager = NSFileManager.defaultManager()
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        
        var name = txtName.text + "\(myVar)" + ".MOV"
        
        var filePathToWrite = "\(paths)/\(name)"
        var MovieData:NSData = NSData(contentsOfURL: tempImage)!
        MovieData.writeToFile(filePathToWrite, atomically: true)
        
        let pathString = tempImage.relativePath
        vidlink = filePathToWrite
        println("Video Save Link: " + vidlink)
        
         UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
         btnSave.enabled = true
        self.dismissViewControllerAnimated(true, completion: {})
        
       
        
    }
    
//14 Functions to complete recording
    func moviePlayerDidFinishPlaying(notification: NSNotification) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorControllerDidCancel(editor: UIVideoEditorController) {
        println("User cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func videoEditorController(editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        println("editedVideoPath: " + editedVideoPath)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController, didFailWithError error: NSError) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}

