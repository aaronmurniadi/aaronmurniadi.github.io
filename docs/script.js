// ========================================
// FONT LOADING & FADE-IN ANIMATION
// ========================================

// Function to handle font loading and fade-in animation
function initializeFontLoading() {
  const loadingOverlay = document.getElementById('loading-spinner');
  const mainContent = document.getElementById('main-content');

  // List of fonts to wait for
  const fontsToLoad = [
    { family: 'Spectral', weight: '400' },
    { family: 'Spectral', weight: '600' },
    { family: 'Spectral SC', weight: '400' },
    { family: 'Spectral SC', weight: '600' },
    { family: 'Floral Capitals', weight: '400' }
  ];

  // Create font loading promises
  const fontPromises = fontsToLoad.map(font => {
    return new FontFace(font.family, `url(https://fonts.cdnfonts.com/s/${font.family.toLowerCase().replace(/\s+/g, '-')}/${font.family.replace(/\s+/g, '')}-${font.weight}.woff2)`, {
      weight: font.weight,
      style: 'normal'
    }).load().catch(() => {
      // If a specific font fails to load, continue anyway
      console.warn(`Failed to load font: ${font.family} ${font.weight}`);
      return null;
    });
  });

  // Alternative approach using document.fonts.ready for broader compatibility
  const fontLoadingPromise = Promise.allSettled([
    ...fontPromises,
    document.fonts.ready
  ]);

  // Set a maximum timeout to prevent infinite loading
  const timeoutPromise = new Promise(resolve => {
    setTimeout(resolve, 5000); // 5 second timeout
  });

  // Wait for fonts to load or timeout
  Promise.race([fontLoadingPromise, timeoutPromise]).then(() => {
    // Add a small delay for smoother transition
    setTimeout(() => {
      // Fade out loading spinner
      loadingOverlay.classList.add('hidden');

      // Fade in main content
      mainContent.classList.add('loaded');

      // Remove loading overlay from DOM after transition
      setTimeout(() => {
        if (loadingOverlay && loadingOverlay.parentNode) {
          loadingOverlay.remove();
        }
      }, 500);
    }, 200);
  });
}

// Initialize font loading when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeFontLoading);
} else {
  initializeFontLoading();
}

// ========================================
// EXISTING FUNCTIONALITY
// ========================================

const firstPWithoutTime = document.querySelector('main p:not(:has(time)):not(blockquote p)');
if (firstPWithoutTime) {
  firstPWithoutTime.classList.add('drop-cap');

  // Wrap first 3 words in a span for small-caps styling while preserving HTML formatting
  const originalHTML = firstPWithoutTime.innerHTML;

  // Create a temporary element to work with the HTML content
  const tempDiv = document.createElement('div');
  tempDiv.innerHTML = originalHTML;

  // Get the text content to count words, but preserve the original HTML structure
  const textContent = tempDiv.textContent || tempDiv.innerText;
  const words = textContent.trim().split(/\s+/);

  if (words.length >= 3) {
    // We need to find where the first 3 words end in the HTML
    // This is a more complex approach that preserves HTML formatting
    const firstThreeWords = words.slice(0, 3).join(' ');

    // Create a walker to traverse text nodes
    const walker = document.createTreeWalker(
      tempDiv,
      NodeFilter.SHOW_TEXT,
      null,
      false
    );

    let wordCount = 0;
    let targetWordCount = 3;
    let textNodes = [];
    let node;

    // Collect all text nodes and count words
    while (node = walker.nextNode()) {
      textNodes.push(node);
    }

    // Find where to split by counting words in text nodes
    let splitNode = null;
    let splitOffset = 0;
    let currentWordCount = 0;

    for (let textNode of textNodes) {
      const nodeText = textNode.textContent;
      const nodeWords = nodeText.trim().split(/\s+/).filter(word => word.length > 0);

      if (currentWordCount + nodeWords.length >= targetWordCount) {
        // The split point is in this node
        splitNode = textNode;
        const wordsNeeded = targetWordCount - currentWordCount;

        // Find the character position after the needed words
        let charCount = 0;
        let wordsSeen = 0;

        for (let i = 0; i < nodeText.length; i++) {
          if (nodeText[i].match(/\s/)) {
            // Found whitespace, check if we've seen enough words
            if (wordsSeen >= wordsNeeded) {
              splitOffset = i;
              break;
            }
          } else if (i === 0 || nodeText[i - 1].match(/\s/)) {
            // Starting a new word
            wordsSeen++;
          }
        }

        // If we've seen all needed words, find the end of the last word
        if (wordsSeen >= wordsNeeded) {
          for (let i = splitOffset; i < nodeText.length; i++) {
            if (nodeText[i].match(/\s/)) {
              splitOffset = i;
              break;
            }
            if (i === nodeText.length - 1) {
              splitOffset = i + 1;
              break;
            }
          }
        }
        break;
      }

      currentWordCount += nodeWords.length;
    }

    if (splitNode && splitOffset > 0) {
      // Split the text node
      const beforeText = splitNode.textContent.substring(0, splitOffset);
      const afterText = splitNode.textContent.substring(splitOffset);

      // Create the span for first three words
      const span = document.createElement('span');
      span.className = 'first-three-words';
      span.textContent = beforeText.trim();

      // Replace the original text node
      const parent = splitNode.parentNode;
      parent.insertBefore(span, splitNode);

      if (afterText.trim()) {
        splitNode.textContent = afterText;
      } else {
        parent.removeChild(splitNode);
      }

      // Update the paragraph's HTML
      firstPWithoutTime.innerHTML = tempDiv.innerHTML;
    }
  }
}

