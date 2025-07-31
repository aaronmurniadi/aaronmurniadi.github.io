const firstPWithoutTime = document.querySelector('main p:not(:has(time))');
if (firstPWithoutTime) {
  firstPWithoutTime.classList.add('drop-cap');
}