import UIKit
import Speech

class ViewController: UIViewController {

    private let viewModel = DependencyGraph.shared.getRecorderViewModel()
    
    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    var recordingSession: AVAudioSession!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        
        setupAudioSession()
    }
    
    func setupAudioSession() {
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record, authorizations not set
                    }
                }
            }
        } catch let error {
            print(String(describing: error))
            // failed to record!
        }
    }
    
    func loadRecordingUI() {
        
        microphoneButton.frame = CGRect(x: 64, y: 64, width: 128, height: 64)
        microphoneButton.setTitle("Tap to Record", for: .normal)
        microphoneButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func startRecording() {
        
        do {
            let recorderSettings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
            
            audioRecorder = try AVAudioRecorder(url: viewModel.temporaryFileURL, settings: recorderSettings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            microphoneButton.setTitle("Tap to Stop", for: .normal)
        } catch let error {
            print(String(describing: error))
            finishRecording(success: false)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder == nil {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        clearAudioRecorder()
    }
    
    func finishRecording(success: Bool) {
        
        if success {
            microphoneButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            microphoneButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    func clearAudioRecorder() {
        
        audioRecorder = nil
    }
}

extension ViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        toggleLoading(.blue, .clear)
        if flag {
            viewModel.recognizeAudioFrom(url: recorder.url) { [unowned self] text, error in
             
                guard error != nil else {
                    self.viewModel.save(recordingText: text)
                    self.finishRecording(success: true)
                    self.toggleLoading()
                    return
                }
                self.finishRecording(success: false)
                self.toggleLoading()
                return
            }
        } else {
            self.toggleLoading()
            finishRecording(success: false)
            
        }
    }
}
