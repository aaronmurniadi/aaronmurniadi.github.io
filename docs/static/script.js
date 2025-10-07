// ========================================
// FONT LOADING & FADE-IN ANIMATION
// ========================================

// Function to handle font loading and fade-in animation
function initializeFontLoading() {
  const loadingOverlay = document.getElementById('loading-spinner');
  const mainContent = document.getElementById('main-content');

  // Use document.fonts.ready instead of trying to load individual font files
  // This waits for all CSS-declared fonts to load
  const fontLoadingPromise = document.fonts.ready;

  // Set a maximum timeout to prevent infinite loading
  const timeoutPromise = new Promise((resolve) => {
    setTimeout(resolve, 3000); // 3 second timeout (reduced from 5)
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
// DROPCAP AND FIRST THREE WORDS
// ========================================

const firstPWithoutTime = document.querySelector(
  'main p:not(:has(time)):not(blockquote p)'
);
if (firstPWithoutTime) {
  firstPWithoutTime.classList.add('drop-cap');

  // Wrap first 3 words in a span for small-caps styling while preserving HTML formatting
  // Also wrap the first letter in a div with class "first-letter"
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
    // Create a walker to traverse text nodes
    const walker = document.createTreeWalker(
      tempDiv,
      NodeFilter.SHOW_TEXT,
      null,
      false
    );

    let targetWordCount = 3;
    let textNodes = [];
    let node;

    // Collect all text nodes and count words
    while ((node = walker.nextNode())) {
      textNodes.push(node);
    }

    // Find where to split by counting words in text nodes
    let splitNode = null;
    let splitOffset = 0;
    let currentWordCount = 0;

    for (let textNode of textNodes) {
      const nodeText = textNode.textContent;
      const nodeWords = nodeText
        .trim()
        .split(/\s+/)
        .filter((word) => word.length > 0);

      if (currentWordCount + nodeWords.length >= targetWordCount) {
        // The split point is in this node
        splitNode = textNode;
        const wordsNeeded = targetWordCount - currentWordCount;

        // Find the character position after the needed words
        let wordsSeen = 0;
        let splitFound = false;
        for (let i = 0; i < nodeText.length; i++) {
          if (nodeText[i].match(/\s/)) {
            if (wordsSeen >= wordsNeeded) {
              splitOffset = i;
              splitFound = true;
              break;
            }
          } else if (i === 0 || nodeText[i - 1].match(/\s/)) {
            wordsSeen++;
          }
        }
        // If we've seen all needed words, find the end of the last word
        if (wordsSeen >= wordsNeeded && !splitFound) {
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

      // Find the first letter to create the drop-cap
      const firstLetterMatch = beforeText.match(/^\s*(\S)/);
      const parent = splitNode.parentNode;

      if (firstLetterMatch) {
        const firstLetter = firstLetterMatch[1];
        const firstLetterIndex = beforeText.indexOf(firstLetter);

        // Create the div for the first letter
        const firstLetterDiv = document.createElement('div');
        firstLetterDiv.className = 'first-letter';
        firstLetterDiv.textContent = firstLetter;

        // The rest of the text for the first three words span
        const remainingText =
          beforeText.slice(0, firstLetterIndex) +
          beforeText.slice(firstLetterIndex + 1);

        // Create the span for first three words (without the first letter)
        const threeWordsSpan = document.createElement('span');
        threeWordsSpan.className = 'first-three-words';
        threeWordsSpan.textContent = remainingText.trim();

        // Insert the new elements before the original text node
        parent.insertBefore(firstLetterDiv, splitNode);
        parent.insertBefore(threeWordsSpan, splitNode);
      } else {
        // Fallback for cases where no letter is found (e.g., only whitespace)
        const span = document.createElement('span');
        span.className = 'first-three-words';
        span.textContent = beforeText.trim();
        parent.insertBefore(span, splitNode);
      }

      // Handle the text after the first three words
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
document.querySelectorAll('.footnote-ref').forEach((ref) => {
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

// ========================================
// RIVER OF WHITE DETECTOR
// ========================================

const SHOW_RIVER_BORDER = false;

// --- Algorithm Parameters ---
const GAP_THRESHOLD_MULTIPLIER = 3.5;
const MAX_WORD_SPACING_ITERATIONS = 25;
const MAX_LETTER_SPACING_ITERATIONS = 15; 
const WORD_SPACING_STEP = -0.002; // em
const LETTER_SPACING_STEP = -0.002; // em
// --- End of Parameters ---

// Debounce function to limit how often a function can run.
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

const modifiedElements = new Map();

// This script detects "rivers of white" in justified text blocks.
// It works by measuring the gaps between words and highlights elements
// where these gaps are excessively large, which is a common typography issue.
function detectAndCorrectRivers() {
  // Restore any previously modified elements to their original state before re-running.
  modifiedElements.forEach(
    ({ originalHTML, originalLetterSpacing, originalWordSpacing }, element) => {
      element.innerHTML = originalHTML;
      if (SHOW_RIVER_BORDER) {
        element.style.outline = '';
        element.style.outlineOffset = '';
      }
      element.style.letterSpacing = originalLetterSpacing;
      element.style.wordSpacing = originalWordSpacing;
    }
  );
  modifiedElements.clear();

  // Select all paragraphs and list items within the main content area.
  const elements = document.querySelectorAll('main p, main li');

  elements.forEach((element) => {
    const style = window.getComputedStyle(element);
    // Only process elements with justified text alignment.
    if (style.textAlign !== 'justify') {
      return;
    }

    const originalHTML = element.innerHTML;
    const originalLetterSpacing = style.letterSpacing;
    const originalWordSpacing = style.wordSpacing;

    if (checkElementForRivers(element)) {
      // Store original state before attempting to fix.
      modifiedElements.set(element, {
        originalHTML,
        originalLetterSpacing,
        originalWordSpacing,
      });

      // Attempt to fix the issue iteratively.
      iterativelyAdjustSpacing(element);

      // Mark the element as adjusted, regardless of success.
      if (SHOW_RIVER_BORDER) {
        element.style.outline = '1px solid rgba(255, 0, 0, 0.5)';
        element.style.outlineOffset = '2px';
      }
    }
  });
}

// Checks a single element for "rivers of white" without permanent DOM changes.
function checkElementForRivers(element) {
  const originalHTML = element.innerHTML;
  let hasLargeGap = false;

  // Wrap words in temporary spans to measure their positions.
  function wrapWordsInSpans(node) {
    if (node.nodeType === Node.TEXT_NODE && node.nodeValue.trim().length > 0) {
      const fragment = document.createDocumentFragment();
      const words = node.nodeValue.split(/(\s+)/);
      words.forEach((word) => {
        if (word.trim().length > 0) {
          const span = document.createElement('span');
          span.className = 'word-span-for-river-detection';
          span.textContent = word;
          fragment.appendChild(span);
        } else {
          fragment.appendChild(document.createTextNode(word));
        }
      });
      node.parentNode.replaceChild(fragment, node);
    } else if (node.nodeType === Node.ELEMENT_NODE) {
      Array.from(node.childNodes).forEach(wrapWordsInSpans);
    }
  }

  wrapWordsInSpans(element);

  const wordSpans = element.querySelectorAll('.word-span-for-river-detection');

  if (wordSpans.length >= 15) {
    const spaceMeasure = document.createElement('span');
    spaceMeasure.style.visibility = 'hidden';
    spaceMeasure.style.whiteSpace = 'pre';
    spaceMeasure.textContent = ' ';
    element.appendChild(spaceMeasure);
    const spaceWidth = spaceMeasure.getBoundingClientRect().width;
    element.removeChild(spaceMeasure);

    const lines = new Map();
    wordSpans.forEach((span) => {
      const top = Math.round(span.getBoundingClientRect().top);
      if (!lines.has(top)) {
        lines.set(top, []);
      }
      lines.get(top).push(span);
    });

    const largeGapThreshold = spaceWidth * GAP_THRESHOLD_MULTIPLIER;

    for (const lineSpans of lines.values()) {
      if (lineSpans.length < 2) continue;
      lineSpans.sort(
        (a, b) =>
          a.getBoundingClientRect().left - b.getBoundingClientRect().left
      );
      for (let i = 0; i < lineSpans.length - 1; i++) {
        const currentRect = lineSpans[i].getBoundingClientRect();
        const nextRect = lineSpans[i + 1].getBoundingClientRect();
        const gap = nextRect.left - currentRect.right;
        if (gap > largeGapThreshold) {
          hasLargeGap = true;
          break;
        }
      }
      if (hasLargeGap) break;
    }
  }

  // Restore the original content to undo the temporary spans.
  element.innerHTML = originalHTML;
  return hasLargeGap;
}

// Iteratively adjusts spacing to try and fix rivers.
function iterativelyAdjustSpacing(element) {
  // Phase 1: Adjust word-spacing first, as it's generally more effective.
  for (let i = 1; i <= MAX_WORD_SPACING_ITERATIONS; i++) {
    element.style.wordSpacing = `${WORD_SPACING_STEP * i}em`;
    if (!checkElementForRivers(element)) {
      return true; // Problem solved.
    }
  }

  // Phase 2: If not solved, also adjust letter-spacing.
  // word-spacing is kept at its most adjusted value from Phase 1.
  for (let i = 1; i <= MAX_LETTER_SPACING_ITERATIONS; i++) {
    element.style.letterSpacing = `${LETTER_SPACING_STEP * i}em`;
    if (!checkElementForRivers(element)) {
      return true; // Problem solved.
    }
  }

  // If the process completes and the issue wasn't fixed, reset to avoid overly tight text.
  element.style.letterSpacing = '';
  element.style.wordSpacing = '';
  return false; // Could not solve.
}

// Run the river detection script after the page has fully loaded,
// ensuring all styles and assets are in place for accurate measurements.
window.addEventListener('load', detectAndCorrectRivers);
window.addEventListener('resize', debounce(detectAndCorrectRivers, 250));
