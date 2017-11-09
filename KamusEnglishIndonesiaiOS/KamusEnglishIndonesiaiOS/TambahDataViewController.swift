//
//  TambahDataViewController.swift
//  KamusEnglishIndonesiaiOS
//
//  Created by Rizki Syaputra on 11/9/17.
//  Copyright © 2017 Rizki Syaputra. All rights reserved.
//

import UIKit

class TambahDataViewController: UIViewController {
    
    //load url
    let urlInputData :URL = URL(string: "http://localhost/KamusApp/index.php/api/input_data_kamus")!
    
    @IBOutlet weak var etTeksIndonesia: UITextField!
    @IBOutlet weak var etTeksEnglish: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSaveData(_ sender: Any) {
        //deklarasi variable nTeksEnglish and nTeksIndo
        let nTeksEnglish:NSString = etTeksEnglish.text! as NSString
        let nTeksIndonesia : NSString = etTeksIndonesia.text as! NSString
        
        //pengecekan apabila nilai kosong
        if (etTeksEnglish.isEqual("") || etTeksIndonesia.isEqual("")){
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Input Data Failed"
            alertView.message = "Please Input Teks For English and Indonesia"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
        }else{
            do {
            //kondisi ketika nilai tidak kosong
            //deklarasi parameter untuk post data
            let post: NSString = "kamus_indonesia=\(nTeksIndonesia)&kamus_inggris=\(nTeksEnglish)" as NSString
            //log data
            NSLog("Post Data : %@", post )
            //deklarasi postdata
            let postData : Data = post.data(using: String.Encoding.ascii.rawValue)!
            //deklarasi post length
            let postLength :NSString = String(postData.count) as NSString
            
            let requestData : NSMutableURLRequest = NSMutableURLRequest(url: urlInputData as URL)
            
            //penggunaan method post untuk encode dan decode data json
            requestData.httpMethod = "POST"
            requestData.httpBody = postData
            requestData.setValue(postLength as String  , forHTTPHeaderField:"Content-Length")
            requestData.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            requestData.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError : NSError?
            var response : URLResponse?
            
            //deklarasi variable urlData
            var urlData : Data?
            
            do{
                //pengecekan error pada singkronisasi koneksi
                urlData = try NSURLConnection.sendSynchronousRequest(requestData as URLRequest, returning: &response)
                
            }catch let error as NSError {
                //untuk menampilkan respon error
                responseError = error
                urlData = nil
            }
            
            //pengecekan urlData tidak sama dengan nil
            if (urlData != nil){
                let res = response as! HTTPURLResponse!
                
                let responseData: NSString = NSString(data: urlData!, encoding: String.Encoding.utf8.rawValue)!
                
                NSLog("Response ==> %@", responseData)
                
                let jsonData : NSDictionary =  try JSONSerialization.jsonObject(with: urlData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let result: NSInteger = jsonData.value(forKey: "true") as! NSInteger
                
                if (result == 1){
                    self.dismiss(animated: true, completion: nil)
                }else{
                    var error_msg : NSString
                    
                    if (jsonData["error_meesage"] as! NSString != nil){
                        error_msg = jsonData["error_message"] as! NSString
                    }else{
                        error_msg = "Uknown Error"
                        
                    }
                    
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Input Data Failed"
                    alertView.message = error_msg as String
                    alertView.delegate = self
                    alertView.addButton(withTitle: "OK")
                    alertView.show()
                    
                    
                }
            }else{
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Input Data Failed"
                alertView.message = "Error Server"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
            }
            
            }catch{
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Input Data Failed"
                alertView.message = "Can not connect"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
            }
        }
    }
    
                
                
            
            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
            
            
            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destinationViewController.
             // Pass the selected object to the new view controller.
             }
             */
            
}
