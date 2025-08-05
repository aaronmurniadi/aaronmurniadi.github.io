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