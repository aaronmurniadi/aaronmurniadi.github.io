document.addEventListener('DOMContentLoaded', function() {
    // Lightbox elements
    let lightbox = null;
    let currentIndex = 0;
    const photos = [];
    
    // Initialize the lightbox
    function initLightbox() {
        // Find all gallery photos
        document.querySelectorAll('.photo-container').forEach((container, index) => {
            const img = container.querySelector('.gallery-photo');
            const metadataContainer = container.querySelector('.metadata-container');
            
            // Get the metadata from the data attribute
            let metadata = {};
            if (metadataContainer) {
                try {
                    const metadataStr = metadataContainer.getAttribute('data-metadata');
                    console.log("Raw metadata string:", metadataStr);
                    
                    // Replace escaped unicode with the actual character
                    const fixedMetadataStr = metadataStr.replace(/\\u\d+/g, (match) => {
                        return String.fromCodePoint(parseInt(match.slice(2), 16));
                    });
                    
                    console.log("Fixed metadata string:", fixedMetadataStr);
                    metadata = JSON.parse(fixedMetadataStr);
                    console.log("Parsed metadata object:", metadata);
                } catch (e) {
                    console.error('Error parsing metadata:', e);
                }
            }
            
            // Store photo data
            photos.push({
                src: img.src,
                alt: img.alt,
                metadata: metadata
            });
            
            // Add click event to open lightbox
            img.addEventListener('click', function() {
                openLightbox(index);
            });
            
            // Make the photo container appear clickable
            container.style.cursor = 'pointer';
            container.addEventListener('click', function(e) {
                if (e.target === container || e.target === img) {
                    openLightbox(index);
                }
            });
        });
        
        // Create lightbox if not already created
        if (!lightbox) {
            createLightbox();
        }
    }
    
    // Create the lightbox HTML structure
    function createLightbox() {
        lightbox = document.createElement('div');
        lightbox.className = 'lightbox';
        lightbox.innerHTML = `
            <div class="lightbox-overlay"></div>
            <div class="lightbox-content">
                <button class="lightbox-close">&times;</button>
                <button class="lightbox-nav lightbox-prev">&#10094;</button>
                <div class="lightbox-container">
                    <div class="lightbox-image-container">
                        <img class="lightbox-image" src="" alt="">
                    </div>
                    <div class="lightbox-thumbnails"></div>
                </div>
                <button class="lightbox-nav lightbox-next">&#10095;</button>
                <div class="lightbox-sidebar">
                    <div class="lightbox-exif"></div>
                </div>
            </div>
        `;
        
        document.body.appendChild(lightbox);
        
        // Add event listeners
        lightbox.querySelector('.lightbox-overlay').addEventListener('click', closeLightbox);
        lightbox.querySelector('.lightbox-close').addEventListener('click', closeLightbox);
        lightbox.querySelector('.lightbox-prev').addEventListener('click', showPreviousImage);
        lightbox.querySelector('.lightbox-next').addEventListener('click', showNextImage);
        
        // Keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (!lightbox.classList.contains('active')) return;
            
            if (e.key === 'Escape') closeLightbox();
            if (e.key === 'ArrowLeft') showPreviousImage();
            if (e.key === 'ArrowRight') showNextImage();
        });
    }
    
    // Open the lightbox with a specific image
    function openLightbox(index) {
        if (!lightbox) createLightbox();
        
        currentIndex = index;
        updateLightboxContent();
        
        // Create thumbnails
        createThumbnails();
        
        // Show the lightbox
        lightbox.classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevent scrolling
    }
    
    // Close the lightbox
    function closeLightbox() {
        lightbox.classList.remove('active');
        document.body.style.overflow = ''; // Restore scrolling
    }
    
    // Update the active image in the lightbox
    function updateLightboxContent() {
        const photo = photos[currentIndex];
        const img = lightbox.querySelector('.lightbox-image');
        
        // Reset any previous sizing
        img.style.width = 'auto';
        img.style.height = 'auto';
        img.style.maxWidth = '100%';
        img.style.maxHeight = '100%';
        
        // Set src after resetting styles
        img.src = photo.src;
        img.alt = photo.alt;
        
        // Handle image loading to adjust for portrait/landscape
        img.onload = function() {
            const container = lightbox.querySelector('.lightbox-image-container');
            const containerRect = container.getBoundingClientRect();
            const imageRatio = this.naturalWidth / this.naturalHeight;
            
            console.log(`Image dimensions: ${this.naturalWidth}x${this.naturalHeight}, ratio: ${imageRatio}`);
            console.log(`Container dimensions: ${containerRect.width}x${containerRect.height}`);
            
            // Center and size the image properly based on orientation
            if (imageRatio < 1) {
                // Portrait image (taller than wide)
                console.log('Portrait orientation detected');
                this.style.maxHeight = '100%';
                this.style.maxWidth = '100%';
            } else {
                // Landscape image (wider than tall)
                console.log('Landscape orientation detected');
                this.style.maxWidth = '100%';
                this.style.maxHeight = '100%';
            }
        };
        
        // Create a formatted metadata display
        const exifContainer = lightbox.querySelector('.lightbox-exif');
        let exifContent = '';
        
        const metadata = photo.metadata || {};
        
        // Display camera, lens, and tag with special formatting
        if (metadata.camera) {
            exifContent += `<p><strong>CAMERA</strong> ${metadata.camera}</p>`;
        }
        
        if (metadata.lens) {
            exifContent += `<p><strong>LENS</strong> ${metadata.lens}</p>`;
        }
        
        // Add tag if available
        if (metadata.tags && metadata.tags.length > 0) {
            exifContent += `<p><strong>TAG</strong> ${metadata.tags[0]}</p>`;
        } else if (metadata.tag) {
            exifContent += `<p><strong>TAG</strong> ${metadata.tag}</p>`;
        } else {
            exifContent += `<p><strong>TAG</strong> PHOTO</p>`;
        }
        
        // Handle special display for technical settings
        const technicalSettings = [];
        
        // Add focal length if available (without label)
        if (metadata.focal_length) {
            technicalSettings.push(`<p>${metadata.focal_length}</p>`);
        }
        
        // Add aperture if available (without label)
        if (metadata.aperture) {
            const aperture = metadata.aperture.replace(/\\u([\d\w]{4})/gi, (match, grp) => String.fromCharCode(parseInt(grp, 16)));
            technicalSettings.push(`<p>${aperture}</p>`);
        }
        
        // Add shutter speed if available (without label)
        if (metadata.shutter_speed) {
            technicalSettings.push(`<p>${metadata.shutter_speed}</p>`);
        }
        
        // Add ISO if available (with ISO prefix)
        if (metadata.iso) {
            technicalSettings.push(`<p>ISO ${metadata.iso}</p>`);
        }
        
        // Add all technical settings
        exifContent += technicalSettings.join('');
        
        // Add date if available (at the bottom)
        if (metadata.date) {
            exifContent += `<p>${metadata.date}</p>`;
        } else {
            const now = new Date();
            const formattedDate = now.toLocaleDateString('en-US', {
                day: '2-digit',
                month: 'short',
                year: 'numeric'
            }).toUpperCase();
            const formattedTime = now.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            }).toUpperCase();
            
            exifContent += `<p>${formattedDate} ${formattedTime}</p>`;
        }
        
        // Display any additional metadata fields that aren't handled above
        const handledFields = ['camera', 'lens', 'tag', 'tags', 'focal_length', 'aperture', 'shutter_speed', 'iso', 'date'];
        
        for (const [key, value] of Object.entries(metadata)) {
            if (!handledFields.includes(key) && value) {
                // Format the key for display (uppercase, replace underscores with spaces)
                const formattedKey = key.toUpperCase().replace(/_/g, ' ');
                exifContent += `<p><strong>${formattedKey}</strong> ${value}</p>`;
            }
        }
        
        exifContainer.innerHTML = exifContent;
        
        // Update active thumbnail
        const thumbnails = lightbox.querySelectorAll('.lightbox-thumbnail');
        thumbnails.forEach((thumb, i) => {
            thumb.classList.toggle('active', i === currentIndex);
        });
    }
    
    // Show the previous image
    function showPreviousImage() {
        currentIndex = (currentIndex - 1 + photos.length) % photos.length;
        updateLightboxContent();
    }
    
    // Show the next image
    function showNextImage() {
        currentIndex = (currentIndex + 1) % photos.length;
        updateLightboxContent();
    }
    
    // Create thumbnails for all images
    function createThumbnails() {
        const thumbnailsContainer = lightbox.querySelector('.lightbox-thumbnails');
        thumbnailsContainer.innerHTML = '';
        
        photos.forEach((photo, index) => {
            const thumbnail = document.createElement('div');
            thumbnail.className = 'lightbox-thumbnail';
            if (index === currentIndex) thumbnail.classList.add('active');
            
            const img = document.createElement('img');
            img.src = photo.src;
            img.alt = `Thumbnail ${index + 1}`;
            
            thumbnail.appendChild(img);
            thumbnailsContainer.appendChild(thumbnail);
            
            thumbnail.addEventListener('click', function() {
                currentIndex = index;
                updateLightboxContent();
            });
        });
    }
    
    // Initialize the lightbox when the page loads
    initLightbox();
}); 