import Nat "mo:base/Nat";
import Text "mo:base/Text";

import Random "mo:base/Random";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Nat8 "mo:base/Nat8";
import Blob "mo:base/Blob";

actor {
    // Card type definition
    type Card = {
        suit: Text;
        value: Text;
    };

    // Stable variables for persistence
    stable var cards: [Card] = [];
    stable var seed: Nat = 0;
    stable var lastShuffleTime: Time.Time = 0;

    // Initialize the deck
    private func initDeck() : [Card] {
        let suits = ["hearts", "diamonds", "clubs", "spades"];
        let values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
        
        var deck: [Card] = [];
        for (suit in suits.vals()) {
            for (value in values.vals()) {
                deck := Array.append(deck, [{suit = suit; value = value}]);
            };
        };
        deck
    };

    // Fisher-Yates shuffle implementation
    private func shuffleArray(arr: [Card], seedBlob: Blob) : [Card] {
        let seedArray = Blob.toArray(seedBlob);
        var mutableArray = Array.thaw<Card>(arr);
        var currentIndex = arr.size();
        
        while (currentIndex > 1) {
            currentIndex -= 1;
            let byteIndex = currentIndex % seedArray.size();
            let randomByte = seedArray[byteIndex];
            let randomIndex = Nat8.toNat(randomByte) % (currentIndex + 1);
            
            // Swap elements
            let temp = mutableArray[currentIndex];
            mutableArray[currentIndex] := mutableArray[randomIndex];
            mutableArray[randomIndex] := temp;
        };

        Array.freeze(mutableArray)
    };

    // System functions for upgrade persistence
    system func preupgrade() {
        // No cleanup needed
    };

    system func postupgrade() {
        if (cards.size() == 0) {
            cards := initDeck();
        };
    };

    // Heartbeat function for periodic shuffling
    system func heartbeat() : async () {
        let currentTime = Time.now();
        if (currentTime > lastShuffleTime + 10_000_000_000) { // 10 seconds in nanoseconds
            let entropy = await Random.blob();
            cards := shuffleArray(cards, entropy);
            lastShuffleTime := currentTime;
            seed += 1;
        };
    };

    // Shuffle the cards
    public shared func shuffleCards() : async () {
        let entropy = await Random.blob();
        cards := shuffleArray(cards, entropy);
        lastShuffleTime := Time.now();
        seed += 1;
    };

    // Get the current state of cards
    public query func getCards() : async [Card] {
        cards
    };
}
