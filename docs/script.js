const firstPWithoutTime = document.querySelector('main p:not(:has(time))');
if (firstPWithoutTime) {
  firstPWithoutTime.classList.add('drop-cap');
}

// Add hierarchical numbering to headers starting from H2
function addHeaderNumbering() {
  const headers = document.querySelectorAll('h2, h3, h4, h5, h6');
  const counters = [0, 0, 0, 0, 0]; // counters for h2, h3, h4, h5, h6
  
  headers.forEach(header => {
    const level = parseInt(header.tagName.charAt(1)) - 2; // h2=0, h3=1, h4=2, etc.
    
    // Increment counter for current level
    counters[level]++;
    
    // Reset all deeper level counters
    for (let i = level + 1; i < counters.length; i++) {
      counters[i] = 0;
    }
    
    // Build the numbering string
    let numbering = '';
    for (let i = 0; i <= level; i++) {
      if (counters[i] > 0) {
        numbering += (numbering ? '.' : '') + counters[i];
      }
    }
    
    // Add the numbering prefix to the header text
    if (numbering) {
      header.textContent = numbering + '. ' + header.textContent;
    }
  });
}

// Run the numbering function when the page loads
addHeaderNumbering();