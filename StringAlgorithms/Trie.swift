//
//  Trie.swift
//  StringAlgorithms
//
//  Created by Edmund Mok on 9/9/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

class TrieNode<T> {

    var value: T?
    var children = [Character: TrieNode<T>]()

    init(value: T?) {
        self.value = value
    }

}

public class Trie<T> {

    let rootNode: TrieNode<T>
    private(set) var count = 0

    public init() {
        self.rootNode = TrieNode<T>(value: nil)
    }

    public func contains(key: String) -> Bool {
        return self.get(key: key) != nil
    }

    public func get(key: String) -> T? {
        return getTerminalNode(forKey: key)?.value
    }

    private func getTerminalNode(forKey key: String) -> TrieNode<T>? {
        let characters = key.map { $0 }
        var currNode = rootNode
        for char in characters {
            if let childNode = currNode.children[char] {
                currNode = childNode
                continue
            }
            return nil
        }
        return currNode
    }

    public func insert(key: String, val: T) {
        let characters = key.map { $0 }
        var currNode = rootNode
        var currIndex = 0
        let keyLength = Int(key.count)

        // Find the largest prefix present
        for i in 0..<keyLength {
            // Check if this char exists
            if let childNode = currNode.children[characters[i]] {
                currNode = childNode
                currIndex = i + 1
                continue
            }
            // Char does not exist
            break
        }

        // Append new nodes if necessary
        for i in currIndex..<keyLength {
            currNode.children[characters[i]] = TrieNode<T>(value: nil)
            currNode = currNode.children[characters[i]]!
        }

        // This word did not exist before, increase word count
        if currNode.value == nil {
            count += 1
        }
        currNode.value = val
    }

    public func delete(key: String) -> T? {
        if key.count == 0 { return nil }
        return delete(node: rootNode, characters: key.map { $0 }, index: 0).1
    }

    private func delete(node: TrieNode<T>, characters: [Character], index: Int) -> (Bool, T?) {
        if index >= characters.count {
            // Delete entire node itself if no children
            if node.children.count == 0 {
                return (true, node.value)
            } else {
                // If have children, delete the value at nodes
                node.value = nil
                return (false, node.value)
            }
        }

        if let childNode = node.children[characters[index]] {
            let (canDelete, value) = delete(node: childNode, characters: characters, index: index+1)
            if canDelete {
                node.children[characters[index]] = nil
            }
            return (canDelete && node.children.count == 1, value)
        } else {
            return (node.children.count == 1, nil)
        }
    }

//    func getPrefixes(of string: String) -> [String] {
//
//    }
//
//    func getKeys(startingWithPrefix prefix: String) -> [String] {
//
//    }
//
//    func keys() -> [String] {
//
//    }
//
//    func items() -> [(String, T)] {
//
//    }

}
