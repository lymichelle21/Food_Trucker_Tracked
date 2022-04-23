import UIKit
import AlamofireImage
import MapKit

class FoodtruckMapViewController: UIViewController {

    @IBOutlet weak var Full_map: MKMapView!
    
    var foodtrucks = [[String:Any]]()

        override func viewDidLoad() {
            
            super.viewDidLoad()
                    
                let url = URL(string: "https://data.sfgov.org/resource/rqzj-sfat.json")!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                     if let error = error {
                            print(error.localizedDescription)
                     } else if let data = data {
                         self.foodtrucks = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                            
                         //print(self.foodtrucks)
                         
                         
                         for foodtruck in self.foodtrucks
                         {
                             //print(foodtruck)
                             let truck = MKPointAnnotation()
                             truck.title = foodtruck["applicant"] as? String
                             print(truck.title ?? "Food Truck")
                             let truckLatitude = (foodtruck["latitude"] as! NSString).doubleValue
                             let truckLongitude = (foodtruck["longitude"] as! NSString).doubleValue
                             truck.coordinate = CLLocationCoordinate2D(latitude: truckLatitude, longitude: truckLongitude)
                             print (truck.coordinate)
                             self.Full_map!.addAnnotation(truck)
                             
                             print("complete!")
                              
                         }
                          
                     }
                    
                }
                task.resume()
            

            let truck = MKPointAnnotation()
            truck.title = "You are here"
            truck.coordinate = CLLocationCoordinate2D(latitude: 37.744, longitude: -122.38)
            Full_map.addAnnotation(truck)
            
            let initialLocation = CLLocation(latitude: 37.744, longitude: -122.38)
            
            Full_map.centerToLocation(initialLocation)
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
