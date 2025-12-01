document.addEventListener('DOMContentLoaded', () => {
    const mainContentWrap = document.querySelector('.main-content-wrap');
    const sidebar = document.querySelector('.side-bar');

    // Ensure sidebar is above main content for the slide-under effect
    // We rely on CSS for z-index. We do NOT set position here to avoid breaking sticky/fixed sidebars.
    if (mainContentWrap) {
        mainContentWrap.style.position = 'relative';
        mainContentWrap.style.zIndex = '1';
    }

    document.body.addEventListener('click', (e) => {
        const link = e.target.closest('a');
        if (!link) return;

        // Ignore external links, anchors, and special modifiers
        if (
            link.hostname !== window.location.hostname ||
            link.getAttribute('target') === '_blank' ||
            link.getAttribute('href').startsWith('#') ||
            e.ctrlKey || e.metaKey || e.shiftKey || e.altKey
        ) {
            return;
        }

        // Ignore links to non-HTML resources (simple check)
        const href = link.getAttribute('href');
        if (href.match(/\.(pdf|zip|jpg|jpeg|png|gif)$/i)) return;

        // Auto-close mobile navigation if link is in nav list
        if (link.closest('.nav-list-item')) {
            const siteNav = document.querySelector('.site-nav');
            if (siteNav) {
                siteNav.classList.add('nav-closed');
                siteNav.classList.remove('nav-open'); // Ensure it's not open
            }
        }

        e.preventDefault();
        const url = link.href;

        navigateTo(url);
    });

    window.addEventListener('popstate', () => {
        navigateTo(window.location.href, false);
    });

    async function navigateTo(url, pushState = true) {
        if (!mainContentWrap) {
            window.location.href = url;
            return;
        }

        // Start exit animation
        mainContentWrap.classList.add('page-exit');

        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error('Network response was not ok');
            const text = await response.text();

            // Parse new content
            const parser = new DOMParser();
            const doc = parser.parseFromString(text, 'text/html');
            const newContent = doc.querySelector('.main-content-wrap').innerHTML;
            const newTitle = doc.title;

            // Wait for exit animation to finish (approx match CSS transition time)
            setTimeout(() => {
                if (pushState) {
                    history.pushState(null, newTitle, url);
                }
                document.title = newTitle;

                // Swap content
                mainContentWrap.innerHTML = newContent;

                // Scroll to top
                window.scrollTo(0, 0);

                // Remove exit class and add enter class
                mainContentWrap.classList.remove('page-exit');
                mainContentWrap.classList.add('page-enter');

                // Force reflow
                void mainContentWrap.offsetWidth;

                // Activate enter animation
                mainContentWrap.classList.add('page-enter-active');

                // Cleanup after animation
                setTimeout(() => {
                    mainContentWrap.classList.remove('page-enter', 'page-enter-active');
                    // Re-run any necessary scripts or re-attach listeners if needed
                    // For simple content, this might be enough. 
                    // If there are specific page scripts, they might need re-initialization.
                }, 300); // Match CSS transition duration

            }, 300); // Match CSS transition duration

        } catch (error) {
            console.error('Navigation failed:', error);
            window.location.href = url; // Fallback to full reload
        }
    }
});
