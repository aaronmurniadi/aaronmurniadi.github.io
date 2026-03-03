const pluginRss = require("@11ty/eleventy-plugin-rss");
const pluginSyntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const pluginBundle = require("@11ty/eleventy-plugin-bundle");
const pluginSeo = require("eleventy-plugin-seo");
const markdownIt = require("markdown-it");
const markdownItAnchor = require("markdown-it-anchor");
const markdownItAttrs = require("markdown-it-attrs");
const markdownItFootnote = require("markdown-it-footnote");

module.exports = function (eleventyConfig) {
  // Plugins
  eleventyConfig.addPlugin(pluginRss);
  eleventyConfig.addPlugin(pluginSyntaxHighlight, {
    preAttributes: {
      tabindex: -1
    },
    alwaysWrapLineHighlights: false,
    trim: true
  });
  eleventyConfig.addPlugin(pluginBundle);
  eleventyConfig.addPlugin(pluginSeo);

  // Custom shortcode for rendering post lists
  eleventyConfig.addShortcode("postList", function (collection) {
    let items = collection.map(item => {
      const date = item.date ? `<span>${new Date(item.date).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })} — </span>` : '';
      return `<li>${date}<a href="${item.url}">${item.data.title || item.title}</a></li>`;
    }).join('');
    return `<ul>${items}</ul>`;
  });

  // Markdown configuration
  let markdownLib = markdownIt({
    html: true,
    breaks: false,
    linkify: true,
    typographer: true,
    quotes: ['\u201c', '\u201d', '\u2018', '\u2019']
  })
    .use(markdownItAnchor, {
      permalink: markdownItAnchor.permalink.linkAfterHeader({
        style: "visually-hidden",
        assistiveText: title => `Permalink to section "${title}"`,
        visuallyHiddenClass: "visually-hidden",
        symbol: "#"
      })
    })
    .use(markdownItAttrs)
    .use(markdownItFootnote);

  eleventyConfig.setLibrary("md", markdownLib);

  // Markdown library without anchors for simple layouts
  let markdownLibNoAnchors = markdownIt({
    html: true,
    breaks: true,
    linkify: true,
    typographer: true,
    quotes: ['\u201c', '\u201d', '\u2018', '\u2019']
  })
    .use(markdownItAttrs)
    .use(markdownItFootnote);

  eleventyConfig.setLibrary("md", markdownLib);
  eleventyConfig.addPairedShortcode("markdownNoAnchors", function (content) {
    return markdownLibNoAnchors.render(content);
  });

  // Collections
  eleventyConfig.addCollection("posts", function (collectionApi) {
    return collectionApi.getFilteredByGlob("_posts/**/*.md").sort(function (a, b) {
      return b.date - a.date;
    });
  });

  eleventyConfig.addCollection("articles", function (collectionApi) {
    return collectionApi.getFilteredByGlob("_articles/**/*.md").sort(function (a, b) {
      return b.date - a.date;
    });
  });

  eleventyConfig.addCollection("recaps", function (collectionApi) {
    return collectionApi.getFilteredByGlob("_recaps/**/*.md").sort(function (a, b) {
      return b.date - a.date;
    });
  });

  eleventyConfig.addCollection("summaries", function (collectionApi) {
    return collectionApi.getFilteredByGlob("_summaries/**/*.md").sort(function (a, b) {
      return b.date - a.date;
    });
  });

  eleventyConfig.addCollection("tools", function (collectionApi) {
    return collectionApi.getFilteredByGlob("_tools/**/*.md").sort(function (a, b) {
      return b.date - a.date;
    });
  });

  // Copy assets
  eleventyConfig.addPassthroughCopy("assets");
  eleventyConfig.addPassthroughCopy("media");
  eleventyConfig.addPassthroughCopy("avatar.jpg");
  eleventyConfig.addPassthroughCopy("robots.txt");
  eleventyConfig.addPassthroughCopy("_includes/**/*.(css|js|jpg|jpeg|png|gif|svg|ico|pdf)");

  // Date filters
  eleventyConfig.addFilter("dateReadable", dateObj => {
    return new Date(dateObj).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  });

  eleventyConfig.addFilter("dateToRfc3339", dateObj => {
    return new Date(dateObj).toISOString();
  });

  eleventyConfig.addFilter("date", (dateObj, format) => {
    const date = new Date(dateObj);
    if (format === "%Y") {
      return date.getFullYear();
    }
    return date.toISOString();
  });

  // Global data
  eleventyConfig.addGlobalData("site", {
    title: "Contemplative Coder",
    email: "aaronmurniadi@gmail.com",
    description: "A Software Engineer with a passion for technology, coding, and open-source software.",
    baseurl: "",
    url: "https://aaronmurniadi.github.io",
    lang: "en-US",
    github_username: "aaronmurniadi",
  });

  return {
    dir: {
      input: ".",
      includes: "_includes",
      data: "_data",
      output: "_site",
      layouts: "_layouts"
    },
    templateFormats: ["md", "njk", "html"],
    htmlTemplateEngine: "njk",
    markdownTemplateEngine: "njk",
    dataTemplateEngine: "njk",
    passthroughFileCopy: true,
    cleanUrls: true
  };
};
