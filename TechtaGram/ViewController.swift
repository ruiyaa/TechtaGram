//
//  ViewController.swift
//  TechtaGram
//
//  Created by tanaka niko on 2022/12/10.
//

import UIKit

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var cameraImageView:UIImageView!
    
    var originalimage:UIImage!
    
    var filter:CIFilter!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image=info[.editedImage]as? UIImage//文字列を写真に変換
        
        originalimage=cameraImageView.image
        dismiss(animated:true,completion:nil)//出ていた画面を削除
    }
    
    @IBAction func takephoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let picker=UIImagePickerController()//定数・機能を代入
            picker.sourceType = .camera//両脇にスペースを入れないと怒られる
            picker.delegate=self
            
            picker.allowsEditing=true
            
            present(picker,animated:true,completion:nil)//画面が登場
            
        }else{
            print("error")
        }
    }
    
    @IBAction func openalbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let picker=UIImagePickerController()
            
            picker.sourceType = .photoLibrary
            picker.delegate=self
            
            picker.allowsEditing=true
            
            present(picker,animated: true,completion: nil)
            
        }else{
            print("error")
        }
    }
    
    @IBAction func colorfilter(){
        let filterimage:CIImage=CIImage(image:originalimage)!
        
        filter=CIFilter(name:"CIColorControls")!
        filter.setValue(filterimage,forKey: kCIInputImageKey)
        
        filter.setValue(1.0,forKey:"inputSaturation")//彩度
        
        filter.setValue(0.5,forKey:"inputBrightness")//明度
        
        filter.setValue(2.5,forKey:"inputContrast")//コントラスト
        
        let ctx=CIContext(options:nil)
        
        let cgImage=ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image=UIImage(cgImage: cgImage!)
        
        
        
    }
    
    @IBAction func susshare(){
        
        let sharetext="写真加工いえい"
        
        let image=cameraImageView.image!
        
        let activityItems:[Any]=[sharetext,image]
        
        let activeViewController=UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes=[UIActivity.ActivityType.postToWeibo,.saveToCameraRoll,.print]
        
        activeViewController.excludedActivityTypes=excludedActivityTypes
        
        present(activeViewController,animated:true,completion: nil)
        
        
        
    }
    
    @IBAction func savephoto(){
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }


}

