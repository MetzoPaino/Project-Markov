//
//  MarkovGenerator.swift
//  Project Markov
//
//  Created by William Robinson on 28/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

class VariationGenerator {
    
    // MARK: - Shuffle Array
    // Ensure the motifs aren't always in the same sequence
    
    private func shuffleArray(selectedMotifs: [Motif]) -> [String] {
        
//        println("ORIGINAL ARRAY")
//        for motif in selectedMotifs {
//            println("\(motif.content)")
//        }
//        println("")
        
        var shuffledArray = [String]()
        for motif in selectedMotifs {
            
            shuffledArray.append(motif.content)
        }
        
        shuffledArray.shuffle()
        
//        println("SHUFFLED ARRAY")
//        for motif in shuffledArray {
//            println("\(motif)")
//        }
//        println("")
        
        return shuffledArray
    }
    
    // MARK: - Strip Words
    // Strip all motifs into array of single words whenever characters in unwantedCharacterSet are found
    // Will recognise spaces as words, so need to ignore those
    
    private func stripWords(shuffledArray: [String]) -> [VariationWord] {
        
        let splitByCharacterSet = NSCharacterSet(charactersInString: "(), ")
        var strippedArray = [VariationWord]()
        
        // Create stripped array of words, but due to loop within loop can't assign index
        
        for motif in shuffledArray {
            
            let words = motif.componentsSeparatedByCharactersInSet(splitByCharacterSet)
            for word in words {
                
                if !word.isEmpty {
                    let variationWord = VariationWord(word: word)
                    strippedArray.append(variationWord)
                }
            }
        }
        
        // Assign index
        
        for (index, variationWord) in enumerate(strippedArray) {
            
            variationWord.totalWordIndex = index
            strippedArray[index] = variationWord
        }
        
        return strippedArray
    }
    
    // MARK: - Generate sentence length
    
    private func generateSentenceLength(maxLength: Int, minLength: Int) -> Int {
        
        var sentenceLength = 0
        do {
            sentenceLength = Int(arc4random_uniform(UInt32(maxLength)) + 1)
        } while sentenceLength < minLength
        
        println("Sentence length: \(sentenceLength), Max: \(maxLength), Min: \(minLength)")
        return sentenceLength
    }
    
    // MARK: - Generate random seed
    // Seed must be -2 from wordArraySize, due to needing 3 words in succession
    
    private func generateRandomSeed(maxSeedLength: Int) -> Int {
        
        var seed = Int(arc4random_uniform(UInt32(maxSeedLength - 2)))
//        println("SeedForElement: \(seed + 1), wordArraySize: \(maxSeedLength)")
        return seed
    }
    
    // MARK: - Pick starting words
    
    private func pickStartingWordsFrom(seed: Int, totalWordList: [VariationWord]) -> (firstWord: String, firstWordIndex: Int, secondWord: String, secondWordIndex: Int) {
        
        let firstWord = totalWordList[seed].word
        let secondWord = totalWordList[seed + 1].word
        
        return (firstWord, seed, secondWord, seed + 1)
    }
    
    // MARK: - Find all possible paths
    // Need to find all possible word paths, then randomly choose one
    
    private func findWordForContinuationFrom(totalWordList: [VariationWord], firstWord: String, secondWord: String) -> (thirdWord: String, indexOfThirdWord: Int)? {
        
        println("\n----\n----")
        println("First word: \(firstWord), Second word: \(secondWord)")
        
        var nextWords = [String]()
        var indexOfNextWords = [Int]()
        var itterator = 1
        for variationWord in totalWordList {
            
            let potentialFirstWord = variationWord.word

            if itterator < totalWordList.count - 1 {
                
                // Look through array, making PSW the word after PFW
                let potentialSecondWord = totalWordList[itterator].word
                if potentialFirstWord == firstWord && potentialSecondWord == secondWord {
                    // PFW & PSW match, get third word
                    let thirdWord = totalWordList[itterator + 1].word
                    nextWords.append(thirdWord)
                    indexOfNextWords.append(itterator + 1)
                } else {
                    // First & second words don't match with potentials, so don't want a third word
                }
                
                itterator++
                
            } else {
                // To close to end of array so can't get a third word
                break
            }
        }
        
        if nextWords.isEmpty {
            return (nil)
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(nextWords.count)))
        
