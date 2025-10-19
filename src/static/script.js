// ========================================
// FONT LOADING & FADE-IN ANIMATION
// ========================================

// Function to handle font loading and fade-in animation
function initializeFontLoading() {
  const loadingOverlay = document.getElementById('loading-spinner');
  const mainContent = document.getElementById('main-content');

  // Check if the browser supports the Font Loading API
  if ('fonts' in document) {
    // Use document.fonts.ready to wait for all CSS-declared fonts to load
    // This is more efficient than loading individual font files
    const fontLoadingPromise = document.fonts.ready;

    // Set a maximum timeout to prevent infinite loading
    const timeoutPromise = new Promise((resolve) => {
      setTimeout(resolve, 2000); // 2 second timeout (reduced from 3)
    });

    // Wait for fonts to load or timeout, whichever comes first
    Promise.race([fontLoadingPromise, timeoutPromise])
      .then(() => showContent())
      .catch(() => showContent()); // Ensure content shows even if font loading fails
  } else {
    // Fallback for browsers that don't support the Font Loading API
    setTimeout(showContent, 1000);
  }

  // Function to show content and hide loading spinner
  function showContent() {
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
  }
}

// Initialize font loading as early as possible
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeFontLoading);
} else {
  // Execute immediately if DOM is already loaded
  initializeFontLoading();
}

// Add support for requestIdleCallback for non-critical operations
const requestIdleCallback = window.requestIdleCallback ||
  function (cb) {
    return setTimeout(function () {
      const start = Date.now();
      cb({
        didTimeout: false,
        timeRemaining: function () {
          return Math.max(0, 50 - (Date.now() - start));
        }
      });
    }, 1);
  };

// ========================================
// DROPCAP AND FIRST THREE WORDS
// ========================================

