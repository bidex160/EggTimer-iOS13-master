
import UIKit
import AVFoundation
class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    var secsPassed = 0;
    
    let dic : [String: Int] = ["Soft": 5, "Medium": 7, "Hard": 12];
    
    var totalTime: Int = 0
    
    var timerSch = Timer()
    
    var player: AVAudioPlayer?
    //button action
    @IBAction func eggPressed(_ sender: UIButton) {
       let title = sender.currentTitle!
        let time: Int = dic[title]!
        totalTime = time
        timerSch.invalidate()
        progressBar.progress = 0;
        secsPassed = 0;
        titleLabel.text = title

        
      timerSch =     Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(updateTimer), userInfo: nil, repeats: true)
    
    
    }
    
    //timer update
    @objc func updateTimer(){
        if(secsPassed < totalTime){
            let pProgress:Float = Float(secsPassed) / Float(totalTime);
       
            progressBar.progress = pProgress;
            print(pProgress)
            secsPassed += 1;
        }else{
            titleLabel.text = "Done!"
            timerSch.invalidate()
            progressBar.progress = 1;
            
            playSound()

        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                player.stop();
            }
        

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
