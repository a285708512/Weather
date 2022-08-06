import UIKit
import CoreLocation


class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    //locationManager會負責獲取手機當前的GPS位置
    
    
    //一次性同意獲得user當前位置
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //當使用者開啟APP會獲得user同意才能讀取
        locationManager.requestLocation()
        
    
        weatherManager.delegate = self
        searchTextField.delegate = self
        //self為當前的視圖控制器(ViewController)可參考第147章節的protocol
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController:UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "press the city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
           
        }
        
        searchTextField.text = ""
    }
    
}

//MARK: WeatherManagerDelegate

extension WeatherViewController:WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager:WeatherManager ,weather:WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            //temperatureString來自於WeatherModel第9~11行
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            //來自於WeatherModel第15~36行
            self.cityLabel.text = weather.cityname
            
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
    
//MARK: CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetWeather(latitude: lat, longitude: lon)
        }
        //locations最後一項 last item in the array
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
