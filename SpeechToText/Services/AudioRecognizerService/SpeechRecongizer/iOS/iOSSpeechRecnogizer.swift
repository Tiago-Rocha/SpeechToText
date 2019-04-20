import Speech

extension SFSpeechRecognizer: SpeechRecognizerProtocol {

    func audioToText(url: URL, completion: @escaping (String, Error?) -> ()) {
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        request.shouldReportPartialResults = false
        
        self.recognitionTask(with: request) { result, error in
            guard error == nil else {
                print(String(describing: error))
                completion("", error)
                return
                
            }
            
            guard let result = result else {
                completion("", error)
                return
            }
            
            completion(result.bestTranscription.formattedString, nil)
            return
            
        }
    }
}