        var thirdWord = nextWords[randomIndex]
        let indexOfThirdWord = indexOfNextWords[randomIndex]
        println("Third word: \(thirdWord)")
        return (thirdWord, indexOfThirdWord)
        
    }
    
    // MARK: - Construct sentence
    
    func createSentence(sentenceComponents: [String]) -> String {
        
        var variationSentence = ""
        for word in sentenceComponents {
            variationSentence = variationSentence + word
            variationSentence = variationSentence + " "
        }
        return variationSentence
    }
    
    // MARK: - Construct variation
    
    func createVariation(selectedMotifs: [Motif], minSentenceLength: Int, maxSentenceLength: Int, maxSectionLength: Int) -> Variation {

        var variation = Variation(sentenceComponents: [String]())
        variation.minimumSentenceLength = minSentenceLength
        variation.maximumSentenceLength = maxSentenceLength
        
        let shuffledMotifs = shuffleArray(selectedMotifs)
        variation.totalWordList = stripWords(shuffledMotifs)
        
        let sentenceLength = generateSentenceLength(maxSentenceLength, minLength: minSentenceLength)
        var randomSeed = generateRandomSeed(variation.totalWordList.count)
        var startingWords = pickStartingWordsFrom(randomSeed, totalWordList: variation.totalWordList)
        
        variation.sentenceComponents.append(startingWords.firstWord)
        variation.totalWordList[startingWords.firstWordIndex].inUse = true
        variation.totalWordList[startingWords.firstWordIndex].inUseIndex.append(0)

        
        variation.sentenceComponents.append(startingWords.secondWord)
        variation.totalWordList[startingWords.secondWordIndex].inUse = true
        variation.totalWordList[startingWords.secondWordIndex].inUseIndex.append(1)
        
//        println("\(variation.sentenceComponents)")
//        println("")

        while variation.sentenceComponents.count < sentenceLength {
            
            // Create section by going on for so long from 1st & 2nd word
            // Add the 3rd word, then move words along to find new 3rd word
            
            var sectionLength = Int(arc4random_uniform(UInt32(maxSectionLength)) + 1)
            println("SectionLength: \(sectionLength)")
            
            for var itterator = 0; itterator < sectionLength; itterator++ {
                
                if variation.sentenceComponents.count < sentenceLength {
                    
                    if let nextWord = findWordForContinuationFrom(variation.totalWordList, firstWord: startingWords.firstWord, secondWord: startingWords.secondWord) {
                        variation.sentenceComponents.append(nextWord.thirdWord)
                        variation.totalWordList[nextWord.indexOfThirdWord].inUse = true
                        variation.totalWordList[nextWord.indexOfThirdWord].inUseIndex.append(variation.sentenceComponents.count - 1)
                        startingWords.firstWord = startingWords.secondWord
                        startingWords.secondWord = nextWord.thirdWord
                    } else {
                        // Couldn't find a suitable string, break and try from new seed
                        println("We break 1")
                        break
                    }
                    
//                    println("We itterate \(itterator)")
                    
                } else {
                    // MarkovArray has reached SentenceLength, so don't add anything
                    println("We break 2")

//                    println("We break at \(itterator)")
                    break
                }
            }
            println("end of section")
            randomSeed = generateRandomSeed(variation.totalWordList.count)
            startingWords = pickStartingWordsFrom(randomSeed, totalWordList: variation.totalWordList)
            
            variation.sentenceComponents.append(startingWords.firstWord)
            variation.totalWordList[startingWords.firstWordIndex].inUse = true
            variation.totalWordList[startingWords.firstWordIndex].inUseIndex.append(variation.sentenceComponents.count - 1)

            variation.sentenceComponents.append(startingWords.secondWord)
            variation.totalWordList[startingWords.secondWordIndex].inUse = true
            variation.totalWordList[startingWords.secondWordIndex].inUseIndex.append(variation.sentenceComponents.count - 1)
        }
        
        // If a word is used more than once it can cause issues
        // First, find out how many words there are needed
        
        println("\(variation.sentenceComponents)")
        variation.sentence = createSentence(variation.sentenceComponents)
        var itterator = 0
        var sentenceComponentsArray = [Int]()
        
        for variationWord in variation.totalWordList {
            if variationWord.inUse {
                
                for inUseIndex in variationWord.inUseIndex {
                    sentenceComponentsArray.append(0)
                }
            }
        }
        
        // Now array is correctly sized loop back through and put indexes in correct please

        for (index, variationWord) in enumerate(variation.totalWordList) {
            if variationWord.inUse {
                
                for inUseIndex in variationWord.inUseIndex {
                    sentenceComponentsArray[inUseIndex] = variationWord.totalWordIndex!
                }
            }
        }
        
        variation.sentenceComponentsIndexes = sentenceComponentsArray
        return variation
    }
}

