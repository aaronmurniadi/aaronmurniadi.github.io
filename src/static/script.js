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
  document.addEventListener('DOMContentLoaded', () => {
    initializeFontLoading();
    initPhotoGallery();
  });
} else {
  // Execute immediately if DOM is already loaded
  initializeFontLoading();
  initPhotoGallery();
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

// Photography lightbox functionality
function initPhotoGallery() {
  const lightbox = document.getElementById('lightbox');
  const lightboxImg = document.getElementById('lightbox-img');
  const closeButton = document.querySelector('.close-button');

  if (!lightbox || !lightboxImg) return;

  // Find all photo links
  const photoLinks = document.querySelectorAll('.photo-link');

  photoLinks.forEach(link => {
    link.addEventListener('click', function (e) {
      e.preventDefault();

      // Get the full-size image URL
      const fullSizeUrl = this.getAttribute('href');

      // Get caption content from the next sibling
      const captionElement = this.nextElementSibling;
      let captionHTML = '';

      if (captionElement && captionElement.classList.contains('photo-caption')) {
        captionHTML = captionElement.innerHTML;
      }

      // Set the lightbox image source
      lightboxImg.src = fullSizeUrl;

      // Show the lightbox
      lightbox.classList.add('active');

      // Prevent scrolling on the body
      document.body.style.overflow = 'hidden';
    });
  });

  // Close lightbox when clicking the close button
  if (closeButton) {
    closeButton.addEventListener('click', closeLightbox);
  }

  // Close lightbox when clicking outside the image
  lightbox.addEventListener('click', function (e) {
    if (e.target === lightbox) {
      closeLightbox();
    }
  });

  // Close lightbox when pressing ESC key
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && lightbox.classList.contains('active')) {
      closeLightbox();
    }
  });

  function closeLightbox() {
    lightbox.classList.remove('active');
    document.body.style.overflow = '';

    // Clear the image src after a short delay to prevent image flashing
    setTimeout(() => {
      lightboxImg.src = '';
    }, 300);
  }
}

// ========================================
// DROPCAP AND FIRST THREE WORDS
// ========================================

