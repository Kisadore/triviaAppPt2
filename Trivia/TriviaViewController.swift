//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
    private let triviaService = TriviaQuestionService()
    
    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        // TODO: FETCH TRIVIA QUESTIONS HERE
        fetchTriviaQuestions()
    }
    
    private func fetchTriviaQuestions() {
        TriviaQuestionService.fetchTrivia { [weak self] questions in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !questions.isEmpty {
                    self.questions = questions
                    self.updateQuestion(withQuestionIndex: 0)
                } else {
                    print("No questions fetched")
                }
            }
        }
    }
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = question.category
        
        // Check if the question is a true/false question
        if question.type == "boolean" {
            // show only true/false buttons
            answerButton0.isHidden = false
            answerButton1.isHidden = false
            answerButton2.isHidden = true
            answerButton3.isHidden = true
                    
            // Set titles for true/false buttons
            answerButton0.setTitle("True", for: .normal)
            answerButton1.setTitle("False", for: .normal)
        } else {
            // For multiple-choice questions, show all buttons
            answerButton0.isHidden = false
            answerButton1.isHidden = false
            answerButton2.isHidden = false
            answerButton3.isHidden = false
                    
            // Set titles and hide unnecessary buttons as before
            let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
            if answers.count > 0 {
                answerButton0.setTitle(answers[0], for: .normal)
            }
            if answers.count > 1 {
                answerButton1.setTitle(answers[1], for: .normal)
                answerButton1.isHidden = false
            }
            if answers.count > 2 {
                answerButton2.setTitle(answers[2], for: .normal)
                answerButton2.isHidden = false
            }
            if answers.count > 3 {
                answerButton3.setTitle(answers[3], for: .normal)
                answerButton3.isHidden = false
            }
        }
  }
    private func updateToNextQuestion(answer: String) {
        let isCorrectBool: Bool = isCorrectAnswer(answer)
        if isCorrectBool {
            numCorrectQuestions += 1
        }
        currQuestionIndex += 1
        print(currQuestionIndex)
        guard currQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        showFeedbackAlert(with: isCorrectBool)
        updateQuestion(withQuestionIndex: currQuestionIndex)
  }
    
    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
  }
    
    // show feedback after ach question is answered
    private func showFeedbackAlert(with isCorrectBool: Bool) -> Void {
        if isCorrectBool {
            let correctController = UIAlertController(title: "Correct: ",
                                                      message: "You currently have: \(numCorrectQuestions)/\(questions.count) correct",
                                                      preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",
                                         style: .default,
                                         handler: nil)
            correctController.addAction(okAction)
            present(correctController, animated: true, completion: nil)
        } else {
            let incorrectController = UIAlertController(title: "Incorrect: ",
                                                        message: "You currently have: \(numCorrectQuestions)/\(questions.count) correct",
                                                        preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",
                                         style: .default,
                                         handler: nil)
            incorrectController.addAction(okAction)
            present(incorrectController, animated: true, completion: nil)
        }
    }
    
    //Display score
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currQuestionIndex = 0
            numCorrectQuestions = 0
            //updateQuestion(withQuestionIndex: currQuestionIndex) world just reset back to the first question
            questions.removeAll() // Clear the current questions
            
            // Fetch new questions
            fetchTriviaQuestions()
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
                UIColor(red: 1.0, green: 0.65, blue: 0.79, alpha: 1.0).cgColor, // Pink
                UIColor(red: 0.71, green: 0.53, blue: 0.32, alpha: 1.0).cgColor  // Brown
            ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }

}

