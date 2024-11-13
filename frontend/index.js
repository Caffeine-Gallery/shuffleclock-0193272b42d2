import { backend } from "declarations/backend";

const cardContainer = document.getElementById("cardContainer");
const loadingElement = document.getElementById("loading");
const timerElement = document.getElementById("timer");

let countdown = 10;

const suits = {
    "hearts": "♥",
    "diamonds": "♦",
    "clubs": "♣",
    "spades": "♠"
};

function showLoading() {
    loadingElement.classList.remove("d-none");
    cardContainer.classList.add("opacity-50");
}

function hideLoading() {
    loadingElement.classList.add("d-none");
    cardContainer.classList.remove("opacity-50");
}

function createCardElement(card) {
    const cardDiv = document.createElement("div");
    cardDiv.className = "card";
    const symbol = suits[card.suit];
    const color = card.suit === "hearts" || card.suit === "diamonds" ? "red" : "black";
    
    cardDiv.innerHTML = `
        <div class="card-inner" style="color: ${color}">
            <div class="card-value">${card.value}</div>
            <div class="card-suit">${symbol}</div>
        </div>
    `;
    return cardDiv;
}

async function updateCards() {
    showLoading();
    try {
        const cards = await backend.getCards();
        cardContainer.innerHTML = "";
        cards.forEach(card => {
            cardContainer.appendChild(createCardElement(card));
        });
    } catch (error) {
        console.error("Error fetching cards:", error);
    }
    hideLoading();
}

function updateTimer() {
    countdown--;
    timerElement.textContent = `Next shuffle in: ${countdown}s`;
    
    if (countdown <= 0) {
        countdown = 10;
        updateCards();
    }
}

// Initial load
updateCards();

// Update timer every second
setInterval(updateTimer, 1000);
