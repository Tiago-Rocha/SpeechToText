import Foundation

protocol SpeechRecognizer {

    func audioToText(url: URL,  completion: @escaping (String, Error?) -> ())
}
