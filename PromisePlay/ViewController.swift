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

        // use https, doesn't require app transport security exception
        let urlString = "https://upload.wikimedia.org/wikipedia/commons/6/69/Dog_morphological_variation.png"

        // getImage with completion, not using Promise
        // ImageManager.getImage(urlString: urlString) { image, error in
        //     if error != nil {
        //         print(String(describing: error))
        //         return
        //    }
        //     self.imageView.image = image
        // }

        // getImage2 with Promise
        do {
            try ImageManager.getImage2(urlString: urlString)
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

        // call method from a tutorial
        // http://drekka.ghost.io/doing-it-asynchronously-rxswift-vs-promisekit/
        foo()
            // .then(execute: bar)
            .then {fooResult in
                self.bar(fooResult)
            }
            .done { barResult in
                print("Success \(barResult)")
            }
            .catch { error in
                print("Error \(error)")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func foo() -> Promise<String> {
        // .value initializes a new fulfilled promise
        return .value("abc")
    }

    func bar(_ arg: String) -> Promise<String> {
        return .value("\(arg)def")
    }
}

