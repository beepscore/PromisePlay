//
//  ImageManager.swift
//  PromisePlay
//
//  Created by Steve Baker on 4/14/18.
//  Copyright © 2018 Beepscore LLC. All rights reserved.
//

import UIKit

class ImageManager {

    /// Ray Wenderlich WeatherHelper.swift getWeatherTheOldFashionedWay
    /// https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    /// - Parameters:
    ///   - urlString: url of image to download
    ///   - completion: will be run after download task finishes
    static func getImage(urlString: String, completion: @escaping (UIImage?, Error?) -> ()) {

        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared

        // completionHandler has 3 arguments data, response, error
        let dataTask = session.dataTask(with: request) { data, response, error in

            if error != nil {
                completion(nil, error)
                return
            }

            guard let data = data,
                let image = UIImage(data: data) else {
                    completion(nil, error)
                    return
            }
            DispatchQueue.main.async {
                // on main queue, so completion may safely use image to update UI
                completion(image, nil)
            }
        }

        // start dataTask
        dataTask.resume()
    }

}