// Process dropcap and first three words styling after initial render
function processDropcap() {
  const firstPWithoutTime = document.querySelector(
    '.column-content p:not(:has(time)):not(blockquote p)'
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

// Create sidenotes from footnotes with synchronized positioning
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

  // Add content-with-sidenotes class to column-content
  const contentWrapper = document.querySelector('.column-content');
  if (contentWrapper) {
    contentWrapper.classList.add('content-with-sidenotes');
  }

  // Clear existing sidenotes
  sidenoteContainer.innerHTML = '';

  // Process each footnote reference
  footnoteRefs.forEach((ref, index) => {
    // The href might be "#fn:1" for a reference to footnote 1
    const href = ref.getAttribute('href');
    if (!href || !href.startsWith('#fn:')) return;

    const footnoteId = href.slice(1); // Remove the # to get "fn:1"
    const footnoteContent = footnoteMap.get(footnoteId);

    if (footnoteContent) {
      // Get the parent paragraph or element containing the reference
      const supElement = ref.closest('sup[id^="fnref:"]');
      const refParent = supElement ? supElement.parentNode : null;

      if (refParent) {
        // Create a marker element at the reference point
        const marker = document.createElement('span');
        marker.className = 'sidenote-marker';
        marker.id = `marker-${footnoteId}`;
        marker.dataset.footnoteId = footnoteId;
        marker.setAttribute('aria-hidden', 'true');

        // Insert the marker right after the sup element
        if (supElement.nextSibling) {
          refParent.insertBefore(marker, supElement.nextSibling);
        } else {
          refParent.appendChild(marker);
        }

        // Create a sidenote element
        const sidenoteFootnote = document.createElement('div');
        sidenoteFootnote.className = 'sidenote-footnote';
        sidenoteFootnote.id = `sidenote-${footnoteId}`;
        sidenoteFootnote.dataset.footnoteId = footnoteId;

        // Add the reference number to the sidenote for identification
        const refNumber = ref.textContent;
        sidenoteFootnote.dataset.refNumber = refNumber;

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
        const markerSpan = document.createElement('span');
        markerSpan.className = 'sidenote-footnote-marker';
        markerSpan.textContent = refNumber;
        sidenoteFootnote.prepend(markerSpan);

        // Add to sidenote container
        sidenoteContainer.appendChild(sidenoteFootnote);

        // Make the reference clickable to highlight the sidenote
        ref.addEventListener('click', (e) => {
          if (window.innerWidth >= 1024) {
            e.preventDefault();
            // Highlight the sidenote
            document.querySelectorAll('.sidenote-footnote').forEach(note => {
              note.classList.remove('highlighted');
            });
            sidenoteFootnote.classList.add('highlighted');

            // Scroll the sidenote into view if needed
            sidenoteFootnote.scrollIntoView({ behavior: 'smooth', block: 'center' });

            // Remove highlight after a delay
            setTimeout(() => {
              sidenoteFootnote.classList.remove('highlighted');
            }, 2000);
          }
          // On mobile, let the browser handle the navigation to the footnote
        });
      }
    }
  });

  // Add a class to the body to indicate sidenotes are ready
  document.body.classList.add('sidenotes-processed');
}

// Synchronize sidenotes with their reference positions
function synchronizeSidenotes(forceUpdate = false) {
  if (window.innerWidth < 1024) return; // Only run in desktop mode

  const markers = document.querySelectorAll('.sidenote-marker');
  const sidenotes = document.querySelectorAll('.sidenote-footnote');
  const sidenoteContainer = document.querySelector('.sidenote-container');
  const columnSidenotes = document.querySelector('.column-sidenotes');

  if (!markers.length || !sidenotes.length || !sidenoteContainer || !columnSidenotes) return;

  // Get container dimensions - use column-sidenotes for positioning context
  const containerRect = columnSidenotes.getBoundingClientRect();
  const containerTop = containerRect.top;
  const containerHeight = containerRect.height;

  // Create a map for faster lookups
  const sidenoteMap = new Map();
  sidenotes.forEach(note => {
    sidenoteMap.set(note.dataset.footnoteId, note);
  });

  // Position each sidenote based on its marker position
  markers.forEach(marker => {
    const footnoteId = marker.dataset.footnoteId;
    const sidenote = sidenoteMap.get(footnoteId);

    if (sidenote) {
      const markerRect = marker.getBoundingClientRect();
      const markerTop = markerRect.top;

      // Calculate position relative to the sidenote container
      let relativeTop = markerTop - containerTop;

      // Ensure the sidenote stays within the container
      const sidenoteHeight = sidenote.offsetHeight;
      const maxTop = containerHeight - sidenoteHeight - 20; // Add some bottom margin

      // Adjust position if it would overflow
      if (relativeTop > maxTop) {
        relativeTop = maxTop;
      }
      if (relativeTop < 0) {
        relativeTop = 0;
      }

      // Only update position if it's changed significantly or on force update
      const currentTop = parseInt(sidenote.style.top) || 0;
      if (forceUpdate || Math.abs(currentTop - relativeTop) > 5) {
        // Use transform for smoother animation instead of changing top
        sidenote.style.transform = `translateY(${relativeTop}px)`;
      }

      // Check if the marker is in the viewport with some buffer
      const buffer = 100; // 100px buffer above and below viewport
      const isInViewport = (
        markerRect.top >= -buffer &&
        markerRect.top <= (window.innerHeight + buffer)
      );

      // Show sidenote if its marker is in viewport
      if (isInViewport) {
        if (!sidenote.classList.contains('in-view')) {
          sidenote.classList.add('in-view');
        }
      } else {
        if (sidenote.classList.contains('in-view')) {
          sidenote.classList.remove('in-view');
        }
      }
    }
  });
}

// Use requestAnimationFrame for smoother scrolling
let ticking = false;
function requestSyncUpdate() {
  if (!ticking) {
    requestAnimationFrame(() => {
      synchronizeSidenotes();
      ticking = false;
    });
    ticking = true;
  }
}

// Initialize sidenote footnotes when the page is fully loaded
document.addEventListener('DOMContentLoaded', () => {
  // Use requestIdleCallback to move footnotes without blocking rendering
  requestIdleCallback(() => {
    moveFootnotesToSidenotes();

    // Initial synchronization with forced update
    synchronizeSidenotes(true);

    // Synchronize on scroll using requestAnimationFrame for smoother performance
    window.addEventListener('scroll', requestSyncUpdate, { passive: true });

    // Synchronize on resize with debouncing
    let resizeTimeout;
    window.addEventListener('resize', () => {
      clearTimeout(resizeTimeout);
      resizeTimeout = setTimeout(() => {
        synchronizeSidenotes(true); // Force update on resize
      }, 200); // Debounce to run 200ms after resize ends
    });
  }, { timeout: 1000 }); // Ensure it runs within 1 second even if the browser is busy
});

// Add tooltip for footnotes (simpler implementation)
document.querySelectorAll('sup[id^="fnref:"] a.footnote-ref').forEach((ref) => {
  const tooltip = document.getElementById('footnote-tooltip');
  if (!tooltip) return;

  ref.addEventListener('mouseenter', () => {
    // Only show tooltip in mobile view when sidenotes aren't visible
    if (window.innerWidth >= 1024) {
      return; // Don't show tooltip in desktop view
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
      tooltip.style.display = 'block';

      // Simple positioning near the reference
      const refRect = ref.getBoundingClientRect();
      tooltip.style.top = `${refRect.bottom + window.scrollY + 5}px`;
      tooltip.style.left = `${refRect.left + window.scrollX}px`;

      // Remove tooltip when mouse leaves
      const onLeave = () => {
        tooltip.style.display = 'none';
        ref.removeEventListener('mouseleave', onLeave);
      };

      ref.addEventListener('mouseleave', onLeave);
    }
  });
});