class Prefetcher{constructor(options={}){this.options={hoverDelay:65,hoverTimeout:null,prefetchedUrls:new Set(),maxPrefetches:5,prefetchCount:0,...options};this.init();}
init(){if(document.readyState==='complete'){this.addListeners();}else{window.addEventListener('load',()=>this.addListeners());}}
addListeners(){const links=document.querySelectorAll('a');links.forEach(link=>{if(this.isInternalLink(link)){link.addEventListener('mouseenter',()=>this.handleLinkHover(link));link.addEventListener('touchstart',()=>this.handleLinkHover(link),{passive:true});link.addEventListener('mouseleave',()=>this.cancelPrefetch());link.addEventListener('touchend',()=>this.cancelPrefetch());}});}
isInternalLink(link){const url=new URL(link.href,window.location.origin);if(url.origin!==window.location.origin){return false;}
if(url.pathname===window.location.pathname&&url.hash){return false;}
const extension=url.pathname.split('.').pop().toLowerCase();if(['jpg','jpeg','png','gif','webp','pdf','zip','mp4','mp3'].includes(extension)){return false;}
return true;}
handleLinkHover(link){this.cancelPrefetch();this.options.hoverTimeout=setTimeout(()=>{this.prefetchUrl(link.href);},this.options.hoverDelay);}
cancelPrefetch(){if(this.options.hoverTimeout){clearTimeout(this.options.hoverTimeout);this.options.hoverTimeout=null;}}
prefetchUrl(url){if(this.options.prefetchedUrls.has(url)||this.options.prefetchCount>=this.options.maxPrefetches){return;}
this.options.prefetchedUrls.add(url);this.options.prefetchCount++;const prefetchLink=document.createElement('link');prefetchLink.rel='prefetch';prefetchLink.href=url;prefetchLink.as='document';document.head.appendChild(prefetchLink);console.log(`Prefetched: ${url}`);}}
document.addEventListener('DOMContentLoaded',()=>{window.prefetcher=new Prefetcher();});