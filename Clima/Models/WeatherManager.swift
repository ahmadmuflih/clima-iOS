import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailedWithError(_ error: Error)
}


struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=5e0475ef67296223d7bd4bc48f453955&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let fullUrl = weatherUrl+"&q="+cityName
        performRequest(fullUrl)
    }
    func fetchWeather(lat: Double, lon: Double){
        let fullUrl = weatherUrl+"&lat="+String(lat)+"&lon="+String(lon)
        performRequest(fullUrl)
    }
    
    func performRequest(_ urlString: String){
        // Create url
        if let url = URL(string: urlString){
            // Create url session
            let session = URLSession(configuration: .default)
            // Give session task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailedWithError(error!)
                    return
                }
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)!
//                    print(dataString)
                    if let weather = self.parseJson(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    } else if let error = self.parseJsonError(safeData){
                        self.delegate?.didFailedWithError(error)
                    }
                    
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main?.temp ?? 0.0
            let name = decodedData.name ?? ""
            
            if let weatherId = decodedData.weather?[0].id {
                let weather = WeatherModel(conditionId: weatherId, cityName: name, temperature: temp)
                return weather
            }
        } catch {
            self.delegate?.didFailedWithError(error)
        }
        return nil
    }
    
    func parseJsonError(_ weatherData: Data) -> Error?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherError.self, from: weatherData)
            return decodedData
        } catch {
            self.delegate?.didFailedWithError(error)
        }
        return nil
    }
    
    
}
