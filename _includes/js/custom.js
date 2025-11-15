const sideNoteStartMargin = 12,
  sideNoteMaxWidth = 280,
  sideNoteMinWidth = 140;

window.addEventListener("load", function () {
  const footnotes = document.querySelector(".footnotes");

  // don't run this script if there aren't any footnotes
  if (!footnotes) {
    return;
  }

  loadSideNotesFromFootnotes();

  window.addEventListener("resize", function () {
    loadSideNotesFromFootnotes();
  });

  function loadSideNotesFromFootnotes() {
    const postTitle = document.querySelector("title");
    const post = document.querySelector("main");

    // remove any existing side notes to begin
    document.querySelectorAll(".sidenote").forEach(sidenote => sidenote.remove());

    if (footnotes) footnotes.style.display = ""; // previous resize could have hidden footnotes

    //#region Should we even show sidenotes?

    //#region there's no post-content
    if (!postTitle) {
      return;
    }
    //#endregion

    //#region there's no space for sidenotes
    const browserWidth = post ? post.offsetWidth : 0;
    // Instead of positioning to the left of the main post, position to the right edge of main + margin
    // Post main is typically centered in the viewport, so footnotes should be placed to the *right* of main
    const postRect = post ? post.getBoundingClientRect() : { left: 0, width: 0 };
    const scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;
    const startPosition = postRect.left + scrollLeft + postRect.width + sideNoteStartMargin;
    const availabeSpaceForSideNote = (window.innerWidth - startPosition);

    if (availabeSpaceForSideNote < sideNoteMinWidth) {
      return;
    }
    //#endregion

    //#endregion

    // Get footnote list items
    const fnItems = [];
    const ol = footnotes.querySelector("ol");
    if (ol) {
      ol.querySelectorAll("li").forEach(li => fnItems.push(li));
    }

    // Find all <sup> and attach sidenotes
    const sups = document.querySelectorAll("sup");
    sups.forEach(function (sup, index) {
      if (!fnItems[index]) return;
      const footnoteHtml = fnItems[index].innerHTML;
      createSideNote(sup, footnoteHtml, startPosition, index);
    });

    if (footnotes) footnotes.style.display = "none";
  }

  function createSideNote(superscript, footnoteHtml, startPosition, index) {
    const div = document.createElement('div');
    // Append the footnote index number to the sidenote (index is zero-based, so +1)
    // Insert the index at the beginning, styled as superscript, before the sidenote text
    // div.innerHTML = '<sup>' + (index + 1) + '</sup> ' + footnoteHtml;
    div.innerHTML = footnoteHtml;
    div.classList.add("sidenote");

    const rect = superscript.getBoundingClientRect();
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    // No need for scrollLeft as left position is absolute to viewport + page scroll already
    const topPosition = rect.top + scrollTop;

    div.style.position = "absolute";
    div.style.left = startPosition + "px"; // Place at calculated right of main
    div.style.top = topPosition + "px";
    div.style.minWidth = sideNoteMinWidth + "px";
    div.style.maxWidth = sideNoteMaxWidth + "px";

    document.body.appendChild(div);
  }
});

document.addEventListener('DOMContentLoaded', function () {
  const footnotes = document.querySelectorAll('p a.reversefootnote');

  footnotes.forEach(link => {
    const href = link.getAttribute('href');
    const match = href.match(/fnref:(\d+)/);

    if (match) {
      const num = match[1];
      const paragraph = link.closest('p');
      paragraph.setAttribute('data-footnote-num', num);
    }
  });
});