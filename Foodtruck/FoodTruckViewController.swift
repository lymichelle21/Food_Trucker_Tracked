import UIKit
import AlamofireImage
import Parse

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var foodtrucks = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
                tableView.delegate = self
                
                let url = URL(string: "https://data.sfgov.org/resource/rqzj-sfat.json")!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                     // This will run when the network request returns
                     if let error = error {
                            print(error.localizedDescription)
                     } else if let data = data {
                         self.foodtrucks = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                            
                         
                         self.tableView.reloadData()
                         
                         //print(self.foodtrucks)

                     }
                }
                task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodtrucks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodtruckCell") as! FoodtruckCell
            let foodtruck = foodtrucks[indexPath.row]
            let title = foodtruck["applicant"] as! String
            let synopsis = foodtruck["fooditems"] as! String
            
            cell.titleLabel.text = title
            cell.synopsisLabel.text = synopsis
            
            return cell
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            print("Loading up details screen")
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let foodtruck = foodtrucks[indexPath.row]
            
            // Pass selected foodtrucks to details view controller
            let detailsViewController = segue.destination as!FoodtruckDetailsViewController
            detailsViewController.foodtruck = foodtruck
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        @IBAction func onLogoutButton(_ sender: Any) {
            PFUser.logOut()
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
            
            delegate.window?.rootViewController = loginViewController
        }

}

