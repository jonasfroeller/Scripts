import { writeFileSync } from "node:fs";

const USE_GITHUB_TOKEN = false;
const GITHUB_TOKEN = "<AUTH-KEY>";

const username = "jonasfroeller";
const REQUESTS_PER_MINUTE = 60;
const RATE_LIMIT_DELAY = (60 * 1000) / REQUESTS_PER_MINUTE;

async function fetchStarredRepos(username) {
  let page = 1;
  const repos = [];

  while (true) {
    await delay(RATE_LIMIT_DELAY);

    const response = await fetch(
      `https://api.github.com/users/${username}/starred?page=${page}&per_page=100`,
      USE_GITHUB_TOKEN
        ? {
            headers: {
              Authorization: `token ${GITHUB_TOKEN}`,
            },
          }
        : {}
    );

    if (!response.ok) {
      throw new Error(`Failed to fetch page ${page}: ${response.statusText}`);
    }

    const data = await response.json();
    repos.push(...data.map((repo) => repo.html_url));

    console.log(repos);
    console.log("repos.length", repos.length);

    const linkHeader = response.headers.get("link");
    console.log("Link header:", linkHeader);

    const nextPageUrl = getNextPageUrl(linkHeader);
    if (!nextPageUrl) {
      break;
    }

    page = getPageFromUrl(nextPageUrl);

    console.log("page: ", page);
  }

  return repos;
}

function getNextPageUrl(linkHeader) {
  if (!linkHeader) return null;
  const links = linkHeader.split(",");

  for (const link of links) {
    const [url, rel] = link.split(";").map((part) => part.trim());
    if (rel === 'rel="next"') {
      const nextPageUrl = url.match(/<(.*?)>/);
      return nextPageUrl[1];
    }
  }

  return null;
}

function getPageFromUrl(url) {
  const regex = /page=(\d+)/;
  const match = url.match(regex);
  if (match) {
    return Number.parseInt(match[1]);
  }
  return null;
}

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function generateHTML(username) {
  const repos = await fetchStarredRepos(username);

  let html = `<html>
    <body>
      <h1>Starred Repositories of ${username}</h1>
      <ul>`;

  for (const repo of repos) {
    html += `\n<li><a href="${repo}">${repo}</a></li>`;
  }

  html += `\n</ul>
    </body>
  </html>`;

  return html;
}

generateHTML(username)
  .then((html) => {
    writeFileSync("starred_repos.html", html);
    console.log("HTML generated and saved successfully!");
  })
  .catch((error) => {
    console.error("Error generating HTML:", error);
  });
