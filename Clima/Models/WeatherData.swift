//
//  WeatherData.swift
//  Clima
//
//  Created by baso on 23/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable{
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    
    let name: String?
    let timezone: Int?
}

struct Coord: Codable{
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable{
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Codable{
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Double?
    let humidity: Double?
    let sea_level: Double?
    let grnd_level: Double?
}


struct WeatherError: Codable, Error{
    let cod: String?
    let message: String?
}
