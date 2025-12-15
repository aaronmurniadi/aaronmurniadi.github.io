---
layout: post_no_comment
title: 🧰 Toolbox
---

<style>
.toolbox-grid {
  font-family: system-ui, -apple-system, blinkmacsystemfont, "Segoe UI", roboto, "Helvetica Neue", arial, sans-serif, "Segoe UI Emoji";
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
  margin: 2rem 0;
  padding: 0;
}

@media (max-width: 900px) {
  .toolbox-grid {
    gap: 1.2rem;
  }
}

@media (max-width: 750px) {
  .toolbox-grid {
    gap: 1rem;
  }
}

.toolbox-card-link {
  text-decoration: none;
  color: inherit;
  width: 100%;
  height: 100%;
  display: flex;
  flex: 1 1 calc(33.333% - 1.0rem);
  max-width: calc(33.333% - 1.0rem);
}

@media (max-width: 900px) {
  .toolbox-card-link {
    flex: 1 1 calc(50% - 0.8rem);
    max-width: calc(50% - 0.8rem);
  }
}

@media (max-width: 600px) {
  .toolbox-card-link {
    flex: 1 1 100%;
    max-width: 100%;
    min-width: 0;
  }
}

.toolbox-card {
  background: #fff;
  border: 1px solid #e1e4e8;
  border-radius: 10px;
  box-shadow: 0 2px 6px #0001;
  padding: 1.5rem 1.25rem;
  min-height: 135px;
  display: flex;
  flex-direction: column;
  align-items: center;            /* Centers horizontally */
  justify-content: center;        /* Centers vertically */
  transition: box-shadow 0.2s;
  box-sizing: border-box;
  width: 100%;
  height: 100%;
}

.toolbox-card:hover, .toolbox-card:focus-within {
  box-shadow: 0 6px 18px #0002;
  border-color: #d1d5da;
}

.toolbox-card-link:focus .toolbox-card,
.toolbox-card-link:hover .toolbox-card {
  box-shadow: 0 6px 18px #0002;
  border-color: #d1d5da;
}

.toolbox-tool-title {
  font-size: 1.1rem;
  font-weight: 600;
  margin: 0;
  color: #215578;
  text-decoration: none;
  display: flex;
  align-items: center;
  justify-content: center; /* Center link contents horizontally if more elements */
}

.toolbox-tool-date {
  font-size: 0.85rem;
  color: #666;
  margin-bottom: 0.3rem;
}

.toolbox-tool-icon {
  font-size: 2rem;
  margin-right: 0.5rem;
  line-height: 1;
}
</style>

<div class="toolbox-grid">
  {% for tool in site.tools %}
    <a href="{{ tool.url | relative_url }}" class="toolbox-card-link">
      <div class="toolbox-card">
        <span class="toolbox-tool-title">{{ tool.title }}</span>
      </div>
    </a>
  {% endfor %}
</div>
