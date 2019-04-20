import Foundation

protocol SpeechRecognizerProtocol {

    func audioToText(url: URL,  completion: @escaping (String, Error?) -> ())
}
