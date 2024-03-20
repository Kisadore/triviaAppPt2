//
//  CurrentTriviaQuestion.swift
//  Trivia
//
//  Created by Kiahna Isadore on 3/20/24.
//

import Foundation

struct CurrentTriviaQuestion: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    private enum CodingKeys: String, CodingKey {
        case category = "category"
        case type = "type"
        case difficulty = "difficulty"
        case question = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

// stores the API response, since the data we need is in the key <results>
struct TriviaAPIResponse: Decodable {
    let results: [CurrentTriviaQuestion]
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
