import UIKit
import Speech

class ViewController: UIViewController {
    
    private var recognizer: SpeechRecognizerProtocol? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    var recordingSession: AVAudioSession!
    
    var audioRecorder: AVAudioRecorder!
    
    private let currentRecordingName = "current.m4a"
    
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
        
        let temporaryFileURL = getDocumentsDirectory().appendingPathComponent(currentRecordingName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: temporaryFileURL, settings: settings)
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
            finishRecording(success: true)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        clearAudioRecorder()
        
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
        print("finished recording")

        if flag {
            let text = recognizer?.audioToText(url: recorder.url) {
                text, error in
                self.textView.text = text


            }
        } else {
            finishRecording(success: false)
        }
    }
}
