//
//  ViewController.swift
//  PromisePlay
//
//  Created by Steve Baker on 4/14/18.
//  Copyright © 2018 Beepscore LLC. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        experimentFooBar()

        // use https, doesn't require app transport security exception
        let urlString = "https://upload.wikimedia.org/wikipedia/commons/6/69/Dog_morphological_variation.png"

        // experimentGetImageCompletion(urlString: urlString)
        // experimentGetImagePromise(urlString: urlString)
        experimentGetImagePromise2(urlString: urlString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - tutorial

    // call method from a tutorial
    // http://drekka.ghost.io/doing-it-asynchronously-rxswift-vs-promisekit/
    func experimentFooBar() {

        foo()
            // .then from blog post didn't work
            // .then(execute: bar)
            .then { fooResult in
                self.bar(fooResult)
            }
            .done { barResult in
                print("Success \(barResult)")
            }
            .catch { error in
                print("Error \(error)")
        }
    }

    func foo() -> Promise<String> {
        // .value initializes a new fulfilled promise
        return .value("abc")
    }

    func bar(_ arg: String) -> Promise<String> {
        return .value("\(arg)def")
    }

    // MARK: -

    // getImage with completion, not using Promise
    func experimentGetImageCompletion(urlString: String) {
        ImageManager.getImage(urlString: urlString) { image, error in
            if error != nil {
                print(String(describing: error))
                return
            }
            self.imageView.image = image
        }
    }

    func experimentGetImagePromise(urlString: String) {
        do {
            try ImageManager.getImagePromise(urlString: urlString)
                .done { image in
                    self.imageView.image = image
                }
                .catch { error in
                    // catches ImageManagerError dataInvalid, thrown after dataTask
                    print(error)
            }
        } catch {
            // catches error ImageManagerError urlInvalid, thrown before dataTask starts
            print(error)
        }
    }

    /// method with Promise
    /// https://github.com/mxcl/PromiseKit
    /// - Parameters:
    ///   - url: url of image to download
    /// - Returns: a Promise, not Guarantee because method can throw an error
    func experimentGetImagePromise2(urlString: String) {

        // https://stackoverflow.com/questions/47802071/xcode-9-ios-11-boringssl-ssl-error-zero-return
        firstly { URLSession.shared.dataTask(.promise, with: try ImageManager.urlRequest(urlString: urlString))
            }
            // compactMap lets you get error transmission when nil is returned
            .map { arg -> UIImage? in
                // closure tuple arg has Data .data and URLResponse .response

                // response don't care
                let _ = arg.response

                guard let image = UIImage(data: arg.data) else { return nil }
                return image
            }
            .done { image in
                if let image = image {
                    self.imageView.image = image
                }
            }
            .catch { error in
                print(error)
        }
    }

}

