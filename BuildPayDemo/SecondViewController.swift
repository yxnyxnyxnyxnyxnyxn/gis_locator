//
//  SecondViewController.swift
//  BuildPayDemo
//
//  Created by Mark Bofill on 9/21/16.
//  Copyright © 2016 Mark Bofill. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var btnShowProjects: UIButton!
    @IBOutlet weak var btnShowMerchants: UIButton!
    @IBOutlet weak var btnShowSuppliers: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnShowProjectsClicked(sender: UIButton) {
        print("projects clicked")
        if projectsOn {
            projectsOn = false
            print ("turned projects off")
            sender.setTitle("Off", forState: .Normal)
        }
        else {
            projectsOn = true
            print("turned projects on")
            sender.setTitle("On", forState: .Normal)
            
        }
        
    }

    @IBAction func btnShowMerchantsClicked(sender: UIButton) {
        print("mechants clicked")
        if merchantsOn {
            merchantsOn = false
            print ("turned merchants off")
            sender.setTitle("Off", forState: .Normal)
        }
        else {
            merchantsOn = true
            print("turned merchants on")
            sender.setTitle("On", forState: .Normal)
            
        }
        
        
    }
    @IBAction func btnShowSuppliersClicked(sender: UIButton) {
        print("Suppliers clicked")
        if suppliersOn {
            suppliersOn = false
            print ("turned suppliers off")
            sender.setTitle("Off", forState: .Normal)
        }
        else {
            suppliersOn = true
            print("turned suppliers on")
            sender.setTitle("On", forState: .Normal)
            
        }
        
    }
}

