//
//  ImageManager.swift
//  PromisePlay
//
//  Created by Steve Baker on 4/14/18.
//  Copyright © 2018 Beepscore LLC. All rights reserved.
//

import UIKit
import PromiseKit

class ImageManager {

    enum ImageManagerError: Error {
        case urlInvalid
        case dataInvalid
    }

    /// method with Promise
    /// - Parameters:
    ///   - urlString: url of image to download
    /// - Returns: a Promise, not Guarantee because method can throw an error
    static func getImage2(urlString: String) throws -> Promise<UIImage> {

        guard let url = URL(string: urlString) else { throw ImageManagerError.urlInvalid }

        let request = URLRequest(url: url)

        // Tested In simulator. Didn't test on device yet.
        // when app starts it makes 1 request.
        // If I leave app running, after several minutes get
        // [BoringSSL] Function boringssl_session_errorlog: line 2881 [boringssl_session_read]
        // SSL_ERROR_ZERO_RETURN(6): operation failed because the connection was cleanly shut down with a close_notify alert
        // 2018-04-15 10:52:54.334279-0700 PromisePlay[39551:663001] TIC Read Status [1:0x0]: 1:57
        // https://stackoverflow.com/questions/47802071/xcode-9-ios-11-boringssl-ssl-error-zero-return
        return URLSession.shared.dataTask(.promise, with: request)

            .compactMap { arg -> UIImage in
                // closure tuple arg has Data .data and URLResponse .response
                
                // response don't care
                let _ = arg.response

                guard let image = UIImage(data: arg.data) else { throw ImageManagerError.dataInvalid }
                return image
        }
    }

    /// method with completion, doesn't use Promise
    /// references
    /// Ray Wenderlich WeatherHelper.swift getWeatherTheOldFashionedWay
    /// https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    /// - Parameters:
    ///   - urlString: url of image to download
    ///   - completion: will be run after download task finishes
    static func getImage(urlString: String, completion: @escaping (UIImage?, Error?) -> ()) {

        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared

        let dataTask = session.dataTask(with: request) { data, response, error in

            // dataTask's completionHandler now has values for data, response, error

            if error != nil {
                DispatchQueue.main.async {
                    // execute the getImage completion argument within dataTask's completion block.
                    // on main queue, so completion may safely use image to update UI
                    completion(nil, error)
                }
            }

            guard let data = data,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        // execute the getImage completion argument within dataTask's completion block.
                        // on main queue, so completion may safely use image to update UI
                        completion(nil, error)
                    }
                    return
            }
            DispatchQueue.main.async {
                // execute the getImage completion argument within dataTask's completion block.
                // on main queue, so completion may safely use image to update UI
                completion(image, nil)
            }
        }

        // start dataTask
        dataTask.resume()
    }

}
