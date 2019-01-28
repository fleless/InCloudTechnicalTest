//
//  TrackerViewController.swift
//  TrackingTest
//
//  Created by fahmex on 25/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

import UIKit

class TrackerViewController: UIViewController {

    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    var time: Int = 0
    var timer = Timer()
    var startDate: Date = Date()
    var endDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func start(_ sender: Any) {
        if(time == 0)
        {
            self.startDate = Date()
        }
        if(startBtn.image(for: UIControl.State.normal) == UIImage(named: "start")){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
        }else{
            timer.invalidate()
            startBtn.setImage(UIImage(named: "start"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        time = 0
        self.startDate = Date()
        updateUI()
    }
    
    @IBAction func stop(_ sender: Any) {
        if(time==0){return}
        timer.invalidate()
        startBtn.setImage(UIImage(named: "start"), for: UIControl.State.normal)
        time = 0
        self.endDate = Date()
        let alertController = UIAlertController(title: "Book Time for task", message: "Do you want to book this time for a task", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
            UIAlertAction in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookView") as! BookTaskViewController
                vc.editableTiming = false
                vc.hours = self.hours.text
                vc.minutes = self.minutes.text
                vc.seconds = self.seconds.text
                vc.startDate = self.startDate
                vc.endDate = self.endDate
                self.updateUI()
                self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            self.updateUI()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func updateTime(){
        time += 1
        updateUI()
    }
    
    private func updateUI(){
        hours.text = String(format: "%02d",time/(3600))
        minutes.text = String(format: "%02d",(time/60) % 60)
        seconds.text = String(format: "%02d",time % 60)
    }
    
    @IBAction func bookTimeWithoutTracker(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "bookView") as! BookTaskViewController
        vc.editableTiming = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