// Process dropcap and first three words styling after initial render
function processDropcap() {
  const firstPWithoutTime = document.querySelector(
    'main p:not(:has(time)):not(blockquote p)'
  );
  if (!firstPWithoutTime) return;

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

// Defer dropcap processing to not block initial render
window.addEventListener('load', () => {
  requestIdleCallback(() => {
    processDropcap();
  }, { timeout: 2000 });
});

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

// Move footnotes to sidenotes
function moveFootnotesToSidenotes() {
  // Check if we have the sidenote container
  const sidenoteContainer = document.querySelector('.sidenote-container');
  if (!sidenoteContainer) return;

  // Look for the footnote div with the specific structure
  const footnoteDiv = document.querySelector('.footnote');
  if (!footnoteDiv) return;

  // Get all footnote references
  const footnoteRefs = document.querySelectorAll('sup[id^="fnref:"] a.footnote-ref');
  if (!footnoteRefs.length) return;

  // Create a map to store footnote content by ID
  const footnoteMap = new Map();

  // Extract all footnote content from the footnote div
  const footnoteItems = footnoteDiv.querySelectorAll('li[id^="fn:"]');
  footnoteItems.forEach(item => {
    const id = item.id;
    // Get the content but remove the back-reference link
    const content = item.innerHTML.replace(/<a class="footnote-backref".*?<\/a>/g, '');
    footnoteMap.set(id, content);
  });

  // Check if the column layout is horizontal (side-by-side) or vertical
  const isColumnLayoutHorizontal = () => {
    const layout = document.querySelector('.three-column-layout');
    return layout && window.getComputedStyle(layout).flexDirection === 'row';
  };

  // Function to toggle between sidenote and traditional footnote mode
  const toggleFootnoteMode = () => {
    const sidenoteElements = document.querySelectorAll('.sidenote-footnote');
    const isHorizontal = isColumnLayoutHorizontal();

    if (isHorizontal) {
      // Show sidenotes, hide traditional footnotes
      sidenoteElements.forEach(el => el.style.display = 'block');
      if (footnoteDiv) footnoteDiv.style.display = 'none';
      sidenoteContainer.style.display = 'block';
    } else {
      // Hide sidenotes, show traditional footnotes
      sidenoteElements.forEach(el => el.style.display = 'none');
      if (footnoteDiv) footnoteDiv.style.display = 'block';
      sidenoteContainer.style.display = 'none';
    }
  };

  // Process each footnote reference
  footnoteRefs.forEach((ref, index) => {
    // The href might be "#fn:1" for a reference to footnote 1
    const href = ref.getAttribute('href');
    if (!href || !href.startsWith('#fn:')) return;

    const footnoteId = href.slice(1); // Remove the # to get "fn:1"
    const footnoteContent = footnoteMap.get(footnoteId);

    if (footnoteContent) {
      // Create a sidenote element
      const sidenoteFootnote = document.createElement('div');
      sidenoteFootnote.className = 'sidenote-footnote';
      sidenoteFootnote.id = `sidenote-${footnoteId}`;

      // Extract just the text content for cleaner display in sidenotes
      const tempDiv = document.createElement('div');
      tempDiv.innerHTML = footnoteContent;

      // Remove any nested <p> tags but keep their content
      const paragraphs = tempDiv.querySelectorAll('p');
      paragraphs.forEach(p => {
        const parent = p.parentNode;
        while (p.firstChild) {
          parent.insertBefore(p.firstChild, p);
        }
        parent.removeChild(p);
      });

      sidenoteFootnote.innerHTML = tempDiv.innerHTML;

      // Add footnote marker
      const marker = document.createElement('span');
      marker.className = 'sidenote-footnote-marker';
      marker.textContent = ref.textContent;
      sidenoteFootnote.prepend(marker);

      // Add to sidenote container
      sidenoteContainer.appendChild(sidenoteFootnote);

      // Get the sup element that contains the reference
      const supElement = ref.closest('sup[id^="fnref:"]');

      // Position the sidenote at the same vertical position as the reference
      positionSidenoteFootnote(supElement || ref, sidenoteFootnote);

      // Update positioning on window resize
      window.addEventListener('resize', () => {
        toggleFootnoteMode();
        if (isColumnLayoutHorizontal()) {
          const supElement = ref.closest('sup[id^="fnref:"]');
          positionSidenoteFootnote(supElement || ref, sidenoteFootnote);
        }
      });

      // Make the reference clickable to highlight the sidenote or navigate to footnote
      ref.addEventListener('click', (e) => {
        e.preventDefault();
        if (isColumnLayoutHorizontal()) {
          highlightSidenoteFootnote(sidenoteFootnote);
        } else {
          // Use default behavior to navigate to footnote at the bottom
          window.location.href = href;
        }
      });
    }
  });

  // Initial toggle based on current viewport size
  toggleFootnoteMode();
}

// Position a sidenote footnote at the same vertical position as its reference
function positionSidenoteFootnote(reference, footnote) {
  const refRect = reference.getBoundingClientRect();
  const mainContent = document.querySelector('.column-content');
  const sidenoteColumn = document.querySelector('.column-sidenotes');

  if (!mainContent || !sidenoteColumn) return;

  const mainRect = mainContent.getBoundingClientRect();
  const sidenoteRect = sidenoteColumn.getBoundingClientRect();

  // Calculate the vertical position relative to the sidenote container
  // Add an offset to align the top of the sidenote with the reference
  const footnoteHeight = footnote.getBoundingClientRect().height;
  const referenceHeight = refRect.height;
  const verticalOffset = (referenceHeight - footnoteHeight) / 2;
  const relativeTop = refRect.top - sidenoteRect.top + verticalOffset;

  // Set the position
  footnote.style.top = `${relativeTop}px`;
  footnote.classList.add('positioned');
}

// Highlight a sidenote footnote when its reference is clicked
function highlightSidenoteFootnote(footnote) {
  // Remove highlight from all footnotes
  document.querySelectorAll('.sidenote-footnote').forEach(note => {
    note.style.backgroundColor = '';
  });

  // Highlight this footnote
  footnote.style.backgroundColor = 'rgba(150, 150, 150, 0.1)';

  // Scroll the sidenote into view if needed
  footnote.scrollIntoView({ behavior: 'smooth', block: 'center' });

  // Remove highlight after a delay
  setTimeout(() => {
    footnote.style.backgroundColor = '';
  }, 2000);
}

// Initialize sidenote footnotes when the page is fully loaded
// Use requestIdleCallback to defer non-critical operations
document.addEventListener('DOMContentLoaded', () => {
  // Use requestIdleCallback to move footnotes without blocking rendering
  requestIdleCallback(() => {
    moveFootnotesToSidenotes();
  }, { timeout: 1000 }); // Ensure it runs within 1 second even if the browser is busy

  // Then ensure it works after full page load
  window.addEventListener('load', () => {
    // Re-position all sidenotes after everything is loaded
    requestIdleCallback(() => {
      document.querySelectorAll('.sidenote-footnote').forEach(footnote => {
        const footnoteId = footnote.id;
        if (footnoteId && footnoteId.startsWith('sidenote-fn:')) {
          const refId = 'fnref:' + footnoteId.replace('sidenote-fn:', '');
          const reference = document.getElementById(refId);
          if (reference) {
            positionSidenoteFootnote(reference, footnote);
          }
        }
      });
    }, { timeout: 2000 });
  });
});

// Add tooltip for footnotes (fallback for mobile or when sidenotes aren't visible)
document.querySelectorAll('sup[id^="fnref:"] a.footnote-ref').forEach((ref) => {
  const tooltip = document.getElementById('footnote-tooltip');
  if (!tooltip) return;

  ref.addEventListener('mouseenter', () => {
    // Don't show tooltip if column layout is horizontal and sidenotes are visible
    if (isColumnLayoutHorizontal()) {
      const sidenoteColumn = document.querySelector('.column-sidenotes');
      if (sidenoteColumn && window.getComputedStyle(sidenoteColumn).display !== 'none') {
        return; // Don't show tooltip if sidenotes are visible
      }
    }

    const href = ref.getAttribute('href');
    if (!href || !href.startsWith('#fn:')) return;

    const footnoteId = href.slice(1);
    const footnote = document.getElementById(footnoteId);

    if (footnote) {
      // Clone the footnote but remove the back reference
      const clone = footnote.cloneNode(true);
      const backRef = clone.querySelector('.footnote-backref');
      if (backRef) backRef.remove();

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