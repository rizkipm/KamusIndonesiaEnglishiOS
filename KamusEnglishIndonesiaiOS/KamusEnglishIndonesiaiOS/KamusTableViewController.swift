//
//  KamusTableViewController.swift
//  KamusEnglishIndonesiaiOS
//
//  Created by Rizki Syaputra on 11/9/17.
//  Copyright © 2017 Rizki Syaputra. All rights reserved.
//

import UIKit

class KamusTableViewController: UITableViewController {
    
    //deklarasi url untuk mengambil data json
    let kamusURL = "https://api.kivaws.org/v1/loans/newest.json"
    //deklarasi variable loans untuk memanggil class Loan yang sudah dibuat sebelumnya
    var kamusData = [KamusModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // mengambil data dari API loans
        getAllDataKamus()
        
        // Self sizing cells
        //mengatur tinggi row table menjadi 92
        tableView.estimatedRowHeight = 92.0
        //mengatur tinggi row table menjadi dimensi otomatis
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kamusData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellKamus", for: indexPath) as! KamusCell

        // Configure the cell...
        
        cell.labelEnglish.text = kamusData[indexPath.row].kamus_english
        cell.labelIndonesia.text = kamusData[indexPath.row].kamus_indonesia
        

        return cell
    }
    
    
    // MARK: - JSON Parsing
    //membuat method baru dengan nama : getLatestLoans()
    func getAllDataKamus() {
        //deklarasi  loanUrl untuk memanggil variable kivaLoanURL yang telah d deklarasi sebelumnya
        guard let loanUrl = URL(string: kamusURL) else {
            return //return ini berfungsi untuk mengembalikan nilai yang sudah didapat ketika memanggil variable loanUrl
        }
        
        //deklarasi request untuk request URL loanUrl
        let request = URLRequest(url: loanUrl)
        //deklarasi task untuk mengambil data dari variable request diatas
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            //mengecek apakah ada error apa tidak
            if let error = error {
                //kondisi ketika ada error
                //menctak error
                print(error)
                return//mengembalikan nilai error yang didapat
            }
            
            // Parse JSON data
            //deklarasi variable data untuk memanggil data
            if let data = data {
                //pada bagian ini akan memanggil method parseJsonData yang akan kita buat di bawah
                self.kamusData = self.parseJsonData(data: data)
                
                // Reload table view
                OperationQueue.main.addOperation({
                    //reloadData kembali
                    self.tableView.reloadData()
                })
            }
        })
        //task akan melakukan resume untuk memanggil data json nya
        task.resume()
    }
    //membuat method baru dengan nama ParseJsonData
    //method ini akan melakukan parsing data Json
    func parseJsonData(data: Data) -> [KamusModel] {
        //deklarasi variable loans sebagai objeck dari class Loan
        var loans = [KamusModel]()
        //akan melakukan perulangan terhadap data json yang di parsing
        do {
            //deklarasi jsonResult untuk mengambil data dari jsonnya
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            // Parse JSON data
            //deklarasi jsonLoans untuk memanggil data array jsonResult yang bernama Loans
            let jsonLoans = jsonResult?["data"] as! [AnyObject]
            //akan melakukan pemanggilan data berulang2 selama jsonLoan memiliki data json array dari variable jsonLoans
            for jsonLoan in jsonLoans {
                //deklarasi loan sebagai object dari class Loan
                let loan = KamusModel()
                //memasukkan nilai ke dalam masing2 object dari class Loan
                //memasukkan nilai jsonLoan dengan nama object name sbg String
                loan.kamus_indonesia = jsonLoan["kamus_indonesia"] as! String
                //memasukkan nilai jsonLoan dengan nama object loan_amount sbg Integer
                loan.kamus_english = jsonLoan["kamus_inggris"] as! String
                kamusData.append(loan)
            }
            
        } catch {
            print(error)
        }
        
        return kamusData
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
