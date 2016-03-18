//
//  SpotDetailVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/18/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit

class SpotDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