// // Add hierarchical numbering to headers starting from H2
// function addHeaderNumbering() {
//   const headers = document.querySelectorAll('h2, h3, h4, h5, h6');
//   const counters = [0, 0, 0, 0, 0]; // counters for h2, h3, h4, h5, h6

//   headers.forEach(header => {
//     const level = parseInt(header.tagName.charAt(1)) - 2; // h2=0, h3=1, h4=2, etc.

//     // Increment counter for current level
//     counters[level]++;

//     // Reset all deeper level counters
//     for (let i = level + 1; i < counters.length; i++) {
//       counters[i] = 0;
//     }

//     // Build the numbering string
//     let numbering = '';
//     for (let i = 0; i <= level; i++) {
//       if (counters[i] > 0) {
//         numbering += (numbering ? '.' : '') + counters[i];
//       }
//     }

//     // Add the numbering prefix to the header text
//     if (numbering) {
//       header.textContent = numbering + '. ' + header.textContent;
//     }
//   });
// }

// // Run the numbering function when the page loads
// addHeaderNumbering();

// Add tooltip for footnotes
document.querySelectorAll('.footnote-ref').forEach(ref => {
  const tooltip = document.getElementById('footnote-tooltip');

  ref.addEventListener('mouseenter', () => {
    const href = ref.getAttribute('href');
    const footnoteId = href.slice(1);
    const footnote = document.getElementById(footnoteId);

    if (footnote) {
      const clone = footnote.cloneNode(true);
      tooltip.innerHTML = clone.innerHTML;

      // Temporarily show tooltip off-screen to measure it
      tooltip.style.visibility = 'hidden';
      tooltip.style.display = 'block';
      tooltip.style.left = '-9999px';
      tooltip.style.top = '-9999px';

      // Wait for layout to complete before showing at real position
      requestAnimationFrame(() => {
        const tooltipWidth = tooltip.offsetWidth;
        const tooltipHeight = tooltip.offsetHeight;
        const padding = 12;
        const viewportWidth = window.innerWidth;
        const viewportHeight = window.innerHeight;

        const updatePosition = (e) => {
          let left = e.clientX + 10;
          let top = e.clientY + 10;

          if (left + tooltipWidth + padding > viewportWidth) {
            left = viewportWidth - tooltipWidth - padding;
          }
          if (top + tooltipHeight + padding > viewportHeight) {
            top = viewportHeight - tooltipHeight - padding;
          }

          left = Math.max(padding, left);
          top = Math.max(padding, top);

          tooltip.style.left = `${left}px`;
          tooltip.style.top = `${top}px`;
        };

        // Now show tooltip visibly and follow mouse
        tooltip.style.visibility = 'visible';

        // Save and use a single mousemove handler for this tooltip
        const onMouseMove = (e) => updatePosition(e);
        ref.addEventListener('mousemove', onMouseMove);

        // Remove everything on leave
        const onLeave = () => {
          tooltip.style.display = 'none';
          tooltip.style.visibility = 'hidden';
          ref.removeEventListener('mousemove', onMouseMove);
          ref.removeEventListener('mouseleave', onLeave);
        };

        ref.addEventListener('mouseleave', onLeave);
      });
    }
  });
});