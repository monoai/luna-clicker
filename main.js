let cookieCount = parseInt(localStorage.getItem('cookieCount')) || 0;
let autoClickerCount = parseInt(localStorage.getItem('autoClickerCount')) || 0;
let autoClickerCost = 100;
let grandmaCount = parseInt(localStorage.getItem('grandmaCount')) || 0;
let grandmaCost = 500;

updateScoreDisplay();
startAutoClickers();

document.getElementById('cookie').addEventListener('click', function() {
    cookieCount++;
    localStorage.setItem('cookieCount', cookieCount);
    updateScoreDisplay();
});

function updateScoreDisplay() {
    document.getElementById('score').textContent = `Cookies: ${cookieCount}`;
    document.getElementById('autoClickers').textContent = `Auto-Clickers: ${autoClickerCount}`;
    document.getElementById('grandmas').textContent = `Grandmas: ${grandmaCount}`;
}

document.getElementById('autoClicker-btn').addEventListener('click', function() {
    if (cookieCount >= autoClickerCost) {
        cookieCount -= autoClickerCost;
        autoClickerCount++;
        autoClickerCost = Math.ceil(autoClickerCost * 1.15); // Increase cost by 15%

        localStorage.setItem('cookieCount', cookieCount);
        localStorage.setItem('autoClickerCount', autoClickerCount);
        updateScoreDisplay();
        updateAutoClickerDisplay();
    } else {
        alert("You need more cookies!");
    }
});

document.getElementById('grandma-btn').addEventListener('click', function() {
    if (cookieCount >= grandmaCost) {
        cookieCount -= grandmaCost;
        grandmaCount++;
        grandmaCost = Math.ceil(grandmaCost * 1.15); // Grandmas become more expensive too

        localStorage.setItem('cookieCount', cookieCount);
        localStorage.setItem('grandmaCount', grandmaCount);
        updateScoreDisplay();
        updateGrandmaDisplay();
    } else {
        alert("You need more cookies for a Grandma!");
    }
});

function updateGrandmaDisplay() {
    document.getElementById('grandma-btn').textContent = `Hire Grandma (Cost: ${grandmaCost} Cookies)`;
}

function updateAutoClickerDisplay() {
    document.getElementById('autoClicker-btn').textContent = `Buy Auto-Clicker (Cost: ${autoClickerCost} Cookies)`;
}

function startAutoClickers() {
    setInterval(function() {
        cookieCount += autoClickerCount;
        localStorage.setItem('cookieCount', cookieCount);
        updateScoreDisplay();
    }, 1000); // Add cookies every second
}

// Call this function on page load to update the button display
updateAutoClickerDisplay();
updateGrandmaDisplay();
