const axios = require('axios');
const fs = require('fs');

// This function fetches all starred repositories of a given github user.
const username = 'jonasfroeller';

async function fetchStarredRepos(username) {
  let page = 1;
  const repos = [];

  while (true) {
    const response = await axios.get(`https://api.github.com/users/${username}/starred`, {
      params: {
        per_page: 100,
        page: page,
      },
    });

    repos.push(...response.data.map(repo => repo.html_url));

    const nextPageUrl = getNextPageUrl(response.headers.link);
    if (!nextPageUrl) {
      break;
    }

    page++;
  }

  return repos;
}

function getNextPageUrl(linkHeader) {
  const links = linkHeader.split(',');

  for (const link of links) {
    const [url, rel] = link.split(';').map(part => part.trim());
    if (rel === 'rel="next"') {
      const nextPageUrl = url.match(/<(.*?)>/);
      return nextPageUrl[1];
    }
  }

  return null;
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
  .then(html => {
    fs.writeFileSync('starred_repos.html', html);
    console.log('HTML generated and saved successfully!');
  })
  .catch(error => {
    console.error('Error generating HTML:', error);
  });
