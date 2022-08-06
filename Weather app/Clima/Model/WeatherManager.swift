import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager ,weather:WeatherModel)
    func didFailWithError(error:Error)
    
}

struct WeatherManager{
    
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=28e3feb8a514798298e0b2985c823d51&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(with: urlString)
    }
    
    func fetWeather(latitude: CLLocationDegrees , longitude :CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
  
    
    
    func performRequest(with urlString:String){
        //在此寫四個步驟即可完成Networking
        
        
        //step1.Create URL
        if let url = URL(string: urlString){
        
            //step2.Create a URLSession
            let session = URLSession(configuration: .default)
            //default configuration 默認的意思，此段程式碼的意思就是像一個瀏覽器，可以進入第三步可參考圖片
            
            //step3.Give the session a task(給session一個任務)，並命名為task
            
            let task = session.dataTask(with: url) { (data, responese, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    
                    if  let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                        
                    }
                   
                }
            }
            //step4.Start the task
            task.resume()

        }
    }
        
    
    
    func parseJSON(_ weatherData : Data) -> WeatherModel?{
        //decoder(解碼器)
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(WeatherData.self, from:weatherData)
        let id = decodedData.weather[0].id
        let temp = decodedData.main.temp
        let name = decodedData.name
        let weather = WeatherModel(conditionId: id, cityname: name, temperature: temp)
        return weather
        
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
            
        }
        
    
    }
}
