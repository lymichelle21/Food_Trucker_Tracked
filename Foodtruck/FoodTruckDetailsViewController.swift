import UIKit
import AlamofireImage
import MapKit

class FoodtruckDetailsViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var truckAddress: UILabel!
    
    @IBOutlet weak var truckMapLocation: MKMapView!
    
    var foodtruck: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = foodtruck["applicant"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = foodtruck["fooditems"] as? String
        
        //show the address
        truckAddress.text = foodtruck["locationdescription"] as? String
        // Set initial location
        let truckLatitude = (foodtruck["latitude"] as! NSString).doubleValue
        let truckLongitude = (foodtruck["longitude"] as! NSString).doubleValue
        let initialLocation = CLLocation(latitude: truckLatitude, longitude: truckLongitude)
        
        truckMapLocation.centerToLocation(initialLocation)
        
        //show the annotation of the truck on the map
        let truck = MKPointAnnotation()
        truck.title = foodtruck["applicant"] as? String
        truck.coordinate = CLLocationCoordinate2D(latitude: truckLatitude, longitude: truckLongitude)
        truckMapLocation.addAnnotation(truck)

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
