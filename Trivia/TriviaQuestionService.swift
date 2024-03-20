//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Kiahna Isadore on 3/20/24.
//

import Foundation
class TriviaQuestionService {
    static func fetchTrivia(completion: @escaping ([TriviaQuestion]) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=7")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TriviaAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results)
                }
            } catch let error as DecodingError {
                print("Decoding error: \(error)")
            } catch {
                print("General error: \(error)")
                // Handle other types of errors
            }
        }
        task.resume()
    }
    
    private static func parse(data: Data) -> TriviaQuestion? {
        do {
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let currentTrivia = jsonDictionary?["current_trivia"] as? [String: Any],
                  let category = currentTrivia["category"] as? String,
                  let question = currentTrivia["question"] as? String,
                  let type = currentTrivia["type"] as? String,
                  let difficulty = currentTrivia["difficulty"] as? String,
                  let correctAnswer = currentTrivia["correctAnswer"] as? String,
                  let incorrectAnswers = currentTrivia["incorrectAnswers"] as? [String] else {
                return nil
            }
            return TriviaQuestion(category: category,
                                  type: type,
                                  difficulty: difficulty,
                                  question: question,
                                  correctAnswer: correctAnswer,
                                  incorrectAnswers: incorrectAnswers)
        } catch {
            print("Error parsing data: \(error)")
            return nil
        }
    }
    
}
