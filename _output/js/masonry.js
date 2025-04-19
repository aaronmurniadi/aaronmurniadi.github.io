/**
 * Masonry layout implementation for photo gallery
 */
document.addEventListener('DOMContentLoaded', function() {
    initMasonry();
    
    // Re-initialize masonry when window is resized
    let resizeTimer;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(initMasonry, 200);
    });
    
    // Re-initialize masonry when all images are loaded
    const images = document.querySelectorAll('.gallery-photo');
    let loadedImages = 0;
    images.forEach(img => {
        if (img.complete) {
            loadedImages++;
            if (loadedImages === images.length) {
                initMasonry();
            }
        } else {
            img.addEventListener('load', function() {
                loadedImages++;
                if (loadedImages === images.length) {
                    initMasonry();
                }
            });
        }
    });

    // Handle image loading for the gallery
    images.forEach(img => {
        // Set initial state
        img.parentElement.style.opacity = 0;
        
        // When an image loads, fade it in
        img.addEventListener('load', function() {
            this.parentElement.style.transition = 'opacity 0.5s ease';
            this.parentElement.style.opacity = 1;
        });
        
        // If image failed to load, show error
        img.addEventListener('error', function() {
            this.parentElement.style.opacity = 0.5;
            console.error('Failed to load image:', this.src);
        });
        
        // If image is already loaded, make sure it's visible
        if (img.complete) {
            img.parentElement.style.opacity = 1;
        }
    });
});

/**
 * Initialize masonry layout by calculating and setting the appropriate grid-row-end
 * for each item based on its content height
 */
function initMasonry() {
    const gallery = document.querySelector('.gallery');
    if (!gallery) return;
    
    const rowHeight = parseInt(window.getComputedStyle(gallery).getPropertyValue('grid-auto-rows'));
    const rowGap = parseInt(window.getComputedStyle(gallery).getPropertyValue('grid-gap') || 
                           window.getComputedStyle(gallery).getPropertyValue('grid-row-gap'));
    
    const photoContainers = document.querySelectorAll('.photo-container');
    
    photoContainers.forEach(item => {
        // Reset to default first to get accurate height
        item.style.gridRowEnd = 'span 1';
        
        // Calculate how many rows this item should span based on its height
        const itemHeight = item.clientHeight;
        const rowSpan = Math.ceil((itemHeight + rowGap) / (rowHeight + rowGap));
        
        // Set the correct row span
        item.style.gridRowEnd = `span ${rowSpan}`;
    });
}

/**
 * For manual recalculation if needed elsewhere
 */
function recalculateMasonry() {
    setTimeout(initMasonry, 100);
} 